/* SQL Server Extended event paths cannot use parameters for the file and metadata file values
Run the statements to build or confirm the paths for the XE files
Then use the results of the select statement to specify the variable values using the 
Query > Specify Values for Template Parameters in the main menu.
*/
/* Use the @ReplaceExistingXE to drop and recreate the XE with the current specifications */
DECLARE @ReplaceExistingXE BIT
DECLARE @XEName NVARCHAR(128)
DECLARE @AuditDataPath NVARCHAR(260)
DECLARE @StringPath VARCHAR(100)
DECLARE @PathSeparator VARCHAR(1) = '\'
DECLARE @i AS INT

SET @XEName = N'<XE Name, NVARCHAR(128), XE Name>'
SET @ReplaceExistingXE = <Replace Existing XE,bit,Replace Existing XE>

SELECT @AuditDataPath = CAST([value] AS NVARCHAR(260))
FROM [sys].[server_event_session_fields] AS T1
INNER JOIN [sys].[server_event_sessions] AS T2
ON [T1].[event_session_id] = [T2].[event_session_id]
WHERE [T2].[name] = @XEName
AND [T1].[name] = 'filename'

SET @AuditDataPath = REVERSE(@AuditDataPath)
SET @i = CHARINDEX(@PathSeparator, @AuditDataPath,1)
SET @AuditDataPath = RTRIM(LTRIM(REVERSE(SUBSTRING(@AuditDataPath,@i,len(@AuditDataPath)))))
SET @AuditDataPath = @AuditDataPath + @PathSeparator + @XEName + '*'


BEGIN TRY
IF (EXISTS (SELECT * FROM [sys].[server_event_sessions] WHERE [name] = @XEName))
BEGIN
IF (@ReplaceExistingXE = 1)
	BEGIN
	--Stop the session
	-- 0 if not is running, 1 if it is running
		IF (SELECT iif(RS.name IS NULL, 0, 1) FROM sys.dm_xe_sessions RS RIGHT JOIN sys.server_event_sessions ES ON RS.name = ES.name WHERE es.name = @XEName) = 1
		BEGIN
			ALTER EVENT SESSION [XE_Sec_LoginEvents] ON SERVER
			STATE = STOP;
		END
		DROP EVENT SESSION [XE_Sec_LoginEvents] ON SERVER;

		EXEC sp_configure 'show advanced options', 1;
		Reconfigure;
		EXEC sp_configure 'xp_cmdshell',1
		Reconfigure

		DECLARE @shellcmd NVARCHAR(400)
		SET @shellcmd = N'del ' + @AuditDataPath
		PRINT 'Deleting files related to audit:' + @shellcmd
		EXEC [master]..xp_cmdshell @shellcmd

		EXEC sp_configure 'show advanced options', 1;
		Reconfigure;
		EXEC sp_configure 'xp_cmdshell',0
		Reconfigure
		GOTO CREATE_XE
	END
	ELSE
	BEGIN
	--The XE exists but not instructed to replace it
	--throw an error
	SELECT * FROM [sys].[server_event_sessions] WHERE [name] = @XEName
	GOTO FINISH	
	END

END
ELSE
BEGIN
	GOTO CREATE_XE
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

--Since the XE does not exist 
CREATE_XE:
CREATE EVENT SESSION [XE_Sec_LoginEvents] ON SERVER 
ADD EVENT sqlserver.login
(
    ACTION(
    package0.event_sequence
    ,package0.last_error
    ,sqlos.task_time
    ,sqlserver.client_app_name
    ,sqlserver.client_connection_id
    ,sqlserver.client_hostname
    ,sqlserver.database_id
    ,sqlserver.database_name
    ,sqlserver.is_system
    ,sqlserver.nt_username
    ,sqlserver.server_principal_name
    ,sqlserver.server_principal_sid
    ,sqlserver.session_id
    ,sqlserver.session_nt_username
    ,sqlserver.session_server_principal_name
    ,sqlserver.username
    )
    WHERE 
	([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_hostname],N'SAPP203')) 
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_app_name],'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT SERVICE\ReportServer'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT AUTHORITY\SYSTEM'))
    ),
ADD EVENT sqlserver.logout(
    ACTION(
    package0.event_sequence
    ,package0.last_error
    ,sqlos.task_time
    ,sqlserver.client_app_name
    ,sqlserver.client_connection_id
    ,sqlserver.client_hostname
    ,sqlserver.database_id
    ,sqlserver.database_name
    ,sqlserver.is_system
    ,sqlserver.nt_username
    ,sqlserver.server_principal_name
    ,sqlserver.server_principal_sid
    ,sqlserver.session_id
    ,sqlserver.session_nt_username
    ,sqlserver.session_server_principal_name
    ,sqlserver.username)
    WHERE 
	([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_hostname],N'SAPP203')) 
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_app_name],'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT SERVICE\ReportServer'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT AUTHORITY\SYSTEM'))
    ),
ADD EVENT sqlserver.server_start_stop(
    ACTION(sqlserver.session_id)
    WHERE 
	([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_hostname],N'SAPP203')) 
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_app_name],'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT SERVICE\ReportServer'))
	AND ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'NT AUTHORITY\SYSTEM'))
	)
ADD TARGET package0.event_file(
SET filename = N'<XE Path,NVARCHAR(256), XE file path><XE Name, NVARCHAR(128), XE Name>.xel',max_rollover_files=(5),max_file_size=(1024),
metadatafile=N'<XE Path,NVARCHAR(256), XE file path><XE Name, NVARCHAR(128), XE Name>.xem'
)
WITH (
MAX_MEMORY=4096 KB
,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS
,MAX_DISPATCH_LATENCY=30 SECONDS
,MAX_EVENT_SIZE=0 KB
,MEMORY_PARTITION_MODE=NONE
,TRACK_CAUSALITY=ON
,STARTUP_STATE=ON)

ALTER EVENT SESSION [XE_Sec_LoginEvents] ON SERVER
STATE = START

FINISH:
SELECT * FROM [sys].[server_event_sessions] WHERE [name] = @XEName


