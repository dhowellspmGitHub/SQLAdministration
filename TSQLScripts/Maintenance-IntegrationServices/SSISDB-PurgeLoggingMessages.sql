USE SSISDB;
/*
Author: Danny Howell
Description: 
The default SSIS maintenance jobs may experience locking and deadlock issues if a large number of messages are recorded.
The primary issues is the number and range of records per each purge for which the default processes cannot handle.
The Microsoft system stored procedure treats the entire range of messages and events as a single atomic transaction using CASCADE DELETE settings on the relationships.
CASCADE DELETE methods are sufficient for smaller ranges but requires a very large log file if there are a great deal of records and the entire range is treated as a single 
atomic transaction. 
To overcome these issues, these custom purge queries were composed to purge out the message and log history in batches and treat each operation as an atomic transaction instead
of a range of operations.  The batch size is determined by several variables below with the key ones being
@delete_operations_batch_size -- the count of records to delete in each batch; can be adjusted up or down increasing/decreasing the quantity of event messages
@retention_window_length -- number of days in the past to establish the cutoff of history to retain after the purge
@delete_batch_size -- number of operations (SSIS executions) for which to include in a batch

Without detailing the SSIS catalog, the logging and messaging history is managed using four tables
While the documentation references the 'catalog' schema objects, these are the MS stored procedures and not the underlying tables.
The script works directly with the SSISDB tables in the 'internal' schema.
For details about executions, validations, messages that are logged during operations, and contextual information related to errors, query these views.
catalog.operations (SSISDB Database)
catalog.operation_messages (SSISDB Database)
catalog.event_messages
catalog.event_message_context
With the operations table being the upper most parent, the purge processes deletions up through the relationship tree loading the PK/FK values to temp tables

This script may need to be run iteratively to process all the operations desired.
*/

DECLARE @delete_operations_batch_size int = 10000
DECLARE @retention_window_length int
DECLARE @delete_batch_size int
--iF NULL, THEN GET THE RETENTION WINDOW DAYS FROM THE SSIS CATALOG

SET @delete_batch_size = 20
set @retention_window_length = 2

DECLARE @enable_clean_operation bit
DECLARE @server_operation_encryption_level int
DECLARE @temp_date datetime
DECLARE @rows_affected bigint
SET @temp_date = GETDATE() - @retention_window_length

DECLARE @mincontext_id BIGINT
DECLARE @maxcontext_id BIGINT
DECLARE @batchcounter int = 0
DECLARE @totalforoperationid BIGINT
DECLARE @totaloperationids BIGINT
DECLARE @currentoperationid BIGINT
DECLARE @operationscounter int = 0

--Get the operations subject to the retention window--table used to obtain related operations and event messages
IF NOT EXISTS
(
select [IO].[operation_id]
FROM [internal].[operations] AS IO
WHERE ( [IO].[end_time] <= @temp_date
OR ([IO].[end_time] IS NULL AND [IO].[status] = 1 AND [IO].[created_time] <= @temp_date )
)
)
BEGIN
PRINT 'No [internal].[operations] exist that meet the date cutoff criteria.'
END
ELSE
BEGIN

SET NOCOUNT ON;
IF object_id('tempdb..#DELETE_CANDIDATES') IS NOT NULL
BEGIN
DROP TABLE #DELETE_CANDIDATES;
END;

CREATE TABLE #DELETE_CANDIDATES
(operation_id bigint NOT NULL PRIMARY KEY);

INSERT INTO
#DELETE_CANDIDATES
(operation_id)
select top (@delete_batch_size) [IO].[operation_id]
FROM [internal].[operations] AS IO
WHERE ( [IO].[end_time] <= @temp_date
OR ([IO].[end_time] IS NULL AND [IO].[status] = 1 AND [IO].[created_time] <= @temp_date )
)


SELECT @totaloperationids = count(*) 
FROM #DELETE_CANDIDATES
PRINT 'Purging SSISDB Operations prior to: ' + convert(nvarchar(25), @temp_date, 101)
PRINT 'Total number of operations being processed: ' + cast(@totaloperationids as nvarchar(20))

--Treat each operations as an atomic transaction.  Use the WHILE looping functions to work through the operations
WHILE (SELECT COUNT(*) FROM #DELETE_CANDIDATES) > 0
BEGIN
SET @operationscounter = @operationscounter + 1
SELECT TOP 1 @currentoperationid = operation_id
FROM #DELETE_CANDIDATES AS DC
PRINT 'Operations Counter: ' + cast(@operationscounter as nvarchar(20)) + '--Processing Operation ID: ' + cast(@currentoperationid as nvarchar(20))

SELECT @totalforoperationid = count(*) FROM internal.event_message_context AS T WHERE t.operation_id = @currentoperationid
PRINT N'Total number of internal.event_message_context records to purge for this Operation ID:' + cast(@totalforoperationid as nvarchar(20))

--PROCESS internal.event_message_context records subject to the @delete_operations_batch_size for the current operation id
WHILE (SELECT COUNT(*) FROM internal.event_message_context AS T INNER JOIN #DELETE_CANDIDATES AS DC ON DC.operation_id = T.operation_id) > 0
BEGIN
	
	SET NOCOUNT ON;
	IF object_id('tempdb..#DELETE_event_message_context') IS NOT NULL
	BEGIN
	DROP TABLE #DELETE_event_message_context;
	END;
	CREATE TABLE #DELETE_event_message_context
	(context_id bigint NOT NULL PRIMARY KEY);

	INSERT INTO #DELETE_event_message_context (context_id)
	SELECT TOP (@delete_operations_batch_size) context_id FROM internal.event_message_context AS T WHERE t.operation_id = @currentoperationid
	SELECT @mincontext_id = min(context_id), @maxcontext_id = MAX(context_id) FROM #DELETE_event_message_context

	BEGIN TRANSACTION
	SET @batchcounter = @batchcounter + 1
	PRINT N'Batch counter: ' + cast(@batchcounter as nvarchar(20)) + '--Deleting internal.event_message_context for Operation ID where context_id between ' + cast(@mincontext_id as NVARCHAR(20)) + ' and ' + cast(@maxcontext_id as NVARCHAR(20))
	DELETE T
	FROM internal.event_message_context AS T
	WHERE t.operation_id = @currentoperationid
	AND T.context_id BETWEEN @mincontext_id AND @maxcontext_id
	COMMIT TRANSACTION

IF (SELECT COUNT(*) FROM internal.event_message_context AS T WHERE t.operation_id = @currentoperationid) <= 0
	BREAK
	ELSE
	CONTINUE
END

--PROCESS internal.event_messages records subject to the @delete_operations_batch_size for the current operation id
SET @mincontext_id = 0
SET @maxcontext_id = 0
SET @batchcounter = 0
SELECT @totalforoperationid = count(*) FROM internal.event_messages AS T WHERE t.operation_id = @currentoperationid
PRINT N'Total number of internal.event_messages records to purge for this Operation ID:' + cast(@totalforoperationid as nvarchar(20))

WHILE (SELECT COUNT(*) FROM internal.event_messages AS T WHERE t.operation_id = @currentoperationid) > 0
BEGIN
	SET NOCOUNT ON;
	IF object_id('tempdb..#DELETE_event_messages') IS NOT NULL
	BEGIN
	DROP TABLE #DELETE_event_messages;
	END;
	CREATE TABLE #DELETE_event_messages
	(event_message_id bigint NOT NULL PRIMARY KEY);

	INSERT INTO #DELETE_event_messages (event_message_id)
	SELECT TOP (@delete_operations_batch_size) event_message_id FROM internal.event_messages AS T WHERE t.operation_id = @currentoperationid
	SELECT @mincontext_id = min(event_message_id), @maxcontext_id = MAX(event_message_id) FROM #DELETE_event_messages

	BEGIN TRANSACTION
	SET @batchcounter = @batchcounter + 1
	PRINT N'Batch counter: ' + cast(@batchcounter as nvarchar(20)) + '--Deleting internal.event_messages for Operation ID where event_message_id between ' + cast(@mincontext_id as NVARCHAR(20)) + ' and ' + cast(@maxcontext_id as NVARCHAR(20))
	DELETE T
	FROM internal.event_messages AS T
	WHERE t.operation_id = @currentoperationid
	AND T.event_message_id BETWEEN @mincontext_id AND @maxcontext_id
	COMMIT TRANSACTION

IF (SELECT COUNT(*) FROM internal.event_messages AS T WHERE t.operation_id = @currentoperationid) <= 0
	BREAK
	ELSE
	CONTINUE
END

--PROCESS internal.operations_messages records subject to the @delete_operations_batch_size for the current operation id
SET @mincontext_id = 0
SET @maxcontext_id = 0
SET @batchcounter = 0
SELECT @totalforoperationid = count(*) FROM internal.operation_messages AS T WHERE t.operation_id = @currentoperationid
PRINT N'Total number of internal.operation_messages records to purge for this Operation ID:' + cast(@totalforoperationid as nvarchar(20))

WHILE (SELECT COUNT(*) FROM internal.operation_messages AS T WHERE t.operation_id = @currentoperationid) > 0
BEGIN
	SET NOCOUNT ON;
	IF object_id('tempdb..#DELETE_operation_messages') IS NOT NULL
	BEGIN
	DROP TABLE #DELETE_operation_messages;
	END;
	CREATE TABLE #DELETE_operation_messages
	(operation_message_id bigint NOT NULL PRIMARY KEY);

	INSERT INTO #DELETE_operation_messages (operation_message_id)
	SELECT TOP (@delete_operations_batch_size) operation_message_id FROM internal.operation_messages AS T WHERE t.operation_id = @currentoperationid
	SELECT @mincontext_id = min(operation_message_id), @maxcontext_id = MAX(operation_message_id) FROM #DELETE_operation_messages

	BEGIN TRANSACTION
	SET @batchcounter = @batchcounter + 1
	PRINT N'Batch counter: ' + cast(@batchcounter as nvarchar(20)) + '--Deleting internal.operation_messages for Operation ID where operation_message_id between ' + cast(@mincontext_id as NVARCHAR(20)) + ' and ' + cast(@maxcontext_id as NVARCHAR(20))
	DELETE T
	FROM internal.operation_messages AS T
	WHERE t.operation_id = @currentoperationid
	AND T.operation_message_id BETWEEN @mincontext_id AND @maxcontext_id
	COMMIT TRANSACTION

IF (SELECT COUNT(*) FROM internal.operation_messages AS T WHERE t.operation_id = @currentoperationid) <= 0
	BREAK
	ELSE
	CONTINUE
END

--Finally, since each child record is deleted, delete the current operation from the operations table
PRINT 'Deleting Operation ID: ' + cast(@currentoperationid as nvarchar(20))
BEGIN TRANSACTION
DELETE T
FROM
internal.operations AS T
WHERE t.operation_id = @currentoperationid
COMMIT TRANSACTION
delete from #DELETE_CANDIDATES where operation_id = @currentoperationid

PRINT 'Processing complete for Operation ID: ' + cast(@currentoperationid as nvarchar(20))
IF (SELECT COUNT(*) FROM #DELETE_CANDIDATES) <= 0
	BREAK
	ELSE
	CONTINUE


END
END
