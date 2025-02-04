/* Information on out of date statistics--same query used in the statistics maintenance package for determining which to process */
USE CC_PROD
GO

SELECT  
CAST(DB_ID() AS [INT]) as [database_id]
,CAST([ss].[object_id] AS BIGINT) AS [object_id]
,[sch].[name] AS [schema_name]
,[so].[name] AS [table_name]
,[ss].[stats_id] AS [statistic_id]
,[ss].[name] AS [statistic_name]
,ISNULL([sp].[rows],0) AS [table_rowcount] 
,ISNULL([sp].[rows_sampled],0) AS [rows_sampled]
,[ss].[auto_created] AS [auto_created]
,[ss].[user_created] AS [user_created]
,CAST(ISNULL([sp].[last_updated],DATEADD(YEAR,-1,GETDATE())) AS DATETIME) AS [system_last_updated] 
,CASE WHEN [sp].[last_updated] IS NULL THEN 0 ELSE 1 END AS [statupdate_performedind]
,CASE WHEN [sp].[rows_sampled] IS NULL THEN 0 WHEN [sp].[rows_sampled] = 0 THEN 0 WHEN ISNULL([sp].[rows_sampled],0) >= ISNULL([sp].[rows],0) THEN 3 ELSE 1 END AS [last_scan_type_performed]
,CAST(CASE WHEN [si].[object_id] IS NULL THEN 0 ELSE 1 END AS BIT) AS [index_statistic]
,ISNULL([sp].[modification_counter],0) AS [modification_counter]
,(CAST(CAST(ISNULL([sp].[rows_sampled],0) AS DECIMAL(18,3)) / CAST(ISNULL([sp].[rows],1) AS DECIMAL(18,3)) AS DECIMAL(18,3)) * 100) AS [percentage_rows_sampled_priorupdate]
,(CAST(CAST(ISNULL([sp].[modification_counter],0) AS DECIMAL(18,3)) / CAST(ISNULL([sp].[rows],1) AS DECIMAL(18,3)) AS DECIMAL(18,3)) * 100) AS [percentage_rows_modified]
FROM    [sys].[stats] [ss]
        LEFT OUTER JOIN [sys].[objects] [so] ON [ss].[object_id] = [so].[object_id]
        LEFT OUTER JOIN [sys].[schemas] [sch] ON [so].[schema_id] = [sch].[schema_id]
        OUTER APPLY [sys].[dm_db_stats_properties]([so].[object_id],[ss].[stats_id]) sp
		LEFT OUTER JOIN [sys].[indexes] [si] ON [ss].[object_id] = [si].[object_id] and [ss].[stats_id] = [si].[index_id]
WHERE   [so].[type] = 'U'
AND OBJECT_SCHEMA_NAME([ss].[object_id]) NOT LIKE 'sys'
AND ISNULL([sp].[rows],0) > 0
ORDER BY 
DB_ID()
,[ss].[object_id]
,[ss].[stats_id]