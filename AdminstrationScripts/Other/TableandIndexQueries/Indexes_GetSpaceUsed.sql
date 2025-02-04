use [obprod]
go
declare @tablename NVARCHAR(128)
SET @tablename = ''
-- Ensure a USE <databasename> statement has been executed first.
SELECT 
object_name(i.object_id),
i.[name] AS IndexName
    ,(SUM(s.[used_page_count]) * 8)/1024 AS IndexSizeMB
FROM sys.dm_db_partition_stats AS s
INNER JOIN sys.indexes AS i ON s.[object_id] = i.[object_id]
    AND s.[index_id] = i.[index_id]
--WHERE object_name(i.object_id) = @tablename
GROUP BY i.[name], object_name(i.object_id)
ORDER BY (SUM(s.[used_page_count]) * 8) desc, i.[name]
GO
 