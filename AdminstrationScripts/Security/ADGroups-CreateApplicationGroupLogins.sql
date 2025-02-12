DECLARE @DomainName NVARCHAR(128)
DECLARE @GroupPrefix NVARCHAR(128)
DECLARE @ApplicationName NVARCHAR(128)
DECLARE @RoleName NVARCHAR(128)
DECLARE @Separator NVARCHAR(1)
DECLARE @WindowsGroupName NVARCHAR(128)

DECLARE @dbname NVARCHAR(128)
DECLARE @currentdbid INT
DECLARE @tsql NVARCHAR(2000)
DECLARE @dbrolestogrant TABLE (ADGroupName NVARCHAR(128), ADrolename NVARCHAR(128), dbrolename NVARCHAR(128), SPIsprocessed BIT, DBPIsProcessed BIT)
DECLARE @pschema NVARCHAR(128)
DECLARE @pname NVARCHAR(128)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @grantcontrol BIT 
DECLARE @isproductionsystem BIT
DECLARE @resetdatabasepermissions BIT
/* These next three items/variable values must be changed for each database against which this procedure is run */
--Set the USE statement for the database in which the groups are to be created
USE [PI_UAT2_ARCHIVE]

-- Set variable indicating if server is a production server or non-production server
--1 = Yes; 0 = No
SET @isproductionsystem = 0
SET @resetdatabasepermissions = 1

/* Set value for the database, application name (as defined by Data Security) and Role name in the parameters below */
SET @ApplicationName = 'PolicyCenter'

SET @Separator = '_'
SET @DomainName = 'KFBDOM1\'
SET @GroupPrefix = 'SQL'

SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
SET @dbname = db_name()
--Add DataAdmin roles to table variable
IF @isproductionsystem = 1
BEGIN

	SET @RoleName = 'DataAdmin'
	SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datawriter',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddlviewer',0,0)

	--Add ProdSupport role to table variable
	SET @RoleName = 'ProdSupport'
	SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datareader',0,0)
	--INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddlviewer',0,0)
	--the ProdSupport group is granted the datawriter database role on non-production database only

END

--Add Developer roles to table for non-production databases

IF @isproductionsystem = 0
BEGIN
/*
	SET @RoleName = 'Designer'
	SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datawriter',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddlviewer',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddladmin',0,0)
*/
	SET @RoleName = 'Developer'
	SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datareader',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datawriter',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddlviewer',0,0)

--Add Integrator roles to table for non-production databases
	SET @RoleName = 'Integrator'
	SET @WindowsGroupName = @DomainName + @GroupPrefix + @Separator + @ApplicationName + @Separator + @RoleName
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_datareader',0,0)
	--INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_executor',0,0)
	INSERT INTO @dbrolestogrant (ADGroupName,ADrolename,dbrolename,SPIsprocessed, DBPIsProcessed) VALUES (@WindowsGroupName,@RoleName,'db_ddlviewer',0,0)
END

SELECT db_name(), * FROM @dbrolestogrant

--BEGIN TRY 
SELECT @currentdbid = database_id FROM master.sys.databases where name like @dbname
IF @currentdbid <= 4
BEGIN
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = 'This procedure should not be run against system databases.  Please correct your USE statement above to the correct database and re-run'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	--THROW 60000 , @msg, 1 
END
ELSE
	WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE SPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @WindowsGroupName = ADGroupName FROM @dbrolestogrant WHERE SPIsProcessed = 0
		-- Create the SQL Server Login if it does not exist
		IF NOT EXISTS (SELECT * FROM master.sys.server_principals WHERE [name] LIKE @WindowsGroupName AND [type] LIKE 'G')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE MASTER' + CHAR(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE LOGIN ' + quotename(@WindowsGroupName) + ' FROM WINDOWS WITH DEFAULT_DATABASE=' + quotename(@dbname) + ', DEFAULT_LANGUAGE=[us_english];'
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @tsql;
			exec sp_executesql @tsql
			PRINT @WindowsGroupName + ' login granted access to the server'
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE ADGroupName = @WindowsGroupName
		END
		ELSE
		BEGIN
			UPDATE @dbrolestogrant
			SET SPIsProcessed = 1
			WHERE ADGroupName = @WindowsGroupName
			PRINT '--Windows Group: ' + @WindowsGroupName + ' already exists on this server.  The below TSQL code has been run creating database principal and appropriate authority to the ' + @dbname + 
			' database'
		END

		SET @tsql = ''set @tsql = 'USE MASTER' + CHAR(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'GRANT VIEW SERVER STATE TO ' + quotename(@WindowsGroupName) + CHAR(13) 
			SET @tsql = @TSQL + 'GRANT VIEW ANY DATABASE TO ' + quotename(@WindowsGroupName) + CHAR(13) 
			SET @tsql = @TSQL + 'GRANT VIEW ANY DEFINITION TO ' + quotename(@WindowsGroupName) + CHAR(13) 
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @tsql;
			exec sp_executesql @tsql

		--For this database (see USE statement above), create a corresponding database principal for this login
		IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name LIKE @WindowsGroupName AND type like 'G')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE USER ' + quotename(@WindowsGroupName) + ' FOR LOGIN ' + quotename(@WindowsGroupName)  + char(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			--SET @tsql = @TSQL + 'ALTER USER ' + quotename(@WindowsGroupName) + ' WITH DEFAULT_SCHEMA=[dbo]' + char(13)
			PRINT @TSQL
			exec sp_executesql @tsql
		END

		SET @tsql = ''
		set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
		SET @tsql = @TSQL + 'GRANT SHOWPLAN TO [' + @WindowsGroupName +  ']' + CHAR(13) 
		SET @tsql = @TSQL + 'GRANT VIEW DATABASE STATE TO [' + @WindowsGroupName +  ']' + CHAR(13) 
		SET @tsql = @TSQL + 'GRANT VIEW DEFINITION TO [' + @WindowsGroupName +  ']' + CHAR(13) 
		PRINT @TSQL
		exec sp_executesql @tsql

		
		--When adding AD groups to a database, a default schema cannot be specified. However, for some reason, SQL Server creates a new schema using the group name
		--Don't want this to happen so if a new schema is created with the name of the AD group, drop the schema
		IF EXISTS (SELECT * FROM sys.schemas WHERE name like @WindowsGroupName)
		BEGIN
			PRINT 'Schema named ' + @WindowsGroupName + ' created by script. Dropping this new schema'
			SET @tsql = ''
			set @tsql = 'USE ' +  quotename(@dbname)  + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'DROP SCHEMA ' + quotename(@WindowsGroupName) + char(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @TSQL
		exec sp_executesql @tsql 
		END
	
		IF NOT EXISTS (SELECT * FROM tempdb.sys.database_principals WHERE name LIKE @WindowsGroupName AND type like 'G')
		BEGIN
			SET @tsql = ''
			set @tsql = 'USE [TEMPDB]' + char(13)
			SET @tsql = @TSQL + 'BEGIN'  + char(13)
			SET @tsql = @TSQL + 'CREATE USER ' + quotename(@WindowsGroupName) + ' FOR LOGIN ' + quotename(@WindowsGroupName)  + char(13)
			SET @tsql = @TSQL + 'EXEC sp_addrolemember N' + CHAR(39) + 'db_owner' + CHAR(39) + ', N' + CHAR(39) + @WindowsGroupName + CHAR(39) + CHAR(13)
			SET @tsql = @TSQL + 'END;' +  + char(13)
			PRINT @TSQL
			exec sp_executesql @tsql
		END
	

	END  --while end
	

	-- for role assignments, it is simpler and more accurate to revoke all current database roles and regrant them rather than attempting to validate each role.  Additionally, this procedure can be used to reset the authority granted.  If a variation of the standard authority is made, then confirming roles other than those designated while granted those allowed, results in much more complex TSQL code to record those variations.
	-- for each role that exists for this user, use the ALTER ROLE statement to drop the database principal
	

	DECLARE DBRMCursor CURSOR
	FOR
	select SR1.name from sys.database_principals as SR1
	INNER JOIN sys.database_role_members as SRM1
	on SR1.principal_id = SRM1.role_principal_id
	INNER JOIN sys.database_principals as SP1
	ON SRM1.member_principal_id = SP1.principal_id
	where [SR1].[type] like 'R'
	AND [SP1].name LIKE @WindowsGroupName

	OPEN DBRMCursor
	FETCH NEXT FROM DBRMCursor 
	INTO @dbrolename
	WHILE @@FETCH_STATUS = 0
	BEGIN
	EXEC sp_droprolemember 'db_owner' ,@WindowsGroupName

	PRINT 'EXEC sp_droprolemember ' + @dbrolename + ',' +  @WindowsGroupName
	EXEC sp_droprolemember @dbrolename ,@WindowsGroupName
	
	FETCH NEXT FROM DBRMCursor 
	INTO @dbrolename
	END

	CLOSE DBRMCursor
	DEALLOCATE DBRMCursor

	IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_executor' AND type = 'R')
	BEGIN
	CREATE ROLE [db_executor] AUTHORIZATION [dbo]
	END

	PRINT 'Grant database level permissions to role db_executor'
	GRANT VIEW DATABASE STATE TO [db_executor]

	set @grantcontrol = 0
	SET @dbname = DB_NAME()
	SET @dbrolename = 'db_executor'
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
			SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' + @pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) 
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
		The next phase in the process is to grant 'VIEW DEFINITION' on all "code related" objects within the database by creating a custom DDLViewer database role and granting those rights to the database role.
		By using a custom role similar to the DB_executor role, permission granularity is more manageable.
		The db_ddlviewer role is limited to user defined, non-CLR objects.  From the SQL object types, these are included.
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

		PRINT 'Grant database level permissions to role db_ddlviewer'
		GRANT VIEW DATABASE STATE TO [db_ddlviewer]

		DECLARE @objname NVARCHAR(128)
		DECLARE @objtype NVARCHAR(10)
		DECLARE @objtypedesc NVARCHAR(128)

		SET @dbrolename = 'db_ddlviewer'
		PRINT 'Review the DAL queries below before copy/paste and execution'
		DECLARE ddlviewercur CURSOR
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

		OPEN ddlviewercur
		FETCH NEXT FROM ddlviewercur
		INTO @pschema, @objname, @objtype, @objtypedesc

		WHILE @@FETCH_STATUS = 0
		BEGIN
				BEGIN TRY 
					SET @tsql = ''
					SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
					SET @tsql = @tsql + 'GRANT VIEW DATABASE STATE TO '+  quotename(@WindowsGroupName) + CHAR(13) 
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
				FETCH NEXT FROM ddlviewercur
				INTO @pschema, @objname, @objtype, @objtypedesc
			END

		CLOSE ddlviewercur
		DEALLOCATE ddlviewercur
		


	WHILE (SELECT COUNT(*) FROM @dbrolestogrant WHERE DBPIsProcessed = 0) > 0
	BEGIN
		SELECT TOP 1 @WindowsGroupName = ADGroupName, @dbrolename = dbrolename FROM @dbrolestogrant WHERE DBPIsProcessed = 0
		PRINT 'EXEC sp_addrolemember '+ @DBrolename + ',' + @WindowsGroupName 
		EXEC sp_addrolemember @DBrolename ,@WindowsGroupName 
		UPDATE @dbrolestogrant
		SET DBPIsProcessed = 1
		WHERE dbrolename = @dbrolename
		AND ADGroupName =  @WindowsGroupName
		PRINT @WindowsGroupName + ' login granted the ' +  @DBrolename +  ' in the ' + DB_NAME() + ' database'

		
	END
--END TRY 

--BEGIN CATCH 
--		SELECT
--		ERROR_NUMBER() AS ErrorNumber
--		,ERROR_SEVERITY() AS ErrorSeverity
--		,ERROR_STATE() AS ErrorState
--		,ERROR_PROCEDURE() AS ErrorProcedure
--		,ERROR_LINE() AS ErrorLine
--		,ERROR_MESSAGE() AS ErrorMessage;
--		PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS NVARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS NVARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS NVARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000))
--END CATCH 
SET NOCOUNT OFF
SET XACT_ABORT OFF



--declare @dbrolename nvarchar(128)
SET @dbrolename = N'db_ddlreader'
PRINT 'Review the DAL queries below before copy/paste and execution'
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = @dbrolename AND type = 'R')
BEGIN
	DECLARE @dbpname NVARCHAR(128)
	DECLARE replacedrolecur CURSOR
	FOR
	SELECT DISTINCT
	[DBP1].[name]
	--,[DBRM1].*
	from [sys].[database_principals] as DBP1
	INNER JOIN [sys].[database_role_members] AS DBRM1
	ON [DBP1].[principal_id] = [DBRM1].[member_principal_id]
	INNER JOIN [sys].[database_principals] AS DBR1
	ON [DBRM1].[role_principal_id] = [DBR1].[principal_id]
	WHERE [DBP1].[type] IN ('S','U','G')
	AND [DBR1].[name] like @dbrolename
	OPEN replacedrolecur
	FETCH NEXT FROM replacedrolecur
	INTO @dbpname

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY 
			SET @tsql = ''
			SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
			SET @tsql = @tsql + 'ALTER ROLE [' + @dbrolename +  '] DROP MEMBER [' + @dbpname + ']' + CHAR(13) 
			exec sp_executesql @tsql
			PRINT @tsql
			--EXEC sp_droprolemember @dbrolename, @dbpname
			PRINT @dbrolename + ' role revoked from ' + @dbpname + ' successful'
			
		END TRY 
		BEGIN CATCH 
			PRINT @dbrolename + ' role revoked from ' + @dbpname + ' failed'
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
		FETCH NEXT FROM replacedrolecur
		INTO @dbpname
	END

	CLOSE replacedrolecur
	DEALLOCATE replacedrolecur
	
	SET @tsql = ''
	SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
	SET @tsql = @tsql + 'REVOKE VIEW DATABASE STATE TO [' + @dbrolename + '] AS [dbo]'
	PRINT @tsql
	exec sp_executesql @tsql

	SET @tsql = ''
	SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) 
	SET @tsql = @tsql + 'DROP ROLE [' + @dbrolename +  ']' + CHAR(13) 
	PRINT @tsql
	exec sp_executesql @tsql

END
ELSE
BEGIN
	PRINT 'Database role:' + @dbrolename + ' does not exist in this database-' + @dbname
END
