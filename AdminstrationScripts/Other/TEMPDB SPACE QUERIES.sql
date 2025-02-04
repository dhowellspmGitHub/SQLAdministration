
SELECT SUM(unallocated_extent_page_count) AS [free pages], 
(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB],
SUM(version_store_reserved_page_count) AS [version store pages used],
(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
,SUM(user_object_reserved_page_count) AS [user object pages used],
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;

/*
https://technet.microsoft.com/en-us/library/ms176029(v=sql.105).aspx

Obtaining the space consumed by internal objects in all currently running tasks in each session.
The following example creates the view all_task_usage. When queried, the view returns the total space used by internal objects in all currently running tasks in tempdb.
*/


SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id;

/*
B. Obtaining the space consumed by internal objects in the current session for both running and completed tasks
The following example creates the view all_session_usage. When queried, the view returns the space used by all internal objects running and completed tasks in tempdb.
*/

SELECT R1.session_id,
        R1.internal_objects_alloc_page_count 
        + R2.task_internal_objects_alloc_page_count AS session_internal_objects_alloc_page_count,
        R1.internal_objects_dealloc_page_count 
        + R2.task_internal_objects_dealloc_page_count AS session_internal_objects_dealloc_page_count
    FROM sys.dm_db_session_space_usage AS R1 
    INNER JOIN all_task_usage AS R2 ON R1.session_id = R2.session_id;
GO

CREATE VIEW all_request_usage
AS 
  SELECT session_id, request_id, 
      SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
  FROM sys.dm_db_task_space_usage 
  GROUP BY session_id, request_id;
GO
CREATE VIEW all_query_usage
AS
  SELECT R1.session_id, R1.request_id, 
      R1.request_internal_objects_alloc_page_count, R1.request_internal_objects_dealloc_page_count,
      R2.sql_handle, R2.statement_start_offset, R2.statement_end_offset, R2.plan_handle,
SUBSTRING(st.text, (R2.statement_start_offset/2)+1, 
        ((CASE R2.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE R2.statement_end_offset
         END - R2.statement_start_offset)/2) + 1) AS statement_text

  FROM all_request_usage R1
  INNER JOIN sys.dm_exec_requests R2 ON R1.session_id = R2.session_id and R1.request_id = R2.request_id
CROSS APPLY sys.dm_exec_sql_text(r2.PLAN_HANDLE) AS ST ;
GO

SELECT * FROM sys.dm_exec_sql_text(@sql_handle);
SELECT * FROM sys.dm_exec_query_plan(@plan_handle);
