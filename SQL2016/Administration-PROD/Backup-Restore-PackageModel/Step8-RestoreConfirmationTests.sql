USE [RUTest1]
GO
declare @tcnum int
declare @tcname varchar(300)
set @tcnum = 1
set @tcname = 'User Confirmation-Missing Restores'
SELECT 
[TCNum]
,@tcname
,[databasename] COLLATE SQL_Latin1_General_CP1_CI_AS
,[name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[principal_id]
,[type] COLLATE SQL_Latin1_General_CP1_CI_AS
,[default_schema_name] COLLATE SQL_Latin1_General_CP1_CI_AS
,[owning_principal_id] 
FROM [tempdb].[dbo].[prerestore_database_principals]
WHERE [databasename] = DB_NAME()
except
SELECT 
@tcnum
,@tcname
,DB_NAME() COLLATE SQL_Latin1_General_CP1_CI_AS
,[name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[principal_id]
,[type] COLLATE SQL_Latin1_General_CP1_CI_AS
,[default_schema_name] COLLATE SQL_Latin1_General_CP1_CI_AS
,[owning_principal_id] 
FROM [sys].[database_principals]
WHERE [type] IN ('S','U','G')
and [principal_id] > 0
and [is_fixed_role] = 0


set @tcnum = 2
set @tcname = 'Custom Role Confirmation-Missing Roles'
SELECT 
[TCNum]
,@tcname
,[databasename] COLLATE SQL_Latin1_General_CP1_CI_AS
,[name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[principal_id]
,[type] COLLATE SQL_Latin1_General_CP1_CI_AS
,[default_schema_name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[owning_principal_id]
FROM [tempdb].[dbo].[prerestore_database_roles]
WHERE [databasename] = DB_NAME()
EXCEPT
SELECT 
@tcnum as TCNum
,@tcname
,DB_NAME() COLLATE SQL_Latin1_General_CP1_CI_AS AS [databasename] 
,[RUT2].[name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[RUT2].[principal_id]
,[RUT2].[type] COLLATE SQL_Latin1_General_CP1_CI_AS
,[RUT2].[default_schema_name] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[RUT2].[owning_principal_id]
FROM [sys].[database_principals] AS RUT2
WHERE [RUT2].[type] IN ('R')
and [RUT2].[principal_id] > 0
and [RUT2].[is_fixed_role] = 0



set @tcnum = 3
set @tcname = 'Role Permission Confirmation';
SELECT 
[TCNum]
,@tcname
,[databasename] COLLATE SQL_Latin1_General_CP1_CI_AS
,[object_schema_name] COLLATE SQL_Latin1_General_CP1_CI_AS
,[object_name] COLLATE SQL_Latin1_General_CP1_CI_AS
,[object_type_desc] COLLATE SQL_Latin1_General_CP1_CI_AS
,[object_type] COLLATE SQL_Latin1_General_CP1_CI_AS
--,[grantee_principal_id]
,[permission_type] COLLATE SQL_Latin1_General_CP1_CI_AS
,[permission_name] COLLATE SQL_Latin1_General_CP1_CI_AS
,[permission_state] COLLATE SQL_Latin1_General_CP1_CI_AS
,[permission_state_desc] COLLATE SQL_Latin1_General_CP1_CI_AS
,[permission_class] 
,[permission_class_desc] COLLATE SQL_Latin1_General_CP1_CI_AS
,[permission_major_object_id]
,[permission_minor_object_type]
FROM [tempdb].[dbo].[prerestore_database_role_permissions]
WHERE [databasename] = DB_NAME()
EXCEPT
SELECT 
@tcnum as TCNum
,@tcname
,CAST(DB_NAME() AS VARCHAR(128)) COLLATE SQL_Latin1_General_CP1_CI_AS AS [databasename]
,ISNULL(SCHEMA_NAME([SO1].[schema_id]),'dbo') COLLATE SQL_Latin1_General_CP1_CI_AS AS [object_schema_name]
,ISNULL([SO1].[name],'DATABASE') COLLATE SQL_Latin1_General_CP1_CI_AS AS [object_name]
,ISNULL([SO1].[type_desc],'Database') COLLATE SQL_Latin1_General_CP1_CI_AS AS [object_type_desc]
,ISNULL([SO1].[type],'DB') COLLATE SQL_Latin1_General_CP1_CI_AS AS [object_type]
--,[DP2].[grantee_principal_id] AS [grantee_principal_id]
,[DP2].[type] COLLATE SQL_Latin1_General_CP1_CI_AS AS [permission_type] 
,[DP2].[permission_name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [permission_name] 
,[DP2].[state] COLLATE SQL_Latin1_General_CP1_CI_AS AS [permission_state] 
,[DP2].[state_desc] COLLATE SQL_Latin1_General_CP1_CI_AS AS [permission_state_desc] 
,[DP2].[class] AS [permission_class] 
,[DP2].[class_desc] COLLATE SQL_Latin1_General_CP1_CI_AS AS [permission_class_desc] 
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
set @tcname = 'Role Members Confirmation-Missing Members';

SELECT 
[TCNum]
,@tcname
,[databasename]
--,[member_principal_id]
,[role_name]
--,[principal_id]
,[is_fixed_role]
,[principal_name]
FROM [tempdb].[dbo].[prerestore_database_role_members]
WHERE [databasename] = DB_NAME()
EXCEPT
SELECT
@tcnum as TCNum
,@tcname
,DB_NAME() as [databasename]
--,[DRM1].[member_principal_id]
,[DP1].[name] as [role_name]
--,[DP1].[principal_id]
,[DP1].[is_fixed_role]
,[DP2].[name] as [principal_name]
FROM [sys].[database_role_members] AS DRM1
INNER JOIN [sys].[database_principals] AS DP1
ON [DRM1].[role_principal_id] = [DP1].[principal_id]
INNER JOIN [sys].[database_principals] AS DP2
ON [DRM1].[member_principal_id] = [DP2].[principal_id]
WHERE [dp1].[name] NOT IN ('dbo','sys','guest','INFORMATION_SCHEMA')



