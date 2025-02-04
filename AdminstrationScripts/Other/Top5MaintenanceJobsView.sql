USE [KFBSQLMgmt]
GO

SELECT 
'Index Maintenance'
,[t1].[initiating_job_scheduler_application_name]
,[t1].[initiating_job_name]
,[t1].[server_name]
,[t1].[database_name]
,convert(varchar(20),[t1].[last_update_date], 100) as jobdate
,DATEDIFF(minute,[t1].[defragmentation_job_starttime],[defragmentation_job_endtime]) duration_minutes
,convert(varchar(20),[t1].[defragmentation_job_starttime],100) as jobstarttime
,convert(varchar(20),[t1].[defragmentation_job_endtime],100) as jobendtime
,[t1].[defragmentation_comments]
FROM [dbo].[vw_Index_Defragmentation_History_Summary] as t1
INNER JOIN
	(
	select row_number() over(partition by [database_name] order by [last_update_date] desc ) as rownum, database_name, defragmentation_job_id, last_update_date from dbo.vw_Index_Defragmentation_History_Summary 
	where defragmentation_performed_ind = 1
	) AS maintsum
on t1.defragmentation_job_id = maintsum.defragmentation_job_id
where maintsum.rownum <= 5
order by database_name, jobdate desc

SELECT 
'Statistics Maintenance'
,[t1].[initiating_job_scheduler_application_name]
,[t1].[initiating_job_name]
,[t1].[server_name]
,[t1].[database_name]
,convert(varchar(20),[t1].[statsupdate_job_date],100) as jobdate
,convert(varchar(20),[t1].[statsupdate_job_starttime], 100) as jobstarttime
,convert(varchar(20),[t1].[statsupdate_job_endtime],100) as jobendtime
,[t1].[statsupdate_comments]
FROM [dbo].[vw_Statistics_Update_History_Summary] as t1
INNER JOIN
	(
	select row_number() over(partition by [database_name] order by [statsupdate_job_date] desc ) as rownum, database_name, [statssummary_job_id], [statsupdate_job_date] from [dbo].[vw_Statistics_Update_History_Summary]  
	where [statsupdate_performed_ind] = 1
	) AS maintsum
on t1.[statssummary_job_id] = maintsum.[statssummary_job_id]
where maintsum.rownum <= 5
order by database_name, t1.statsupdate_job_date desc
GO


