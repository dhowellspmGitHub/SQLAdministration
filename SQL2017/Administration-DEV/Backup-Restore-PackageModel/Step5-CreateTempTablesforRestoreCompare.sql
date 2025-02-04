USE [CC_G_ETL]
GO
declare @tcnum int
declare @tcname varchar(300)
set @tcnum = 1
set @tcname = 'User Confirmation'
/* Queries record the DBPs,DBRs, DBRMs and DBR authoriztions before the restore package is run.
Used to confirm the backup is getting all the users, roles and permissions
*/

delete from [tempdb].[dbo].[prerestore_database_principals]
where [databasename] = db_name()

INSERT INTO [tempdb].[dbo].[prerestore_database_principals]
([TCNum]
,[databasename]
,[name]
,[principal_id]
,[type]
,[default_schema_name]
,[sid]
,[owning_principal_id])
SELECT 
@tcnum as TCNum
,DB_NAME() AS [databasename]
,[RUT2].[name]
,[RUT2].[principal_id]
,[RUT2].[type]
,[RUT2].[default_schema_name]
,[RUT2].[sid]
,[RUT2].[owning_principal_id]
FROM [sys].[database_principals] AS RUT2
WHERE [RUT2].[type] IN ('S','U','G')
and [RUT2].[principal_id] > 0
and [RUT2].[is_fixed_role] = 0

set @tcnum = 2
set @tcname = 'Custom Role Confirmation'

delete from tempdb.dbo.prerestore_database_roles
where databasename = DB_NAME()

INSERT INTO [tempdb].[dbo].[prerestore_database_roles]
([TCNum]
,[databasename]
,[name]
,[principal_id]
,[type]
,[default_schema_name]
,[sid]
,[owning_principal_id])
SELECT 
@tcnum as TCNum
,DB_NAME() AS [databasename]
,[RUT2].[name]
,[RUT2].[principal_id]
,[RUT2].[type]
,[RUT2].[default_schema_name]
,[RUT2].[sid]
,[RUT2].[owning_principal_id]
FROM [sys].[database_principals] AS RUT2
WHERE [RUT2].[type] IN ('R')
and [RUT2].[principal_id] > 0
and [RUT2].[is_fixed_role] = 0


set @tcnum = 3
set @tcname = 'Role Permission Confirmation';

delete from [tempdb].[dbo].[prerestore_database_role_permissions]
where databasename = DB_NAME()

INSERT INTO [tempdb].[dbo].[prerestore_database_role_permissions]
([TCNum]
,[databasename]
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
SELECT 
@tcnum as TCNum
,CAST(DB_NAME() AS VARCHAR(128)) AS [databasename]
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



set @tcnum = 4
set @tcname = 'Role Members Confirmation';

delete from [tempdb].[dbo].[prerestore_database_role_members]
where databasename = db_name()

INSERT INTO [tempdb].[dbo].[prerestore_database_role_members]
([TCNum]
,[databasename]
,[member_principal_id]
,[role_name]
,[principal_id]
,[sid]
,[is_fixed_role]
,[principal_name])
SELECT
@tcnum as TCNum
,DB_NAME() as [databasename]
,[DRM1].[member_principal_id]
,[DP1].[name] as [role_name]
,[DP1].[principal_id]
,[DP1].[sid]
,[DP1].[is_fixed_role]
,[DP2].[name] as [principal_name]
FROM [sys].[database_role_members] AS DRM1
INNER JOIN [sys].[database_principals] AS DP1
ON [DRM1].[role_principal_id] = [DP1].[principal_id]
INNER JOIN [sys].[database_principals] AS DP2
ON [DRM1].[member_principal_id] = [DP2].[principal_id]
WHERE [dp1].[name] NOT IN ('dbo','sys','guest','INFORMATION_SCHEMA')


select 'prerestore_database_principals',
* from [tempdb].[dbo].[prerestore_database_principals]
WHERE [databasename] = db_name()

select 'prerestore_database_role_members',
* from [tempdb].[dbo].[prerestore_database_role_members]
WHERE [databasename] = db_name()

select 'prerestore_database_role_permissions',
* from [tempdb].[dbo].[prerestore_database_role_permissions]
WHERE [databasename] = db_name()

select 'prerestore_database_roles',
* from [tempdb].[dbo].[prerestore_database_roles]
WHERE [databasename] = db_name()