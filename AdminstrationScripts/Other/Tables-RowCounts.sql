 /********************************************************************************
	Script Name:    DATABASE-Create Table List with Row Count

	Date:           10/13/2008

	Author:         Danny Howell

	Purpose:   Create a table of a current database's table with current record count.  
	Use the RECORDCOUNT_ESTIMATE field to calculate a change from current.  
	Use the table along with the DATABASE-Create an Estimate of Database Size script to perform the 
	final estimate calculation

	Dependencies: None
	
	Tables Referred  : sys.objects

	Input Parameters : None
	Output Parameters:   None
	Results: A table of table names, current row count for which the script is run against.
	Script Macro Logic:	Retrieve field information on a named table
				
************************************************************************************************/
--CREATE A TABLE TO HOLD THE TABLE NAMES AND CURRENT RECORD COUNT IN A NAMED DATABASE
SET NOCOUNT ON
GO
USE [KFBSQLMgmt]
GO

SELECT 
db_name()
,OBJECT_SCHEMA_NAME(t.object_id)
,[NAME] as Table_Name
, I.row_count AS [ROWCOUNT] 
FROM sys.tables AS T 
INNER JOIN sys.dm_db_partition_stats AS I 
ON T.object_id = I.object_id 
AND I.index_id < 2 
ORDER BY 
OBJECT_SCHEMA_NAME(t.object_id)
,T.name

/*
IF NOT EXISTS (SELECT NAME FROM TEMPDB.SYS.OBJECTS WHERE NAME LIKE 'Table_RowCounts' AND TYPE LIKE 'U')
BEGIN
CREATE TABLE TEMPDB.DBO.Table_RowCounts (DBNAME NVARCHAR(128)
, SCHEMANAME NVARCHAR(128) NOT NULL
, TABLENAME NVARCHAR(128) NOT NULL
, QUERYDATE DATETIME NULL
, RECORDCOUNT_CURRENT INT NOT NULL
, RECORDCOUNT_ESTIMATE INT NOT NULL)
END
--ELSE
--BEGIN
TRUNCATE TABLE TEMPDB.DBO.Table_RowCounts
--TRUNCATE TABLE TEMPDB.DBO.TBLINDEXES  
--END
--GO
--LOOP THROUGH ALL TABLES, ADDING THE RECORD COUNTS TO THE TEMP TABLE
DECLARE @DBNAME AS NVARCHAR(128)
DECLARE @SCHEMANAME AS NVARCHAR(128)
DECLARE @TBNAME AS NVARCHAR(128)
DECLARE @TSQL AS NVARCHAR(1000)
SET @TSQL = ''
DECLARE @RUNDATE DATETIME
SET @RUNDATE = GETDATE()
DECLARE TN_CUR CURSOR FOR
SELECT S.NAME, T.NAME  FROM SYS.OBJECTS T INNER JOIN SYS.SCHEMAS S 
ON T.SCHEMA_ID = S.SCHEMA_ID WHERE T.TYPE_DESC = 'USER_TABLE'
OPEN TN_CUR
FETCH NEXT FROM TN_CUR INTO @SCHEMANAME ,@TBNAME
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @TSQL = @TSQL + 'DECLARE @ROWCNT AS INT ' + CHAR(13)
	SET @TSQL = @TSQL + 'SELECT @ROWCNT = COUNT(*) FROM ' + @SCHEMANAME + '.' + @TBNAME + ' OPTION (MAXDOP 1)' + CHAR(13) + CHAR(13)
	SET @TSQL = @TSQL + 'INSERT INTO TEMPDB.DBO.Table_RowCounts VALUES (' + CHAR(39) + DB_NAME() + CHAR(39) + ',' + CHAR(39) + @SCHEMANAME + CHAR(39) + ',' + CHAR(39) + @TBNAME + CHAR(39) + ', CAST('+ CHAR(39) + CAST(@RUNDATE AS NVARCHAR(20)) + CHAR(39) + ' AS DATETIME),  @ROWCNT,0)' + CHAR(13) + CHAR(13)
	PRINT @TSQL
	
	EXEC SP_EXECUTESQL @TSQL
	SET @TSQL = ''
	FETCH NEXT FROM TN_CUR INTO @SCHEMANAME ,@TBNAME
END
CLOSE TN_CUR
DEALLOCATE TN_CUR
*/
-- Follow up query
/* use the query below to compare record counts before and after a database change to confirm consistent record counts.
Remember to comment out the above code that TRUNCATES the table else there won't be records to compare
--*/

--SELECT [T2].[DBNAME]
--      ,[T2].[SCHEMANAME]
--      ,[T2].[TABLENAME]
--      ,[T2].[QUERYDATE]
--      ,[T2].[RECORDCOUNT_CURRENT]
--      ,coalesce([T1].[RECORDCOUNT_CURRENT],0) as [RECORDCOUNT_PRIOR]
--FROM [tempdb].[dbo].[Table_RowCounts] AS T2
--  LEFT OUTER JOIN 
--  (SELECT [DBNAME]
--      ,[SCHEMANAME]
--      ,[TABLENAME]
--      ,[QUERYDATE]
--      ,[RECORDCOUNT_CURRENT]
--      ,[RECORDCOUNT_ESTIMATE]
--  FROM [tempdb].[dbo].[Table_RowCounts]
--  where [Querydate] = (select MIN([QUERYDATE]) from [tempdb].[dbo].[Table_RowCounts])) AS T1
--  ON T2.DBNAME = T1.DBNAME AND
--  T2.SCHEMANAME = T1.SCHEMANAME
--  AND T2.TABLENAME = T1.TABLENAME
--  where T2.[Querydate] = (select MAX([QUERYDATE]) from [tempdb].[dbo].[Table_RowCounts])
--  order by   T2.[QUERYDATE], T2.TABLENAME
--GO


