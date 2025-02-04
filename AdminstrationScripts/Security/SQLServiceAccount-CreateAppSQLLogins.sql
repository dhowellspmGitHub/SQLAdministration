/* 
This script is designed to run against domain and non-domain SQL servers used to create SQL Login accounts for SERVICE ACCOUNTS used by applications
The designated SQL Service Account must exist as a SQL Login prior to running this script
You MUST set the 'role' below appropriately as permissions granted in the database depend upon the role assigned
Service Accounts do not have the password policies turned on and are granted the db_owner role.  
User accounts do have password policies turned on and are granted role specific permissions in the named database.
Please review the below variables which must be set for each server, database and role
*/


SET NOCOUNT ON;
DECLARE @SQLLoginName VARCHAR(128)
DECLARE @CurrentPassword VARCHAR(128)
DECLARE @RoleName VARCHAR(128)
DECLARE @dbname VARCHAR(128)
DECLARE @currentdbid INT
DECLARE @tsql NVARCHAR(2000)
DECLARE @rolestogrant TABLE (SQLLoginName VARCHAR(128), RoleNameToGrant VARCHAR(128), IsServerRole BIT, SPIsprocessed BIT, DBPIsProcessed BIT)
DECLARE @pschema VARCHAR(128)
DECLARE @pname VARCHAR(128)
DECLARE @RoleNameToGrant VARCHAR(128)
DECLARE @grantcontrol BIT 
DECLARE @isproductionsystem BIT
DECLARE @assigneddatabase VARCHAR(128)
DECLARE @msg VARCHAR(2048)
DECLARE @currObject VARCHAR(128)
DECLARE @currprod VARCHAR(128)
DECLARE @enforcepasswordpolicy VARCHAR(3) = 'OFF'
DECLARE @changepasswordpolicy VARCHAR(15) = ' MUST_CHANGE'
DECLARE @alldatabasesindicator VARCHAR(30) = 'ALLDATABASES'

/* Customize the WHERE condition and use the following query to get a list of the Service Accounts to use in the SELECT list in the INSERT statement to the 
@CredentialsTable.  Copy/paste the first column as the SELECT values.  Remove the last UNION keyword
SELECT 'SELECT ' + CHAR(39) + [UserId] + CHAR(39) + ',' + CHAR(39) + [CurrentPassword] + CHAR(39) + ',' + CHAR(39) + isnull([AssignedDatabaseName],'ALLDATABASES') + CHAR(39) + ',0 UNION' 
,[servernameid],[ApplicationCreatedForName]
FROM [dbo].[ServerPrincipalsLogins]
WHERE
userid like ?
and ServerNameId = ?
order by servernameid, UserId
*/
DECLARE @CredentialsTable TABLE (SQLCredential VARCHAR(128), CurrentPassword VARCHAR(128), [AssignedDatabaseName] VARCHAR(128), CredIsProcessed BIT)
INSERT INTO @CredentialsTable (SQLCredential,CurrentPassword,[AssignedDatabaseName],CredIsProcessed)
(
--paste results of the first column from the above SELECT statement here
)
-- change query to derive role from name; add default database to the database used

USE []

SELECT * FROM @CredentialsTable
WHILE (SELECT COUNT(*) FROM @CredentialsTable WHERE CredIsProcessed = 0) > 0
BEGIN
SELECT TOP 1 @SQLLoginName = SQLCredential, @CurrentPassword = CurrentPassword, @assigneddatabase = [AssignedDatabaseName] FROM @CredentialsTable WHERE CredIsProcessed = 0

/* Set variable indicating if server is a production server or non-production server*/

--1 = Yes; 0 = No
SET @isproductionsystem = 0


/* the @RoleName is derived from SQL login's name using the standard roles for production/non-production access.  This role name is used to populate temporary tables with the SQL standard and custom DB roles granting the user authority the role should have.  The same production/non-production roles-authority scheme used in domain member servers is used for DMZ servers.  See RBAC documentation or below TSQL code for specifics. Run this statement in the KFB SQL Management database for the current role names
*/

DECLARE @RoleTable TABLE (RoleID INT, RoleName VARCHAR(128))
IF @isproductionsystem = 1
BEGIN
INSERT INTO @RoleTable(RoleID, RoleName)
(SELECT 12,'FullAdmin'
UNION SELECT 14, 'Service'
UNION SELECT 16, 'Integration'
UNION SELECT 18, 'Reader'
UNION SELECT 10, 'SysAdmin'
)
END
ELSE
BEGIN
INSERT INTO @RoleTable(RoleID, RoleName)
(SELECT 13,'FullAdmin'
UNION SELECT 15, 'Service'
UNION SELECT 17, 'Integration'
UNION SELECT 19, 'Reader'
UNION SELECT 11, 'SysAdmin'
)
END

DECLARE @RoleID INT
SET @RoleID = CAST(SUBSTRING(@SQLLoginName,9,2) AS INT)

SELECT @RoleName = RoleName FROM @RoleTable
WHERE RoleID = @RoleID

DECLARE @ApplicationID INT
SET @ApplicationID = CAST(SUBSTRING(@SQLLoginName,4,3) AS INT)

/* These next three items/variable values must be changed for each user database against which this procedure is run */
--Set the USE statement for the database in which the groups are to be created
SET @dbname = DB_NAME()
--if the user is not for a specific database, the credential is used for all of the application's database.  
--if not for all databases, then there is a need to compare the current db_name to the database assigned to the user
IF (SELECT CHARINDEX(@assigneddatabase, @alldatabasesindicator)) = 0
--if the assigned database value matches the string indicating 'all databases', the function returns a value greater than 0
--else if 0, the credentials are for a specific database
--use the same logic in comparing the assigned database to the current database for this batch
--if the above USE statement instructs to use a database other than the assigned database, throw an error and fail the batch
BEGIN
	IF (SELECT CHARINDEX(@assigneddatabase, @dbname)) = 0
	BEGIN
		SET @currObject = '@assigneddatabase'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid connection or usage: The assigned database is %s while the current database is %s - Change the USE [] phrase to match this database'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @assigneddatabase,@dbname);
		THROW 60000 , @msg, 1 
	END
END

--Add DataAdmin roles to table variable
	IF PATINDEX('SysAdmin', @RoleName) > 0
	BEGIN
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'sysadmin',1,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_owner',0,0,0)
	SET @enforcepasswordpolicy = 'OFF'
	SET @changepasswordpolicy = ''
	END

	IF PATINDEX('FullAdmin', @RoleName) > 0
	BEGIN
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_owner',0,0,0)
	SET @enforcepasswordpolicy = 'OFF'
	SET @changepasswordpolicy = ''
	END

	IF PATINDEX('Service', @RoleName) > 0
	BEGIN
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_datareader',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_datawriter',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_executor',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_ddlviewer',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_ddladmin',0,0,0)
	SET @enforcepasswordpolicy = 'OFF'
	SET @changepasswordpolicy = ''
	END

	IF PATINDEX('Integration', @RoleName) > 0
	BEGIN
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_datareader',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_datawriter',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_executor',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_ddlviewer',0,0,0)
	END

	IF PATINDEX('Reader', @RoleName) > 0
	BEGIN
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_datareader',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_executor',0,0,0)
	INSERT INTO @rolestogrant (SQLLoginName,RoleNameToGrant,IsServerRole,SPIsprocessed, DBPIsProcessed) VALUES (@SQLLoginName,'db_ddlviewer',0,0,0)
	END
	Select *
	from @rolestogrant

IF (@CurrentPassword IS NULL) OR (LEN(@CurrentPassword) < 12)
BEGIN
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = 'ERROR: Password is NULL or less than 12 characters.  Reset the password to at least 12 chars'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	RAISERROR(60000,10,1)
	GOTO EXITONERROR
END

IF (SELECT COUNT(*) FROM @rolestogrant)  = 0
BEGIN
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = 'There are no roles to grant to this user.  Check the combination of the production indicator variable and role name'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	RAISERROR(60000,10,1)
	GOTO EXITONERROR
END

SELECT @currentdbid = database_id FROM master.sys.databases where name like @dbname
IF (@currentdbid <= 4 AND @ApplicationID > 1)
BEGIN
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	EXEC sys.sp_addmessage
	@msgnum   = 60001
	,@severity = 10
	,@msgtext  = 'This procedure should not be run against system databases.  Please correct your USE statement above to the correct database and re-run'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60001, @currprod,@currObject);
	RAISERROR(60001,10,1)
	GOTO EXITONERROR
END
ELSE
BEGIN
	WHILE (SELECT COUNT(*) FROM @rolestogrant WHERE SPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @SQLLoginName = SQLLoginName FROM @rolestogrant WHERE SPIsProcessed = 0
		-- Create the SQL Server Login if it does not exist
		IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE @SQLLoginName AND [type] LIKE 'S')
		BEGIN
			SET @tsql = 'USE MASTER; CREATE LOGIN [<uname>]  WITH PASSWORD=N<upassword>, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=OFF, CHECK_POLICY=<enforcepasswordpolicy>; USE [tempdb]; CREATE USER [<uname>] FOR LOGIN [<uname>]; ALTER ROLE [db_owner] ADD MEMBER [<uname>]; '
			SET @currentpassword = QUOTENAME(@currentpassword,'''')
			SET  @tsql  = REPLACE( @tsql ,'<uname>',@SQLLoginName)
			SET @tsql  = REPLACE(@tsql,'<upassword>',@currentpassword)
			SET @tsql = REPLACE(@tsql,'<enforcepasswordpolicy>', @enforcepasswordpolicy)
			PRINT @tsql;
			exec sp_executesql @tsql
			PRINT @SQLLoginName + ' login granted access to the server'
			UPDATE @rolestogrant
			SET SPIsProcessed = 1
			WHERE SQLLoginName = @SQLLoginName
		END
		ELSE
		BEGIN
			PRINT @SQLLoginName + '--Server login already exists on this server.  Checking role for instance level authority and continuing to process authority to the ' + @dbname + 
			' database'
			WHILE (SELECT COUNT(*) FROM @rolestogrant WHERE SPIsProcessed = 0 AND IsServerRole = 1 ) > 0
			BEGIN
			SELECT TOP 1 @SQLLoginName = SQLLoginName,@RoleNameToGrant = RoleNameToGrant FROM @rolestogrant WHERE SPIsProcessed = 0 AND IsServerRole = 1
			SET @tsql = 'ALTER SERVER ROLE [<urolename>] ADD MEMBER [<uname>]; GRANT VIEW SERVER STATE TO [<uname>];'
			SET  @tsql  = REPLACE(@tsql ,'<uname>',@SQLLoginName)
			SET @tsql  = REPLACE(@tsql,'<urolename>',@RoleNameToGrant)
			PRINT @tsql;
			exec sp_executesql @tsql
			UPDATE @rolestogrant
			SET SPIsProcessed = 1
			WHERE SQLLoginName = @SQLLoginName
			END		
		END
	
		SET @tsql = 'USE MASTER' + CHAR(13)
		SET @tsql = @TSQL + 'BEGIN GRANT VIEW SERVER STATE TO [<uname>]; GRANT VIEW ANY DATABASE TO [<uname>];  GRANT VIEW ANY DEFINITION TO [<uname>]; END;'
		SET  @tsql  = REPLACE( @tsql ,'<uname>',@SQLLoginName)
		PRINT @tsql;
		exec sp_executesql @tsql
		

		--For this database (see USE statement above), create a corresponding database principal for this login
		IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name LIKE @SQLLoginName AND type like 'S')
		BEGIN
			SET @tsql = 'USE [<dbname>]; CREATE USER [<uname>] FOR LOGIN [<uname>]; ALTER USER [<uname>] WITH DEFAULT_SCHEMA=[dbo]'
			SET  @tsql  = REPLACE(@tsql ,'<dbname>',@dbname)
			SET  @tsql  = REPLACE(@tsql ,'<uname>',@SQLLoginName)
			PRINT @TSQL
			exec sp_executesql @tsql
		END
		
		--When adding AD groups to a database, a default schema cannot be specified. However, for some reason, SQL Server creates a new schema using the group name
		--Don't want this to happen so if a new schema is created with the name of the AD group, drop the schema
		IF EXISTS (SELECT * FROM sys.schemas WHERE name like @SQLLoginName)
		BEGIN
			PRINT 'Schema named ' + @SQLLoginName + ' created by script. Dropping this new schema'
			SET @tsql = 'USE [<dbname>]; DROP SCHEMA [<uname>];'
			SET  @tsql  = REPLACE(@tsql ,'<dbname>',@dbname)
			SET  @tsql  = REPLACE(@tsql ,'<uname>',@SQLLoginName)
			PRINT @TSQL
		exec sp_executesql @tsql 
		END
	
		IF NOT EXISTS (SELECT * FROM tempdb.sys.database_principals WHERE name LIKE @SQLLoginName AND type like 'S')
		BEGIN
			SET @tsql = 'USE [TEMPDB]; CREATE USER [<uname>] FOR LOGIN [<uname>] ; ALTER ROLE [db_owner] ADD MEMBER [<uname>];'
			SET  @tsql  = REPLACE(@tsql ,'<uname>',@SQLLoginName)
			PRINT @TSQL
			exec sp_executesql @tsql
		END

		UPDATE @rolestogrant
		SET SPIsProcessed = 1
		WHERE SQLLoginName = @SQLLoginName
		IF  (SELECT COUNT(*) FROM @rolestogrant WHERE SPIsProcessed = 0) = 0 
		BREAK
		ELSE
		CONTINUE
	END  --while end
END

	-- for role assignments, it is simpler and more accurate to revoke all current database roles and regrant them rather than attempting to validate each role.  Additionally, this procedure can be used to reset the authority granted.  If a variation of the standard authority is made, then confirming roles other than those designated while granted those allowed, results in much more complex TSQL code to record those variations.
	-- for each role that exists for this user, use the ALTER ROLE statement to drop the database principal

	DECLARE DBRMCursor CURSOR
	FOR
	select SR1.[name] from sys.database_principals as SR1
	INNER JOIN sys.database_role_members as SRM1
	on SR1.principal_id = SRM1.role_principal_id
	INNER JOIN sys.database_principals as SP1
	ON SRM1.member_principal_id = SP1.principal_id
	where [SR1].[type] like 'R'
	AND [SP1].name LIKE   @SQLLoginName

	OPEN DBRMCursor
	FETCH NEXT FROM DBRMCursor 
	INTO @RoleNameToGrant
	WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT 'EXEC sp_droprolemember ' + @RoleNameToGrant + ',' +  @SQLLoginName
	EXEC sp_droprolemember @RoleNameToGrant ,@SQLLoginName
	PRINT 'The user ' + @SQLLoginName + ' dropped from the role ' + @RoleNameToGrant
	FETCH NEXT FROM DBRMCursor 
	INTO @RoleNameToGrant
	END
	CLOSE DBRMCursor
	DEALLOCATE DBRMCursor

	IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_executor' AND type = 'R')
	BEGIN
	CREATE ROLE [db_executor] AUTHORIZATION [dbo]
	END
	ELSE
	BEGIN
	PRINT 'The database role db_executor already exists in this database'
	END
	set @grantcontrol = 0
	SET @dbname = DB_NAME()
	SET @RoleNameToGrant = 'db_executor'
	SET @grantcontrol = 1

	DECLARE pcur CURSOR
	FOR
	SELECT 
	S1.[name]
	,SP1.[name]
	FROM sys.procedures as SP1
	INNER JOIN sys.schemas as S1
	ON SP1.schema_id = S1.schema_id

	OPEN pcur
	FETCH NEXT FROM pcur
	INTO @pschema, @pname
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY 
			SET @tsql = ''
			SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
			SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @pname + '] TO ['+ @RoleNameToGrant + '] ' + CHAR(13) 
			--PRINT @TSQL
			IF @grantcontrol = 1 
			BEGIN
			SET @tsql = @tsql + 'GRANT CONTROL ON [' +@pschema +  '].[' + @pname + '] TO ['+ @RoleNameToGrant + '] ' + CHAR(13) 
			SET @tsql = @tsql +  'GRANT EXECUTE ON [' +@pschema +  '].[' + @pname + '] TO ['+ @RoleNameToGrant + '] ' + CHAR(13) 
			END
		
			exec sp_executesql @tsql
			print @tsql
			PRINT @RoleNameToGrant + ' permissions granted on ' + @pname + ' success'
		END TRY 
		BEGIN CATCH 
			PRINT @RoleNameToGrant + ' permissions granted on ' + @pname + ' failed'
			--PRINT @tsql
			SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
			PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS VARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS VARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS VARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS VARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS VARCHAR(4000))
			END CATCH 
		FETCH NEXT FROM pcur
		INTO @pschema, @pname
	END
	CLOSE pcur
	DEALLOCATE pcur
	
		/*
		The next phase in the process is to grant 'VIEW DEFINITION' on all "code related" objects within the database by creating a custom ddlreader database role and granting those rights to the database role.
		By using a custom role similar to the DB_executor role, permission granularity is more manageable.
		The db_ddlreader role is limited to user defined, non-CLR objects.  From the SQL object types, these are included.
		AF = Aggregate function (CLR)
		FN = SQL scalar function
		IF = SQL inline table-valued function
		P = SQL Stored Procedure
		PG = Plan guide
		SN = Synonym
		TF = SQL table-valued-function
		TR = SQL DML trigger
		UQ = UNIQUE constraint
		V = View
		X = Extended stored procedure
		Additionally, non-user schema objects (such as sys, guest and INFORMATION_SCHEMA) are excluded
		*/

		IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_ddlviewer' AND type = 'R')
		BEGIN
		CREATE ROLE [db_ddlviewer] AUTHORIZATION [dbo]
		END

		DECLARE @objname VARCHAR(128)
		DECLARE @objtype VARCHAR(10)
		DECLARE @objtypedesc VARCHAR(128)

		SET @RoleNameToGrant = 'db_ddlviewer'
		--PRINT 'Review the DAL queries below before copy/paste and execution'
		DECLARE ddlreadercur CURSOR
		FOR
		SELECT DISTINCT
		SCHEMA_NAME([schema_id]),[name], [type], [type_desc]
		from [sys].[objects]
		WHERE [type] IN 
		--('AF','FN','IF','P','PG','SN','TF','TR','UQ','V','X')
		('FN','P','TF','SN','V')
		AND [is_ms_shipped] = 0
		AND schema_id NOT IN (2,3,4)
		AND schema_id < 16384
		ORDER BY 
		[type],[name]

		OPEN ddlreadercur
		FETCH NEXT FROM ddlreadercur
		INTO @pschema, @objname, @objtype, @objtypedesc

		WHILE @@FETCH_STATUS = 0
		BEGIN
				BEGIN TRY 
					SET @tsql = ''
					SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
					SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @objname + '] TO ['+ @RoleNameToGrant + '] ' + CHAR(13) 
					--print @tsql
					exec sp_executesql @tsql
					PRINT @RoleNameToGrant + ' permissions granted on ' + @objtypedesc +  ' object type ' + @pschema +  '.' +  @objname + ' success'
				END TRY 
				BEGIN CATCH 
					PRINT @RoleNameToGrant + ' permissions granted on ' + @objtypedesc +  ' object type ' + @pschema +  '.' +  @objname + ' failed'
					PRINT @tsql
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
					PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS VARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS VARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS VARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS VARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS VARCHAR(4000))
					END CATCH 
				FETCH NEXT FROM ddlreadercur
				INTO @pschema, @objname, @objtype, @objtypedesc
			END
		CLOSE ddlreadercur
		DEALLOCATE ddlreadercur
		
	WHILE (SELECT COUNT(*) FROM @rolestogrant WHERE DBPIsProcessed = 0 AND IsServerRole = 0) <> 0
	BEGIN
		SELECT TOP 1 @SQLLoginName = SQLLoginName, @RoleNameToGrant = RoleNameToGrant FROM @rolestogrant WHERE DBPIsProcessed = 0 AND IsServerRole = 0
		PRINT 'EXEC sp_addrolemember '+ @RoleNameToGrant + ',' + @SQLLoginName 
		EXEC sp_addrolemember @RoleNameToGrant ,@SQLLoginName 
		UPDATE @rolestogrant
		SET DBPIsProcessed = 1
		WHERE RoleNameToGrant = @RoleNameToGrant
		AND SQLLoginName =  @SQLLoginName
		IF  (SELECT COUNT(*) FROM @rolestogrant WHERE DBPIsProcessed = 0 AND IsServerRole = 0) = 0
		BREAK
		ELSE
		CONTINUE
		
		PRINT @SQLLoginName + ' login granted the ' +  @RoleNameToGrant +  ' in the ' + DB_NAME() + ' database'
	END

--Set the user's default database to the current database
BEGIN
	SET @tsql = ''
	SET @tsql = 'USE MASTER; '
	SET @tsql = @tsql + 'ALTER LOGIN [' + @SQLLoginName +  '] WITH DEFAULT_DATABASE = ['+ @dbname + '] , DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF' + CHAR(13) 
	exec sp_executesql @tsql
	print @tsql
	PRINT 'Default database for ' + @SQLLoginName + ' set to ' + @dbname
END
	

UPDATE @CredentialsTable
SET CredIsProcessed = 1
WHERE SQLCredential = @SQLLoginName

END
SELECT * from @CredentialsTable

EXITONERROR:



SET NOCOUNT OFF
SET XACT_ABORT OFF