--(@ExecutionID NVarChar(max), @PackageNameContains NVarChar(max), @ExecutionPathContains NVarChar(max), @ExecutableNameContains NVarChar(max), @Result Int)          


USE [SSISDB];
          SELECT
          executables.[execution_id]
          ,CASE WHEN LEN(executables.[executable_name]) <= 1024 THEN executables.[executable_name] ELSE LEFT(executables.[executable_name], 1024) + '...' END AS [executable_name]
          ,executables.[executable_guid]
          ,CASE WHEN LEN(executable_statistics.[execution_path]) <= 1024 THEN executable_statistics.[execution_path] ELSE LEFT(executable_statistics.[execution_path], 1024) + '...' END AS [execution_path]
          ,executables.[package_name]
          ,executable_statistics.[statistics_id]
          ,CONVERT(FLOAT,executable_statistics.[execution_duration])/1000 AS [execution_duration]
          ,executable_statistics.[execution_result]
          ,executable_statistics.[execution_value]
          FROM
          [catalog].[executable_statistics] AS executable_statistics, [catalog].[executables] AS executables
          WHERE
          executable_statistics.[execution_id] =executables.[execution_id] AND
          executable_statistics.[executable_id] =executables.[executable_id] 
		  --AND
    --      executables.[execution_id]  = @ExecutionID AND
    --      (ISNULL(executables.[package_name], '') LIKE '%' + REPLACE(REPLACE(REPLACE(@PackageNameContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    --      (ISNULL(executable_statistics.[execution_path], '') LIKE '%' + REPLACE(REPLACE(REPLACE(@ExecutionPathContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    --      (ISNULL(executables.[executable_name], '') LIKE '%' + REPLACE(REPLACE(REPLACE(@ExecutableNameContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    --      executable_statistics.[execution_result] =
    --      (CASE
    --      WHEN (@Result > -1) THEN @Result
    --        ELSE executable_statistics.[execution_result]
    --        END)
ORDER BY executables.[package_name], executable_statistics.[execution_path]