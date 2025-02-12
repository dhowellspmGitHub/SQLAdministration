/****** Script for SelectTopNRows command from SSMS  ******/
USE [KFBSQLMgmt]
GO

--Package error checking--are there any stats details records duplicated--there was an issue where the job was processing each stat multiple times
/*
with statsum ([statssummary_job_id],[database_id],[schema_name],[table_id],[table_name],[statistic_id],[statistic_name],[dupl_stat_count])
AS
(
SELECT 
[statssummary_job_id]
,[database_id]
,[schema_name]
,[table_id]
,[table_name]
,[statistic_id]
,[statistic_name]
,COUNT(*)
FROM [dbo].[Statistics_Update_History_Detail]
GROUP BY
[statssummary_job_id]
,[database_id]
,[schema_name]
,[table_id]
,[table_name]
,[statistic_id]
,[statistic_name]
HAVING COUNT(*) > 1
)

select 
'Confirmation-No stats update processing same statistic multiple times in a job',
t2.database_name
,t2.statsupdate_job_date
,t1.*
from statsum as t1
inner join [dbo].[Statistics_Update_History_Summary] as t2
on t1.statssummary_job_id = t2.statssummary_job_id
order by statssummary_job_id desc
*/

/*
Stats summary IDs by ExecutionID--to get duration and max/min IDs for each time the AB job was run
*/
/*
SELECT
'First & Last stats job by executionGUID--will need for report--LOJ to job date by GUID',
[t2].[executioninstanceGUID]
,[T3].[JobStartDate]
,min([t2].[statssummary_job_id]) as firststatssumaryid
,max([t2].[statssummary_job_id]) as laststatssumaryid
,t3.duration
--,[t3].JobStartTime,[t3].JobEndTime
 FROM [dbo].[Statistics_Update_History_Summary] as t2
 LEFT OUTER JOIN
	(
	SELECT [executioninstanceGUID]
	,MIN([STATSUPDATE_JOB_date]) as [JobStartDate]
	,min([statsupdate_job_starttime]) as [JobStartTime]
	,max([statsupdate_job_endtime]) as [JobEndTime]
	,datediff(minute,min([statsupdate_job_starttime]),max([statsupdate_job_endtime])) as duration
	FROM [dbo].[Statistics_Update_History_Summary] 
	GROUP BY [executioninstanceGUID]) AS t3
ON [T2].[executioninstanceGUID] = [T3].[executioninstanceGUID]
 group by 
 [t2].[executioninstanceGUID]
 ,[T3].[JobStartDate]
 ,t3.duration
 ORDER BY [T3].[JobStartDate] DESC
 */


/*
Stats job by Stats summary IDs--gets the per database information on the maintenance job--used in reporting
*/
/*
SELECT 
'Current job status',
[t2].[statssummary_job_id]
,[t2].[statsupdate_job_date]
,[t2].[statsupdate_process_completed_ind]
,datediff(minute,[t2].[statsupdate_job_starttime],ISNULL([t2].[statsupdate_job_endtime],GETDATE())) AS TimeToProcessDBStats
,[t3].[statsupdatedcount]
,[t2].[executioninstanceGUID]
,[t2].[database_id]
,[t2].[database_name]
,[t2].[statsupdate_comments]
FROM [dbo].[Statistics_Update_History_Summary] as t2
LEFT OUTER JOIN 
	(SELECT [statssummary_job_id]
	,[database_id]
	,count([statistic_name]) as statsupdatedcount
	FROM [dbo].[Statistics_Update_History_Detail]
	group by 
	[statssummary_job_id]
	,[database_id]
	) AS T3
ON [t2].[statssummary_job_id] = [T3].[statssummary_job_id]
order by t2.statssummary_job_id desc
*/


use pc_prod
go
declare @currdbid int
--set @currdbid = db_id()
SELECT 
	@currdbid = MAX([statssummary_job_id])
	FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Summary] 
	WHERE [database_id] = db_id()


select 
OBJECT_NAME(s1.object_id),
s1.auto_created
,s1.user_created
,[CSJ1].[table_row_count]
,[CSJ1].[statsupdate_completed_ind]
,[CSJ1].[statsupdate_performed_ind]
,[CSJ1].[statsupdate_failed_ind]
,[CSJ1].[statsupdate_fromindexdefrag]
,[CSJ1].[statsupdate_scan_type_performed]
,'need to provide text of scantypeperformeID'
,datediff(minute,[csj1].[statsupdate_task_starttime],[csj1].[statsupdate_task_endtime]) as statsupdatetime
,[CSJ1].[statsupdate_task_starttime]
,[CSJ1].[statsupdate_task_endtime]
,[CSJ1].[system_last_updated]
,[CSJ1].[rows_sampled]
,[CSJ1].[statistic_specific_comments]
from sys.stats as s1
left outer join 
(SELECT [SD1].[statssummary_job_id]
      ,[SD1].[schema_name]
      ,[SD1].[table_id]
      ,[SD1].[table_name]
      ,[SD1].[statistic_id]
      ,[SD1].[statistic_name]
      ,[SD1].[table_row_count]
      ,[SD1].[statsupdate_completed_ind]
      ,[SD1].[statsupdate_performed_ind]
      ,[SD1].[statsupdate_failed_ind]
      ,[SD1].[statsupdate_fromindexdefrag]
      ,[SD1].[statsupdate_scan_type_performed]
	  ,[SD1].[statsupdate_task_starttime]
      ,[SD1].[statsupdate_task_endtime]
      ,[SD1].[auto_created]
      ,[SD1].[user_created]
      ,[SD1].[system_last_updated]
      ,[SD1].[rows_sampled]
      ,[SD1].[statistic_specific_comments]
  FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Detail]  AS SD1 
  WHERE [SD1].[statssummary_job_id] = @currdbid
  ) as csj1
  on s1.object_id = csj1.table_id
  and s1.stats_id = csj1.statistic_id
where OBJECT_SCHEMA_NAME(object_id) not like 'sys'
--and csj1.table_name is null

