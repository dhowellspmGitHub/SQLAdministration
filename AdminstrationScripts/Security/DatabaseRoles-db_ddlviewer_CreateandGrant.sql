USE [eBusiness_PmtInt_QA]

DECLARE @dbname NVARCHAR(128)
--DECLARE @currentdbid INT
DECLARE @tsql NVARCHAR(2000)
--DECLARE @dbrolestogrant TABLE (ADGroupName NVARCHAR(128), ADrolename NVARCHAR(128), dbrolename NVARCHAR(128), SPIsprocessed BIT, DBPIsProcessed BIT)
DECLARE @pschema NVARCHAR(128)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @grantcontrol BIT 
DECLARE @objname NVARCHAR(128)
DECLARE @objtype NVARCHAR(10)
DECLARE @objtypedesc NVARCHAR(128)

SET @dbname = db_name()

/*

AF = Aggregate function (CLR)
C = CHECK constraint
D = DEFAULT (constraint or stand-alone)
F = FOREIGN KEY constraint
FN = SQL scalar function
FS = Assembly (CLR) scalar-function
FT = Assembly (CLR) table-valued function
IF = SQL inline table-valued function
IT = Internal table
P = SQL Stored Procedure
PC = Assembly (CLR) stored-procedure
PG = Plan guide
PK = PRIMARY KEY constraint
R = Rule (old-style, stand-alone)
RF = Replication-filter-procedure
S = System base table
SN = Synonym
SO = Sequence object
SQ = Service queue
TA = Assembly (CLR) DML trigger
TF = SQL table-valued-function
TR = SQL DML trigger 
TT = Table type
U = Table (user-defined)
UQ = UNIQUE constraint
V = View
X = Extended stored procedure
*/

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_ddlviewer' AND type = 'R')
	BEGIN
	CREATE ROLE [db_ddlviewer] AUTHORIZATION [dbo]
	END
GRANT VIEW DATABASE STATE TO [db_ddlviewer]

SET @dbrolename = 'db_ddlviewer'
PRINT 'Review the DAL queries below before copy/paste and execution'
DECLARE ddlviewercur CURSOR
FOR
SELECT DISTINCT
SCHEMA_NAME([schema_id]),[name], [type], [type_desc]
from [sys].[objects]
WHERE [type] IN 
('AF','C','FN','IF','P','PG','PK','SN','SO','TF','U','V','X')
--('FN','D','P','TF','SN','TR','V')
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
			SET @tsql = @tsql + 'GRANT SHOWPLAN TO [' + @dbrolename + '] ' + CHAR(13) 
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
			EXEC sp_droprolemember @dbrolename, @dbpname
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

/*

*/