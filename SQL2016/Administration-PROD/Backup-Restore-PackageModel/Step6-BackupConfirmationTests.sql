USE [RUTest1]
GO
declare @tcnum int
declare @tcname varchar(300)
set @tcnum = 1
set @tcname = 'User Confirmation'

SELECT 
@tcnum
,@tcname
,DB_NAME() AS [databasename]
,[RUT2].[name]
,[RUT2].[principal_id]
,[RUT2].[type]
,[RUT2].[default_schema_name]
,[RUT2].[sid]
,[RUT2].[owning_principal_id]
,[RUT1].[name]
,[RUT1].[principal_id]
,[RUT1].[type]
,[RUT1].[default_schema_name]
,[RUT1].[sid]
,[RUT1].[server_principal]
FROM [sys].[database_principals] AS RUT2
LEFT OUTER JOIN [msdb].[dbo].[database_restore_users] AS RUT1
ON [RUT2].[name] = [RUT1].[name]
AND [RUT1].databasename = DB_NAME()
WHERE [RUT2].[type] IN ('S','U','G')
and [RUT2].[principal_id] > 0
and [RUT2].[is_fixed_role] = 0
AND [RUT1].[name] is null
ORDER BY [RUT1].[name];
GO


declare @tcnum int
declare @tcname varchar(300);

set @tcnum = 2
set @tcname = 'Role Permission Confirmation';


WITH cteDBRolePermissions (
[databasename]
,[object_schema_name]
,[object_name]
,[object_type_desc]
,[object_type]
,[grantee_principal_id]
,[permission_type]
,[permission_name]
,[permission_state]
,[permission_state_desc]
,[permission_class]
,[permission_class_desc]
,[permission_major_object_id]
,[permission_minor_object_type])
AS
(
SELECT 
CAST(DB_NAME() AS VARCHAR(128)) AS [databasename]
,ISNULL(SCHEMA_NAME([SO1].[schema_id]),'dbo') AS [object_schema_name]
,ISNULL([SO1].[name],'DATABASE') AS [object_name]
,ISNULL([SO1].[type_desc],'Database') AS [object_type_desc]
,ISNULL([SO1].[type],'DB') AS [object_type]
,[DP2].[grantee_principal_id] AS [grantee_principal_id]
,[DP2].[type] AS [permission_type]
,[DP2].[permission_name] AS [permission_name]
,[DP2].[state] AS [permission_state]
,[DP2].[state_desc] AS [permission_state_desc]
,[DP2].[class] AS [permission_class]
,[DP2].[class_desc] AS [permission_class_desc]
,[DP2].[major_id] AS [permission_major_object_id]
,[DP2].[minor_id] AS [permission_minor_object_type]
FROM [sys].[database_permissions] AS DP2
INNER JOIN [sys].[database_principals] AS DP1
ON [DP2].[grantee_principal_id] = [DP1].[principal_id]
LEFT OUTER JOIN [sys].[objects] AS SO1
ON [DP2].[major_id] = [SO1].[object_id]
WHERE [DP1].[type] = 'R'
AND [DP1].[is_fixed_role] <> 1
AND [DP1].[principal_id] > 0
AND [DP1].[name] NOT IN ('dbo','sys','guest','INFORMATION_SCHEMA')
)

SELECT 
@tcnum
,@tcname
,[dp1].[databasename]
,[dp1].[object_schema_name]
,[dp1].[object_name]
,[dp1].[object_type_desc]
,[dp1].[object_type]
,[dp1].[grantee_principal_id]
,[DP1].[permission_type]
,[DP1].[permission_name]
,[DP1].[permission_state]
,[DP1].[permission_state_desc]
,[DP1].[permission_class]
,[DP1].[permission_class_desc]
,[DP1].[permission_major_object_id]
,[DP1].[permission_minor_object_type]
,[RUT1].[object_schema_name]
,[RUT1].[object_name]
,[RUT1].[object_type_desc]
,[RUT1].[object_type]
,[RUT1].[grantee_principal_id]
FROM [cteDBRolePermissions] AS DP1
LEFT OUTER JOIN [msdb].[dbo].[database_restore_customrolepermissions] AS RUT1
on
[DP1].[databasename] = [RUT1].[databasename]
AND [DP1].[object_schema_name] = [RUT1].[object_schema_name]
AND [DP1].[object_name] = [RUT1].[object_name]
AND [DP1].[object_type] = [RUT1].[object_type] COLLATE SQL_Latin1_General_CP1_CI_AS
AND [DP1].[permission_type] = [RUT1].[permission_type] COLLATE SQL_Latin1_General_CP1_CI_AS
AND [DP1].[permission_state] = [RUT1].[permission_state] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE [DP1].[databasename] = DB_NAME()
and [RUT1].[object_name] is null
ORDER BY [RUT1].[object_name];
GO




declare @tcnum int
declare @tcname varchar(300);

set @tcnum = 3
set @tcname = 'Role Members Confirmation';

WITH RUT2 ([databasename],[member_principal_id],[role_name],[principal_id],[sid],[is_fixed_role],[user_name])
AS
(
SELECT
DB_NAME() as [databasename]
,[DRM1].[member_principal_id]
,[DP1].[name]
,[DP1].[principal_id]
,[DP1].[sid]
,[DP1].[is_fixed_role]
,[DP2].[name]
FROM [sys].[database_role_members] AS DRM1
INNER JOIN [sys].[database_principals] AS DP1
ON [DRM1].[role_principal_id] = [DP1].[principal_id]
INNER JOIN [sys].[database_principals] AS DP2
ON [DRM1].[member_principal_id] = [DP2].[principal_id]
WHERE [dp1].[name] NOT IN ('dbo','sys','guest','INFORMATION_SCHEMA')
)



SELECT 
@tcnum
,@tcname
,[rut2].[databasename]
,[rut2].[member_principal_id]
,[rut2].[role_name]
,[rut2].[principal_id]
,[rut2].[sid]
,[rut2].[is_fixed_role]
,[rut2].[user_name]
,[RDPM1].[databasename]
,[RDPM1].[member_principal_id]
,[RDPM1].[role_name]
,[RDPM1].[principal_id]
,[RDPM1].[sid]
,[RDPM1].[is_fixed_role]
FROM RUT2
LEFT OUTER JOIN [msdb].[dbo].[database_restore_usersrolemembers] AS RDPM1
inner join [msdb].[dbo].[database_restore_users] as RDP1
ON [RDPM1].[databasename] = [RDP1].[databasename]
AND [RDPM1].member_principal_id = [RDP1].[principal_id]
ON [RUT2].[databasename] = [RDPM1].[databasename]
AND [RUT2].[role_name] = [RDPM1].[role_name]
AND [RUT2].[user_name] = [RDP1].[name]
WHERE [RDPM1].[role_name] IS NULL
ORDER BY [RDPM1].[role_name];