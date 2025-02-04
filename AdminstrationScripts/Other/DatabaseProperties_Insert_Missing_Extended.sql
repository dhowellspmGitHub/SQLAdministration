--Create cursor and table variable to hold the list of all current extended properties
USE tempdb 
IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME LIKE 'database_current_extended_properties' AND TYPE LIKE 'U')
BEGIN
DROP TABLE TEMPDB.DBO.database_current_extended_properties
END
GO
CREATE TABLE tempdb.dbo.database_current_extended_properties (DBName NVARCHAR(128), EPName NVARCHAR(128))
GO

DECLARE @dbn NVARCHAR(128)
DECLARE @epname NVARCHAR(128)

DECLARE DBNCursor CURSOR
FOR
SELECT db1.name
FROM master.sys.databases as DB1
WHERE [state_desc] NOT LIKE 'OFFLINE'
AND source_database_id IS NULL

OPEN DBNCursor
FETCH NEXT FROM DBNCursor
INTO @dbn

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @TSQL NVARCHAR(4000)
SET @TSQL = 'USE [' + @dbn + '] 
INSERT INTO [tempdb].[dbo].[database_current_extended_properties]
           ([DBName]
           ,[EPName])
SELECT cast(db_name() as nvarchar(128)), cast(name as nvarchar(128)) from sys.extended_properties WHERE class_desc = '+ CHAR(39) + 'DATABASE' + CHAR(39) + ' and class = 0'
--print @tsql
EXEC SP_EXECUTESQL @TSQL
FETCH NEXT FROM DBNCursor
INTO @dbn
END
CLOSE DBNCursor
DEALLOCATE DBNCursor

DECLARE EPToRemoveCur CURSOR
FOR
select DBName,epname from tempdb.dbo.database_current_extended_properties
where EPName not like '%microsoft%'

OPEN EPToRemoveCur
FETCH NEXT FROM EPToRemoveCur
INTO @dbn, @epname

WHILE @@FETCH_STATUS = 0
BEGIN
--DECLARE @TSQL NVARCHAR(4000)
set @TSQL = 'USE master EXEC [' + @dbn + '].sys.sp_dropextendedproperty @name=N' + char(39) + @epname + char(39)
print @tsql
EXEC SP_EXECUTESQL @TSQL
FETCH NEXT FROM EPToRemoveCur
INTO @dbn, @epname
END
CLOSE EPToRemoveCur
DEALLOCATE EPToRemoveCur
GO


--Confirm all user databases have the expected extended properties
USE tempdb 
IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME LIKE 'database_KFBSQL_extended_properties' AND TYPE LIKE 'U')
BEGIN
DROP TABLE TEMPDB.DBO.database_KFBSQL_extended_properties
END
GO
CREATE TABLE tempdb.dbo.database_KFBSQL_extended_properties (EPName NVARCHAR(128))
GO
INSERT INTO tempdb.dbo.database_KFBSQL_extended_properties  (EPName)
VALUES(N'ApplicationID')
INSERT INTO tempdb.dbo.database_KFBSQL_extended_properties  (EPName)
VALUES(N'InitialDBRequestedByContactName')

--Create cursor and table variable to hold the list of 
DECLARE @dbn NVARCHAR(128)
DECLARE @epname NVARCHAR(128)

DECLARE DBNCursor CURSOR
FOR
SELECT db1.name
,t1.epname
FROM master.sys.databases as DB1
CROSS JOIN tempdb.dbo.database_KFBSQL_extended_properties as T1
WHERE [state_desc] NOT LIKE 'OFFLINE'
AND source_database_id IS NULL

OPEN DBNCursor
FETCH NEXT FROM DBNCursor
INTO @dbn, @epname

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @TSQL NVARCHAR(4000)
SET @TSQL =
'USE [' + @dbn + '] 
IF NOT EXISTS(SELECT * from sys.extended_properties WHERE name LIKE ' + CHAR(39) + @epname+ CHAR(39) + ' and class_desc = '+ CHAR(39) + 'DATABASE' + CHAR(39) + ' and class = 0)
BEGIN 
USE [' + @dbn + '] EXEC sp_addextendedproperty @name = N' + CHAR(39) + @epname + CHAR(39) + ', @value = N' + char(39) + 'Needs value entered' + char(39) +
'END'

print @tsql
EXEC SP_EXECUTESQL @TSQL
FETCH NEXT FROM DBNCursor
INTO @dbn, @epname
END
CLOSE DBNCursor
DEALLOCATE DBNCursor
GO
