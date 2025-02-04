-- Create or remove option
USE [SSISDB]
GO
DISABLE TRIGGER ddl_cleanup_object_permissions ON DATABASE

go

DECLARE @RemoveInd BIT
DECLARE @DomainUser NVARCHAR(128)
DECLARE @PrincipalToRemove NVARCHAR(128)
DECLARE @dbname NVARCHAR(128)
DECLARE @dbrolestoremove TABLE (ADUserName NVARCHAR(128), dbrolename NVARCHAR(128),  SPIsprocessed BIT, databasename NVARCHAR(128), DBPIsProcessed BIT)
DECLARE @resetdatabasepermissions BIT
DECLARE @RoleName NVARCHAR(128)
DECLARE @tsql NVARCHAR(2000)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @dbstring NVARCHAR(128)
DECLARE @unamestring NVARCHAR(25)
set @unamestring = 'ens035%'
DECLARE unamecur CURSOR
FOR
SELECT [name]
FROM [sys].[server_principals]
WHERE name like @unamestring
AND [type] = 'S'

OPEN unamecur

FETCH NEXT FROM unamecur
INTO @DomainUser

WHILE @@FETCH_STATUS = 0
BEGIN
PRINT @domainuser


SET @dbstring = 'PMT%'
SET @RemoveInd = 1
SET @resetdatabasepermissions = 0

--Add Integrator roles to table for non-production databases
INSERT INTO @dbrolestoremove (ADUserName,dbrolename,SPIsprocessed, databasename, DBPIsProcessed) SELECT DISTINCT @DomainUser,'%',0,[name],0 FROM [sys].[databases] WHERE 
is_read_only = 0 and [state] = 0 and [source_database_id] is null and [name] like @dbstring

IF (@RemoveInd = 1)
BEGIN
PRINT 'Removing User process'
WHILE (SELECT COUNT(*) FROM @dbrolestoremove WHERE DBPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @PrincipalToRemove = ADUserName, @dbname = databasename FROM @dbrolestoremove WHERE DBPIsProcessed = 0
			
		SET @tsql = ''
		set @tsql = 'USE ' +  quotename(@dbname)  + char(13)

		set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.schemas WHERE [name] LIKE ' + char(39) + @PrincipalToRemove + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP SCHEMA ' + quotename(@PrincipalToRemove)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)
				
		set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.database_principals WHERE [name] LIKE ' + char(39) + @PrincipalToRemove + char(39) + ' AND type like ' + char(39) + 'S' + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP USER ' + quotename(@PrincipalToRemove)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)
				
		PRINT @tsql;
		EXEC sp_executesql @tsql

		UPDATE @dbrolestoremove
		SET DBPIsProcessed = 1
		WHERE ADUserName = @PrincipalToRemove
		AND databasename = @dbname
		PRINT '--User: ' + @PrincipalToRemove + ' granted a role in ' + @dbname + '.  The TSQL code has been run removing the principal from the database.'
		UPDATE @dbrolestoremove
		SET SPIsProcessed = 1
		WHERE ADUserName = @PrincipalToRemove

		
	END
END




FETCH NEXT FROM unamecur
INTO @DomainUser

END


CLOSE unamecur
DEALLOCATE unamecur
		