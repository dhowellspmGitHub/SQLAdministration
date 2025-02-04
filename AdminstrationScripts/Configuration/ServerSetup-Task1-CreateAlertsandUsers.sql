/*
***********************************************************************************************
	Created By:  Danny Howell			
	Created On:  10/05/2008
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

/* Add a custom table to the MASTER database which will hold custom properties for the server.  These custom properties can be used by other applications to retrieve non-system, KFB defined properties for the server
*/
USE MASTER
GO
DECLARE @ServerIsProductionServer BIT
SET @ServerIsProductionServer = 0

DECLARE @SQLAdminPath NVARCHAR(256)
DECLARE @Shortdesc nvarchar(100)
DECLARE @Longdesc nvarchar(3000)
DECLARE @LastUpdated date
DECLARE @User nvarchar(20)
DECLARE @Setupdate date

-- Set these values prior to running the batch
set @Shortdesc = N''
set @Longdesc =N''
SET @User = SUSER_NAME()
Set @LastUpdated = CAST(GETDATE() as DATE)
Set @Setupdate = CAST(GETDATE() as DATE)
set @SQLAdminPath = N'D:\SQLAdmininstration'

BEGIN TRANSACTION
CREATE TABLE dbo.server_custom_kfb_properties
	(
	ServerShortDescription nvarchar(100) NOT NULL,
	ServerLongDescription nvarchar(3000) NOT NULL,
	LastUpdatedDt date NULL,
	ServerBuiltBy nvarchar(20) NULL,
	ServerSetupDt date NULL
	)  ON [PRIMARY]
COMMIT TRANSACTION;

BEGIN TRANSACTION
ALTER TABLE dbo.server_custom_kfb_properties SET (LOCK_ESCALATION = TABLE)
COMMIT TRANSACTION
select Has_Perms_By_Name(N'dbo.server_custom_kfb_properties', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.server_custom_kfb_properties', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.server_custom_kfb_properties', 'Object', 'CONTROL') as Contr_Per 

INSERT INTO dbo.server_custom_kfb_properties(ServerShortDescription,ServerLongDescription,LastUpdatedDt,ServerBuiltBy,ServerSetupDt)
VALUES 
(@Shortdesc,
@Longdesc,
@LastUpdated,
@User,
@Setupdate)

/* Set MODEL database recovery method to the default 'SIMPLE' method */
ALTER DATABASE [model] SET RECOVERY SIMPLE WITH NO_WAIT


/* Create standard administrative users*/
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
VALUES ('KFBDOM1\SQLServices2018PRD',1,0,'sysadmin','master')
END
ELSE
BEGIN
INSERT INTO @sysadminst
VALUES ('KFBDOM1\SQLServices2018DEV',1,0,'sysadmin','master')
END

INSERT INTO @sysadminst
VALUES ('KFBDOM1\SQL_Server_SysAdmins',1,0,'sysadmin','master')
INSERT INTO @sysadminst
VALUES ('KFBDOM1\SQLMgtApp',1,0,'sysadmin','master')
INSERT INTO @sysadminst
VALUES ('KFBDOM1\SQL_Admins',1,0,'public','msdb')
INSERT INTO @sysadminst
VALUES ('KFBDOM1\FTPSQLMaint',1,0,'public','SSISDB')
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
GO
IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'KFBDOM1\SQL_Admins')
BEGIN
CREATE USER [KFBDOM1\SQL_Admins] FOR LOGIN [KFBDOM1\SQL_Admins]
END
GO
ALTER ROLE [db_datareader] ADD MEMBER [KFBDOM1\SQL_Admins]
ALTER ROLE [db_datawriter] ADD MEMBER [KFBDOM1\SQL_Admins]
ALTER ROLE [db_ssisadmin] ADD MEMBER [KFBDOM1\SQL_Admins]
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE [name] = 'SSISDB')
BEGIN
USE [SSISDB]
CREATE USER [KFBDOM1\FTPSQLMaint] FOR LOGIN [KFBDOM1\FTPSQLMaint]
ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\FTPSQLMaint]
END
ELSE
BEGIN
PRINT 'The SSISDB database and SSIS catalogs have not been created.  Please create the SSIS Catalogs and rerun these statements'
PRINT 'USE [SSISDB]'
PRINT 'CREATE USER [KFBDOM1\FTPSQLMaint] FOR LOGIN [KFBDOM1\FTPSQLMaint]'
PRINT 'ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\FTPSQLMaint]'
END


/* Create users for maintenance tasks and KFBSQLMgmt databases and as SysAdmin so the SSIS package can obtain server and database metadata*/

/* For security reasons the login is created disabled and with a random password. */

--NOTE: Change passwords after users are created
/* For security reasons the login is created disabled and with a random password. */

/****** Object:  Login [SQLMgtApp]    Script Date: 09/24/2012 16:51:07 ******/
IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE 'SQLMgtApp')
BEGIN
CREATE LOGIN [SQLMgtApp] WITH PASSWORD=N'?¸È≈™??\«Z?∫J?hØ?´??°«èw^+-ù6', 
DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO

EXEC sys.sp_addsrvrolemember @loginame = N'SQLMgtApp', @rolename = N'sysadmin'
PRINT 'The SQLMgtApp SQL Login password must be MANUALLY reset to its standard password which is recorded in the KFBSQLMgmt database'
GO

ALTER LOGIN [SQLMgtApp] ENABLE
GO


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
EXEC msdb.dbo.sp_add_operator @name=N'SQL Administrators', 
		@enabled=1, 
		@email_address=N'SQL_Alerts@KYFB.COM', 
		@category_name=N'[Uncategorized]'
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
SELECT @SQLADMINNAME = NAME FROM DBO.SYSOPERATORS WHERE EMAIL_ADDRESS LIKE 'SQL_Alerts@KYFB.COM'


--Create Alerts
IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'MSDB Log-File is full')
EXEC msdb.dbo.sp_delete_alert @name=N'MSDB Log-File is full'
DECLARE @var_name SYSNAME
DECLARE @var_message_id INT
DECLARE @var_severity INT
DECLARE @var_enabled TINYINT
DECLARE @VAR_delay_between_responses INT
DECLARE @var_notification_message nvarchar(512)
DECLARE @var_include_event_description_in tinyint
DECLARE @var_database_name sysname


select @var_name= N'MSDB Log-File is full', 
@var_message_id =9002, 
@var_severity = 0, 
@var_enabled = 1, 
@VAR_delay_between_responses = 60, 
@VAR_notification_message = 'The log file for database MSDB is full. Back up the transaction log for the database to free up s',
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
EXEC msdb.dbo.sp_delete_alert @name=N'TEMPDB Log-File is full'

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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 19'
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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 20'
exec sp_add_alert 
	@name = 'ALL DATABASES-ERROR-Severity 20',
	@message_id = 0,
	@severity = 20,
	@enabled = 1,
	@delay_between_responses = 300,
	@notification_message = 'Investigate server and Windows logs. A statement has encountered a problem. Because the problem has affected only the current task, it is unlikely that the database itself has been damaged.
This error must be corrected by the system administrator or primary support provider.', 
	@include_event_description_in = 1;
     

EXEC DBO.SP_ADD_NOTIFICATION
 @ALERT_NAME = N'ALL DATABASES-ERROR-SEVERITY 20',
 @OPERATOR_NAME = @SQLADMINNAME,
 @NOTIFICATION_METHOD = 1 ;


IF  EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'ALL DATABASES-ERROR-Severity 21')
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 21'

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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 22'

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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 23'


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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 24'


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
EXEC msdb.dbo.sp_delete_alert @name=N'ALL DATABASES-ERROR-Severity 25'


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
GO