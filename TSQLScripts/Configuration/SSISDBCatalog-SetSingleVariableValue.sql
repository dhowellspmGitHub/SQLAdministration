USE [SSISDB]
GO

DECLARE @pvar_templatename NVARCHAR(128)
DECLARE @envvalue NVARCHAR(128)
set @envvalue = '\\sddb200%'

SELECT DISTINCT [EV1].name, [EV1].value, 
E1.environment_id,e1.name
FROM [catalog].[environment_variables] AS EV1
INNER JOIN [catalog].[environments] AS E1
ON [EV1].[environment_id] = [E1].[environment_id]
INNER JOIN [catalog].[projects] AS P1
ON [E1].[folder_id] = [P1].[folder_id]
INNER JOIN [catalog].[folders] AS F1
ON [P1].[folder_id] = [F1].[folder_id]
WHERE CAST(EV1.value AS NVARCHAR(128)) LIKE @envvalue


DECLARE @var sql_variant = N'\\vx01-dd038-backup\backup\sql'
EXEC [catalog].[set_environment_variable_value] 
	@variable_name=N'Backup_Parameters_PrimaryPathRoot'
	,@environment_name=N'Backups-npSDBS004-Full'
	,@folder_name=N'Administration'
	,@value=@var
GO
