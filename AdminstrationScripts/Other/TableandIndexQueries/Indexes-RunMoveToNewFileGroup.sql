USE [PC_MODEL2]
GO

IF EXISTS (SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'table_and_index_storage')
BEGIN
DROP TABLE [tempdb].[dbo].[table_and_index_storage]
END
go

DECLARE @DBName sysname
DECLARE @SchemaName sysname
DECLARE @ObjectNameList varchar(max)
DECLARE @IndexName sysname
declare @CurrentFileGroupName nvarchar(100)
DECLARE @TSQL NVARCHAR(4000)

CREATE TABLE tempdb.dbo.table_and_index_storage
(rundate DATETIME NOT NULL
,database_name VARCHAR(128) NOT NULL
,t_schema_id INT NULL
,t_schema_name NVARCHAR(128) NOT NULL
,t_object_id INT NOT NULL
,t_name VARCHAR(128) NOT NULL
,object_category VARCHAR(128) NOT NULL
,create_date datetime NULL
,i_index_id INT NOT NULL
,i_object_type INT NOT NULL
,I_object_type_description VARCHAR(128) NOT NULL
,i_name VARCHAR(128) NOT NULL
,i_is_unique BIT NOT NULL
,i_is_primary_key BIT NOT NULL
,t_data_space_id INT NOT NULL
,t_file_group_name NVARCHAR(60) NOT NULL
)

DECLARE @rundate DATETIME
DECLARE @runinit INT
SET @rundate = GETDATE()
SELECT @runinit =  1

INSERT INTO [tempdb].[dbo].[table_and_index_storage]
	([rundate]
	,[database_name]
	,[t_schema_id]
	,[t_schema_name]
	,[t_object_id]
	,[t_name]
	,[object_category]
	,[create_date]
	,[i_index_id]
	,[i_object_type]
	,[I_object_type_description]
	,[i_name]
	,[i_is_unique]
	,[i_is_primary_key]
	,[t_data_space_id]
	,[t_file_group_name])
SELECT 
@rundate
,DB_name()
,o.schema_id
,SCHEMA_NAME(o.schema_id)
,o.object_id 
,o.[name] 
,o.type_desc
,o.create_date
,i.index_id
,i.[type]
,i.[type_desc]
,ISNULL(i.name,'NONE') AS indexname
,i.is_unique
,i.is_primary_key
,i.data_space_id
,ds.[name]
FROM 
sys.objects o
LEFT OUTER JOIN sys.indexes i ON 
o.[object_id] = i.[object_id] 
INNER JOIN sys.data_spaces as ds
ON i.data_space_id = ds.data_space_id
WHERE 
i.index_id in (0, 1) and
o.type LIKE 'u' 
UNION
SELECT 
@rundate
,DB_NAME()
,t.schema_id
,SCHEMA_NAME(t.schema_id)
,i.object_id
,OBJECT_NAME(i.object_id)
,'INDEX'
,NULL
,i.index_id
,i.[type]
,i.type_desc
,ISNULL(i.name ,'HEAP')
,i.is_unique
,i.is_primary_key
,i.data_space_id
,fg1.name
FROM sys.indexes i 
INNER JOIN sys.tables t 
ON t.object_id = i.object_id 
LEFT OUTER JOIN sys.filegroups as fg1
ON i.data_space_id = fg1.data_space_id
WHERE i.is_hypothetical = 0
AND i.index_id NOT IN (0,1)

select * from tempdb.dbo.table_and_index_storage
order by t_name, object_category

/*
DECLARE IndexCursor CURSOR
FOR
-- If the Database_Tables_with_RowCounts package has been run before this query, uncomment out the sections below to also include current row counts in the results
SELECT 
[database_name]
,[t_schema_name]
,[t_name]
,[i_name]
,[t_file_group_name]
FROM [tempdb].[dbo].[table_and_index_storage]
WHERE i_object_type = 2
AND [object_category] LIKE 'INDEX'
--AND [t_file_group_name] NOT LIKE @TargetFileGroupName
AND [I_object_type_description] LIKE 'NONCLUSTERED'
order by t_name, i_is_primary_key desc, i_index_id asc

OPEN IndexCursor
FETCH NEXT FROM IndexCursor
INTO @DBName, @SchemaName, @ObjectNameList, @IndexName, @CurrentFileGroupName

WHILE @@FETCH_STATUS = 0
BEGIN
--SET @TSQL = ''
select @TSQL = 'DROP INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@DBName) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectNameList)  
print @tsql
exec sp_executesql @tsql

FETCH NEXT FROM IndexCursor
INTO @DBName, @SchemaName, @ObjectNameList, @IndexName, @CurrentFileGroupName

END
CLOSE IndexCursor
DEALLOCATE IndexCursor
*/
GO

