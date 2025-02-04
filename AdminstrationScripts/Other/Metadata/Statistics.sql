use []
go

SELECT
DB_ID() as database_id
,DB_NAME() as Database_name
,OBJECT_SCHEMA_NAME([T1].[object_id]) as [SchemaName]
,OBJECT_NAME([T1].[object_id]) as [SchemaName]
,[T1].name AS [StatisticName]
,[T2].[rows]
,[T1].[auto_created]
,[T1].[user_created]
,CAST([T2].[last_updated] AS DATETIME) AS [last_updated]
,[T2].[rows_sampled]
FROM [sys].[stats] AS T1
LEFT JOIN 
(SELECT IUS.object_id 
,MAX(ISNULL(IUS.last_user_update, IUS.last_system_update)) AS LastUpdate 
FROM sys.dm_db_index_usage_stats AS IUS 
WHERE database_id = DB_ID() 
AND NOT ISNULL(IUS.last_user_update, IUS.last_system_update) IS NULL 
GROUP BY IUS.object_id 
) AS IUS 
ON IUS.object_id = S.object_id 
OUTER APPLY [sys].[dm_db_stats_properties] ([T1].[object_id],[T1].[stats_id]) AS T2
WHERE OBJECT_SCHEMA_NAME([T1].[object_id]) NOT LIKE 'sys'
ORDER BY 
DB_ID()
,object_name(t1.[object_id])
,t1.name
,[T1].[object_id]
;
