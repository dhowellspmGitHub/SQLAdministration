-- Create or remove option
DECLARE @RemoveInd BIT
DECLARE @DomainUser NVARCHAR(128)
DECLARE @PrincipalToGrant NVARCHAR(128)
DECLARE @dbname NVARCHAR(128)
DECLARE @dbrolestogrant TABLE (ADUserName NVARCHAR(128), dbrolename NVARCHAR(128),  SPIsprocessed BIT, databasename NVARCHAR(128), IsDatabaseOwner BIT, IsSystemDB BIT, DBPIsProcessed BIT, DBRIsProcessed BIT)
DECLARE @resetdatabasepermissions BIT
DECLARE @RoleName NVARCHAR(128)
DECLARE @tsql NVARCHAR(2000)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @DBOwnerInd BIT
DECLARE @SysDBInd BIT
DECLARE @CredentialType VARCHAR(1)
SET @RemoveInd = 0
SET @resetdatabasepermissions = 1
SET @DomainUser = 'KFBDOM1\SQL_Admins'
SET @CredentialType = 'G'

--Add Integrator roles to table for non-production databases
INSERT INTO @dbrolestogrant (ADUserName,dbrolename,SPIsprocessed, databasename, IsDatabaseOwner, IsSystemDB, DBPIsProcessed, DBRIsProcessed) SELECT DISTINCT @DomainUser,'db_datareader',0,[name],PATINDEX(@DOMAInUser,suser_sname(owner_sid)),CASE WHEN database_id <= 4 THEN 1 ELSE 0 END,0,0 FROM [sys].[databases] WHERE 
is_read_only = 0 and [state] = 0 and [source_database_id] is null
INSERT INTO @dbrolestogrant (ADUserName,dbrolename,SPIsprocessed, databasename, IsDatabaseOwner, IsSystemDB, DBPIsProcessed,DBRIsProcessed) SELECT DISTINCT @DomainUser,'db_ddlviewer',0,[name], PATINDEX(@DOMAInUser,suser_sname(owner_sid)),CASE WHEN database_id <= 4 THEN 1 ELSE 0 END ,0,0 FROM [sys].[databases] WHERE 
is_read_only = 0 and [state] = 0 and [source_database_id] is null

IF (@RemoveInd = 1)
BEGIN
PRINT 'Removing User process'
WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @PrincipalToGrant = ADUserName, @DBOwnerInd = IsDatabaseOwner, @SysDBInd = IsSystemDB,  @dbname = databasename FROM @dbrolestogrant WHERE DBPIsProcessed = 0
		
		SET @tsql = ''
		set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
		--If the Server Principal owns a database, first transfer ownership to the SA user
		IF (@DBOwnerInd = 1)
		BEGIN
			set @tsql = @TSQL + 'ALTER AUTHORIZATION ON DATABASE::' +  quotename(@dbname) + ' TO [SA]' + char(13)
		END
		set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.schemas WHERE [name] LIKE ' + char(39) + @PrincipalToGrant + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP SCHEMA ' + quotename(@PrincipalToGrant)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)

		set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.database_principals WHERE [name] LIKE ' + char(39) + @PrincipalToGrant + char(39) + ' AND type like ' + char(39) + @CredentialType + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP USER ' + quotename(@PrincipalToGrant)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)

		--PRINT @tsql;
		EXEC sp_executesql @tsql

		UPDATE @dbrolestogrant
		SET DBPIsProcessed = 1
		WHERE ADUserName = @PrincipalToGrant
		AND databasename = @dbname

	END
	
	SET @tsql = ''
	set @tsql = 'USE [master]' + char(13)
	set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.server_principals WHERE [name] LIKE ' + char(39) + @PrincipalToGrant + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP LOGIN ' + quotename(@PrincipalToGrant)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)
		EXEC sp_executesql @tsql
	
END
ELSE
BEGIN
	WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE SPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @PrincipalToGrant = ADUserName FROM @dbrolestogrant WHERE SPIsProcessed = 0
			-- Create the SQL Server Login if it does not exist
		
		IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE @PrincipalToGrant AND [type] LIKE @CredentialType)
		BEGIN
			PRINT 'Creating server prinicpal:' + @PrincipalToGrant
			SET @tsql = ''
			set @tsql = 'USE MASTER' + CHAR(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE LOGIN ' + quotename(@PrincipalToGrant) + ' FROM WINDOWS' + char(13) 
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @tsql;
			EXEC sp_executesql @tsql
						
			set @tsql = 'USE MASTER' + CHAR(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'GRANT CONNECT SQL TO ' + quotename(@DomainUser) + CHAR(13)
			SET @tsql = @TSQL + 'GRANT VIEW SERVER STATE TO ' + quotename(@DomainUser) + CHAR(13) 
			SET @tsql = @TSQL + 'GRANT VIEW ANY DATABASE TO ' + quotename(@DomainUser) + CHAR(13) 
			SET @tsql = @TSQL + 'GRANT VIEW ANY DEFINITION TO ' + quotename(@DomainUser) + CHAR(13) 
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @tsql;
			EXEC sp_executesql @tsql

			PRINT @PrincipalToGrant + ' login granted access to the server'
			
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE ADUserName = @PrincipalToGrant
		END
		ELSE
		BEGIN
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE ADUserName = @PrincipalToGrant
			PRINT '--Windows User: ' + @PrincipalToGrant + ' already exists on this server.  The below TSQL code has been run creating database principal and appropriate authority to the ' + @dbname + 
			' database'
		END
		
	END  --while end


	WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBPIsProcessed = 0) > 0
	BEGIN
		
		SELECT TOP 1 @PrincipalToGrant = ADUserName, @DBOwnerInd = IsDatabaseOwner, @SysDBInd = IsSystemDB,  @dbname = databasename FROM @dbrolestogrant WHERE DBPIsProcessed = 0
		PRINT 'Processing database name: ' + @dbname
		--For this database (see USE statement above), create a corresponding database principal for this login
		SET @tsql = ''
		set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
		set @tsql = @TSQL + 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE [name] LIKE ' + char(39) + @PrincipalToGrant + char(39) + ' AND type like ' + char(39) + @CredentialType + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'CREATE USER ' + quotename(@PrincipalToGrant) + ' FOR LOGIN ' + quotename(@PrincipalToGrant)+ ' WITH DEFAULT_SCHEMA=[dbo]'  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)
	
		set @tsql = @TSQL + 'IF EXISTS (SELECT * FROM sys.schemas WHERE [name] LIKE ' + char(39) + @PrincipalToGrant + char(39) + ')' + char(13)
		SET @tsql = @TSQL + 'BEGIN'  + char(13)
		SET @tsql = @TSQL + 'DROP SCHEMA ' + quotename(@PrincipalToGrant)  + char(13)
		SET @tsql = @TSQL + 'END' + char(13)
			
		PRINT @tsql
		EXEC sp_executesql @tsql
				
		IF (@SysDBInd = 0)
		BEGIN
		WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBRIsProcessed = 0 and databasename = @dbname) > 0
			BEGIN
				SELECT TOP 1 @PrincipalToGrant = ADUserName, @dbrolename = dbrolename FROM @dbrolestogrant WHERE databasename = @dbname AND DBRIsProcessed = 0
				PRINT 'Processing role name: ' + @dbrolename
				SET @tsql = ''
				set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
				set @tsql = @tsql + 'IF EXISTS (SELECT * FROM sys.database_principals WHERE name = ' + char(39) + @dbrolename + char(39) + ' AND type = ''R'') BEGIN ' + char(13)
				set @tsql = @tsql + 'EXEC sp_addrolemember ' + char(39) + @DBrolename + char(39) + ',' + char(39) + @PrincipalToGrant + char(39) + char(13)
				set @tsql = @tsql + 'END' + char(13)
				set @tsql = @tsql + 'ELSE' + char(13)
				set @tsql = @tsql + 'BEGIN ' + char(13)
				set @tsql = @tsql + 'SELECT ' + CHAR(39) + @dbname + '--NEEDS DATABASE ' + @dbrolename + ' ROLE ADDED ' + CHAR(39) + char(13)
				set @tsql = @tsql + 'END' + char(13)

				PRINT @tsql
				EXEC sp_executesql @tsql
				PRINT @PrincipalToGrant + ' login granted the ' +  @DBrolename +  ' in the ' + DB_NAME() + ' database'

				UPDATE @dbrolestogrant
				SET DBRIsProcessed = 1
				WHERE dbrolename = @dbrolename
				AND ADUserName =  @PrincipalToGrant
				AND databasename = @dbname
			END
		END
		ELSE
		BEGIN
			UPDATE @dbrolestogrant
				SET DBRIsProcessed = 1
				WHERE dbrolename = @dbrolename
				AND ADUserName =  @PrincipalToGrant
				AND databasename = @dbname
		END
		
					
			--PRINT '--Windows User: ' + @PrincipalToGrant + ' already exists in the database:' + @dbname +  '  The below TSQL code has been run creating database principal and appropriate authority to the ' + @dbname + 
			--' database'
		
		SET @tsql = ''
		set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
		SET @tsql = @TSQL + 'GRANT SHOWPLAN TO [' + @PrincipalToGrant +  ']' + CHAR(13) 
		SET @tsql = @TSQL + 'GRANT VIEW DATABASE STATE TO [' + @PrincipalToGrant +  ']' + CHAR(13) 
		SET @tsql = @TSQL + 'GRANT VIEW DEFINITION TO [' + @PrincipalToGrant +  ']' + CHAR(13) 
		--PRINT @tsql
		EXEC sp_executesql @tsql

		UPDATE @dbrolestogrant
		SET DBPIsProcessed = 1
		WHERE ADUserName = @PrincipalToGrant
		AND databasename = @dbname
	END
	
END

SELECT ADUserName
,dbrolename
,SPIsprocessed
,databasename
,DBPIsProcessed
,DBRIsProcessed
FROM @dbrolestogrant 

		

		