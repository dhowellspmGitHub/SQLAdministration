USE [SSISDB]
GO

SET NOCOUNT ON;
/*
AUTHOR: Danny Howell
DESCRIPTION: This series of TSQL statements create an environment for the folder and project named below in the 
This process creates the environment and copies the parameters from a preexisting 'template' environment which is project/package specific
While it does create environment variables it DOES NOT set any values.  The values are environment specific and must be updated manually.

REQUIRED CHANGES:
@pvar_folder_name -- the SSISDB folder name
@pvar_project_name -- the SSISDB project name
@pvar_templatename -- the template environment from which EVs are copied
@pvar_newenvname -- set to the value for the new environment
*/
--This is to create an environment from a template environment containing all the parameters for a given package.
--No values are assigned for any of the environment variables.
DECLARE @pvar_package_name NVARCHAR(128) = 'Databases_Backup.dtsx'
DECLARE @pvar_folder_name NVARCHAR(128)
DECLARE @pvar_project_name NVARCHAR(128)

DECLARE @pvar_templatename NVARCHAR(128)
DECLARE @pvar_newenvname NVARCHAR(128)

SELECT 
@pvar_folder_name = [FLD1].[name]
,@pvar_project_name = [PRJ1].[name]
FROM [catalog].[folders] AS [FLD1]
INNER JOIN [catalog].[projects] AS [PRJ1]
ON [FLD1].[folder_id] = [PRJ1].[folder_id]
INNER JOIN [catalog].[packages] AS [PKG1]
ON [PRJ1].[project_id] = [PKG1].[project_id]
WHERE [PKG1].[name] LIKE @pvar_package_name

SET @pvar_templatename = N''
SET @pvar_newenvname = N''

DECLARE @var_name NVARCHAR(128)
DECLARE @var_data_type NVARCHAR(128)
DECLARE @var_desc NVARCHAR(1024)
DECLARE @var_sensitive BIT
DECLARE @var sql_variant

SELECT [E1].name FROM [catalog].[environments] AS E1
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE [P1].[name] LIKE @pvar_project_name
AND [F1].[name] LIKE @pvar_folder_name
AND [E1].[name] LIKE @pvar_templatename

IF NOT EXISTS (
SELECT [E1].name FROM [catalog].[environments] AS E1
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE [P1].[name] LIKE @pvar_project_name
AND [F1].[name] LIKE @pvar_folder_name
AND [E1].[name] LIKE @pvar_templatename
)
BEGIN
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
SET @currObject = @pvar_templatename
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Template Environment does not exist'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
END

IF NOT EXISTS (
SELECT [E1].name FROM [catalog].[environments] AS E1
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE [P1].[name] LIKE @pvar_project_name
AND [F1].[name] LIKE @pvar_folder_name
AND [E1].[name] LIKE @pvar_newenvname)
BEGIN
	EXEC [catalog].[create_environment] @environment_name=@pvar_newenvname, @environment_description=N'', @folder_name=@pvar_folder_name
END
ELSE
BEGIN
SET @currObject = @pvar_newenvname
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - environment already exist'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
END



DECLARE @tPackageEnvParameters TABLE (parameter_name NVARCHAR(128) NOT NULL, parameter_data_type NVARCHAR(128) NOT NULL, parameter_description NVARCHAR(1024) NULL, parameter_sensitive BIT NOT NULL, parameter_value SQL_VARIANT NULL, parameter_processed BIT NOT NULL)
INSERT INTO @tPackageEnvParameters (parameter_name, parameter_data_type , parameter_description , parameter_sensitive , parameter_value,parameter_processed) 
SELECT 
[EV1].name
,[EV1].[type]	
,[EV1].[description]
,[EV1].[sensitive]
,[EV1].[value]
,0
FROM [catalog].[environment_variables] AS EV1
INNER JOIN [catalog].[environments] AS E1
ON [EV1].[environment_id] = [E1].[environment_id]
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE [P1].[name] LIKE @pvar_project_name
AND [F1].[name] LIKE @pvar_folder_name
AND [E1].[name] LIKE @pvar_templatename


------------new code above here ------------------------------------
WHILE (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type NOT LIKE 'String') >  0
BEGIN
	SELECT TOP 1 
	@var_name = parameter_name,
	@var_data_type = parameter_data_type,
	@var_desc = parameter_description,
	@var_sensitive = parameter_sensitive,
	@var = 		case parameter_data_type 
		when 'boolean' then cast(parameter_value as bit) 
		when 'int32' then cast(parameter_value as int)
		when 'int64' then cast(parameter_value as bigint) 
		else 0 
	End
	FROM @tPackageEnvParameters
	WHERE parameter_processed = 0
	AND parameter_data_type NOT LIKE 'String'

		IF EXISTS(
		SELECT [EV1].name FROM [catalog].[environment_variables] AS EV1
		INNER JOIN [catalog].[environments] AS E1
		ON [EV1].[environment_id] = [E1].[environment_id]
		INNER JOIN [catalog].[projects] AS P1
		ON [E1].[folder_id] = [P1].[folder_id]
		INNER JOIN [catalog].[folders] AS F1
		ON [P1].[folder_id] = [F1].[folder_id]
		WHERE [P1].[name] LIKE @pvar_project_name
		AND [F1].[name] LIKE @pvar_folder_name
		AND [E1].[name] LIKE @pvar_newenvname
		AND [EV1].[name] LIKE @var_name)
		BEGIN
			EXEC [catalog].[set_environment_variable_value] @folder_name = @pvar_folder_name, @environment_name = @pvar_newenvname, @variable_name = @var_name, @value = @var  
			PRINT 'An environment variable named "' + @var_name + '" already exists in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  An update of the value was performed'
		END
		ELSE
		BEGIN
			EXEC [catalog].[create_environment_variable] @variable_name=@var_name, @sensitive=@var_sensitive, @description=@var_desc, @environment_name=@pvar_newenvname, @folder_name=@pvar_folder_name, @value=@var, @data_type=@var_data_type
			PRINT 'An environment variable named "' + @var_name + '" was created in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  This variable was added with its value set as in the procedure.'
		END
			
	UPDATE @tPackageEnvParameters SET parameter_processed = 1
	WHERE parameter_name = @var_name 

		IF (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type NOT LIKE 'String') =  0
		BREAK
		ELSE
		CONTINUE

END

------------new code above here ------------------------------------
WHILE (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type LIKE 'String') >  0
BEGIN
	SELECT TOP 1 
	@var_name = parameter_name,
	@var_data_type = parameter_data_type,
	@var_desc = parameter_description,
	@var_sensitive = parameter_sensitive,
	@var = parameter_value
	FROM @tPackageEnvParameters
	WHERE parameter_processed = 0
	AND parameter_data_type LIKE 'String'
	AND parameter_sensitive = 0

		IF EXISTS(
		SELECT [EV1].name FROM [catalog].[environment_variables] AS EV1
		INNER JOIN [catalog].[environments] AS E1
		ON [EV1].[environment_id] = [E1].[environment_id]
		INNER JOIN [catalog].[projects] AS P1
		ON [E1].[folder_id] = [P1].[folder_id]
		INNER JOIN [catalog].[folders] AS F1
		ON [P1].[folder_id] = [F1].[folder_id]
		WHERE [P1].[name] LIKE @pvar_project_name
		AND [F1].[name] LIKE @pvar_folder_name
		AND [E1].[name] LIKE @pvar_newenvname
		AND [EV1].[name] LIKE @var_name)
		BEGIN
			EXEC [catalog].[set_environment_variable_value] @folder_name = @pvar_folder_name, @environment_name = @pvar_newenvname, @variable_name = @var_name, @value = @var  
			PRINT 'An environment variable named "' + @var_name + '" already exists in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  An update of the value was performed'
		END
		ELSE
		BEGIN
			EXEC [catalog].[create_environment_variable] @variable_name=@var_name, @sensitive=@var_sensitive, @description=@var_desc, @environment_name=@pvar_newenvname, @folder_name=@pvar_folder_name, @value=@var, @data_type=@var_data_type
			PRINT 'An environment variable named "' + @var_name + '" was created in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  This variable was added with its value set as in the procedure.'
		END
			
	UPDATE @tPackageEnvParameters SET parameter_processed = 1
	WHERE parameter_name = @var_name 

		IF (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type LIKE 'String' AND parameter_sensitive = 0) =  0
		BREAK
		ELSE
		CONTINUE

END


WHILE (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type LIKE 'String') >  0
BEGIN
	SELECT TOP 1 
	@var_name = parameter_name,
	@var_data_type = parameter_data_type,
	@var_desc = parameter_description,
	@var_sensitive = parameter_sensitive,
	@var = N''
	FROM @tPackageEnvParameters
	WHERE parameter_processed = 0
	AND parameter_data_type LIKE 'String'
	AND parameter_sensitive = 1

		IF EXISTS(
		SELECT [EV1].name FROM [catalog].[environment_variables] AS EV1
		INNER JOIN [catalog].[environments] AS E1
		ON [EV1].[environment_id] = [E1].[environment_id]
		INNER JOIN [catalog].[projects] AS P1
		ON [E1].[folder_id] = [P1].[folder_id]
		INNER JOIN [catalog].[folders] AS F1
		ON [P1].[folder_id] = [F1].[folder_id]
		WHERE [P1].[name] LIKE @pvar_project_name
		AND [F1].[name] LIKE @pvar_folder_name
		AND [E1].[name] LIKE @pvar_newenvname
		AND [EV1].[name] LIKE @var_name)
		BEGIN
			EXEC [catalog].[set_environment_variable_value] @folder_name = @pvar_folder_name, @environment_name = @pvar_newenvname, @variable_name = @var_name, @value = @var  
			PRINT 'An environment variable named "' + @var_name + '" already exists in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  An update of the value was performed'
		END
		ELSE
		BEGIN
			EXEC [catalog].[create_environment_variable] @variable_name=@var_name, @sensitive=@var_sensitive, @description=@var_desc, @environment_name=@pvar_newenvname, @folder_name=@pvar_folder_name, @value=@var, @data_type=@var_data_type
			PRINT 'An environment variable named "' + @var_name + '" was created in the environment ' + @pvar_newenvname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  This variable was added with its value set as in the procedure.'
		END
			
	UPDATE @tPackageEnvParameters SET parameter_processed = 1
	WHERE parameter_name = @var_name 

		IF (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type LIKE 'String' AND parameter_sensitive = 1) =  0
		BREAK
		ELSE
		CONTINUE

END

DECLARE @reference_id bigint
	IF NOT EXISTS 
	(
	SELECT *
	FROM [catalog].[environment_references] AS ER1
	INNER JOIN [catalog].[projects] AS P1
	ON [ER1].[project_id] = [P1].[project_id]
	INNER JOIN [catalog].[folders] AS F1
	ON [P1].[folder_id] = [F1].[folder_id]
	WHERE [ER1].[reference_type] = 'R'
	AND [P1].[name] = @pvar_project_name
	AND [ER1].[environment_name] = @pvar_newenvname
	AND [F1].[name] = @pvar_folder_name
	)
	BEGIN
	EXEC [catalog].[create_environment_reference] @environment_name=@pvar_newenvname, @reference_id=@reference_id OUTPUT, @project_name=@pvar_project_name, @folder_name=@pvar_folder_name, @reference_type=R
	PRINT 'The environment reference to the environment named "' + @pvar_newenvname + '" was created for the project ' + @pvar_project_name + ' and folder ' + @pvar_folder_name
	END
	ELSE
	BEGIN
	PRINT 'An environment reference to the environment named "' + @pvar_newenvname + '" already exists for the project ' + @pvar_project_name + ' and folder ' + @pvar_folder_name
	END
	

SELECT 
p.name
,f.name
,er.environment_name
,er.reference_id 
,er.project_id
,er.reference_type
,f.folder_id
,f.created_by_name
,p.deployed_by_name
,cast(p.last_deployed_time as datetime) as last_deployed_time
,cast(p.created_time as datetime) as created_time
,p.[description] as project_description
,f.[description] as folder_description
FROM [internal].[folders] AS f
JOIN [internal].[projects] AS p
ON f.folder_id = p.folder_id
JOIN [internal].[environment_references] AS er
ON p.project_id = er.project_id
where er.environment_name = @pvar_newenvname
and f.name like @pvar_folder_name
and p.name like @pvar_project_name
