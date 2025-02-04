IF EXISTS (SELECT * FROM [msdb].[sys].[tables] WHERE [name] LIKE 'database_restore_customrolepermissions')
BEGIN
DROP TABLE [msdb].[dbo].[database_restore_customrolepermissions]
END

IF EXISTS (SELECT * FROM [msdb].[sys].[tables] WHERE [name] LIKE 'database_restore_extendedproperties')
BEGIN
DROP TABLE [msdb].[dbo].[database_restore_extendedproperties]
END

IF EXISTS (SELECT * FROM [msdb].[sys].[tables] WHERE [name] LIKE 'database_restore_users')
BEGIN
DROP TABLE [msdb].[dbo].[database_restore_users]
END

IF EXISTS (SELECT * FROM [msdb].[sys].[tables] WHERE [name] LIKE 'database_restore_usersrolemembers')
BEGIN
DROP TABLE [msdb].[dbo].[database_restore_usersrolemembers]
END
GO

/****** Object:  Role [db_executor]    Script Date: 06/07/2013 12:51:35 ******/
USE [ci_m]	--REPLACE THIS TEXT TO THE DATABASE NAME WHERE THE ROLE WILL BE CREATED--
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_executor' AND type = 'R')
BEGIN
CREATE ROLE [db_executor] AUTHORIZATION [dbo]
END
GO

DECLARE @dbname NVARCHAR(128)
DECLARE @tsql NVARCHAR(2000)
DECLARE @pschema NVARCHAR(128)
DECLARE @pname NVARCHAR(128)
DECLARE @dbrolename NVARCHAR(128)
DECLARE @grantcontrol BIT 

--uncomment out the next line to grant control and execute to role.  Otherwise, the role will only have VIEW DEFINITION permissions on all stored procedures
--THIS MUST BE SET TO 1 ONLY ON NON-PRODUCTION SYSTEMS
set @grantcontrol = 0

/*
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
*/

SET @dbname = DB_NAME()
SET @dbrolename = 'db_executor'
--Create a cursor of all user stored procedures and scalar functions to grant specific access rights
GRANT VIEW DATABASE STATE TO [db_executor]

DECLARE pcur CURSOR
FOR
SELECT 
s1.[name]
,sp1.[name]
FROM sys.procedures as SP1
INNER JOIN sys.schemas as S1
ON SP1.schema_id = S1.schema_id
UNION ALL
SELECT 
s1.[name]
,sp1.[name]
FROM sys.objects as SP1
INNER JOIN sys.schemas as S1
ON SP1.schema_id = S1.schema_id
where sp1.[type] in ('FN','IF')--,'TF')

OPEN pcur
FETCH NEXT FROM pcur
INTO @pschema, @pname

WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN TRY
	SET @tsql = ''
	SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql + 'GRANT SHOWPLAN TO [' + @dbrolename + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql +  'GRANT EXECUTE ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)

	IF @grantcontrol = 1 
	BEGIN
		SET @tsql = @tsql + 'GRANT CONTROL ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	END
		
	EXEC sp_executesql @tsql
	print @tsql
	PRINT @dbrolename + ' permissions granted on ' + @pname + ' success'
END TRY
BEGIN CATCH
PRINT @dbrolename + ' permissions granted on ' + @pname + ' failed'
PRINT @tsql
	SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH
FETCH NEXT FROM pcur
INTO @pschema, @pname
END

CLOSE pcur
DEALLOCATE pcur

--reset variables and create new cursor for table based functions--these do not have the EXECUTE access type but have the REFERENCES access type
SET @pname = null
set @pschema = null

DECLARE fcur CURSOR
FOR
SELECT 
s1.[name]
,sp1.[name]
FROM sys.objects as SP1
INNER JOIN sys.schemas as S1
ON SP1.schema_id = S1.schema_id
where sp1.[type] in ('IF','TF')
order by type

OPEN fcur
FETCH NEXT FROM fcur
INTO @pschema, @pname

WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN TRY
	SET @tsql = ''
	SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	IF @grantcontrol = 1 
	BEGIN
		SET @tsql = @tsql + 'GRANT CONTROL ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
		SET @tsql = @tsql +  'GRANT REFERENCES ON [' +@pschema +  '].[' + @pname + '] TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	END
		
	EXEC sp_executesql @tsql
	print @tsql
	PRINT @dbrolename + ' permissions granted on ' + @pname + ' success'
END TRY
BEGIN CATCH
PRINT @dbrolename + ' permissions granted on ' + @pname + ' failed'
PRINT @tsql
	SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH
FETCH NEXT FROM fcur
INTO @pschema, @pname
END

CLOSE fcur
DEALLOCATE fcur


--reset variables and create new cursor for table based functions--these do not have the EXECUTE access type but have the REFERENCES access type
SET @pname = null
set @pschema = null

DECLARE fcur CURSOR
FOR
SELECT 
SCHEMA_NAME([schema_id])
,[name]
FROM [sys].[types]
WHERE is_user_defined = 1
AND [is_table_type] = 1

OPEN fcur
FETCH NEXT FROM fcur
INTO @pschema, @pname

WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN TRY
	SET @tsql = ''
	SET @tsql = @tsql + 'USE [' + @dbname + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql + 'GRANT VIEW DEFINITION ON TYPE::' + @pname + ' TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	SET @tsql = @tsql +  'GRANT EXECUTE ON TYPE::' + @pname + ' TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	IF @grantcontrol = 1 
	BEGIN
		SET @tsql = @tsql + 'GRANT CONTROL ON TYPE::' + @pname + ' TO ['+ @dbrolename + '] ' + CHAR(13) + CHAR(10)
	END
	EXEC sp_executesql @tsql
	print @tsql
	PRINT @dbrolename + ' permissions granted on ' + @pname + ' success'
END TRY
BEGIN CATCH
PRINT @dbrolename + ' permissions granted on ' + @pname + ' failed'
PRINT @tsql
	SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH
FETCH NEXT FROM fcur
INTO @pschema, @pname
END

CLOSE fcur
DEALLOCATE fcur



 