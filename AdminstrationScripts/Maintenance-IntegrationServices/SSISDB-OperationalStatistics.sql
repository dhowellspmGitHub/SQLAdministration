/*
Author: Danny Howell
Description: 
The default SSIS maintenance jobs may experience locking and deadlock issues if a large number of messages are recorded.
The primary issues is the number and range of records per each purge for which the default processes cannot handle.
To overcome these issues, custom purge queries were composed (see--SSISDB-PurgeLoggingMessages.sql) providing 
The below queries provide statistical information concerning the tables used to log SSIS package executions and messages.
The statistics returned in these queries are used by the purge to narrow the date and number ranges to manageable quantities


*/

use SSISDB
go
SET NOCOUNT ON;
IF object_id('tempdb..#OperationStats') IS NOT NULL
BEGIN
DROP TABLE #OperationStats
END;

CREATE TABLE #OperationStats
(operation_id bigint NOT NULL PRIMARY KEY, event_message_contect_count BIGINT NULL, event_messages_count BIGINT NULL, operation_messages_count BIGINT NULL);
INSERT INTO #OperationStats (operation_id, event_message_contect_count, event_messages_count, operation_messages_count)
select [IO].[operation_id],0,0,0
FROM [internal].[operations] AS IO

UPDATE #OperationStats
SET event_message_contect_count = emc1.tblcount
FROM #OperationStats AS T
inner join 
(SELECT operation_id, count(context_id) as tblcount FROM internal.event_message_context
GROUP BY operation_id) as emc1
on t.operation_id = emc1.operation_id


UPDATE #OperationStats
SET event_messages_count = emc1.tblcount
FROM #OperationStats AS T
inner join 
(SELECT operation_id, count(event_message_id) as tblcount FROM internal.event_messages
GROUP BY operation_id) as emc1
on t.operation_id = emc1.operation_id


UPDATE #OperationStats
SET operation_messages_count = emc1.tblcount
FROM #OperationStats AS T
inner join 
(SELECT operation_id, count(operation_message_id) as tblcount FROM internal.operation_messages
GROUP BY operation_id) as emc1
on t.operation_id = emc1.operation_id


select 
[IO].[operation_id],
convert(nvarchar(20),isnull([io].[end_time],[io].[start_time]),100),
[OS1].*,
[IO].* 
FROM [internal].[operations] AS IO
INNER JOIN #OperationStats as OS1
on [IO].[operation_id] = [OS1].[operation_id]
order by 
--operation_messages_count desc, 
[IO].[operation_id] asc,
isnull([io].[end_time],[io].[start_time]) asc 
