/*********************************************************************************
name:		Database_Tables_VW_SEL_Table_Metadata

Author:		Danny Howell

DATE:		

Description:  Custom VIEW OF TABLE metadata

*********************************************************************************/



use KFBSQLMgmt
go

IF EXISTS (SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'tables_metadata' AND type = 'u' )
BEGIN
DROP TABLE [tempdb].[dbo].[tables_metadata]
END
GO


DECLARE @rundate DATETIME
DECLARE @runinit INT
SET @rundate = GETDATE()
SELECT @runinit =  1

IF NOT EXISTS(
SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'tables_metadata' AND type = 'u' )
BEGIN
CREATE TABLE tempdb.dbo.tables_metadata 
(rundate DATETIME NOT NULL
,database_name VARCHAR(128) NOT NULL
,[schema_name] VARCHAR(128) NOT NULL
,[object_name] VARCHAR(128) NOT NULL
,[object_type] NVARCHAR(60) NOT NULL
,[column_ordinal] INT NOT NULL
,[column_name] VARCHAR(128) NOT NULL
,[is_nullable] VARCHAR(3) NOT NULL
,[data_type] VARCHAR(30) NULL
,[column_default] VARCHAR(30) NULL
,[is_identity] VARCHAR(3) NOT NULL
,[seed_Increment] VARCHAR(6)
)
END

insert into tempdb.dbo.tables_metadata
SELECT 
cast(@rundate as DATE)
,[ISC].[TABLE_CATALOG]
,[ISC].[TABLE_SCHEMA]
,[ISC].[TABLE_NAME]
,CASE WHEN [ISV].[TABLE_NAME] IS NOT NULL THEN 'View' ELSE 'Table' END AS Object_Type
,[ISC].[ORDINAL_POSITION]
,[ISC].[COLUMN_NAME]
,[ISC].[IS_NULLABLE]
,CASE [ISC].[DATA_TYPE]
	WHEN 'INT' THEN [ISC].[DATA_TYPE]
	WHEN 'NCHAR' THEN [ISC].[DATA_TYPE] +'(' +  
		CASE [ISC].[CHARACTER_MAXIMUM_LENGTH]
		WHEN -1 THEN 'Max'
		ELSE CAST([ISC].[CHARACTER_MAXIMUM_LENGTH] AS NVARCHAR(5)) END
		+ ')'
	WHEN 'CHAR' THEN [ISC].[DATA_TYPE] +'(' +  
		CASE [ISC].[CHARACTER_MAXIMUM_LENGTH]
		WHEN -1 THEN 'Max'
		ELSE CAST([ISC].[CHARACTER_MAXIMUM_LENGTH] AS NVARCHAR(5)) END
		+ ')'
	WHEN 'nvarchar' THEN [ISC].[DATA_TYPE] +'(' +  
		CASE [ISC].[CHARACTER_MAXIMUM_LENGTH]
		WHEN -1 THEN 'Max'
		ELSE CAST(([ISC].[CHARACTER_MAXIMUM_LENGTH]) AS NVARCHAR(5)) END
		+ ')'
	WHEN 'varchar' THEN [ISC].[DATA_TYPE]  +'(' +  
		CASE [ISC].[CHARACTER_MAXIMUM_LENGTH]
		WHEN -1 THEN 'Max'
		ELSE CAST([ISC].[CHARACTER_MAXIMUM_LENGTH] AS NVARCHAR(5)) END
		+ ')'
	WHEN 'decimal' THEN [ISC].[DATA_TYPE] +'(' +  CAST([NUMERIC_PRECISION] AS NVARCHAR(5)) + ',' + CAST([NUMERIC_SCALE] AS NVARCHAR(5)) +')'
	ELSE [ISC].[DATA_TYPE] END AS DATA_TYPE
,ISNULL([ISC].[COLUMN_DEFAULT],'') AS COLUMN_DEFAULT
,CASE WHEN IC2.IS_IDENTITY =1 THEN 'Yes' ELSE 'No' END AS IS_IDENTITY 
,ISNULL(IC2.Seed_Increment,'') AS SEED_INCREMENT
 FROM [INFORMATION_SCHEMA].[COLUMNS] AS ISC
LEFT OUTER JOIN [INFORMATION_SCHEMA].[VIEWS] AS ISV
ON ISC.TABLE_SCHEMA = ISV.TABLE_SCHEMA
AND ISC.TABLE_NAME = ISV.TABLE_NAME
LEFT OUTER JOIN 
(
SELECT 
t.name as TABLE_NAME
,c.name AS COLUMN_NAME
,ic.is_identity AS IS_IDENTITY
,cast(ic.seed_value as varchar(2)) + ',' + cast(ic.increment_value as varchar(2)) as Seed_Increment
FROM sys.identity_columns ic 
INNER JOIN sys.columns AS c ON
ic.object_id = c.object_id
AND ic.column_id = c.column_id
INNER JOIN sys.tables as t ON
ic.object_id = t.object_id) AS IC2
ON ISC.TABLE_NAME = ic2.TABLE_NAME 
AND isc.COLUMN_NAME = ic2.COLUMN_NAME
order by Object_Type,[ISC].[TABLE_SCHEMA]
,[ISC].[TABLE_NAME]
, isc.ORDINAL_POSITION


/*
select distinct
column_name AS [Column Name]
,'' as [Friendly Name]
,'' as [Short Description]
,'' as [Long Business Description]
,'' as [Origin]
,'No' as [Is Derived]
,'' as [Derived Column Formula]
,'' as [Values Domain]
,'' as [Reporting System Used In]
from tempdb.dbo.tables_metadata
*/
select 
[column_Name] as [Column Name]
,[column_ordinal] AS [Column Number]
,[schema_name] AS [Schema Name]
,cast(@rundate as DAte) as [Last Metadata Poling Date]
,[OBJECT_NAME] AS [Object Name]
,[object_type] AS [Type]
,'Yes' AS [In Production]
,[is_Nullable] AS [Is Nullable]
,[data_type] AS [Data Type]
,'' AS [Reporting System Used In]
,'' AS [Definition]
,'' as [Source Type]
,'' as [Source Name]
,'' AS [Source Column]
,'' AS [Source Data Type]
,'' AS [Is Derived Column]
,'' AS [Source Formula]
from tempdb.dbo.tables_metadata
