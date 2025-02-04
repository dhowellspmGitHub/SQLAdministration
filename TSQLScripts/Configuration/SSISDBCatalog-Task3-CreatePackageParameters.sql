
SET NOCOUNT ON

USE [SSISDB]
GO
-- Change the folder and project variables if this is being run for packages other than SQL Administration-Maintenance SSIS project packages

DECLARE @pvar_folder_name NVARCHAR(128)
DECLARE @pvar_param_name NVARCHAR(128)
DECLARE @pvar_project_name NVARCHAR(128)
--process below is set to read the package level parameters and set the 'referenced_variable_name' (placeholder) equivalent to the variable name
--change the @pvar_package_name to the SSIS package for which this configuration is being performed
DECLARE @pvar_package_name NVARCHAR(128)
SET @pvar_folder_name=N'Administration'

SET @pvar_project_name=N'Maintenance'
SET @pvar_package_name = 'Databases_Maintenance_Statistics_Update.dtsx'
--SET @pvar_package_name = 'Databases_Maintenance_Index_Defragmentation.dtsx'

--SET @pvar_project_name=N'Backup-Restore'
--SET @pvar_package_name = 'Databases_Backup.dtsx'

DECLARE @pvar_object_type INT = 30
DECLARE @pvar_param_value NVARCHAR(200)

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
AND [object_name] LIKE @pvar_package_name
AND parameter_name NOT LIKE 'CM%'
AND referenced_variable_name IS NULL

--Create a temporary table for processing each of the package parameters.  The parameter_processed field is a bit field used by the later WHILE..BREAK loop to indicate the configuration for that parameter is complete
DECLARE @tPackageParameters TABLE (
parameter_name NVARCHAR(128) NOT NULL, 
parameter_folder NVARCHAR(128) NOT NULL, 
project_name NVARCHAR(128) NOT NULL, 
parameter_value NVARCHAR(128) NOT NULL, 
parameter_processed BIT NOT NULL)

--Load package parameters to temporary processing table
INSERT INTO @tPackageParameters (
parameter_name, 
parameter_folder , 
project_name , 
parameter_value , 
parameter_processed)
SELECT
parameter_name AS pvar_param_name,
@pvar_folder_name,
@pvar_project_name, 
parameter_name AS pvar_param_value,
0
FROM [catalog].[object_parameters]
WHERE object_type = @pvar_object_type
AND object_name LIKE @pvar_package_name
AND parameter_name NOT LIKE 'CM%'
AND referenced_variable_name IS NULL

--Loop through the unprocessed parameters, setting the referenced_variable value equal to the name of the variable.
--Later, scripts creating environments use these variables to map the environment specific values to the parameters
DECLARE @var_param_name NVARCHAR(128)
DECLARE @var_folder_name NVARCHAR(128)
DECLARE @var_project_name NVARCHAR(128)
DECLARE @var_param_value NVARCHAR(128)
DECLARE @var_value_type NVARCHAR(1)

WHILE (SELECT COUNT(*) FROM @tPackageParameters WHERE parameter_processed = 0) >  0
BEGIN
	SELECT TOP 1 
	@var_param_name = parameter_name,
	@var_folder_name = parameter_folder,
	@var_project_name = project_name,
	@var_param_value = parameter_value
	FROM @tPackageParameters
	WHERE parameter_processed = 0

	EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=@pvar_object_type, @parameter_name=@var_param_name, @object_name=@pvar_package_name, @folder_name=@var_folder_name, @project_name=@var_project_name, @value_type=R, @parameter_value=@var_param_value

	UPDATE @tPackageParameters SET parameter_processed = 1
	WHERE parameter_name = @var_param_name 
		IF (SELECT COUNT(*) FROM @tPackageParameters WHERE parameter_processed = 0) =  0
		BREAK
		ELSE
		CONTINUE

END

--Run 'post-change' select of package parameters
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
AND [object_name] LIKE @pvar_package_name
AND parameter_name NOT LIKE 'CM%'
