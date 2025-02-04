/* 
Audit properties cannot be parameterized. Change the values for File and Queue directly below.
Use the Server-Security-CreateAuditPaths TSQL to create the local audit paths and paste the output to the FILEPATH variable below.
Because audit events are not captured until the audit is enabled, events for the EventsAudit will not be captured
until itself is enabled
*/

/* REPLACE THE <FILEPATH> TAG VALUE BELOW WITH THE PATH CREATED AS INSTRUCTED */

SET NOCOUNT ON
SET XACT_ABORT ON
USE [master]
GO
EXEC sp_configure 'show advanced options', 1;
GO
Reconfigure;
GO
  
EXEC sp_configure 'xp_cmdshell',1
GO
Reconfigure
GO

DECLARE @shellcmd NVARCHAR(400)
DECLARE @AuditName NVARCHAR(128)
DECLARE @AuditSpecName NVARCHAR(128)
DECLARE @AuditDataPath NVARCHAR(260)
DECLARE @ReplaceExistingAudit BIT
DECLARE @AuditState BIT = 0
DECLARE @TSQL NVARCHAR(2000)
SET @AuditName = N'Server-AuditEvents'
SET @AuditSpecName = N'Server-AuditEventsSpecifications'

/* Use the @ReplaceExistingAudit to drop and recreate the audit with the current specifications */
SET @ReplaceExistingAudit = 1

BEGIN TRY
--disable and delete any audit specifications not matched to an audit

IF @ReplaceExistingAudit = 1
BEGIN
	DECLARE @InvalidAuditSpec NVARCHAR(128)
	DECLARE @InvalidAuditSpecs TABLE ([AuditSpecName] NVARCHAR(128), [isprocessed] BIT)
	INSERT INTO @InvalidAuditSpecs (AuditSpecName,isprocessed)
	SELECT [T1].[name],0
	FROM [master].[sys].[server_audit_specifications] as t1
	LEFT OUTER JOIN [master].[sys].[server_audits] as t2
	ON [t1].[audit_guid] = [t2].[audit_guid]
	WHERE [t2].[name] IS NULL

	WHILE EXISTS (SELECT [AuditSpecName] FROM @InvalidAuditSpecs WHERE [isprocessed] = 0)
	BEGIN 
	SELECT @InvalidAuditSpec = [AuditSpecName] FROM @InvalidAuditSpecs WHERE [isprocessed] = 0
	SET @TSQL = 'USE [master] ALTER SERVER AUDIT SPECIFICATION ' + QUOTENAME(@InvalidAuditSpec) + ' WITH (STATE = OFF)' + CHAR(10) + CHAR(13)
	SET @TSQL = @TSQL + 'DROP SERVER AUDIT SPECIFICATION ' +  QUOTENAME(@InvalidAuditSpec) + CHAR(10) + CHAR(13)
	EXEC sp_executesql @TSQL
	PRINT ('Audit Specification not matched to a Server Audit deleted:' + @InvalidAuditSpec)
	UPDATE @InvalidAuditSpecs
	SET [isprocessed] = 1
	WHERE [AuditSpecName] = @InvalidAuditSpec
	END

	DECLARE @AuditSpecs TABLE ([AuditName] NVARCHAR(128), [AuditSpecName] NVARCHAR(128), [isprocessed] BIT)
	INSERT INTO @AuditSpecs ([AuditName],[AuditSpecName], [isprocessed])
	SELECT [T2].[name],[T1].[name], CAST(0 as BIT) 
	FROM [sys].[server_audit_specifications] AS T1
	LEFT OUTER JOIN [sys].[server_audits] AS T2
	ON [T1].[audit_guid] = [T2].[audit_guid]
	WHERE [T1].[name] = @AuditSpecName
	AND [T2].[is_state_enabled] = 1

	WHILE EXISTS (SELECT [AuditSpecName] FROM @AuditSpecs WHERE [isprocessed] = 0)
	BEGIN
		SELECT @AuditSpecName = [AuditSpecName] FROM @AuditSpecs WHERE [isprocessed] = CAST(0 AS BIT)
		PRINT ('Dropping Audit Specifications: ' + @AuditSpecName)
		SET @TSQL = 'USE [master] ALTER SERVER AUDIT SPECIFICATION ' + QUOTENAME(@AuditSpecName) + ' WITH (STATE = OFF)' + CHAR(10) + CHAR(13)
		SET @TSQL = @TSQL + 'DROP SERVER AUDIT SPECIFICATION ' +  QUOTENAME(@AuditSpecName) +  CHAR(10) + CHAR(13)
		PRINT @TSQL
		EXEC sp_executesql @TSQL
		UPDATE @AuditSpecs 
		SET [isprocessed] = 1
		WHERE [AuditSpecName] = @AuditSpecName
	END
	
	IF EXISTS (SELECT * FROM [sys].[server_audits] WHERE [name] = @AuditName)
	BEGIN
		SELECT @AuditDataPath = ([log_file_path] + @AuditName + '*') FROM [sys].[server_file_audits]
		PRINT ('Dropping Audit: ' + @AuditName)
		SET @TSQL = 'USE [master] ALTER SERVER AUDIT ' + QUOTENAME(@AuditName) + ' WITH (STATE = OFF)'  + CHAR(10) + CHAR(13)
		SET @TSQL = @TSQL + 'DROP SERVER AUDIT ' +  QUOTENAME(@AuditName)
		PRINT @TSQL
		EXEC sp_executesql @TSQL
	END
	ELSE
	BEGIN
		PRINT (N'Audit does not exists: ' + @AuditName + '--No audit to replace')	
	END	
	
	SET @shellcmd = N'del ' + @AuditDataPath
	PRINT 'Deleting files related to audit:' + @shellcmd
	EXEC [master]..xp_cmdshell @shellcmd

END

BEGIN

	PRINT (N'Creating Audit: ' + @AuditName)
	CREATE SERVER AUDIT [Server-AuditEvents]
	TO FILE 
	(	FILEPATH = 'D:\SQLAudits\MSSQLSERVER\Server\Security\'
		,MAXSIZE = 64 MB
		,MAX_ROLLOVER_FILES = 2
		,RESERVE_DISK_SPACE = OFF
	)
	WITH
	(	QUEUE_DELAY = 1000
		,ON_FAILURE = CONTINUE
	
	)
	WHERE (NOT [server_principal_name] like 'KFBDOM1\SQLServices%' AND NOT [server_principal_name] like 'NT AUTHORITY\SYSTEM' AND NOT [server_principal_name] like 'SQLMgtApp' AND NOT [server_principal_name] like 'KFBDOM1\SQLMgtApp');
	ALTER SERVER AUDIT [Server-AuditEvents] WITH (STATE = OFF);


	/* Enable the audit */
	IF @AuditState = 0
	BEGIN
		PRINT N'Enabling Server Audit'	
		ALTER SERVER AUDIT [Server-AuditEvents]  WITH (STATE = ON);
	END
	ELSE
	BEGIN
		PRINT N'Server Audit' + @AuditName + ' already enabled'
	
	END

	SET @AuditState = 0
	PRINT (N'Creating Audit Specification: ' + @AuditSpecName)
	
	IF EXISTS (SELECT * FROM sys.server_audit_specifications WHERE name = @AuditSpecName)
	BEGIN
		PRINT (N'Audit specification exists: ' + @AuditSpecName + '--Script made no changes. To redefine the audit specifications, manually disable the audit specifications, delete it and rerun this script.')
		
		SELECT @AuditState = [is_state_enabled] FROM [sys].[server_audit_specifications] 
		WHERE [name] = @AuditSpecName	
	END
	ELSE
	BEGIN 
		CREATE SERVER AUDIT SPECIFICATION [Server-AuditEventsSpecifications]
		FOR SERVER AUDIT [Server-AuditEvents]
		ADD (SERVER_STATE_CHANGE_GROUP),
		ADD (AUDIT_CHANGE_GROUP),
		ADD (SERVER_OPERATION_GROUP),
		ADD (USER_DEFINED_AUDIT_GROUP),
		ADD (TRACE_CHANGE_GROUP)
		WITH (STATE = OFF);
	END

	IF @AuditState = 0
	BEGIN
		PRINT N'Enabling Server Audit: ' + @AuditSpecName	
		ALTER SERVER AUDIT SPECIFICATION [Server-AuditEventsSpecifications] WITH (STATE = ON)
		
	END
	ELSE
	BEGIN
		PRINT N'Enabling Server Audit Specification: ' + @AuditSpecName
		
	END
END	

END TRY

BEGIN CATCH
	SELECT
	ERROR_NUMBER() AS ErrorNumber
	,ERROR_SEVERITY() AS ErrorSeverity
	,ERROR_STATE() AS ErrorState
	,ERROR_PROCEDURE() AS ErrorProcedure
	,ERROR_LINE() AS ErrorLine
	,ERROR_MESSAGE() AS ErrorMessage;
	PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS NVARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS NVARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS NVARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000))
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF


EXEC sp_configure 'show advanced options', 1;
GO
Reconfigure;
GO
  
EXEC sp_configure 'xp_cmdshell',0
GO
Reconfigure
GO
