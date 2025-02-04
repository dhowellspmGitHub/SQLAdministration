/* TASK 2 is the deployment of the VS project and the SSIS packages to the catalog and performing post deployment tasks*/

/*TASK 2a--POST PACKAGE DEPLOYMENT TASKS--deployment creates the project if it doesn't exist and publishes packages 
These processes are for the SQL Administration projects and jobs done on server setup
*/
/* 
 The first time the project is deployed, permissions must be set
 For NON-PRODUCTION servers, the standard VBScript user is FTPTZA
 For PRODUCTION servers, get with VB Script and job scheduler personnel for the 'standard' user account for the AB or Zeke job scripts
 This user must be added (see next statements) to the SSISDB database with the ssis_admin role
 */

SET NOCOUNT ON

USE [SSISDB]
GO
DECLARE @script_run_as_user NVARCHAR(128)
SET @script_run_as_user = N'KFBDOM1\FTPSQLMaint'

DECLARE @tsql NVARCHAR(1000)
DECLARE @pvar_security_object_type INT = 2
DECLARE @pvar_object_id INT
DECLARE @pvar_database_principal_id INT
DECLARE @pvar_permission_type INT

DECLARE @pvar_object_type INT = 20
DECLARE @pvar_param_name NVARCHAR(128)
DECLARE @pvar_object_name NVARCHAR(128)
DECLARE @pvar_folder_name NVARCHAR(128)
DECLARE @pvar_project_name NVARCHAR(128)
DECLARE @pvar_param_value NVARCHAR(200)
DECLARE @pvar_package_name NVARCHAR(128)

SET @pvar_object_name=N'Backup-Restore'
SET @pvar_folder_name=N'Administration'
SET @pvar_project_name=N'Backup-Restore'
 
IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] LIKE @script_run_as_user)
BEGIN
SET @tsql =N' CREATE USER [' + @script_run_as_user + N'] FOR LOGIN [' + @script_run_as_user + ']'
exec sp_executesql @tsql
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
AND [DBP2].[name] = @script_run_as_user)
BEGIN
set @tsql = 'ALTER ROLE [ssis_admin] ADD MEMBER [' + @script_run_as_user + ']'
exec sp_executesql @tsql
END


SELECT @pvar_object_id = project_id
FROM SSISDB.catalog.projects
WHERE [name] LIKE @pvar_project_name

SELECT @pvar_database_principal_id = principal_id 
FROM [sys].[database_principals]
WHERE [name] like @script_run_as_user

--Set the authorization for the 'standard job user'--grant READ and EXECUTE to the project
DECLARE @tSSISProjectPermissions TABLE (pvar_object_type INT NOT NULL, pvar_object_id INT NOT NULL,pvar_database_principal_id INT NOT NULL,pvar_permission_type INT NOT NULL, is_processed BIT NOT NULL)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,1,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,3,0)

--Set the authorization for the 'KFBDOM1\SQL_Admins' group--READ, MODIFY and EXECUTE
SELECT @pvar_database_principal_id = principal_id 
FROM [sys].[database_principals]
WHERE [name] like 'KFBDOM1\SQL_Admins'

INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,1,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,2,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,3,0)

--Set the authorization for the 'KFBDOM1\SQL_Server_SysAdmins' group--READ, MODIFY, EXECUTE and MODIFY PERMISSIONS
SELECT @pvar_database_principal_id = principal_id 
FROM [sys].[database_principals]
WHERE [name] like 'KFBDOM1\SQL_Server_SysAdmins'

INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,1,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,2,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,3,0)
INSERT INTO @tSSISProjectPermissions (pvar_object_type, pvar_object_id , pvar_database_principal_id, pvar_permission_type , is_processed)
VALUES (@pvar_security_object_type,@pvar_object_id,@pvar_database_principal_id,4,0)

DECLARE @var_security_object_type INT
DECLARE @var_object_id INT
DECLARE @var_database_principal_id INT
DECLARE @var_permission_type INT

WHILE (SELECT COUNT(*) FROM @tSSISProjectPermissions WHERE is_processed = 0) >  0
BEGIN
	SELECT TOP 1 
	@var_security_object_type = pvar_object_type,
	@var_object_id  = pvar_object_id, 
	@var_database_principal_id = pvar_database_principal_id,
	@var_permission_type = pvar_permission_type
	FROM @tSSISProjectPermissions
	WHERE is_processed = 0
	
	EXEC [catalog].[grant_permission] @object_type=@var_security_object_type, @object_id=@var_object_id, @principal_id=@var_database_principal_id, @permission_type=@var_permission_type

	UPDATE @tSSISProjectPermissions SET is_processed = 1
	WHERE pvar_database_principal_id = @var_database_principal_id 
	AND pvar_permission_type = @var_permission_type
		IF (SELECT COUNT(*) FROM @tSSISProjectPermissions WHERE is_processed = 0) =  0
			BREAK
		ELSE
			CONTINUE
END

--process below is set to read the project level parameters and set the 'referenced_variable_name' (placeholder) equivalent to the variable name
--change the @pvar_folder_name and @pvar_project_name variables to the corresponding folder and SSIS project

--Run 'pre-change' select of package parameters
SELECT
[parameter_name],
[object_name],
[data_type],
[required],
[sensitive],
[description],
[referenced_variable_name]
FROM [catalog].[object_parameters]
WHERE object_type = @pvar_object_type
and [object_name] = @pvar_project_name
AND parameter_name NOT LIKE 'CM%'
AND referenced_variable_name IS NULL

--Create a temporary table for processing each of the project parameters.  The parameter_processed field is a bit field used by the later WHILE..BREAK loop to indicate the configuration for that parameter is complete
DECLARE @tProjectParameters TABLE (parameter_name NVARCHAR(128) NOT NULL, param_object_name NVARCHAR(128) NOT NULL, parameter_folder NVARCHAR(128) NULL, project_name NVARCHAR(128) NOT NULL, parameter_type varchar(1) NOT NULL, parameter_value NVARCHAR(128) NOT NULL, parameter_processed BIT NOT NULL)

--Load package parameters to temporary processing table
INSERT INTO @tProjectParameters (parameter_name, param_object_name , parameter_folder , project_name , parameter_type , parameter_value , parameter_processed)
SELECT
parameter_name AS pvar_param_name,
@pvar_object_name,
@pvar_folder_name,
@pvar_project_name,
N'R',
parameter_name AS pvar_param_value,
0
FROM [catalog].[object_parameters]
WHERE object_type = @pvar_object_type
AND parameter_name NOT LIKE 'CM%'
AND referenced_variable_name IS NULL

--Loop through the unprocessed parameters, setting the referenced_variable value equal to the name of the variable.
--Later, scripts creating environments use these variables to map the environment specific values to the parameters
DECLARE @var_param_name NVARCHAR(128)
DECLARE @var_object_name NVARCHAR(128)
DECLARE @var_folder_name NVARCHAR(128)
DECLARE @var_project_name NVARCHAR(128)
DECLARE @var_param_value NVARCHAR(128)
DECLARE @var_value_type NVARCHAR(1)

WHILE (SELECT COUNT(*) FROM @tProjectParameters WHERE parameter_processed = 0) >  0
BEGIN
	SELECT TOP 1 
	@var_param_name = parameter_name,
	@var_object_name = param_object_name,
	@var_folder_name = parameter_folder,
	@var_project_name = project_name,
	@var_value_type = parameter_type,
	@var_param_value = parameter_value
	FROM @tProjectParameters
	WHERE parameter_processed = 0

	EXEC [catalog].[set_object_parameter_value] @object_type=@pvar_object_type, @parameter_name=@var_param_name, @object_name=@var_object_name, @folder_name=@var_folder_name ,	@project_name=@var_project_name, @value_type=@var_value_type, @parameter_value=@var_param_value

	UPDATE @tProjectParameters SET parameter_processed = 1
	WHERE parameter_name = @var_param_name 

		IF (SELECT COUNT(*) FROM @tProjectParameters WHERE parameter_processed = 0) =  0
		BREAK
		ELSE
		CONTINUE

END

SELECT
[parameter_name],
[object_name],
[data_type],
[required],
[sensitive],
[description],
[referenced_variable_name]
FROM [catalog].[object_parameters]
WHERE object_type = @pvar_object_type
and [object_name] = @pvar_project_name
AND parameter_name NOT LIKE 'CM%'
