
/*********************************************************************************
Name:		Database_Objects_VW_SEL_Tables_and_Indexes_by_Physical_File

Author:		Danny Howell

Date:		

Description:		In SQL Server 2005 The data for about table is stored as an Index.  If a clustered index (indid = 1) then the data is the index.  if If no clustered index, then a heap index is created (indid = 0) (There will always be one or the other but never both).  The filegroup for the table is the filegroup that index is stored--find the type 0 or 1 index for each table and use the data_space_id to find the filegroup,
Quick summary can be gotten by this query:
create table #Temp (
    name nvarchar(128),
    [rows] char(11),
    reserved varchar(18),
    data varchar(18),
    index_size varchar(18),
    unused varchar(18)
)

insert into #Temp
    exec sp_msforeachtable 'sp_spaceused ''?'''

select * from #Temp order by name,cast(replace(reserved,' kb','') as int) desc

drop table #temp
*********************************************************************************/
--list all files by file group for tables
--indexes--get indexes and columns metadata
use PC_PROD_AppSync
go

IF EXISTS (SELECT name FROM tempdb.sys.tables 
WHERE name LIKE 'table_and_index_storage')
BEGIN
DROP TABLE [tempdb].[dbo].[table_and_index_storage]
END
go


DECLARE @rundate DATETIME
DECLARE @runinit INT
DECLARE @runcondition VARCHAR(128)
SET @rundate = GETDATE()
SELECT @runinit =  1
SET @runcondition = 'Current PROD before applying any changes'

CREATE TABLE tempdb.dbo.table_and_index_storage
(runsequence INT NULL
,rundate DATETIME NOT NULL
,runcondition VARCHAR(128) NOT NULL
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

INSERT INTO [tempdb].[dbo].[table_and_index_storage]
	([runsequence]
	,[rundate]
	,[runcondition]
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
@runinit 
,@rundate
,@runcondition
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
@runinit 
,@rundate
,@runcondition
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


USE [tempdb]
GO

SELECT 
[runsequence]
,[rundate]
,[runcondition]
,[database_name]
,[t_schema_name]
,[t_object_id]
,[t_name]
,[i_name]
,[i_index_id]
,[object_category]
,[create_date]
,[i_object_type]
,[I_object_type_description]
,[i_is_primary_key]
,[t_file_group_name]
FROM [dbo].[table_and_index_storage] 
order by t_name, i_is_primary_key desc, i_index_id asc

