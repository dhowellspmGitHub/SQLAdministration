
IF NOT EXISTS (SELECT * FROM tempdb.sys.objects where NAME like 'SecurityCleanupSPServerRoles' and type like 'U')
BEGIN
CREATE TABLE [tempdb].[dbo].[SecurityCleanupSPServerRoles](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[RoleName] [sysname] NOT NULL
) ON [PRIMARY]
END
ELSE
BEGIN
TRUNCATE TABLE [tempdb].[dbo].[SecurityCleanupSPServerRoles]
END

IF NOT EXISTS (SELECT * FROM tempdb.sys.objects where NAME like 'SecurityCleanupSPServerPrincipals' and type like 'U')
BEGIN
CREATE TABLE [tempdb].[dbo].[SecurityCleanupSPServerPrincipals](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[CountOfDatabasesUsedIn] INT
) ON [PRIMARY]
END
ELSE
BEGIN
TRUNCATE TABLE [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
END

INSERT INTO [tempdb].[dbo].[SecurityCleanupSPServerRoles]
([name]
,[principal_id]
,[sid]
,[RoleName]
)
 select 
sp1.name,
sp1.principal_id,
sp1.[sid],
sr1.name as RoleName
from master.sys.server_principals as sp1
left outer join master.sys.server_role_members as srm1
on sp1.principal_id = srm1.member_principal_id
inner join master.sys.server_principals as sr1
on sr1.principal_id = srm1.role_principal_id
where sp1.[type] in ('s')
and sp1.principal_id > 100
GO

--create table to track how many databases a server login has a corresponding database principal in
--these server logins are the ones that DO NOT have any server role
INSERT INTO [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
([name]
,[principal_id]
,[sid]
,[CountOfDatabasesUsedIn])
select 
sp1.name,
sp1.principal_id,
sp1.[sid],
0
from master.sys.server_principals as sp1
left outer join master.sys.server_role_members as srm1
on sp1.principal_id = srm1.member_principal_id
left join master.sys.server_principals as sr1
on sr1.principal_id = srm1.role_principal_id
where sp1.[type] in ('s')
and sp1.principal_id > 100
and sp1.[sid] NOT IN (SELECT [sid]  FROM [tempdb].[dbo].[SecurityCleanupSPServerRoles])
GO



--FOR EACH DATABASE
USE []
GO

DECLARE @DPBSid VARBINARY(85)
DECLARE @DBPUserName NVARCHAR(128)
DECLARE @DBPId INT
DECLARE @DBRoleName NVARCHAR(128)
DECLARE @CanDropUserInd BIT
DECLARE @DropSchemaTSQL NVARCHAR(500)
DECLARE @DropUserTSQL NVARCHAR(500)

--get database principals that are only assigned the 'public' role.  The public role is a default role that has no real access.  These can be removed from the database
DECLARE DBPCur CURSOR FOR
select 
dbp1.[sid],
dbp1.name,
dbp1.principal_id,
dbu2.RoleName
from sys.database_principals as dbp1
LEFT OUTER JOIN (
select 
dbp1.[sid],
dbp1.name,
dbr1.name as RoleName
from sys.database_principals as dbp1
INNER join sys.database_role_members as dbrm1
on dbp1.principal_id = dbrm1.member_principal_id
INNER join master.sys.database_principals as dbr1
on dbr1.principal_id = dbrm1.role_principal_id
where dbp1.[type] in ('s')
) AS dbu2
ON dbp1.[sid] = dbu2.[sid]
WHERE dbu2.RoleName is null
and dbp1.principal_id > 5
and dbp1.[type] = 's'

--however, because of the SQL 2000 compatibility, these database principals may have own a schema usually with same name.  If the schema contains no objects, then delete the schema first, then the user
OPEN DBPCur
FETCH NEXT FROM DBPCur 
INTO @DPBSid, @DBPUserName, @DBPId, @DBRoleName 

WHILE @@FETCH_STATUS = 0
BEGIN
SET @CanDropUserInd = 1
PRINT 'Processing user:' + @DBPUserName
PRINT 'Checking if user owns any schemas'
	DECLARE @DBOwnedSchemaId INT
	DECLARE @DBOwnedSchema NVARCHAR(128)
	DECLARE DBPOwnedSchemas CURSOR FOR
	SELECT name, [schema_id]  FROM sys.schemas where principal_id = @DBPId and schema_id > 4

	OPEN DBPOwnedSchemas
	FETCH NEXT FROM DBPOwnedSchemas
	INTO @DBOwnedSchema, @DBOwnedSchemaId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--SELECT * from sys.objects where schema_id = schema_id(@DBOwnedSchemaId) and [type] not in ('s')
		IF (SELECT count(*) from sys.objects where schema_id = schema_id(@DBOwnedSchemaId) and [type] not in ('s') ) = 0
		BEGIN
			PRINT 'No objects exist for schema:' + @DBOwnedSchema
			PRINT 'Deleting schema:'  + @DBOwnedSchema
			SET @DropSchemaTSQL = 'DROP SCHEMA [' + @DBOwnedSchema + ']'
			exec sp_executesql @DropSchemaTSQL
			SET @CanDropUserInd = 1
		END
		ELSE
		BEGIN
			PRINT 'User name ' + @DBPUserName + ' owns schema named ' + @DBOwnedSchema + ' and schema contains object.  Cannot delete user from the database'
			SET @CanDropUserInd = 0
			UPDATE [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
			SET [CountOfDatabasesUsedIn] = [CountOfDatabasesUsedIn] + 1  
			FROM [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
			WHERE [sid] = @DPBSid

		END
	
	FETCH NEXT FROM DBPOwnedSchemas
	INTO @DBOwnedSchema, @DBOwnedSchemaId
	END
	CLOSE DBPOwnedSchemas
	DEALLOCATE DBPOwnedSchemas

	IF @CanDropUserInd = 1
	BEGIN
	PRINT N'User ' + @DBPUserName + N' owns no schemas or empty owned schemas were deleted'
	PRINT N'Dropping user ' + @DBPUserName + N' from the database ' + DB_Name() 
	SET @DropUserTSQL = 'DROP USER [' + @DBPUserName + ']' 
	exec sp_executesql @DropUserTSQL

	UPDATE [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
	SET [CountOfDatabasesUsedIn] = [CountOfDatabasesUsedIn] + 0
	FROM [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
	WHERE [sid] = @DPBSid

	END
FETCH NEXT FROM DBPCur 
INTO @DPBSid, @DBPUserName, @DBPId, @DBRoleName 
END

CLOSE DBPCur
DEALLOCATE DBPCur
GO

use [master]
GO

DECLARE @SPUserName NVARCHAR(128)
DECLARE @DropLoginTSQL NVARCHAR(500)

--get database principals that are only assigned the 'public' role.  The public role is a default role that has no real access.  These can be removed from the database
DECLARE SPCur CURSOR FOR
select NAME 
from [tempdb].[dbo].[SecurityCleanupSPServerPrincipals]
WHERE countofdatabasesusedin = 0
OPEN SPCur
FETCH NEXT FROM SPCur 
INTO @SPUserName

WHILE @@FETCH_STATUS = 0
BEGIN
			PRINT 'Deleting SQL login that does not exist in any database:'  + @SPUserName
			SET @DropLoginTSQL = 'DROP LOGIN [' +  @SPUserName + ']'
			exec sp_executesql  @DropLoginTSQL

FETCH NEXT FROM SPCur 
INTO @SPUserName
END

CLOSE SPCur
DEALLOCATE SPCur

