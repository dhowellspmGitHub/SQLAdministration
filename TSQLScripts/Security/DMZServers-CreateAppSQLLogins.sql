/* 
This script is designed to run against non-domain SQL servers used to create SQL Login accounts for:
-- SQL LOGINS used by users
You MUST set the 'role' below appropriately as the SQL password policies and permissions granted in the database depend upon the role assigned
Service Accounts do not have the password policies turned on and are granted the db_owner role.  
User accounts do have password policies turned on and are granted role specific permissions in the named database.
Please review the below variables which must be set for each server, database and role
*/

SET NOCOUNT ON;
DECLARE @DMZSQLLoginName NVARCHAR(128)
DECLARE @DMZSQLPassword NVARCHAR(128)
DECLARE @RoleName NVARCHAR(128)
DECLARE @HKLMDomain NVARCHAR(100)

DECLARE @dbname NVARCHAR(128)
DECLARE @currentdbid INT
DECLARE @tsql NVARCHAR(2000)
DECLARE @dbrolestogrant TABLE (DMZSQLLoginName NVARCHAR(128), ADrolename NVARCHAR(128), dbrolename NVARCHAR(128), SPIsprocessed BIT, DBPIsProcessed BIT)
DECLARE @pschema NVARCHAR(128)
DECLARE @pname NVARCHAR(128)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @grantcontrol BIT 
DECLARE @isproductionsystem BIT
DECLARE @msg NVARCHAR(2048)
DECLARE @currObject NVARCHAR(128)
DECLARE @currprod NVARCHAR(128)
DECLARE @enforcepasswordpolicy NVARCHAR(3) = 'ON'
DECLARE @changepasswordpolicy NVARCHAR(15) = ' MUST_CHANGE'

--Set the USE statement for the database in which the groups are to be created
USE []

/* These next three items/variable values must be changed for each user to create and grant access*/
--the @DMZSQLLoginName is the user's AD login name without the KFBDOM1 portion--example for the AD user KFBDOM1\XYZ1234, create a SQL Login named XYZ1234
SET @DMZSQLLoginName = ''

/*
The @DMZSQLPassword is a mixed case, alpha-numeric string of random characters--this must be unique for each user and provided to the user after the account is created
Please note that the inital password must follow the local Windows policies which by default (and unless set by IT Security using Group Policy) are:
Password must meet complexity requirements

This security setting determines whether passwords must meet complexity requirements.

If this policy is enabled, passwords must meet the following minimum requirements:

Not contain the user's account name or parts of the user's full name that exceed two consecutive characters
Be at least six characters in length
Contain characters from three of the following four categories:
English uppercase characters (A through Z)
English lowercase characters (a through z)
Base 10 digits (0 through 9)
Non-alphabetic characters (for example, !, $, #, %)
Complexity requirements are enforced when passwords are changed or created.
*/
SET @DMZSQLPassword = ''

--the @RoleName is one of the four standard "roles" for production/non-production access.  This role name is used to populate temporary tables with the SQL standard and custom DB roles granting the user authority the role should have.  The same production/non-production roles-authority scheme used in domain member servers is used for DMZ servers.  See RBAC documentation or below TSQL code for specifics
SET @RoleName = ''

-- Set variable indicating if server is a production server or non-production server
--1 = Yes; 0 = No
SET @isproductionsystem = 0

SET @dbname = DB_NAME()


EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\services\Tcpip\Parameters', N'Domain',@HKLMDomain OUTPUT
IF @HKLMDomain IS NOT NULL
BEGIN
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	EXEC sys.sp_addmessage
	@msgnum   = 60002
	,@severity = 10
	,@msgtext  = 'This script is designated for use only on servers NOT in the domain.  If applying Role Based security, us the TSQL script for Active Directory groups instead'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	RAISERROR(60002,10,1)
	GOTO EXITONERROR
END



--SET @DMZSQLLoginName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
SET @dbname = db_name()
--Add DataAdmin roles to table variable
IF @isproductionsystem = 1
BEGIN
	IF PATINDEX('ServiceAccount', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_owner',0,0)
	SET @enforcepasswordpolicy = 'OFF'
	SET @changepasswordpolicy = ''
	END

	IF PATINDEX('DataAdmin', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datawriter',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_ddlviewer',0,0)
	END

	--Add ProdSupport role to table variable
	IF PATINDEX('ProdSupport', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_ddlviewer',0,0)
	END

END

--Add Developer roles to table for non-production databases
IF @isproductionsystem = 0
BEGIN
	IF PATINDEX('ServiceAccount', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_owner',0,0)
	SET @enforcepasswordpolicy = 'OFF'
	SET @changepasswordpolicy = ''
	END

	IF PATINDEX('Developer', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datawriter',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_ddlviewer',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_ddladmin',0,0)
	END

	IF PATINDEX('Integration', @RoleName) > 0
	BEGIN
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_ddlviewer',0,0)
	INSERT INTO @dbrolestogrant (DMZSQLLoginName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@DMZSQLLoginName,@RoleName,'db_datawriter',0,0)
	END
	
END


IF (SELECT COUNT(*) FROM @dbrolestogrant) = 0
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
IF @currentdbid <= 4
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

	WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE SPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @DMZSQLLoginName = DMZSQLLoginName FROM @dbrolestogrant WHERE SPIsProcessed = 0
		-- Create the SQL Server Login if it does not exist
		IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE @DMZSQLLoginName AND [type] LIKE 'S')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE MASTER' + CHAR(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE LOGIN ' + quotename(@DMZSQLLoginName) + ' WITH PASSWORD=N' + char(39) + @DMZSQLPassword + char(39) +  @changepasswordpolicy + ' , DEFAULT_DATABASE=[' + @dbname +'], CHECK_EXPIRATION=' + @enforcepasswordpolicy + ', CHECK_POLICY=' + @enforcepasswordpolicy + char(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @tsql;
			exec sp_executesql @tsql
			PRINT @DMZSQLLoginName + ' login granted access to the server'
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE DMZSQLLoginName = @DMZSQLLoginName
		END
		ELSE
		BEGIN
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE DMZSQLLoginName = @DMZSQLLoginName
			PRINT '--SQL Login: ' + @DMZSQLLoginName + ' already exists on this server.  The below TSQL code has been run creating database principal and appropriate authority to the ' + @dbname + 
			' database'
		END

		--For this database (see USE statement above), create a corresponding database principal for this login
		IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name LIKE @DMZSQLLoginName AND type like 'S')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE USER ' + quotename(@DMZSQLLoginName) + ' FOR LOGIN ' + quotename(@DMZSQLLoginName)  + char(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			SET @tsql = @TSQL + 'ALTER USER ' + quotename(@DMZSQLLoginName) + ' WITH DEFAULT_SCHEMA=[dbo]' + char(13)
			PRINT @TSQL
			exec sp_executesql @tsql
		END
		
		--When adding AD groups to a database, a default schema cannot be specified. However, for some reason, SQL Server creates a new schema using the group name
		--Don't want this to happen so if a new schema is created with the name of the AD group, drop the schema
		IF EXISTS (SELECT * FROM sys.schemas WHERE name like @DMZSQLLoginName)
		BEGIN
			PRINT 'Schema named ' + @DMZSQLLoginName + ' created by script. Dropping this new schema'
			SET @tsql = ''
			set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'DROP SCHEMA ' + quotename(@DMZSQLLoginName) + char(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @TSQL
		exec sp_executesql @tsql 
		END
	
		IF NOT EXISTS (SELECT * FROM tempdb.sys.database_principals WHERE name LIKE @DMZSQLLoginName AND type like 'S')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE [TEMPDB]' + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE USER ' + quotename(@DMZSQLLoginName) + ' FOR LOGIN ' + quotename(@DMZSQLLoginName)  + char(13)
			SET @tsql = @TSQL + 'EXEC sp_addrolemember N' + CHAR(39) + 'db_owner' + CHAR(39) + ', N' + CHAR(39) + @DMZSQLLoginName + CHAR(39) + CHAR(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @TSQL
			exec sp_executesql @tsql
		END
	END  --while end
END



	-- for role assignments, it is simpler and more accurate to revoke all current database roles and regrant them rather than attempting to validate each role.  Additionally, this procedure can be used to reset the authority granted.  If a variation of the standard authority is made, then confirming roles other than those designated while granted those allowed, results in much more complex TSQL code to record those variations.
	-- for each role that exists for this user, use the ALTER ROLE statement to drop the database principal

	DECLARE DBRMCursor CURSOR
	FOR
	select sr1.name from sys.database_principals as SR1
	INNER JOIN sys.database_role_members as srm1
	on sr1.principal_id = SRM1.role_principal_id
	INNER JOIN sys.database_principals as SP1
	ON srm1.member_principal_id = sp1.principal_id
	where [sr1].[type] like 'R'
	AND [SP1].name LIKE   @DMZSQLLoginName

	OPEN DBRMCursor
	FETCH NEXT FROM DBRMCursor 
	INTO @dbrolename
	WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT 'EXEC sp_droprolemember ' + @dbrolename + ',' +  @DMZSQLLoginName
	EXEC sp_droprolemember @dbrolename ,@DMZSQLLoginName
	PRINT 'The user ' + @DMZSQLLoginName + ' dropped from the role ' + @dbrolename
	FETCH NEXT FROM DBRMCursor 
	INTO @dbrolename
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
	SET @dbrolename = 'db_executor'
	SET @grantcontrol = 1

	DECLARE pcur CURSOR
	FOR
	SELECT 
	s1.[name]
	,sp1.[name]
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
			SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) 
			--PRINT @TSQL
			IF @grantcontrol = 1 
			BEGIN
			SET @tsql = @tsql + 'GRANT CONTROL ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) 
			SET @tsql = @tsql +  'GRANT EXECUTE ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) 
			END
		
			exec sp_executesql @tsql
			print @tsql
			PRINT @dbrolename + ' permissions granted on ' + @pname + ' success'
		END TRY 
		BEGIN CATCH 
			PRINT @dbrolename + ' permissions granted on ' + @pname + ' failed'
			--PRINT @tsql
			SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
			PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS NVARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS NVARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS NVARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000))
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

		DECLARE @objname NVARCHAR(128)
		DECLARE @objtype NVARCHAR(10)
		DECLARE @objtypedesc NVARCHAR(128)

		SET @dbrolename = 'db_ddlviewer'
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
					SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @objname + '] TO ['+ @dbrolename + '] ' + CHAR(13) 
					--print @tsql
					exec sp_executesql @tsql
					PRINT @dbrolename + ' permissions granted on ' + @objtypedesc +  ' object type ' + @pschema +  '.' +  @objname + ' success'
				END TRY 
				BEGIN CATCH 
					PRINT @dbrolename + ' permissions granted on ' + @objtypedesc +  ' object type ' + @pschema +  '.' +  @objname + ' failed'
					PRINT @tsql
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
					PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS NVARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS NVARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS NVARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000))
					END CATCH 
				FETCH NEXT FROM ddlreadercur
				INTO @pschema, @objname, @objtype, @objtypedesc
			END
		CLOSE ddlreadercur
		DEALLOCATE ddlreadercur
		
WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBPIsProcessed = 0) <> 0
	BEGIN
		SELECT TOP 1 @DMZSQLLoginName = DMZSQLLoginName, @dbrolename = dbrolename FROM @dbrolestogrant WHERE DBPIsProcessed = 0 
		PRINT 'EXEC sp_addrolemember '+ @DBrolename + ',' + @DMZSQLLoginName 
		EXEC sp_addrolemember @DBrolename ,@DMZSQLLoginName 
		UPDATE @dbrolestogrant
		SET DBPIsProcessed = 1
		WHERE dbrolename = @dbrolename
		AND DMZSQLLoginName =  @DMZSQLLoginName
		IF  (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBPIsProcessed = 0) = 0
		BREAK
		ELSE
		CONTINUE
		
		PRINT @DMZSQLLoginName + ' login granted the ' +  @DBrolename +  ' in the ' + DB_NAME() + ' database'
	END

EXITONERROR:

SET NOCOUNT OFF
SET XACT_ABORT OFF