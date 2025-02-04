USE [msdb]
GO

/****** Object:  Job [Security_RecreateTEMPDBPermissions]    Script Date: 3/25/2024 2:52:41 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 3/25/2024 2:52:41 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Security_RecreateTEMPDBPermissions', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQL Administrators', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run Custom Procedure whenever SQL Server reboots]    Script Date: 3/25/2024 2:52:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run Custom Procedure whenever SQL Server reboots', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @SPLoginName NVARCHAR(128)
DECLARE @SPLoginType NVARCHAR(1)
DECLARE @TSQL NVARCHAR(1000)

--get database principals that are only assigned the ''public'' role.  The public role is a default role that has no real access.  These can be removed from the database
DECLARE SPNameCur CURSOR FOR
 select 
sp1.name
,SP1.[type]
from master.sys.server_principals as sp1
where type in (''u'',''s'',''g'')
and sp1.principal_id > 100
and sp1.name not like ''##%''

OPEN SPNameCur
FETCH NEXT FROM SPNameCur 
INTO @SPLoginName, @SPLoginType

WHILE @@FETCH_STATUS = 0
BEGIN
print @sploginname
IF NOT EXISTS (select * from tempdb.sys.database_principals WHERE name = @SPLoginName and [type] = @SPLoginType)
begin
print ''creating database principal for login--'' + @sploginname
SET @TSQL = ''USE [TEMPDB] CREATE USER ['' + @SPLoginName + ''] '' 
	IF @SPLoginType <> ''G'' 
	BEGIN
	SET @TSQL = @TSQL + '' WITH DEFAULT_SCHEMA = dbo''
	END

print @tsql
exec sp_executesql @TSQL
USE [tempdb]
print ''EXEC sp_addrolemember N'' + char(39) + ''db_owner'' + char(39) +'', N'' + char(39) +  @sploginname + char(39)
EXEC sp_addrolemember N''db_owner'',@sploginname

end
else
begin
print ''database principal exists for server principal--'' + @sploginname
end

FETCH NEXT FROM SPNameCur 
INTO @SPLoginName, @splogintype
END

CLOSE SPNameCur
DEALLOCATE SPNameCur
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
