/* 
TASK 1A--CREATE THE SSIS CATALOG --THIS TASK IS A MANUAL PROCESS
When creating the SSIS Catalog, the use the SA password for the SQL Server on which it is created in the Password/Retype Password fields
Check (enable) the "Enable automatic execution of Integration Services stored procedure at SQL Server startup" option.
Please see SQL Help -- Create the SSIS Catalog
*/

/*
TASK 1B--Configure the SSIS Catalog and apply security--Run this script
--Review the database file locations for the SSISDB catalog.  Even though it is not in the System Databases folder, it is considered a 'system database'.
--compare the locations of the master database and the SSISDB. If the SSISDB is not in the same location as the master, then stop the Integration Services, detach the SSISDB database, move the files and then reattach the database.  THIS STEP IS NOT MANDATORY BUT SHOULD BE DONE IF THE SSISDB IS CREATED ON A RAW DEVICE CONTAINING OTHER USER DATABASES AND THOSE USER DATABASES HAVE AN APPSYNC JOB.  WE CANNOT HAVE THE SSISDB FILES ON A RAW LUN SHARED WITH ANOTHER DATABASE.
*/

/* Confirm SSIS Catalog database creation--Must be done prior to Deploying Projects (TASK 3)
--Review the database file locations for the SSISDB catalog.  Even though it is not in the System Databases folder, it is considered a 'system database'.
--compare the locations of the master database and the SSISDB. If the SSISDB is not in the same location as the master, then stop the Integration Services, detach the SSISDB database, move the files and then reattach the database.  THIS STEP IS NOT MANDATORY BUT SHOULD BE DONE IF THE SSISDB IS CREATED ON A RAW DEVICE CONTAINING OTHER USER DATABASES AND THOSE USER DATABASES HAVE AN APPSYNC JOB.  WE CANNOT HAVE THE SSISDB FILES ON A RAW LUN SHARED WITH ANOTHER DATABASE.
*/
select db_name(database_id)
,name
,type
,type_desc
,physical_name
from [sys].[master_files] 
where database_id = db_id('ssisdb')
or database_id = db_id('master')
order by database_id, type, name

USE [master]
GO
IF NOT EXISTS (SELECT * FROM [sys].[server_principals] WHERE [name] LIKE 'KFBDOM1\SQL_Admins')
BEGIN
CREATE LOGIN [KFBDOM1\SQL_Admins] FROM WINDOWS WITH DEFAULT_DATABASE=[SSISDB]
END
GO

--After the SSISDB database is set up, add users and assign ssis_admin role.
USE [SSISDB]
GO
IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] LIKE 'KFBDOM1\SQL_Admins')
BEGIN
CREATE USER [KFBDOM1\SQL_Admins] FOR LOGIN [KFBDOM1\SQL_Admins]
END
GO

IF NOT EXISTS (
SELECT 
[DBP1].[name] AS role_name,
[DBP2].[name] AS [login_name]
FROM [sys].[database_role_members] AS DBRM1
INNER JOIN [sys].[database_principals] AS DBP1
ON DBRM1.role_principal_id = DBP1.principal_id
INNER JOIN [sys].[database_principals] AS DBP2
ON DBRM1.member_principal_id = DBP2.principal_id
WHERE [DBP1].[name] = 'ssis_admin'
AND [DBP2].[name] = 'KFBDOM1\SQL_Admins')
BEGIN
ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\SQL_Admins]
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] LIKE 'KFBDOM1\SQL_Server_SysAdmins')
BEGIN
CREATE USER [KFBDOM1\SQL_Server_SysAdmins] FOR LOGIN [KFBDOM1\SQL_Server_SysAdmins]
END

IF NOT EXISTS (
SELECT 
[DBP1].[name] AS role_name,
[DBP2].[name] AS [login_name]
FROM [sys].[database_role_members] AS DBRM1
INNER JOIN [sys].[database_principals] AS DBP1
ON DBRM1.role_principal_id = DBP1.principal_id
INNER JOIN [sys].[database_principals] AS DBP2
ON DBRM1.member_principal_id = DBP2.principal_id
WHERE [DBP1].[name] = 'ssis_admin'
AND [DBP2].[name] = 'KFBDOM1\SQL_Server_SysAdmins')
BEGIN
ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\SQL_Server_SysAdmins]
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] LIKE 'KFBDOM1\FTPSQLMaint')
BEGIN
CREATE USER [KFBDOM1\FTPSQLMaint] FOR LOGIN [KFBDOM1\FTPSQLMaint]
END

IF NOT EXISTS (
SELECT 
[DBP1].[name] AS role_name,
[DBP2].[name] AS [login_name]
FROM [sys].[database_role_members] AS DBRM1
INNER JOIN [sys].[database_principals] AS DBP1
ON DBRM1.role_principal_id = DBP1.principal_id
INNER JOIN [sys].[database_principals] AS DBP2
ON DBRM1.member_principal_id = DBP2.principal_id
WHERE [DBP1].[name] = 'ssis_admin'
AND [DBP2].[name] = 'KFBDOM1\FTPSQLMaint')
BEGIN
ALTER ROLE [ssis_admin] ADD MEMBER [KFBDOM1\FTPSQLMaint]
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] LIKE 'SQLMgtApp')
BEGIN
CREATE USER [SQLMgtApp] FOR LOGIN [SQLMgtApp]
END

IF NOT EXISTS (
SELECT 
[DBP1].[name] AS role_name,
[DBP2].[name] AS [login_name]
FROM [sys].[database_role_members] AS DBRM1
INNER JOIN [sys].[database_principals] AS DBP1
ON DBRM1.role_principal_id = DBP1.principal_id
INNER JOIN [sys].[database_principals] AS DBP2
ON DBRM1.member_principal_id = DBP2.principal_id
WHERE [DBP1].[name] = 'ssis_admin'
AND [DBP2].[name] = 'SQLMgtApp')
BEGIN
ALTER ROLE [ssis_admin] ADD MEMBER [SQLMgtApp]
END
GO



--Decrease the number of project versions and retention history from the default settings (10 & 365 respectively).  Can increase manually later if needed
EXEC [catalog].[configure_catalog] @property_name=N'MAX_PROJECT_VERSIONS', @property_value=5
EXEC [catalog].[configure_catalog] @property_name=N'RETENTION_WINDOW', @property_value=30
GO


/* 2) Create Administration folder */
IF NOT EXISTS (SELECT * FROM [catalog].[folders] WHERE name = N'Administration')
BEGIN
Declare @folder_id bigint
EXEC [catalog].[create_folder] @folder_name=N'Administration', @folder_id=@folder_id OUTPUT
Select @folder_id
EXEC [catalog].[set_folder_description] @folder_name=N'Administration', @folder_description=N'Folder for SQL administrative tasks such as backups, restores and maintenance'
END
GO

/* 
TASK 1C--DEPLOY THE SSIS PROJECT AND PACKAGES TO THE SSIS CATALOG --THIS TASK IS A MANUAL PROCESS
Once the folder is created, projects and packages can be deployed.
Get the latest PROD Maintenance project from TFS and Deploy to the server
Remove the "--PROD" reference in the PROJECT name in the path field during the deployment otherwise the project name in the catalog will not match the name used in later procedures
 */

