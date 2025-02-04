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
@pvar_envname -- the template environment to create
*/
--This is to create an environment from a template environment containing all the parameters for a given package.
--No values are assigned for any of the environment variables.
DECLARE @pvar_package_name NVARCHAR(128) 

DECLARE @pvar_folder_name NVARCHAR(128) 
DECLARE @pvar_project_name NVARCHAR(128)
DECLARE @pvar_envname NVARCHAR(128)
DECLARE @pvar_newenvname NVARCHAR(128)
DECLARE @pvar_object_type INT = 30

SET @pvar_folder_name = 'Maintenance'
SET @pvar_package_name = 'Databases_Maintenance_Statistics_Update.dtsx'
SET @pvar_envname = N'SDBS251-KFB Intranet'




SELECT
'Package Parameters' AS pParameterScope,
[T1].[parameter_name],
[T1].[object_name],
[T1].[data_type],
[T1].[required],
[T1].[sensitive],
[T1].[description],
[T1].[referenced_variable_name]
,[t2].*
FROM [catalog].[object_parameters] AS T1
LEFT OUTER JOIN
(
SELECT 
'Environment Parameters'as eParameterScope
,[E1].name as [PackageName]
,[E1].environment_id
,[EV1].name
,[EV1].[type]	
,[EV1].[description]
,[EV1].[sensitive]
,[EV1].[value]
FROM [catalog].[environment_variables] AS EV1
INNER JOIN [catalog].[environments] AS E1
ON [EV1].[environment_id] = [E1].[environment_id]
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE [P1].[name] LIKE @pvar_project_name
AND [F1].[name] LIKE @pvar_folder_name
AND [E1].[name] LIKE @pvar_envname
) AS T2
ON T1.[parameter_name] = T2.name
WHERE object_type = @pvar_object_type
AND [object_name] LIKE @pvar_package_name
AND parameter_name NOT LIKE 'CM%'
AND referenced_variable_name IS NOT NULL




/*
SELECT 
@pvar_folder_name = [FLD1].[name]
,@pvar_project_name = [PRJ1].[name]
FROM [catalog].[folders] AS [FLD1]
INNER JOIN [catalog].[projects] AS [PRJ1]
ON [FLD1].[folder_id] = [PRJ1].[folder_id]
INNER JOIN [catalog].[packages] AS [PKG1]
ON [PRJ1].[project_id] = [PKG1].[project_id]
WHERE [PKG1].[name] LIKE @pvar_package_name

DECLARE @var_name NVARCHAR(128)
DECLARE @var_data_type NVARCHAR(128)
DECLARE @var_desc NVARCHAR(1024)
DECLARE @var_sensitive BIT
DECLARE @var sql_variant

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
where er.environment_name = @pvar_envname
and f.name like @pvar_folder_name
and p.name like @pvar_project_name
*/

/*
)



BEGIN
	EXEC [catalog].[create_environment] @environment_name=@pvar_envname, @environment_description=N'', @folder_name=@pvar_folder_name
END

DECLARE @pvar_pkgobject_type INT = 20
DECLARE @pvar_object_type INT = 30
DECLARE @pvar_param_value NVARCHAR(200)
DECLARE @tPackageEnvParameters TABLE (parameter_name NVARCHAR(128) NOT NULL, parameter_data_type NVARCHAR(128) NOT NULL, parameter_description NVARCHAR(1024) NULL, parameter_sensitive BIT NOT NULL, parameter_value SQL_VARIANT NULL, parameter_processed BIT NOT NULL)
INSERT INTO @tPackageEnvParameters (parameter_name, parameter_data_type , parameter_description , parameter_sensitive , parameter_value,parameter_processed) 
SELECT
[parameter_name],
case [data_type] when 'double' then 'int32' else [data_type] end,
[description],
[sensitive],
0,
0
FROM [catalog].[object_parameters]
WHERE 
object_type = @pvar_pkgobject_type
AND 
[object_name] LIKE @pvar_project_name
AND parameter_name NOT LIKE 'CM%'
UNION ALL
SELECT
[parameter_name],
case [data_type] when 'double' then 'int32' else [data_type] end,
[description],
[sensitive],
0,
0
FROM [catalog].[object_parameters]
WHERE 
object_type = @pvar_object_type
AND 
[object_name] LIKE @pvar_package_name
AND parameter_name NOT LIKE 'CM%'

------------new code above here ------------------------------------
WHILE (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type NOT LIKE 'String') >  0
BEGIN
	SELECT TOP 1 
	@var_name = parameter_name,
	@var_data_type = case parameter_data_type when 'double' then 'int' else parameter_data_type end ,
	@var_desc = parameter_description,
	@var_sensitive = parameter_sensitive,
	@var = 		case parameter_data_type 
		when 'boolean' then cast(0 as bit) 
		when 'int32' then cast(0 as int)
		when 'int64' then cast(0 as bigint) 
		when 'double' then cast(0 as int) 
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
		AND [E1].[name] LIKE @pvar_envname
		AND [EV1].[name] LIKE @var_name)
		BEGIN
			EXEC [catalog].[set_environment_variable_value] @folder_name = @pvar_folder_name, @environment_name = @pvar_envname, @variable_name = @var_name, @value = @var  
			PRINT 'An environment variable named "' + @var_name + '" already exists in the environment ' + @pvar_envname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  An update of the value was performed'
		END
		ELSE
		BEGIN
			EXEC [catalog].[create_environment_variable] @variable_name=@var_name, @sensitive=@var_sensitive, @description=@var_desc, @environment_name=@pvar_envname, @folder_name=@pvar_folder_name, @value=@var, @data_type=@var_data_type
			PRINT 'An environment variable named "' + @var_name + '" was created in the environment ' + @pvar_envname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  This variable was added with its value set as in the procedure.'
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
	@var = N''
	FROM @tPackageEnvParameters
	WHERE parameter_processed = 0
	AND parameter_data_type LIKE 'String'

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
		AND [E1].[name] LIKE @pvar_envname
		AND [EV1].[name] LIKE @var_name)
		BEGIN
			EXEC [catalog].[set_environment_variable_value] @folder_name = @pvar_folder_name, @environment_name = @pvar_envname, @variable_name = @var_name, @value = @var  
			PRINT 'An environment variable named "' + @var_name + '" already exists in the environment ' + @pvar_envname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  An update of the value was performed'
		END
		ELSE
		BEGIN
			EXEC [catalog].[create_environment_variable] @variable_name=@var_name, @sensitive=@var_sensitive, @description=@var_desc, @environment_name=@pvar_envname, @folder_name=@pvar_folder_name, @value=@var, @data_type=@var_data_type
			PRINT 'An environment variable named "' + @var_name + '" was created in the environment ' + @pvar_envname + ' for the project ' + @pvar_project_name + ' and folder ' +         @pvar_folder_name + '.  This variable was added with its value set as in the procedure.'
		END
			
	UPDATE @tPackageEnvParameters SET parameter_processed = 1
	WHERE parameter_name = @var_name 

		IF (SELECT COUNT(*) FROM @tPackageEnvParameters WHERE parameter_processed = 0 AND parameter_data_type LIKE 'String') =  0
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
	AND [ER1].[environment_name] = @pvar_envname
	AND [F1].[name] = @pvar_folder_name
	)
	BEGIN
	EXEC [catalog].[create_environment_reference] @environment_name=@pvar_envname, @reference_id=@reference_id OUTPUT, @project_name=@pvar_project_name, @folder_name=@pvar_folder_name, @reference_type=R
	PRINT 'The environment reference to the environment named "' + @pvar_envname + '" was created for the project ' + @pvar_project_name + ' and folder ' + @pvar_folder_name
	END
	ELSE
	BEGIN
	PRINT 'An environment reference to the environment named "' + @pvar_envname + '" already exists for the project ' + @pvar_project_name + ' and folder ' + @pvar_folder_name
	END
*/	
