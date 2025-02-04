/*********************************************************************************
name:		Database_TablesAndViews_Metadata

Author:		Danny Howell

DATE:		

Description:  Custom VIEW OF TABLE metadata

*********************************************************************************/

use [PC_appgenerated]
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
WHERE name LIKE 'database_user_objects_metadata' AND type = 'u' )
BEGIN
CREATE TABLE tempdb.dbo.tables_metadata 
(rundate DATETIME NOT NULL
,runsequence INT NOT NULL
,rownum INT NOT NULL
,database_name VARCHAR(128) NOT NULL
,s_name VARCHAR(128) NOT NULL
,t_name VARCHAR(128) NOT NULL
,t_object_id INT NOT NULL
,t_type_desc NVARCHAR(60) NOT NULL
,c_column_id INT NOT NULL
,c_name VARCHAR(128) NOT NULL
,c_is_nullable BIT NOT NULL
,c_system_type_id INT NOT NULL
,tp_name VARCHAR(128)  NULL
,tp_length VARCHAR(4) NULL
,tp_precision VARCHAR(4) NULL
,tp_scale VARCHAR(4) NULL
,tp_fulltype VARCHAR(25) NULL
,tp_is_variable_length BIT NULL
,tp_is_max_length_col BIT NULL
,c_max_length_bytes INT NULL
,c_is_identity BIT NOT NULL
,ic_name VARCHAR(128) NULL
,ic_seed_value VARCHAR(128) NULL
,ic_increment_value VARCHAR(128) NULL
,ic_last_value VARCHAR(128) NULL)
END
ELSE
BEGIN
TRUNCATE TABLE tempdb.dbo.tables_metadata 
END


INSERT INTO [tempdb].[dbo].[tables_metadata]
([rundate]
,[runsequence]
,[rownum]
,[database_name]
,[s_name]
,[t_name]
,[t_object_id]
,[t_type_desc]
,[c_column_id]
,[c_name]
,[c_is_nullable]
,[c_system_type_id]
,[tp_name]
,[tp_length]
,[tp_precision]
,[tp_scale]
,[tp_fulltype]
,[tp_is_variable_length]
,[tp_is_max_length_col]
,[c_max_length_bytes]
,[c_is_identity]
,ic_name 
,ic_seed_value
,ic_increment_value 
,ic_last_value )
SELECT 
@rundate
,@runinit
,ROW_NUMBER() OVER (ORDER BY t.name,c.column_id )
,DB_NAME()
,s.name
,t.name
,t.object_id
,t.type_desc
,c.column_id
,c.name
,CASE c.is_nullable
	WHEN 0 THEN 'false'
	ELSE 'true' END
,c.system_type_id
,tp.name

,CASE tp.name
	WHEN 'nchar' THEN
			CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
	WHEN 'char' THEN 
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
	WHEN 'nvarchar' THEN 
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST((c.max_length/2) AS NVARCHAR(5)) END
	WHEN 'varchar' THEN
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
	ELSE '' END 
,CASE tp.name
	WHEN 'nchar' THEN ''
	WHEN 'char' THEN ''
	WHEN 'nvarchar' THEN ''
	WHEN 'varchar' THEN ''
	WHEN 'int' then ''
	WHEN 'date' THEN ''
	WHEN 'time' THEN ''
	WHEN 'datetime' THEN ''
	WHEN 'datetime2' THEN ''
	ELSE cast(c.precision as varchar(4)) END 
,CASE tp.name
	WHEN 'nchar' THEN ''
	WHEN 'char' THEN ''
	WHEN 'nvarchar' THEN ''
	WHEN 'varchar' THEN ''
	WHEN 'int' then ''
	WHEN 'time' THEN ''
	WHEN 'date' THEN ''
	WHEN 'datetime' THEN ''
	WHEN 'datetime2' THEN ''
	ELSE cast(c.scale as varchar(4)) END 

,CASE tp.name
	WHEN 'int' THEN tp.name
	WHEN 'nchar' THEN tp.name +'(' +  
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
		+ ')'
	WHEN 'char' THEN tp.name +'(' +  
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
		+ ')'
	WHEN 'nvarchar' THEN tp.name +'(' +  
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST((c.max_length/2) AS NVARCHAR(5)) END
		+ ')'
	WHEN 'varchar' THEN tp.name +'(' +  
		CASE c.max_length
		WHEN -1 THEN 'max'
		ELSE CAST(c.max_length AS NVARCHAR(5)) END
		+ ')'
	WHEN 'decimal' THEN tp.name +'(' +  CAST(c.precision AS NVARCHAR(5)) + ',' + CAST(c.scale AS NVARCHAR(5)) +')'
	ELSE tp.name END 
,CASE tp.name
	WHEN 'varchar' THEN 1
	WHEN 'nvarchar' THEN 1
	WHEN 'varbinary' THEN 1
	ELSE 0 END 
,CASE c.max_length
	WHEN -1 THEN 1
	ELSE 0 END 
,CASE c.max_length 
	WHEN -1 THEN 8000
	ELSE c.max_length END
,CASE c.is_identity
	WHEN 0 THEN 'false'
	ELSE 'true' END 
,ISNULL(ic.name,'') 
,ISNULL(CONVERT(VARCHAR(128),ic.seed_value),'') 
,ISNULL(CONVERT(VARCHAR(128),ic.increment_value),'')
,ISNULL(CONVERT(VARCHAR(128),ic.last_value),'') 
FROM sys.columns c
INNER JOIN sys.OBJECTS t ON
t.object_id = c.object_id
INNER JOIN sys.schemas s ON 
t.schema_id = s.schema_id
LEFT OUTER JOIN sys.identity_columns ic ON
ic.object_id = t.object_id
AND ic.column_id = c.column_id
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
WHERE tp.name NOT LIKE 'sysname'
AND t.type in ('U','V')
ORDER BY t.name, c.column_id


SELECT 
[database_name]
,[s_name] as [Schema Name]
,[t_name] as [Table Name]
,[t_object_id] as [Object_id]
,[c_column_id] as [Column ID]
,[c_name] as [Column Name]
,upper([tp_name]) as [Data Type Name]
,[tp_length] as [Data Length]
,[tp_precision] as [Precision]
,[tp_scale] as [Scale]
,case [c_is_nullable] when 1 then 'Y' ELSE 'N' end AS [Nullable (T/F)]
,upper([tp_fulltype]) as [Full Data Type]
,[t_type_desc] as [Object Type]
--,[tp_is_variable_length]
--,[tp_is_max_length_col]
--,[c_max_length_bytes]
--,[c_is_identity]
--,ic_name 
--,ic_seed_value
--,ic_increment_value 
--,ic_last_value
 FROM [tempdb].[dbo].[tables_metadata] 
ORDER BY [t_name], 
[c_name]
--[t_type_desc],[tp_name]
