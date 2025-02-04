USE [KFBSQLMgmt_DEV]
GO

SELECT 
[ServerId]
,s1.[HostSystemID]
,sh1.HostName
,[InstanceName]
--,sa1.[JobGuid]
,sa1.[JobName]
,ags1.[FrequencyInterval]
,ags1.FrequencyIntervalBitMap
,sa1.[Description]
,sa1.[JobState]
,cast(sa1.[LastModifiedDt] as date) as LastModifiedDate
,cast(sa1.[CreatedDt] as date) as CreatedDate
,sa1.[IsEnabledInd]
,sa1.[HasScheduleInd]
,cast(sa1.[LastRunDt] as date) as LastRunDate
,cast(sa1.[NextRunDt] as date) as NextRunDate
,sa1.[LastRunOutcome]
,ags1.[JobScheduleID]
,cast(ags1.[CreatedDt] as date) as ScheduleCreateDt
,ags1.[IsEnabledInd]

,[dbo].[ConvertToBase](ags1.[FrequencyInterval],2)
,ags1.[FrequencyRecurrenceFactor]
,ags1.[FrequencyRelativeIntervals]
,ags1.[FrequencySubDayInterval]
,ags1.[FrequencySubDayTypes]
,ags1.[FrequencyTypes]
,cast(ags1.[ActiveStartDt] as date) as ScheduleStartedDate
,ags1.[ActiveStartTimeOfDay]
,cast(ags1.[ActiveEndDt] as date) as ScheduleToEndDate
,ags1.[ActiveEndTimeOfDay]
FROM [dbo].[Servers] as s1
INNER JOIN [dbo].[ServerHostSystems] as sh1
ON s1.HostSystemID = sh1.HostSystemID
LEFT OUTER JOIN dbo.SQLAgentJobs as sa1
on s1.ServerId = sa1.ServerInstanceID
LEFT OUTER JOIN  [dbo].[SQLAgentSchedules] AS ags1
ON sa1.ServerInstanceID = ags1.ServerInstanceId
and sa1.JobGuid = ags1.JobGUID

where s1.[RetiredInd] = 0
and sh1.ProducitionInd = 0
and FrequencyTypes like 'weekly'
and HostName like 'npsdbs043'
order by HostName,JobName
  
--USE [KFBSQLMgmt_DEV]
--GO

--GO
/* 0001111111 --Everyday
0000000001 -- Sunday
0001000000 -- Saturday
0000100000 -- Friday
0000010000 == Thursday
0000001000 -- Wednesday
0000000100 -- Tuesday
0000000010 -- Monday
0000000000 -- Not scheduled or not a Weekly method

*/



