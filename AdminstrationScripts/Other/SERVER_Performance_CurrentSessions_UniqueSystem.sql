 /*********************************************************************************
Author:		Danny Howell

Date:	02/18/2013

SOURCE: copied from 
http://blog.sqlauthority.com/2011/02/04/sql-server-dmv-sys-dm_os_waiting_tasks-and-sys-dm_exec_requests-wait-type-day-4-of-28/
sys.dm_os_waiting_tasks >> http://msdn.microsoft.com/en-us/library/ms188743.aspx
sys.dm_exec_sessions >> http://msdn.microsoft.com/en-us/library/ms176013(v=sql.105).aspx
sys.dm_exec_requests >> http://msdn.microsoft.com/en-us/library/ms177648(v=sql.105).aspx

WHAT THIS TELLS YOU:
Returns information about the wait queue of tasks that are waiting on some resource joined with authenticated session on SQL Server. sys.dm_exec_sessions is a server-scope view that shows information about all active user connections and internal tasks. Used to first view the current system load and to identify a session of interest and about the processes going in our server at the given instant.

Also, gives estimate of completion, indicating how much longer a query will process (only for certain types--see sys.dm_exec_requests link above)

Various columns that provide important details
--wait_duration_ms – it indicates current wait for the query that executes at that point of time.
--wait_type – it indicates the current wait type for the query
--text – indicates the query text
--query_plan – when clicked on the same, it will display the query plans
--other important information like CPU_time, memory_usage, and logical_reads

SEE ALSO: Review the follow up queries at the end of this file
It is possible to reset the values in this view via a DBCC command. The only other time the stats will be reset is after a SQL server restart. 

*********************************************************************************/
/* This query can be run discretely or can be set up to run in a SQL job and repeat per time increment set in the query
Use the WHILE..BREAK..CONTINUE processing to repeat the query--set the date part by changing the date part and the value in the WHILE statement--also set the same in the BREAK section*/

/*
WHILE DATEPART(minute,GETDATE()) < 30
BEGIN
WAITFOR DELAY '00:00:05'

--move the section from IF to END after the query to set up the loop
IF (SELECT DATEPART(minute,GETDATE())) >= 30
	BREAK
		ELSE
	CONTINUE
END
*/

/* 
To log to a table in tempdb--use the variables and the INSERT statement below--move the DDL for the table before the WHILE statement above
*/

--NEED TO CHANGE THE TARGET TABLE AND INSERT STATEMENT 
DECLARE @pDatabaseName VARCHAR(128)
SET @pDatabaseName = 'imis_prod'
DECLARE @sessionrunid INT
DECLARE @sessionruntime DATETIME
DECLARE @HistoryRetention INT

IF NOT EXISTS (SELECT * FROM tempdb.sys.tables where name like 'queries_current_sessions' and type like 'U')
BEGIN
CREATE TABLE tempdb.dbo.queries_current_sessions
(
session_history_run_id INT,
session_history_run_datetime datetime,
session_id SMALLINT,
client_net_address VARCHAR(48),
auth_scheme VARCHAR(40),
task_state NVARCHAR(60),
exec_context_id INT,
database_name  NVARCHAR(128),
percent_complete REAL,
wait_duration_ms INT,
wait_type NVARCHAR(60),
exec_sessions_status NVARCHAR(30),
cpu_time_ms INT,
memory_usage_8kbpages INT,
logical_reads BIGINT,
writes BIGINT,
total_elapsed_time INT,
row_count BIGINT,
[program_name] NVARCHAR(128),
blocking_session_id SMALLINT,
wait_resource NVARCHAR(256),
login_name NVARCHAR(128),
client_ip_address NVARCHAR(128),
client_host_name NVARCHAR(128),
command NVARCHAR(16),
last_wait_type NVARCHAR(60),
query_text  NVARCHAR(MAX),
query_plan XML,
plan_handle VARBINARY(64), 
creation_time DATETIME NULL,
plan_generation_num BIGINT NULL,
dm_query_stats_sql_handle VARBINARY NULL
)
END
truncate table tempdb.dbo.queries_current_sessions

SELECT @sessionrunid =  (ISNULL(MAX(session_history_run_id),0)) + 1
FROM tempdb.dbo.queries_current_sessions

INSERT INTO [tempdb].[dbo].[queries_current_sessions]
([session_history_run_id]
,[session_history_run_datetime]
,[session_id]
,[client_net_address]
,[auth_scheme]			
,[task_state]
,[exec_context_id]
,[database_name]
,[percent_complete]
,[wait_duration_ms]
,[wait_type]
,[exec_sessions_status]
,[cpu_time_ms]
,[memory_usage_8kbpages]
,[logical_reads]
,[writes]
,[total_elapsed_time]
,[row_count]
,[program_name]
,[blocking_session_id]
,[wait_resource]
,[login_name]
,[client_ip_address]
,[client_host_name]
,[command]
,[last_wait_type]
,[query_text]
--,[query_plan]
--,[plan_handle] 
--,[creation_time]
--,[plan_generation_num]
--,[dm_query_stats_sql_handle]
)
  SELECT 
@sessionrunid,
@sessionruntime,
dm_es.session_ID,
dm_tl.resource_type,
dm_tl.request_mode,
dm_tl.request_status,
dm_tl.request_session_id,
db_name(dm_tl.resource_database_id) DatabaseName,
dm_rq.percent_complete,
dm_ws.wait_duration_ms,
dm_ws.wait_type,
dm_es.[status],
dm_es.cpu_time,
dm_es.memory_usage,
dm_es.logical_reads,
dm_es.writes,
dm_es.total_elapsed_time,
dm_es.row_count,
dm_es.[program_name],
 --Optional columns
dm_ws.blocking_session_id,
dm_rq.wait_resource,
dm_es.login_name,
dm_ec.client_net_address,
dm_es.[host_name],
dm_rq.command,
dm_rq.last_wait_type,
 (SELECT TOP 1 SUBSTRING(dm_t.text,dm_rq.statement_start_offset / 2+1 , 
      ( (CASE WHEN dm_rq.statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),dm_t.text)) * 2) 
         ELSE dm_rq.statement_end_offset END)  - dm_rq.statement_start_offset) / 2+1))  AS sql_statement
--,dm_qp.query_plan
--dm_rq.plan_handle,
--dm_qs.creation_time,
--dm_qs.plan_generation_num,
--dm_qs.[sql_handle]
--dm_ec.client_net_address,
--dm_ec.auth_scheme,
--dm_ost.task_state,
--dm_ost.exec_context_id,
--dm_es.program_name,
FROM sys.dm_tran_locks dm_tl
left join sys.dm_exec_sessions AS dm_es with (nolock)
on dm_tl.request_session_id = dm_es.session_id
LEFT OUTER JOIN sys.dm_exec_requests as dm_rq with (nolock)
ON dm_es.session_id = dm_rq.session_id
LEFT OUTER JOIN sys.dm_os_tasks as dm_ost
ON dm_rq.session_id = dm_ost.session_id
and dm_rq.request_id = dm_ost.request_id
LEFT OUTER JOIN  sys.dm_os_waiting_tasks AS dm_ws with (nolock)
ON dm_es.session_id = dm_ws.session_id
LEFT OUTER JOIN sys.dm_exec_connections as dm_ec
ON dm_es.session_id = dm_ec.session_id
OUTER APPLY sys.dm_exec_sql_text (dm_rq.sql_handle) dm_t 
--OUTER APPLY sys.dm_exec_query_plan (dm_rq.plan_handle) dm_qp
--LEFT OUTER JOIN 
--		(SELECT 
--		creation_time,
--		plan_generation_num, 
--		[sql_handle],
--		plan_handle  
--		from sys.dm_exec_query_stats 
--		) AS dm_qs 
--ON CAST('' AS XML).value('xs:hexBinary(sql:column("dm_rq.plan_handle"))', 'VARCHAR(MAX)')   = CAST('' AS XML).value('xs:hexBinary(sql:column("dm_qs.plan_handle"))', 'VARCHAR(MAX)')
--WHERE 
--DB_NAME(dm_tl.resource_database_id) LIKE @pDatabaseName
--dm_es.is_user_process = 1 
--and dm_es.[status] NOT LIKE 'sleeping'
--AND 
--dm_es.session_id <> @@SPID
order by login_name


/* FOLLOW UP QUERIES--use the follow up queries to view the history logged in the temp table */
select 
@@SERVERNAME,
[session_history_run_id]
,[session_history_run_datetime]
,[session_id]
,[client_net_address]
,[auth_scheme]			
,[task_state]
,[exec_context_id]
,[database_name]
,[percent_complete]
,[wait_duration_ms]
,[wait_type]
,[exec_sessions_status]
,[cpu_time_ms]
,[memory_usage_8kbpages]
,[logical_reads]
,[writes]
,[total_elapsed_time]
,[row_count]
,[program_name]
,[blocking_session_id]
,[wait_resource]
,[login_name]
,[client_ip_address]
,[client_host_name]
from 
 [tempdb].[dbo].[queries_current_sessions]
 where session_id <> @@SPID
 
