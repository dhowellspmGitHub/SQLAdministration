
/*********************************************************************************
Name:		Database_Objects_VW_SEL_Tables_and_Indexes_by_Physical_File

Author:		Danny Howell

Date:		

Description:		In SQL Server 2005 The data for about table is stored as an Index.  If a clustered index (indid = 1) then the data is the index.  if If no clustered index, then a heap index is created (indid = 0) (There will always be one or the other but never both).  The filegroup for the table is the filegroup that index is stored--find the type 0 or 1 index for each table and use the data_space_id to find the filegroup,

*********************************************************************************/
--list all files by file group for tables
--indexes--get indexes and columns metadata
use [OBProd]
go

IF EXISTS (SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'tables_metadata')
BEGIN
DROP TABLE [tempdb].[dbo].[tables_metadata]
END
go
IF EXISTS (SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'indexes_metadata' AND type = 'u' )
BEGIN
DROP TABLE [tempdb].[dbo].[indexes_metadata]
END
GO

CREATE TABLE tempdb.dbo.tables_metadata 
(rundate DATETIME NOT NULL
,database_name VARCHAR(128) NOT NULL
,t_name VARCHAR(128) NOT NULL
,t_object_id INT NOT NULL
,type_desc NVARCHAR(60) NOT NULL
,i_index_id INT NOT NULL
,i_name VARCHAR(128) NOT NULL
,object_type VARCHAR(15) NOT NULL
,data_space_id INT NOT NULL
,file_group_name NVARCHAR(60) NOT NULL
,data_file_name NVARCHAR(128) NOT NULL
,data_file_physical_name NVARCHAR(256) NOT NULL)

CREATE TABLE tempdb.dbo.indexes_metadata 
(rundate DATETIME NOT NULL
,runsequence INT NOT NULL
,database_name VARCHAR(128) NOT NULL
,i_object_id INT NOT NULL
,i_name VARCHAR(128) NOT NULL
,i_index_id INT NOT NULL
,i_type_desc NVARCHAR(60) NOT NULL
,i_is_unique BIT NOT NULL
,i_is_primary_key BIT NOT NULL
,i_fill_factor TINYINT NOT NULL
,t_type_desc NVARCHAR(60) NOT NULL
,tp_is_variable_length BIT NULL
,c_max_length_bytes INT NULL
,t_object_id INT NOT NULL
,t_parent_object_id INT NOT NULL
,t_name NVARCHAR(128) NOT NULL
,c_name NVARCHAR(128) NOT NULL
,ic_index_column_id INT NOT NULL
,ic_column_id INT NOT NULL)



DECLARE @rundate DATETIME
DECLARE @runinit INT
DECLARE @default_fill_factor INT
SET @rundate = GETDATE()
SELECT @runinit =  1
--get system default index fill factor
SELECT @default_fill_factor = CONVERT(INT,value_in_use) FROM sys.configurations
WHERE configuration_id = 109

INSERT INTO [tempdb].[dbo].[tables_metadata]
(rundate
,database_name
,t_name
,t_object_id
,type_desc
,i_index_id
,i_name 
,object_type
,data_space_id
,file_group_name
,data_file_name
,data_file_physical_name
)
SELECT 
@rundate
,DB_name()
,o.[name] 
,o.object_id 
,o.type_desc
, i.index_id
,ISNULL(i.name,'') AS indexname
, CASE i.index_id 
	WHEN 0 THEN 'HEAP'
	WHEN 1 THEN 'PK'
	ELSE 'INDEX' END AS objecttype
,i.data_space_id
,ds.[name]
,dbf.name
,dbf.physical_name
FROM 
sys.objects o
LEFT OUTER JOIN sys.indexes i ON 
o.[object_id] = i.[object_id] 
INNER JOIN sys.database_files dbf ON 
i.data_space_id= dbf.data_space_id
INNER JOIN sys.data_spaces as ds
ON i.data_space_id = ds.data_space_id
WHERE 
--i.index_id in (0, 1) and
o.type LIKE 'u' 
order by o.[name]

INSERT INTO [tempdb].[dbo].[indexes_metadata]
(rundate 
,runsequence 
,database_name
,i_object_id 
,i_name 
,i_index_id 
,i_type_desc 
,i_is_unique 
,i_is_primary_key
,i_fill_factor
,t_type_desc
,tp_is_variable_length
,c_max_length_bytes
,t_object_id
,t_parent_object_id
,t_name
,c_name 
,ic_index_column_id 
,ic_column_id )
SELECT 
@rundate
,@runinit
,DB_NAME()
,i.object_id
,i.name 
,i.index_id
,i.type_desc
,i.is_unique
,i.is_primary_key
,CASE i.fill_factor
WHEN 0 THEN @default_fill_factor
ELSE i.fill_factor END
,t.type_desc
,CASE tp.name
WHEN 'varchar' THEN 1
WHEN 'nvarchar' THEN 1
WHEN 'varbinary' THEN 1
ELSE 0 END AS is_variable_length
,CASE c.max_length 
WHEN -1 THEN 8000
ELSE c.max_length END AS max_length_bytes
,t.object_id
,t.parent_object_id
,t.name
,c.name
,ic.index_column_id
,ic.column_id
FROM sys.index_columns ic
INNER JOIN sys.tables t ON
ic.object_id = t.object_id
INNER JOIN sys.columns c ON
ic.column_id = c.column_id AND 
ic.object_id = c.object_id
INNER JOIN sys.indexes i ON
t.object_id = i.object_id AND
ic.index_id = i.index_id
INNER JOIN
(
SELECT name
,system_type_id
,[SCHEMA_ID]
,max_length
,[PRECISION]
,scale
,is_nullable
FROM sys.types 
WHERE is_user_defined = 0
) AS  tp ON
c.system_type_id = tp.system_type_id
WHERE i.is_hypothetical = 0;

-- If the Database_Tables_with_RowCounts package has been run before this query, uncomment out the sections below to also include current row counts in the results
SELECT 
'Table Storage--Heaps & PrimaryKeys'
,ST1.t_object_id
,ST1.t_name
,ST1.i_index_id
,ST1.i_name
--,CASE IM1.[ic_index_column_id] WHEN 1 THEN TC1.[RECORDCOUNT_CURRENT] ELSE 0 END AS RECCOUNT
,ST1.file_group_name
,ST1.data_file_name
,ST1.data_file_physical_name
,ST1.type_desc
,ST1.object_type
,dm_ius.*
FROM [tempdb].[dbo].[tables_metadata] ST1
LEFT OUTER JOIN sys.dm_db_index_usage_stats dm_ius
on ST1.t_object_id = dm_ius.object_id
AND ST1.i_index_id = dm_ius.index_id
order by 
ST1.file_group_name, 
st1.t_name


--SELECT 
--,o.name AS ObjectName
--,i.name AS IndexName
--,i.index_id AS IndexID
--,dm_ius.user_seeks AS UserSeek
--,dm_ius.user_scans AS UserScans
--,dm_ius.user_lookups AS UserLookups
--,dm_ius.user_updates AS UserUpdates
--,p.TableRows
--FROM sys.dm_db_index_usage_stats dm_ius
--INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = i.OBJECT_ID
--INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
--INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
--INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
--FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
--ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
--WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
--AND dm_ius.database_id = DB_ID()
---- AND i.type_desc = 'nonclustered'
----AND i.is_primary_key = 0
----AND i.is_unique_constraint = 0
--ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC;

GO
/*
SELECT 
ST1.t_name
--,CASE IM1.[ic_index_column_id] WHEN 1 THEN TC1.[RECORDCOUNT_CURRENT] ELSE 0 END AS RECCOUNT
,ST1.file_group_name
,ST1.data_file_name
,ST1.data_file_physical_name
,IM1.[database_name]
,IM1.[t_name]
,IM1.[c_name]
,IM1.[i_index_id]
,IM1.[ic_index_column_id]
,IM1.[ic_column_id]
,IM1.[i_object_id]
,IM1.[i_name]
,IM1.[i_type_desc]
,IM1.[i_is_unique]
,IM1.[i_is_primary_key]-
FROM [tempdb].[dbo].[tables_metadata] ST1
LEFT OUTER JOIN
[tempdb].[dbo].[indexes_metadata] AS IM1
ON ST1.t_OBJECT_ID = IM1.i_object_id
and st1.i_index_id = im1.i_index_id
--LEFT OUTER JOIN 
--	(
--SELECT [DBNAME]
--      ,[SCHEMANAME]
--      ,[TABLENAME]
--      ,[QUERYDATE]
--      ,[RECORDCOUNT_CURRENT]
--      ,[RECORDCOUNT_ESTIMATE]
--  FROM [tempdb].[dbo].[CURRTABLECOUNTS]
--  WHERE DBNAME = DB_NAME() )
--  AS TC1
--ON ST1.t_name = TC1.[TABLENAM
order by 
ST1.file_group_name, 
st1.t_name,[i_index_id],
[ic_index_column_id],
[ic_column_id]
GO

*/