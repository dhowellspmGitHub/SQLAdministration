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
,[CER1].[environment_folder_name]
,[CER1].[environment_name]
,[CER1].[reference_id]
,[CER1].[validation_status]
,[CER1].[last_validation_time]
,[CP1].[description]
,[CP1].[deployed_by_name]
,[CP1].[last_deployed_time]
FROM [catalog].[environment_references] AS CER1
INNER JOIN [catalog].[projects] CP1
ON [CER1].[project_id] = [CP1].[project_id]
WHERE [CP1].[name] like '%'
ORDER BY [CER1].[environment_name] 
GO
