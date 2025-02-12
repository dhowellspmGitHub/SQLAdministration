USE [OBProd]
GO
declare @pDatabaseName NVARCHAR(128)
set @pDatabaseName = 'obprod'

/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_MostRecentDetail_ForDatabase]    Script Date: 8/13/2018 9:12:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
declare @pShowTablesWith0Rows BIT
set @pShowTablesWith0Rows = 0

/*
Author: Danny Howell
Description: Procedure provides detailed Statistics Update (S/U) maintenance job history for tables in the selected databases. 
Report data used to view type of S/U performed for each statistic and table processed by the most recent maintenance job.
The default option excludes tables and statistic for which no maintenance was performed.  
The @pShowStatsNoMaint parameter sets the option to include tables not processed. 
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

DECLARE @ShowTables0Rows BIT = 0
IF @pShowTablesWith0Rows = 1
BEGIN
	SET @ShowTables0Rows = -1
END
			

SELECT 
DB_ID() as database_id
, CAST([T1].[object_id] AS bigint) as [object_id]
,[T1].[stats_id] AS [statistic_id]
,OBJECT_SCHEMA_NAME([T1].[object_id]) AS [schema_name]
,object_name([T1].[object_id]) AS [table_name]
,[T1].[name] AS [statistic_name]
,ISNULL([T2].[rows],0) AS [current_table_rows]
,[T1].[auto_created]
,[T1].[user_created]
,CAST([T2].[last_updated] AS DATETIME) AS [last_updated]
,ISNULL([T2].[rows_sampled],0) as [rows_sampled]
,[IDD4].[statssummary_job_id]
,[IDD4].[statsupdate_completed_ind]
,[IDD4].[statsupdate_performed_ind]
,[IDD4].[statsupdate_failed_ind]
,[IDD4].[statsupdate_task_starttime]
,[IDD4].[statsupdate_task_endtime]
,[IDD4].[maintenance_duration_ms]
,[IDD4].[table_row_count] as [table_rows_at_maintenancetime]
,[IDD4].[statistic_specific_comments]
FROM [sys].[stats] AS T1
OUTER APPLY [sys].[dm_db_stats_properties] ([T1].[object_id],[T1].[stats_id]) AS T2
LEFT OUTER JOIN
	(
	SELECT 
	[IDD1].[statssummary_job_id]
	,[IDD1].[database_id]
	,[IDD1].[table_id]
	,[IDD1].[statistic_id]
	,[IDD1].[table_row_count]
	,[IDD1].[statsupdate_completed_ind]
	,[IDD1].[statsupdate_performed_ind]
	,CASE WHEN [IDD1].[statsupdate_task_endtime] IS NULL THEN CAST(1 AS BIT) ELSE [IDD1].[statsupdate_failed_ind] END AS [statsupdate_failed_ind]
	,[IDD1].[statsupdate_fromindexdefrag]
	,CASE WHEN [IDD1].[statsupdate_scan_type_performed] = 0 THEN 0 WHEN [table_row_count] = [rows_sampled] THEN 3 ELSE 1 END AS SCANTYPE
	,datediff(MILLISECOND,[IDD1].[statsupdate_task_starttime],ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])) as maintenance_duration_ms
	,[IDD1].[statsupdate_task_starttime]
	,ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime]) AS [statsupdate_task_endtime]
	,[IDD1].[statistic_specific_comments]
	FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Detail] AS IDD1
	INNER JOIN 
		(SELECT
		MAX([statssummary_job_id]) AS MRSSID
		,[database_id]
		,[table_id]
		,[statistic_id]
		FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Detail]
		GROUP BY 
		[database_id]
		,[table_id]
		,[statistic_id]
		) AS IDD2
	ON [IDD1].[statssummary_job_id] = [IDD2].[MRSSID]
	AND	[IDD1].[database_id] = [IDD2].[database_id]
	AND [IDD1].[table_id] = [IDD2].[table_id]
	AND [IDD1].[statistic_id] = [IDD2].[statistic_id]
	WHERE [IDD1].[database_id] = DB_ID()
	) AS IDD4
ON [T2].[object_id] = [IDD4].[table_id]
AND [T2].[stats_id] = [IDD4].[statistic_id]
WHERE OBJECT_SCHEMA_NAME([T1].[object_id]) NOT LIKE 'sys'
AND ISNULL([T2].[rows],0) > @ShowTables0Rows 
ORDER BY 
CAST([T2].[last_updated] AS DATETIME) asc
,object_name([T1].[object_id])
,[T1].[name]

