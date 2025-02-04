USE []
GO

/*
Words of precaution:
For SYS.DM_DB_INDEX_USAGE_STATS--per MS documentation, "When an index is used, a row is added to sys.dm_db_index_usage_stats if a row does not already exist for the index. When the row is added, its counters are initially set to zero." This is interpreted that if an index has no matching record in this DMV, then the index has not been used (since the last server restart).  Thus, unused indexes are those for which user seeks,scans,lookups total to 0 or are a NULL match against the DMV.
For DM_DB_INDEX_OPERATIONAL_STATS--per MS documentation, "Therefore, an active heap or index will likely always have its metadata in the cache, and the cumulative counts may reflect activity since the instance of SQL Server was last started. The metadata for a less active heap or index will move in and out of the cache as it is used. As a result, it may or may not have values available.".  This is MAY be interpreted that if an index has no matching record in this DMV, then the index has not been used (since the last server restart).  But because it is also based on cached values, the metrics do not absolutely indicate an used index, just ones that are used more frequently. 
This does indicate the "amount of effort" Thus, unused indexes are those for which user seeks,scans,lookups total to 0 or are a NULL match against the DMV.
An additional concern is the bug highlighted in this blog
https://littlekendra.com/2016/03/07/sql-server-2016-rc0-fixes-index-usage-stats-bug-missing-indexes-still-broken/
indicating that index usage stats are reset upon a rebuild, meaning the metrics provided are only as valid until the next maintenance.

*/

SELECT 
OBJECT_SCHEMA_NAME(I.object_id) AS [OBJECT_SCHEMA_NAME],
I.object_id,
I.index_id,
OBJECT_NAME(I.[OBJECT_ID]) AS [OBJECT NAME], 
I.[NAME] AS [INDEX NAME], 
ISNULL(S.USER_SEEKS,0) + ISNULL(S.USER_SCANS,0) + ISNULL(S.USER_LOOKUPS,0) AS IndexUsage,
ISNULL(S.USER_SEEKS,0) AS USER_SEEKS, 
ISNULL(S.USER_SCANS,0) AS USER_SCANS, 
ISNULL(S.USER_LOOKUPS,0) AS USER_LOOKUPS,
ISNULL(S.USER_UPDATES,0) AS USER_UPDATES,
ISNULL(A.LEAF_INSERT_COUNT,0) AS LEAF_INSERT_COUNT, 
ISNULL(A.LEAF_UPDATE_COUNT,0) AS LEAF_UPDATE_COUNT,
ISNULL(A.LEAF_DELETE_COUNT,0) AS LEAF_DELETE_COUNT
FROM   SYS.INDEXES AS I
LEFT OUTER JOIN SYS.DM_DB_INDEX_USAGE_STATS AS S 
ON I.[OBJECT_ID] = S.[OBJECT_ID] 
AND I.INDEX_ID = S.INDEX_ID 
and db_id() = S.database_id
LEFT OUTER JOIN SYS.DM_DB_INDEX_OPERATIONAL_STATS (db_id(),NULL,NULL,NULL ) A 
ON I.[OBJECT_ID] = A.[OBJECT_ID] 
AND I.INDEX_ID = A.INDEX_ID 
AND DB_ID() = A.database_id
WHERE  
OBJECT_SCHEMA_NAME(I.object_id) NOT LIKE 'sys'
and i.index_id > 0
and (ISNULL(S.USER_SEEKS,0) + ISNULL(S.USER_SCANS,0) + ISNULL(S.USER_LOOKUPS,0)) = 0
and ISNULL(S.USER_UPDATES,0) > 0
ORDER BY
OBJECT_SCHEMA_NAME(I.object_id),
OBJECT_NAME(I.object_id),
I.index_id
