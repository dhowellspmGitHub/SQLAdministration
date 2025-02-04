/* Index fragmentation--same evaluation run in the defragmentation package determining the most fragmented indexes */
USE CC_PROD
GO

SELECT 
database_id
,[object_id]
,object_name(object_id)
,index_id
,MAX(avg_fragmentation_in_percent) AS avg_fragmentation_in_percent
,MAX(page_count) AS page_count 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') WHERE alloc_unit_type_desc = 'IN_ROW_DATA'
AND avg_fragmentation_in_percent > 0
GROUP BY 
database_id, 
[object_id],
index_id
ORDER BY 
MAX(avg_fragmentation_in_percent) DESC
,object_id, index_id
