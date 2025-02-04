/*
***********************************************************************************************
	Created By:  Danny Howell			
	Created On:  10/05/2008
	Revised On:  02/21/2021
	Description:	This procedure is used when a new database server is created.
			The procedures:
				1.) set default settings, 
				2.) create logins, 
				3.) enables email and creates email addresses and profiles
				4.) creates operators
				5.) creates standardized alerts and notifications for them.
	Input Parameters:	The first section (commented out) contains queries that change the default location of new database data and log files and moves the location of the tempdb.  Review prior to running script as these vary from server to server.
	Output Parameters:  NONE
***********************************************************************************************
*/

/**************IMPORTANT NOTE***********************************/
/*
Passwords for SQLMgtApp can be set by this script
However, variables cannot be used. 
Before running this script, you must do a manual Find and Replace these string before running this file
Find and Replace <SQLMgtApp-REPLACE WITH ACTUAL PASSWORD> with the actual password for the SQL login
*/


/* Add a custom table to the MASTER database which will hold custom properties for the server.  These custom properties can be used by other applications to retrieve non-system, KFB defined properties for the server
*/
USE MASTER
GO
DECLARE @ServerIsProductionServer BIT
DECLARE @ServerIsInKFBDOM1Domain BIT
DECLARE @ServerRunsSSISPackages BIT
SET @ServerIsProductionServer = 0
SET @ServerIsInKFBDOM1Domain = 1
SET @ServerRunsSSISPackages = 1

/* Set MODEL database recovery method to the default 'SIMPLE' method */
ALTER DATABASE [model] SET RECOVERY SIMPLE WITH NO_WAIT


/* Create standard administrative users*/
IF @ServerIsInKFBDOM1Domain = 1
BEGIN
USE [master]

DECLARE @sysadminst TABLE 
(server_principal NVARCHAR(128)
,is_domain_account BIT
,processed_ind BIT
,serverrole NVARCHAR(128)
,defaultdatabase NVARCHAR(128))

IF @ServerIsProductionServer = 1
BEGIN
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\SQLServices2025PRD',1,0,'sysadmin','master')
	END
	ELSE
	BEGIN
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\SQLServices2025DEV',1,0,'sysadmin','master')
	END
END

BEGIN
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\SQL_Server_SysAdmins',1,0,'sysadmin','master')
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\SQLMgtApp',1,0,'sysadmin','master')
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\SQL_Admins',1,0,'public','msdb')
	INSERT INTO @sysadminst
	VALUES ('KFBDOM1\FTPSQLMaint',1,0,'public','master')
	INSERT INTO @sysadminst
	VALUES ('NT AUTHORITY\SYSTEM',1,0,'sysadmin','master')


	DECLARE @principal NVARCHAR(128)
	DECLARE @serverrole NVARCHAR(128)
	DECLARE @defaultdb NVARCHAR(128)
	DECLARE @is_domain_account BIT
	DECLARE spcursor CURSOR FOR
	SELECT server_principal,serverrole,defaultdatabase, is_domain_account
	FROM @sysadminst

	OPEN spcursor
	FETCH NEXT FROM spcursor
	INTO @principal, @serverrole, @defaultdb,@is_domain_account

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @principal)
		BEGIN
			BEGIN TRY
				DECLARE @tsql NVARCHAR(1000)

				SET @tsql = 'CREATE LOGIN [' + @principal + '] FROM WINDOWS WITH DEFAULT_DATABASE=[' + @defaultdb + ']'
				EXECUTE  (@tsql)
					IF @is_domain_account = 0
					BEGIN
						SET @tsql = 'ALTER LOGIN ['+  @principal + '] ENABLE'
					EXECUTE (@tsql)
					END
				PRINT @principal + ' server principal created'
				SET @tsql = ''
			END TRY
			BEGIN CATCH
				PRINT N'Error Occurred: ErrorSeverity' + cast(ERROR_SEVERITY() as nvarchar(10)) + N' Error State:' + cast(ERROR_STATE() as nvarchar(10)) + N' Error Line: ' + cast(ERROR_LINE() as nvarchar(10)) + N'Error Number:' + cast(ERROR_NUMBER() AS nvarchar(10)) + ' Error Message: ' +  ERROR_MESSAGE();
				SELECT ERROR_SEVERITY() as ErrorSeverity, ERROR_STATE() as ErrorState, ERROR_LINE() as ErrorLine,  ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() as ErrorMessage ;
			END CATCH
		END
		ELSE
		BEGIN
			PRINT @principal + ' server principal already exists'
		END

		IF CHARINDEX(@serverrole,'public') = 0
		BEGIN
		EXEC master..sp_addsrvrolemember @loginame = @principal, @rolename = @serverrole
		PRINT @principal + ' server principal enabled and granted ' + @serverrole + 'server role'
		END
		ELSE
		BEGIN
		PRINT 'Server Principal  ' + @principal + ' not granted any server role other than public'
		END

		FETCH NEXT FROM spcursor
		INTO @principal, @serverrole, @defaultdb,@is_domain_account
	END
	CLOSE spcursor
	DEALLOCATE spcursor

	USE [msdb]
	IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'KFBDOM1\SQL_Admins')
	BEGIN
	CREATE USER [KFBDOM1\SQL_Admins] FOR LOGIN [KFBDOM1\SQL_Admins]
	END
	ALTER ROLE [db_datareader] ADD MEMBER [KFBDOM1\SQL_Admins]
	ALTER ROLE [db_datawriter] ADD MEMBER [KFBDOM1\SQL_Admins]
	ALTER ROLE [db_ssisadmin] ADD MEMBER [KFBDOM1\SQL_Admins]
	
	IF @ServerRunsSSISPackages = 1
	BEGIN
		IF EXISTS (SELECT * FROM master.sys.databases WHERE [name] = 'SSISDB')
		BEGIN
		USE [SSISDB]
		IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'KFBDOM1\FTPSQLMaint')
		BEGIN
			CREATE USER [KFBDOM1\FTPSQLMaint] FOR LOGIN [KFBDOM1\FTPSQLMaint]
		END
		ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\FTPSQLMaint]
		END
		ELSE
		BEGIN
		PRINT 'The SSISDB database and SSIS catalogs have not been created.  Please create the SSIS Catalogs and rerun these statements'
		PRINT 'USE [SSISDB]'
		PRINT 'CREATE USER [KFBDOM1\FTPSQLMaint] FOR LOGIN [KFBDOM1\FTPSQLMaint]'
		PRINT 'ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\FTPSQLMaint]'
		END
	END
	ELSE
	BEGIN
		PRINT 'Server is not designated to run any packages.  SSISDB Roles not assigned.'
	END

	
END


/* Create users for maintenance tasks and KFBSQLMgmt databases and as SysAdmin so the SSIS package can obtain server and database metadata*/

/* For security reasons the login is created disabled and with a random password. */

--NOTE: Change passwords after users are created
/* For security reasons the login is created disabled and with a random password. */

/****** Object:  Login [SQLMgtApp]    Script Date: 09/24/2012 16:51:07 ******/
IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE 'SQLMgtApp')
BEGIN
	CREATE LOGIN [SQLMgtApp] WITH PASSWORD='<SQLMgtApp-REPLACE WITH ACTUAL PASSWORD>', 
	DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO

IF IS_SRVROLEMEMBER('sysadmin',N'SQLMgtApp') = 0
BEGIN
	EXEC sys.sp_addsrvrolemember @loginame = N'SQLMgtApp', @rolename = N'sysadmin'
END
ALTER LOGIN [SQLMgtApp] ENABLE

PRINT 'The SQLMgtApp SQL Login password was set in the script.  Please confirm by logging onto the server using its known, shared password recorded in the KFBSQLMgmt database and Password Safe SQL Vault'

/* Create CMDB discovery role and SQL credentials used for discovery */

--NOTE: Change passwords after users are created
/* For security reasons the login is created disabled and with a random password. */

/****** Object:  Login [APS11300181]    Script Date: 09/24/2012 16:51:07 ******/
USE [master]
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'discoveryreadonly' AND type = 'U')
	BEGIN
	DROP LOGIN [discoveryreadonly]
	END
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'D42DiscoveryRO' AND type = 'U')
	BEGIN
	DROP LOGIN [D42DiscoveryRO]
	END
GO


IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_discoveryreadonly' AND type = 'R')
	BEGIN
	CREATE ROLE [db_discoveryreadonly] AUTHORIZATION [dbo]
	END
GO

GRANT SELECT ON [sys].[databases] TO [db_discoveryreadonly]
GO
GRANT SELECT ON [sys].[dm_os_sys_info] TO [db_discoveryreadonly]
GRANT SELECT ON [sys].[dm_os_sys_memory] TO [db_discoveryreadonly]
GRANT SELECT ON [sys].[master_files] TO [db_discoveryreadonly]
GRANT SELECT ON [sys].[dm_exec_sessions] TO [db_discoveryreadonly]
GRANT SELECT ON [sys].[dm_exec_connections] TO [db_discoveryreadonly]
GO


IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE 'APS11300181')
BEGIN
	CREATE LOGIN [APS11300181] WITH PASSWORD='fW4pOABSr6jakK', 
	DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO

IF IS_SRVROLEMEMBER('db_discoveryreadonly',N'APS11300181') = 0
BEGIN
	EXEC sys.sp_addsrvrolemember @loginame = N'APS11300181', @rolename = N'db_discoveryreadonly'
END
ALTER LOGIN [APS11300181] ENABLE
GRANT VIEW SERVER STATE TO [APS11300181]
GRANT VIEW ANY DEFINITION TO [APS11300181]


IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'APS11300181' AND type = 'S')
	BEGIN
	CREATE USER [APS11300181] FOR LOGIN [APS11300181] WITH DEFAULT_SCHEMA=[dbo]
	PRINT 'The APS11300181 SQL Login password was set in the script.  Please confirm by logging onto the server using its known, shared password recorded in the KFBSQLMgmt database and Password Safe SQL Vault'

	END
ELSE
	BEGIN
	PRINT 'The APS11300181 was does NOT exist or was NOT created.  Review credentials and confirm the password.  CMDB discovery of databases will fail if not set correctly'

	END
GO

GRANT VIEW DATABASE STATE TO [APS11300181]

-- Enable SQL Mail
USE [master]
exec sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
exec sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO
DECLARE @PROFILE_NAME NVARCHAR(128)
DECLARE @SRVNAME NVARCHAR(64)
DECLARE @display_name NVARCHAR(64) 
DECLARE @BodyAsHTML NVARCHAR(MAX) 
DECLARE @subjectVAR NVARCHAR(128) 

SET @SRVNAME =   CAST(SERVERPROPERTY('SERVERName') AS NVARCHAR(50))
SET @SUBJECTVAR = 'SQL SERVER INSTALLATION CHECKLIST FOR '+@SRVNAME + '--EMAIL SETUP CONFIRMATION'
SET @display_name = 'SQL Alerts-'  + @SRVNAME
SET @PROFILE_NAME = 'SQL Administrative Alerts'
SET @BodyAsHTML =
N'<Head><b><i> SQL SERVER INSTALLATION CHECKLIST FOR SERVER--' + @SRVNAME + '</i></b></p></Head>' +
N'<hr></hr>' +
N'<body>' +
N'This email is set via the SQL Server Installation script used to set standard SQL mgmt items at the installation of a new SQL Server instance. </p>' +
N'The default email profile is named--' + @PROFILE_NAME +
N'<p>Receipt of this email confirms that the Database Mail server options have been set appropriately and that the default SQL Database Mail profile has been created and used.</p>' + 
N'<p><b>The SQLMgtApp SQL Login password must be MANUALLY reset to its standard password which is recorded in the KFBSQLMgmt database</b></p>' ;

--Create the SQL Alerts profile
USE [MSDB]
IF NOT EXISTS (SELECT * FROM DBO.SYSMAIL_PROFILE WHERE NAME = @PROFILE_NAME )
EXECUTE msdb.dbo.sysmail_add_profile_sp
	@profile_name = @PROFILE_NAME
	,@description = 'test Profile used for administrative mail and sending alerts.' 

--Create the SQL Alerts email account
IF NOT EXISTS (SELECT * FROM DBO.SYSMAIL_ACCOUNT WHERE NAME = @PROFILE_NAME)
EXECUTE msdb.dbo.sysmail_add_account_sp
	@account_name = @PROFILE_NAME
	,@description = 'Mail account for administrative e-mail.'
	,@email_address = 'SQL_Alerts@kyfb.com' 
	,@display_name = @display_name
	,@replyto_address = 'SQL_Alerts@kyfb.com' 
	,@mailserver_name = 'Kyfbsmtp.kfbdom1.kyfb.pri' 
	,@port = 25

EXECUTE MSDB.DBO.SYSMAIL_ADD_PROFILEACCOUNT_SP
	@profile_name = @PROFILE_NAME
	,@account_name = @PROFILE_NAME
	,@sequence_number =1 ;

-- Grant access to the profile to all users in the msdb database
EXECUTE MSDB.DBO.SYSMAIL_ADD_PRINCIPALPROFILE_SP
	@profile_name = @PROFILE_NAME
	, @principal_name = 'public'
	, @is_default = 1 ;

EXEC msdb.dbo.sp_send_dbmail @recipients='SQL_Alerts@KYFB.COM',
@profile_name = @PROFILE_NAME,
@subject =@SUBJECTVAR,
@body = @BodyAsHTML,
@body_format = 'HTML' ;
GO

--Create Operators
USE [msdb]
GO

/****** Object:  Operator [SQL Administrators]    Script Date: 10/06/2008 10:33:17 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'SQL Administrators')
BEGIN
	EXEC msdb.dbo.sp_add_operator @name=N'SQL Administrators', 
	@enabled=1, 
	@email_address=N'SQL_Alerts@KYFB.COM', 
	@category_name=N'[Uncategorized]'
END
ELSE
BEGIN
	EXEC msdb.dbo.sp_update_operator @name=N'SQL Administrators', 
	@enabled=1, 
	@email_address=N'SQL_Alerts@KYFB.COM', 
	@category_name=N'[Uncategorized]'
END
GO


--Set Default email for SQL Agent
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', N'REG_DWORD', 1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', N'REG_SZ', N'SQL Administrative Alerts'
GO

use [MSDB]
DECLARE @SQLADMINNAME AS NVARCHAR(128)
DECLARE @var_name SYSNAME
DECLARE @var_message_id INT
DECLARE @var_severity INT
DECLARE @var_enabled TINYINT
DECLARE @VAR_delay_between_responses INT
DECLARE @var_notification_message nvarchar(512)
DECLARE @var_include_event_description_in tinyint
DECLARE @var_database_name sysname

SELECT @SQLADMINNAME = NAME FROM DBO.SYSOPERATORS WHERE EMAIL_ADDRESS LIKE 'SQL_Alerts@KYFB.COM'


--Create Alerts
IF EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'MSDB Log-File is full')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'MSDB Log-File is full'
END

select @var_name= N'MSDB Log-File is full', 
@var_message_id =9002, 
@var_severity = 0, 
@var_enabled = 1, 
@VAR_delay_between_responses = 60, 
@VAR_notification_message = 'The log file for database MSDB is full. Back up the transaction log for the database to free up space',
@var_include_event_description_in = 1, 
@var_database_name = N'msdb'

EXEC msdb.dbo.sp_add_alert 
	@name = @var_name,
	@message_id = @var_message_id, 
	@severity = @var_severity, 
	@enabled = @var_enabled, 
	@delay_between_responses = @var_delay_between_responses, 
	@notification_message = @var_notification_message, 
	@include_event_description_in = @var_include_event_description_in, 
	@database_name = @var_database_name
EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'MSDB Log-File is full',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;

set @var_database_name = 'TEMPDB'
IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'TEMPDB Log-File is full')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'TEMPDB Log-File is full'
END

select @var_name= N'TEMPDB Log-File is full', @var_database_name = N'TEMPDB'
EXEC msdb.dbo.sp_add_alert 
	@name = @var_name,
	@message_id = @var_message_id, 
	@severity = @var_severity, 
	@enabled = @var_enabled, 
	@delay_between_responses = @var_delay_between_responses, 
	@notification_message = @var_notification_message, 
	@include_event_description_in = @var_include_event_description_in, 
	@database_name = @var_database_name

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'TEMPDB Log-File is full',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 19')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 19'
END

exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 19',
	@message_id = 0,
	@severity = 19,
	@enabled = 1,
	@delay_between_responses = 300,
	@notification_message = 'Investigate server and Windows logs. A nonconfigurable Database Engine limit has been exceeded and the current batch process has been terminated. This error must be corrected by the system administrator or primary support provider.', 
	@include_event_description_in = 1;

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 19',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 20')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 20'
END
/* Commenting out creation of this alert.  Triggers when IT Sec performs it's scans.  It is generally ignored because of these false flags */

--exec sp_add_alert 
--	@name = 'ALL DATABASES-ERROR-Severity 20',
--	@message_id = 0,
--	@severity = 20,
--	@enabled = 1,
--	@delay_between_responses = 300,
--	@notification_message = 'Investigate server and Windows logs. A statement has encountered a problem. Because the problem has affected only the current task, it is unlikely that the database itself has been damaged.
--This error must be corrected by the system administrator or primary support provider.', 
--	@include_event_description_in = 1;
     

--EXEC DBO.SP_ADD_NOTIFICATION
-- @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 20',
-- @OPERATOR_NAME = @SQLADMINNAME,
-- @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 21')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 21'
END
exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 21',
	@message_id = 0,
	@severity = 21,
	@enabled = 1,
	@delay_between_responses = 300,
	@notification_message = 'Investigate server and Windows logs. A problem has been encountered that affects all tasks in the current database, but it is unlikely that the database itself has been damaged.
This error must be corrected by the system administrator or primary support provider.', 
	@include_event_description_in = 1;

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 21',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 22')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 22'
END

exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 22',
	@message_id = 0,
	@severity = 22,
	@enabled = 1,
	@delay_between_responses = 60,
	@notification_message = 'Investigate server and Windows logs. This error must be corrected by the system administrator or primary support provider.  The table or index specified in the message has been damaged by a software or hardware problem.  See Online Help--Database Engine Error Severities for recommended actions.', 
	@include_event_description_in = 1;

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 22',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 23')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 23'
END

exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 23',
	@message_id = 0,
	@severity = 23,
	@enabled = 1,
	@delay_between_responses = 60,
	@notification_message = 'Investigate server and Windows logs. This error must be corrected by the system administrator or primary support provider.  The integrity of the entire database is in question because of a hardware or software problem. See Online Help--Database Engine Error Severities for recommended actions.', 
	@include_event_description_in = 1;

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 23',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 24')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 24'
END

exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 24',
	@message_id = 0,
	@severity = 24,
	@enabled = 1,
	@delay_between_responses = 60,
	@notification_message = 'Investigate server and Windows logs. This error must be corrected by the system administrator or primary support provider.  There has been a media failure and call your hardware maintenance. You may need to restore the database. See Online Help--Database Engine Error Severities for recommended actions.', 
	@include_event_description_in = 1;


EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 24',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 25')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 25'
END

exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 25',
	@message_id = 0,
	@severity = 25,
	@enabled = 1,
	@delay_between_responses = 60,
	@notification_message = 'Investigate server and Windows logs. This error must be corrected by the system administrator or primary support provider.  See Online Help--Database Engine Error Severities for recommended actions.', 
	@include_event_description_in = 1;

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 25',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;
 

IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name=N'DATABASE ENGINE-ERROR-Number 823')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'DATABASE ENGINE-ERROR-Number 823'
END
EXEC msdb.dbo.sp_add_alert 
	@name=N'DATABASE ENGINE-ERROR-Number 823',
	@message_id=823,
	@severity=0,
	@enabled=1,
	@delay_between_responses=60,
	@include_event_description_in=1,
	@notification_message=N'POTENTIAL DATABASE CORRUPTION--Investigate server logs. This is a PAGE CHECKSUM error usually indicates that there is a problem with underlying storage system or the hardware or a driver that is in the path of the I/O request. This error indicates inconsistencies in the file system or damage to the database file.  https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15'


EXEC DBO.SP_ADD_NOTIFICATION
	@ALERT_NAME = N'DATABASE ENGINE-ERROR-Number 823',
	@OPERATOR_NAME = @SQLADMINNAME,
	@NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name=N'DATABASE ENGINE-ERROR-Number 824')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'DATABASE ENGINE-ERROR-Number 824'
END
EXEC msdb.dbo.sp_add_alert 
	@name=N'DATABASE ENGINE-ERROR-Number 824',
	@message_id=824,
	@severity=0,
	@enabled=1,
	@delay_between_responses=60,
	@include_event_description_in=1,
	@notification_message=N'POTENTIAL DATABASE CORRUPTION--Investigate server logs. This is a PAGE CHECKSUM error usually indicates that there is a problem with underlying storage system or the hardware or a driver that is in the path of the I/O request. This error indicates inconsistencies in the file system or damage to the database file.  https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15'


EXEC DBO.SP_ADD_NOTIFICATION
	@ALERT_NAME = N'DATABASE ENGINE-ERROR-Number 824',
	@OPERATOR_NAME = @SQLADMINNAME,
	@NOTIFICATION_METHOD = 1 ;

IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name=N'DATABASE ENGINE-ERROR-Number 825')
BEGIN
EXEC msdb.dbo.sp_delete_alert @name=N'DATABASE ENGINE-ERROR-Number 825'
END

EXEC msdb.dbo.sp_add_alert @name=N'DATABASE ENGINE-ERROR-Number 825',
	@message_id=825,
	@severity=0,
	@enabled=1,
	@delay_between_responses=60,
	@include_event_description_in=1,
	@notification_message=N'POTENTIAL DATABASE CORRUPTION--Investigate server logs. This is a PAGE CHECKSUM error usually indicates that there is a problem with underlying storage system or the hardware or a driver that is in the path of the I/O request. This error indicates inconsistencies in the file system or damage to the database file.  https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15'
	

EXEC DBO.SP_ADD_NOTIFICATION
	@ALERT_NAME = N'DATABASE ENGINE-ERROR-Number 825',
	@OPERATOR_NAME = @SQLADMINNAME,
	@NOTIFICATION_METHOD = 1 ;

GO
