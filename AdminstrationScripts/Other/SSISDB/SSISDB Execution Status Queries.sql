SELECT
    E.execution_id
,   E.folder_name
,   E.project_name
,   E.package_name
,   E.reference_id
,   E.reference_type
,   E.environment_folder_name
,   E.environment_name
,   E.project_lsn
,   E.executed_as_sid
,   E.executed_as_name
,   E.use32bitruntime
,   E.operation_type
,   E.created_time
,   E.object_type
,   E.object_id
,   E.status
,   E.start_time
,   E.end_time
,   E.caller_sid
,   E.caller_name
,   E.process_id
,   E.stopped_by_sid
,   E.stopped_by_name
,   E.dump_id
,   E.server_name
,   E.machine_name
,   E.total_physical_memory_kb
,   E.available_physical_memory_kb
,   E.total_page_file_kb
,   E.available_page_file_kb
,   E.cpu_count
,   F.folder_id
,   F.name
,   F.description
,   F.created_by_sid
,   F.created_by_name
,   F.created_time
,   P.project_id
,   P.folder_id
,   P.name
,   P.description
,   P.project_format_version
,   P.deployed_by_sid
,   P.deployed_by_name
,   P.last_deployed_time
,   P.created_time
,   P.object_version_lsn
,   P.validation_status
,   P.last_validation_time
,   PKG.package_id
,   PKG.name
,   PKG.package_guid
,   PKG.description
,   PKG.package_format_version
,   PKG.version_major
,   PKG.version_minor
,   PKG.version_build
,   PKG.version_comments
,   PKG.version_guid
,   PKG.project_id
,   PKG.entry_point
,   PKG.validation_status
,   PKG.last_validation_time
FROM
    catalog.executions AS E
    INNER JOIN
        ssisdb.catalog.folders AS F
        ON F.name = E.folder_name
    INNER JOIN 
        SSISDB.catalog.projects AS P
        ON P.folder_id = F.folder_id
        AND P.name = E.project_name
    INNER JOIN
        SSISDB.catalog.packages AS PKG
        ON PKG.project_id = P.project_id
        AND PKG.name = E.package_name;


-- Generate all the messages associated to failing operations
SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
    INNER JOIN
    (  
        -- Find failing operations
        SELECT DISTINCT
            OM.operation_id  
        FROM
            catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    ) D
    ON D.operation_id = OM.operation_id;

-- Find all messages associated to the last failing run
SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
WHERE
    OM.operation_id = 
    (  
        -- Find the last failing operation
        -- lazy assumption that biggest operation
        -- id is last. Could be incorrect if a long
        -- running process fails after a quick process
        -- has also failed
        SELECT 
            MAX(OM.operation_id)
        FROM
            catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    );

--- http://technet.microsoft.com/en-us/library/ff877994.aspx
-- This query translates the message_type from SSISDB.catalog.operation_messages
-- into useful text
SELECT
    D.message_type
,   D.message_desc
FROM
(
    VALUES
        (-1,'Unknown')
    ,   (120,'Error')
    ,   (110,'Warning')
    ,   (70,'Information')
    ,   (10,'Pre-validate')
    ,   (20,'Post-validate')
    ,   (30,'Pre-execute')
    ,   (40,'Post-execute')
    ,   (60,'Progress')
    ,   (50,'StatusChange')
    ,   (100,'QueryCancel')
    ,   (130,'TaskFailed')
    ,   (90,'Diagnostic')
    ,   (200,'Custom')
    ,   (140,'DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages.  The value of the message column for DiagnosticEx is XML text.')
    ,   (400,'NonDiagnostic')
    ,   (80,'VariableValueChanged')
) D (message_type, message_desc);


-- Where was the error message generated?
SELECT
    D.message_source_type
,   D.message_source_desc
FROM
(
    VALUES
        (10,'Entry APIs, such as T-SQL and CLR Stored procedures')
    ,   (20,'External process used to run package (ISServerExec.exe)')
    ,   (30,'Package-level objects')
    ,   (40,'Control Flow tasks')
    ,   (50,'Control Flow containers')
    ,   (60,'Data Flow task')
) D (message_source_type, message_source_desc);

SELECT      OPR.object_name
            , MSG.message_time
            , MSG.message
FROM        catalog.operation_messages  AS MSG
INNER JOIN  catalog.operations          AS OPR
    ON      OPR.operation_id            = MSG.operation_id
WHERE       MSG.message_type            IN ( 120,130)
ORDER BY MSG.message_time DESC

SELECT event_message_id,MESSAGE,package_name,event_name,message_source_name,package_path,execution_path,message_type,message_source_type
FROM   (
       SELECT  em.*
       FROM    SSISDB.catalog.event_messages em
       WHERE   em.operation_id = (SELECT MAX(execution_id) FROM SSISDB.catalog.executions)
           AND event_name NOT LIKE '%Validate%'
       )q
/* Put in whatever WHERE predicates you might like*/
--WHERE	event_name = 'OnError'
--WHERE	package_name = 'Package.dtsx'
--WHERE execution_path LIKE '%<some executable>%'
ORDER BY message_time DESC