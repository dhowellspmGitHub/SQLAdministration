/*
Author: Danny Howell
Date: 11/15/2017
Description: Script provides the SSISDB/Integration Services job environments for specifying the ENV value to use in jobs.
Run this query and use the value in the [CER1].[reference_id] column for the Envreference value passed to any scripts running the DTEXEC commands
Confirm that the correct project is chosen in the output
*/
USE [SSISDB]
GO

SELECT 
[CP1].[name]
,cast([EX1].[start_time] as datetime) as start_time
,DATEDIFF(minute,[EX1].[start_time],[EX1].[end_time]) as runtime_minutes
,[EX1].[status]
,CASE [EX1].[status] 
	WHEN 1 THEN 'Created'
	WHEN 2 THEN 'Running'
	WHEN 3 THEN 'Cancelled'
	WHEN 4 THEN 'Failed'
	WHEN 5 THEN 'Pending'
	WHEN 6 THEN 'Ended Unexpectedly'
	WHEN 7 THEN 'Succeeded'
	WHEN 8 THEN 'Stopping'
	WHEN 9 THEN 'Completed'
	ELSE 'Unknown' END as [status_desc]
,[CER1].[environment_folder_name]
,[CER1].[environment_name]
,[EX1].[folder_name]
,[EX1].[project_name]
,[EX1].[package_name]
,[CER1].[reference_id]
,[CER1].[validation_status]
,[CER1].[last_validation_time]
,[CP1].[description]
,[CP1].[deployed_by_name]
,cast([CP1].[last_deployed_time] as datetime) as last_deployed_date
,cast([EX1].[end_time] as datetime) as end_time
,[EX1].[process_id]
FROM [catalog].[environment_references] AS CER1
INNER JOIN [catalog].[projects] CP1
ON [CER1].[project_id] = [CP1].[project_id]
INNER JOIN [catalog].[executions] AS EX1
ON [CER1].[reference_id] = [EX1].[reference_id]
  where [CER1].[environment_name] like '%'
   order by 
  [start_time] desc,
  [package_name]
GO
