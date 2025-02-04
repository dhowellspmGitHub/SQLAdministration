(@MessageType Int, @ExecutionID NVarChar(max), @SourceNameContains NVarChar(max), @MessageContains NVarChar(max), @SubComponentNameContains NVarChar(max), @ExecutionPathContains NVarChar(max), @EnvironmentContains NVarChar(max))
USE [SSISDB];
WITH msgEx AS(
    SELECT
        msg.[event_message_id]
        ,msg.[operation_id]
        ,CONVERT(datetime, msg.[message_time]) AS message_time
        ,msg.[message_type]
        ,msg.[message_source_type]
        ,CASE WHEN LEN(msg.[message]) <= 4096 THEN msg.[message] ELSE LEFT(msg.[message], 1024) + '...' END AS [message]
        ,msg.[extended_info_id]
        ,msg.[event_name]
        ,CASE WHEN LEN(msg.[message_source_name]) <= 1024 THEN msg.[message_source_name] ELSE LEFT(msg.[message_source_name], 1024) + '...' END AS [message_source_name]
        ,msg.[message_source_id]
        ,CASE WHEN LEN(msg.[subcomponent_name]) <= 1024 THEN msg.[subcomponent_name] ELSE LEFT(msg.[subcomponent_name], 1024) + '...' END AS [subcomponent_name]
        ,CASE WHEN LEN(msg.[package_path]) <= 1024 THEN msg.[package_path] ELSE LEFT(msg.[package_path], 1024) + '...' END AS [package_path]
        ,CASE WHEN LEN(msg.[execution_path]) <= 1024 THEN msg.[execution_path] ELSE LEFT(msg.[execution_path], 1024) + '...' END AS [execution_path]
        ,msg.[message_code]
        ,info.reference_id
    FROM
    [catalog].[event_messages] msg LEFT JOIN [catalog].[extended_operation_info] info ON msg.extended_info_id = info.info_id
    WHERE
        msg.[operation_id] = @ExecutionID
        ),
msgRef AS(
    SELECT msgEx.*, ref.[reference_type], ref.[environment_folder_name], ref.[environment_name]
    FROM msgEx LEFT JOIN [catalog].[environment_references] ref
    ON msgEx.[reference_id] = ref.[reference_id]
    ),
msgEnv AS(
SELECT *,
    CASE WHEN [reference_id] IS NULL THEN '-' ELSE 
    (CASE WHEN [reference_type] = 'R' OR [reference_type] = 'r' THEN '.' ELSE [environment_folder_name] END) + '\' + [environment_name]
    END AS env
FROM
    msgRef
)
SELECT *
FROM
    msgEnv
WHERE
    (@MessageType=-1 OR [message_type] = @MessageType) AND
    (ISNULL([message_source_name],'') LIKE '%' + REPLACE(REPLACE(REPLACE(@SourceNameContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    (ISNULL([message],'') LIKE '%' + REPLACE(REPLACE(REPLACE(@MessageContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    (ISNULL([subcomponent_name],'') LIKE '%' + REPLACE(REPLACE(REPLACE(@SubComponentNameContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    (ISNULL([execution_path],'') LIKE '%' + REPLACE(REPLACE(REPLACE(@ExecutionPathContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default) AND
    (ISNULL([env],'') LIKE '%' + REPLACE(REPLACE(REPLACE(@EnvironmentContains COLLATE database_default,'[', '[[]'), '_', '[_]'), '%','[%]') + '%' COLLATE database_default)
ORDER BY [message_time] DESC