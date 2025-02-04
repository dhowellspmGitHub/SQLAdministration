use PC_PROD
go
SELECT 
sch.name
,o.name
, i.name AS [Index Name]
, s.name
, ius.LastUpdate as last_change
, t2.last_updated AS Statistics_Date
--, STATS_DATE(i.[object_id], i.index_id) AS [Statistics Date]
, s.auto_created
, s.no_recompute
, s.user_created
, st.row_count
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.schemas AS SCH 
ON o.schema_id = SCH.schema_id 
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.stats AS s WITH (NOLOCK)
ON i.[object_id] = s.[object_id] 
AND i.index_id = s.stats_id
INNER JOIN sys.dm_db_partition_stats AS st WITH (NOLOCK)
ON o.[object_id] = st.[object_id]
AND i.[index_id] = st.[index_id]
LEFT JOIN 
(SELECT IUS.object_id 
,MAX(ISNULL(IUS.last_user_update, IUS.last_system_update)) AS LastUpdate 
FROM sys.dm_db_index_usage_stats AS IUS 
WHERE database_id = DB_ID() 
AND NOT ISNULL(IUS.last_user_update, IUS.last_system_update) IS NULL 
GROUP BY IUS.object_id 
) AS IUS 
ON IUS.object_id = S.object_id 
OUTER APPLY [sys].[dm_db_stats_properties] ([s].[object_id],[s].[stats_id]) AS T2
WHERE o.[type] = 'U'
and st.row_count > 0
ORDER BY 
STATS_DATE(i.[object_id], i.index_id) ASC OPTION (RECOMPILE);  
