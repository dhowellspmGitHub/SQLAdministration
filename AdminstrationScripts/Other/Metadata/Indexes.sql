use [eBusiness_PmtInt_DEV]
go
/* 
Useful Links: 
https://www.red-gate.com/simple-talk/blogs/a-quick-look-at-dm_db_index_usage_stats/ -- see explanation of seeks, lookups, scans and updates --helpful to determine when indexes are used and if causing more of a bottleneck (example: updates > seeks indicates updates are higher than the other operations then this should be a warning sign that the index is taking up valuable resources during updates but providing very little use to data extraction requests

https://www.mssqltips.com/sqlservertip/1545/deeper-insight-into-used-and-unused-indexes-for-sql-server/ -- seemingly more useful queries (
*/
DECLARE @DiagName NVARCHAR(300)
SET @DiagName = 'Index Metadata'

SELECT 
@DiagName,
t.name AS [TableName],
ind.name AS [IndexName],
ind.index_id AS [IndexId],
--ic.index_column_id AS [ColumnId],
--col.name AS [ColumnName],
ind.[type] as IndexType,
ind.[type_desc] as IndexTypeDescription,
ind.fill_factor AS [FillFactor],
ind.is_unique as [IsUnique],
ind.is_primary_key as [IsPrimaryKey],
ind.is_unique_constraint as [IsUniqueConstraint],
ind.is_padded as [IsPadded]
--ic.is_descending_key as [IsDescendingKey],
--ic.is_included_column as [IsIncludedColumn]
--col.* 
FROM sys.indexes AS ind 
--LEFT OUTER JOIN sys.index_columns AS ic 
--ON  ind.object_id = ic.object_id 
--and ind.index_id = ic.index_id 
--LEFT OUTER JOIN sys.columns col 
--ON ic.object_id = col.object_id 
--and ic.column_id = col.column_id 
LEFT OUTER JOIN sys.tables t 
ON ind.object_id = t.object_id 
WHERE 
ind.is_primary_key = 0 
--     AND ind.is_unique = 0 
--     AND ind.is_unique_constraint = 0 
--AND 
and	 t.is_ms_shipped = 0 
ORDER BY 
t.name, ind.index_id, ind.name
--, ic.index_column_id 


--SET @DiagName = 'Current Index Fragmentation'
--SELECT        
--@DiagName
--,[T1].database_id 
--,[T1].[object_id]
--,[T2].[name] as Table_name
--,[T1].index_id
--,[T3].[name] as Index_name
--,([T1].avg_fragmentation_in_percent) AS avg_fragmentation_in_percent
--,([T1].page_count) AS page_count 
--,[T1].index_type_desc
--,[T1].record_count
--,[T1].[index_level]
--,[T1].[index_depth]
--FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, null) AS T1
--LEFT OUTER JOIN [sys].[tables] as T2
--ON T1.object_id = t2.object_id
--LEFT OUTER JOIN [sys].[indexes] AS t3
--ON [T1].[object_id] = [T3].[object_id]
--AND [T1].[index_id] = [T3].[index_id]
----WHERE alloc_unit_type_desc = 'IN_ROW_DATA'
--ORDER BY object_id, index_id;

SET @DiagName = 'Index Usage-Simple'
SELECT 
@DiagName
,o.name AS ObjectName
,i.name AS IndexName
,i.index_id AS IndexID
,dm_ius.user_seeks AS UserSeek
,dm_ius.user_scans AS UserScans
,dm_ius.user_lookups AS UserLookups
,dm_ius.user_updates AS UserUpdates
,p.TableRows
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
-- AND i.type_desc = 'nonclustered'
--AND i.is_primary_key = 0
--AND i.is_unique_constraint = 0
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC;


SET @DiagName = 'Indexes-Used and Unused (does not include Heaps or PKs)'
/* Unused indexes do not have a record in sys.dm_index_usage_stats so a union with a table where a record does not exist is required */
SELECT 
@DiagName,
PVT.SCHEMANAME, PVT.TABLENAME, PVT.INDEXNAME, PVT.INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, [4] AS COL4,  [5] AS COL5, [6] AS COL6, [7] AS COL7, B.USER_SEEKS, B.USER_SCANS, B.USER_LOOKUPS,B.user_updates,b.last_user_update, B.last_user_lookup,b.last_user_seek,b.last_user_scan
FROM   (SELECT SCHEMA_NAME(A.SCHEMA_id) AS SCHEMANAME,
               A.NAME AS TABLENAME, 
               A.OBJECT_ID, 
               B.NAME AS INDEXNAME, 
               B.INDEX_ID, 
               D.NAME AS COLUMNNAME, 
               C.KEY_ORDINAL 
        FROM   SYS.OBJECTS A 
               INNER JOIN SYS.INDEXES B ON A.OBJECT_ID = B.OBJECT_ID 
               INNER JOIN SYS.INDEX_COLUMNS C ON B.OBJECT_ID = C.OBJECT_ID AND B.INDEX_ID = C.INDEX_ID 
               INNER JOIN SYS.COLUMNS D ON C.OBJECT_ID = D.OBJECT_ID AND C.COLUMN_ID = D.COLUMN_ID 
        WHERE  A.TYPE = 'U') P 
       PIVOT 
       (MIN(COLUMNNAME) 
        FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
INNER JOIN SYS.DM_DB_INDEX_USAGE_STATS B ON PVT.OBJECT_ID = B.OBJECT_ID AND PVT.INDEX_ID = B.INDEX_ID AND B.DATABASE_ID = DB_ID() 
UNION  
SELECT 
@DiagName,
SCHEMANAME, TABLENAME, INDEXNAME, INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, [4] AS COL4, [5] AS COL5, [6] AS COL6, [7] AS COL7, 0, 0, 0,0
,cast('01/01/1900' as datetime) as last_user_update
,cast('01/01/1900' as datetime) as last_user_lookup
,cast('01/01/1900' as datetime) as last_user_seek
,cast('01/01/1900' as datetime) as last_user_scan
FROM   (SELECT SCHEMA_NAME(A.SCHEMA_id) AS SCHEMANAME,
               A.NAME AS TABLENAME, 
               A.OBJECT_ID, 
               B.NAME AS INDEXNAME, 
               B.INDEX_ID, 
               D.NAME AS COLUMNNAME, 
               C.KEY_ORDINAL 
        FROM   SYS.OBJECTS A 
               INNER JOIN SYS.INDEXES B ON A.OBJECT_ID = B.OBJECT_ID 
			   INNER JOIN SYS.INDEX_COLUMNS C ON B.OBJECT_ID = C.OBJECT_ID AND B.INDEX_ID = C.INDEX_ID 
               INNER JOIN SYS.COLUMNS D ON C.OBJECT_ID = D.OBJECT_ID AND C.COLUMN_ID = D.COLUMN_ID 
        WHERE  A.TYPE = 'U') P 
       PIVOT 
       (MIN(COLUMNNAME) 
        FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
WHERE  NOT EXISTS (SELECT OBJECT_ID, 
                          INDEX_ID 
                   FROM   SYS.DM_DB_INDEX_USAGE_STATS B 
                   WHERE  DATABASE_ID = DB_ID(DB_NAME()) 
                          AND PVT.OBJECT_ID = B.OBJECT_ID 
                          AND PVT.INDEX_ID = B.INDEX_ID) 
ORDER BY TABLENAME, INDEX_ID; 
/*
Missing Indexes

Query source: http://basitaalishan.com/2013/03/13/find-missing-indexes-using-sql-servers-index-related-dmvs/
The important column is the derived column [IndexAdvantage] which is the basis for ranking the benefit if the missing indexes was added.
The formula is defined by the author.  However, other formulas similar to this have been observed.
All formulas use some combination of the following columns in deriving a method of determining which indexes would have the greatest benefit to query optimization.
(full defnition in BOL https://msdn.microsoft.com/en-us/library/ms345421.aspx) 
--user_seeks = Number of seeks caused by user queries that the recommended index in the group could have been used for.
--user_scans = Number of scans caused by user queries that the recommended index in the group could have been used for.
 --avg_total_user_cost = Average cost of the user queries that could be reduced by the index in the group.
--avg_user_impact = Average percentage benefit that user queries could experience if this missing index group was implemented. The value means that the query cost would on average drop by this percentage if this missing index group was implemented.

--system_seeks = Number of seeks caused by system queries, such as auto stats queries, that the recommended index in the group could have been used for.
--system_scans = Number of scans caused by system queries that the recommended index in the group could have been used for.
--avg_total_system_cost = Average cost of the system queries that could be reduced by the index in the group.
--avg_system_impact = Average percentage benefit that system queries could experience if this missing index group was implemented. The value means that the query cost would on average drop by this percentage if this missing index group was implemented.

With more equations utilizing the 'user' statistics than 'system' statistics
The "Index Advantage" is a relative measure--Since these equations vary, there is no 'absolute' value that above which an index should be created or below which an index should not.
 
DO NOT AUTOMATICALLY USE THE PROPOSED INDEX AS IT IS GENERATED.  WHY?
1) The missing indexes focuses on individual queries and does not incorporate 'recommendations' from others.  Many of the recommended indexes may be duplicates varying on INCLUDED columns.  It is very likely that the 'base' index (without included columns) are repeated multiple times
2) Variations in columns composing the index may vary in order of the columns.  While composite indexes could have additional benefits, composite indexes beyond 3 columns may be excessive
3) Standard concerns of over indexing and its impact on INSERT, UPDATE and DELETE performance
4) TSQL statements generated from the missing indexes must be reviewed for naming convention.

*/
SET @DiagName = 'Missing Indexes' 
SELECT 
	@DiagName as DiagnosticArea
	,CAST(SERVERPROPERTY('ServerName') AS [nvarchar](256)) AS [SQLServer]
	,db.[database_id] AS [DatabaseID]
	,db_name(id.[database_id]) AS [DatabaseName]
	,id.[object_id] AS [ObjectID]
	,CAST((gs.[user_seeks] * gs.[avg_total_user_cost] * (gs.[avg_user_impact] * 0.01)) AS numeric(15,4)) [IndexAdvantage]
	,CAST(gs.[avg_total_user_cost] AS numeric(15,4)) AS [AvgTotalUserCost]
	,CAST(gs.[avg_user_impact] AS numeric(15,4)) AS [AvgUserImpact]
	,CAST(gs.[avg_total_system_cost] AS numeric(15,4)) AS [AvgTotalSystemCost]
	,CAST(gs.[avg_system_impact] AS numeric(15,4)) AS [AvgSystemImpact]
	,RANK () OVER (PARTITION BY db.[database_id],id.[object_id],id.[statement] ORDER BY ((gs.[user_seeks] * gs.[avg_total_user_cost] * (gs.[avg_user_impact] * 0.01))) DESC) AS TableImpact
	,id.[statement] AS [FullyQualifiedObjectName]
	,id.[equality_columns] AS [EqualityColumns]
	,id.[inequality_columns] AS [InEqualityColumns]
	,id.[included_columns] AS [IncludedColumns]
	,gs.[unique_compiles] AS [UniqueCompiles]
	,gs.[user_seeks] AS [UserSeeks]
	,gs.[user_scans] AS [UserScans]
	,gs.[last_user_seek] AS [LastUserSeekTime]
	,gs.[last_user_scan] AS [LastUserScanTime]
	,gs.[system_seeks] AS [SystemSeeks]
	,gs.[system_scans] AS [SystemScans]
	,gs.[last_system_seek] AS [LastSystemSeekTime]
	,gs.[last_system_scan] AS [LastSystemScanTime]
	,'CREATE INDEX [Missing_IXNC_' + OBJECT_NAME(id.[object_id], db.[database_id]) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(id.[equality_columns], ''), ', ', '_'), '[', ''), ']', '') + 
	CASE
		WHEN id.[equality_columns] IS NOT NULL
			AND id.[inequality_columns] IS NOT NULL
			THEN '_'
		ELSE ''
		END + REPLACE(REPLACE(REPLACE(ISNULL(id.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '') + '_' + LEFT(CAST(NEWID() AS [nvarchar](64)), 5) + ']' + ' ON ' + id.[statement] + ' (' + ISNULL(id.[equality_columns], '') + CASE 
		WHEN id.[equality_columns] IS NOT NULL
			AND id.[inequality_columns] IS NOT NULL
			THEN ','
		ELSE ''
		END + ISNULL(id.[inequality_columns], '') + ')' + ISNULL(' INCLUDE (' + id.[included_columns] + ')', '') AS [ProposedIndex]
	,CAST(CURRENT_TIMESTAMP AS [smalldatetime]) AS [CollectionDate]
FROM [sys].[dm_db_missing_index_group_stats] gs WITH (NOLOCK)
INNER JOIN [sys].[dm_db_missing_index_groups] ig WITH (NOLOCK)
	ON gs.[group_handle] = ig.[index_group_handle]
INNER JOIN [sys].[dm_db_missing_index_details] id WITH (NOLOCK)
	ON ig.[index_handle] = id.[index_handle]
INNER JOIN [sys].[databases] db WITH (NOLOCK)
	ON db.[database_id] = id.[database_id]
WHERE id.[database_id] > 4 -- Remove this to see for entire instance
ORDER BY [DatabaseName], [IndexAdvantage] DESC ,[FullyQualifiedObjectName]
OPTION (RECOMPILE);

SET @DiagName = 'Missing Indexes-Ranked/Rated by Impact' 
SELECT 
@DiagName as DiagnosticArea
--gs.[user_seeks] * gs.[avg_total_user_cost] * (gs.[avg_user_impact] * 0.01) AS [IndexAdvantage]
  ,migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS improvement_measure, 
  'CREATE INDEX [missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle) 
  + '_' + LEFT (PARSENAME(mid.statement, 1), 32) + ']'
  + ' ON ' + mid.statement 
  + ' (' + ISNULL (mid.equality_columns,'') 
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END 
    + ISNULL (mid.inequality_columns, '')
  + ')' 
  + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement, 
  migs.*, mid.database_id, mid.[object_id]
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC


;
WITH XMLNAMESPACES
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
 
SELECT query_plan,
       n.value('(@StatementText)[1]', 'VARCHAR(4000)') AS sql_text,
       n.value('(//MissingIndexGroup/@Impact)[1]', 'FLOAT') AS impact,
       DB_ID(REPLACE(REPLACE(n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)'),'[',''),']','')) AS database_id,
       OBJECT_ID(n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)') + '.' +
           n.value('(//MissingIndex/@Schema)[1]', 'VARCHAR(128)') + '.' +
           n.value('(//MissingIndex/@Table)[1]', 'VARCHAR(128)')) AS OBJECT_ID,
       n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)') + '.' +
           n.value('(//MissingIndex/@Schema)[1]', 'VARCHAR(128)') + '.' +
           n.value('(//MissingIndex/@Table)[1]', 'VARCHAR(128)')
       AS statement,
       (   SELECT DISTINCT c.value('(@Name)[1]', 'VARCHAR(128)') + ', '
           FROM n.nodes('//ColumnGroup') AS t(cg)
           CROSS APPLY cg.nodes('Column') AS r(c)
           WHERE cg.value('(@Usage)[1]', 'VARCHAR(128)') = 'EQUALITY'
           FOR  XML PATH('')
       ) AS equality_columns,
        (  SELECT DISTINCT c.value('(@Name)[1]', 'VARCHAR(128)') + ', '
           FROM n.nodes('//ColumnGroup') AS t(cg)
           CROSS APPLY cg.nodes('Column') AS r(c)
           WHERE cg.value('(@Usage)[1]', 'VARCHAR(128)') = 'INEQUALITY'
           FOR  XML PATH('')
       ) AS inequality_columns,
       (   SELECT DISTINCT c.value('(@Name)[1]', 'VARCHAR(128)') + ', '
           FROM n.nodes('//ColumnGroup') AS t(cg)
           CROSS APPLY cg.nodes('Column') AS r(c)
           WHERE cg.value('(@Usage)[1]', 'VARCHAR(128)') = 'INCLUDE'
           FOR  XML PATH('')
       ) AS include_columns
INTO #MissingIndexInfo
FROM
(
   SELECT query_plan
   FROM (
           SELECT DISTINCT plan_handle
           FROM sys.dm_exec_query_stats WITH(NOLOCK)
         ) AS qs
       OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) tp
   WHERE tp.query_plan.exist('//MissingIndex')=1
) AS tab (query_plan)
CROSS APPLY query_plan.nodes('//StmtSimple') AS q(n)
WHERE n.exist('QueryPlan/MissingIndexes') = 1;
 
-- Trim trailing comma from lists
UPDATE #MissingIndexInfo
SET equality_columns = LEFT(equality_columns,LEN(equality_columns)-1),
   inequality_columns = LEFT(inequality_columns,LEN(inequality_columns)-1),
   include_columns = LEFT(include_columns,LEN(include_columns)-1);
 
SELECT *
FROM #MissingIndexInfo;
 
DROP TABLE #MissingIndexInfo;


-- Get all SQL Statements with missing indexes and their cached query plans
;WITH 
 XMLNAMESPACES
     (DEFAULT N'http://schemas.microsoft.com/sqlserver/2004/07/showplan'  
             ,N'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS ShowPlan)      
SELECT ECP.[usecounts]    AS [UsageCounts]
      ,ECP.[refcounts]    AS [RefencedCounts]
      ,ECP.[objtype]      AS [ObjectType]
      ,ECP.[cacheobjtype] AS [CacheObjectType]
      ,EST.[dbid]         AS [DatabaseID]
      ,EST.[objectid]     AS [ObjectID]
      ,EST.[text]         AS [Statement]      
      ,EQP.[query_plan]   AS [QueryPlan]
FROM sys.dm_exec_cached_plans AS ECP
     CROSS APPLY sys.dm_exec_sql_text(ECP.[plan_handle]) AS EST
     CROSS APPLY sys.dm_exec_query_plan(ECP.[plan_handle]) AS EQP
WHERE ECP.[usecounts] > 1  -- Plan should be used more then one time (= no AdHoc queries)
      AND EQP.[query_plan].exist(N'/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/QueryPlan/MissingIndexes/MissingIndexGroup') <> 0
ORDER BY ECP.[usecounts] DESC
