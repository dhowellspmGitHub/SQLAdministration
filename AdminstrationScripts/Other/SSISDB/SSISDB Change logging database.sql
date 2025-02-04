USE [SSISDB]
GO
DECLARE @var sql_variant = N'KFBSQLMgmt'
DECLARE @envname NVARCHAR(128)
declare @varname NVARCHAR(128) = N'Database_Name_01'

DECLARE @pvar_folder_name NVARCHAR(128)
DECLARE @pvar_project_name NVARCHAR(128)
SET @pvar_folder_name  = N'Administration'
SET @pvar_project_name=N'Maintenance'
SELECT 
E1.name,
[EV1].name, ev1.value FROM [catalog].[environment_variables] AS EV1
		INNER JOIN [catalog].[environments] AS E1
		ON [EV1].[environment_id] = [E1].[environment_id]
		INNER JOIN [catalog].[projects] AS P1
		ON [E1].[folder_id] = [P1].[folder_id]
		INNER JOIN [catalog].[folders] AS F1
		ON [P1].[folder_id] = [F1].[folder_id]
		WHERE [P1].[name] LIKE @pvar_project_name
		AND [F1].[name] LIKE @pvar_folder_name
		AND [Ev1].[name] LIKE @varname

DECLARE envcur CURSOR
FOR
SELECT 
--[CP1].[name]
--,[CER1].[environment_folder_name]
[CER1].[environment_name]
--,[CER1].[reference_id]
--,[CER1].[validation_status]
--,[CER1].[last_validation_time]
--,[CP1].[description]
--,[CP1].[deployed_by_name]
--,[CP1].[last_deployed_time]
FROM [catalog].[environment_references] AS CER1
INNER JOIN [catalog].[projects] CP1
ON [CER1].[project_id] = [CP1].[project_id]
WHERE [CP1].[name] like 'Maintenance'
ORDER BY [CER1].[environment_name] 

OPEN envcur
FETCH NEXT from envcur
INTO @envname

WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT from envcur
INTO @envname
EXEC [catalog].[set_environment_variable_value] @variable_name=@varname, @environment_name=@envname, @folder_name=N'Administration', @value=@var
END
CLOSE envcur
DEALLOCATE envcur



DECLARE @pvar_folder_name NVARCHAR(128)
DECLARE @pvar_project_name NVARCHAR(128)
SET @pvar_folder_name  = N'Administration'
SET @pvar_project_name=N'Maintenance'
SELECT [EV1].name, ev1.value FROM [catalog].[environment_variables] AS EV1
		INNER JOIN [catalog].[environments] AS E1
		ON [EV1].[environment_id] = [E1].[environment_id]
		INNER JOIN [catalog].[projects] AS P1
		ON [E1].[folder_id] = [P1].[folder_id]
		INNER JOIN [catalog].[folders] AS F1
		ON [P1].[folder_id] = [F1].[folder_id]
		WHERE [P1].[name] LIKE @pvar_project_name
		AND [F1].[name] LIKE @pvar_folder_name
		AND [Ev1].[name] LIKE @varname