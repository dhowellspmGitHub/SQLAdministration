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
IF EXISTS (SELECT * FROM tempdb.sys.tables where name like 'queries_current_sessions' and type like 'U')
BEGIN
DROP TABLE TEMPDB.DBO.queries_current_sessions
END
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
[host_name] nvarchar(128),
host_process_id int,
client_interface_name nvarchar(32),
[program_name] nvarchar(128),
client_net_address VARCHAR(48),
client_tcp_port INT,
security_id varbinary(85),
original_login_name nvarchar(128),
nt_domain_user nvarchar(128),
connection_id uniqueidentifier,
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
blocking_session_id SMALLINT,
wait_resource NVARCHAR(256),
command NVARCHAR(16),
last_wait_type NVARCHAR(60),
--query_text  NVARCHAR(MAX),
--query_plan XML,
--plan_handle VARBINARY(64), 
--creation_time DATETIME NULL,
--plan_generation_num BIGINT NULL,
--dm_query_stats_sql_handle VARBINARY NULL
)
END


SELECT @sessionrunid =  (ISNULL(MAX(session_history_run_id),0)) + 1
FROM tempdb.dbo.queries_current_sessions

INSERT INTO [tempdb].[dbo].[queries_current_sessions]
([session_history_run_id]
,[session_history_run_datetime]
,[session_id]
,[host_name]
,[host_process_id]
,[client_interface_name]
,[program_name]
,[client_net_address]
,[client_tcp_port]
,[security_id]
,[original_login_name]
,[nt_domain_user]
,[connection_id]
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
,[blocking_session_id]
,[wait_resource]
,[command]
,[last_wait_type]
--,[query_text]
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
dm_es.[host_name],
dm_es.[host_process_id],
dm_es.client_interface_name,
dm_es.[program_name],
dm_ec.client_net_address,
dm_ec.client_tcp_port,
dm_es.security_id,
N'Original:' + dm_es.original_login_name + N'--Current:' + dm_es.login_name,
CASE WHEN (LEN(dm_es.nt_domain) + LEN(dm_es.nt_user_name)) > 0 THEN dm_es.nt_domain + '\' + dm_es.nt_user_name ELSE NULL END,
dm_ec.connection_id,
dm_ec.auth_scheme,
dm_ost.task_state,
dm_ost.exec_context_id,
DB_NAME(dm_rq.database_id),
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
 --Optional columns
dm_ws.blocking_session_id,
dm_rq.wait_resource,
dm_rq.command,
dm_rq.last_wait_type
--NULL,
----(SELECT TOP 1 SUBSTRING(dm_t.text,dm_rq.statement_start_offset / 2+1 , 
----      ( (CASE WHEN dm_rq.statement_end_offset = -1 
----         THEN (LEN(CONVERT(nvarchar(max),dm_t.text)) * 2) 
----         ELSE dm_rq.statement_end_offset END)  - dm_rq.statement_start_offset) / 2+1))  AS sql_statement
--dm_qp.query_plan,
--dm_rq.plan_handle,
--NULL,
--NULL,
--NULL,
--NULL
--,dm_qs.creation_time
--,dm_qs.plan_generation_num
--,null
--,dm_qs.[sql_handle]
FROM sys.dm_exec_connections as dm_ec
LEFT OUTER JOIN sys.dm_exec_sessions AS dm_es with (nolock)
ON dm_ec.session_id = dm_es.session_id 
LEFT OUTER JOIN sys.dm_exec_requests as dm_rq with (nolock)
ON dm_es.session_id = dm_rq.session_id
LEFT OUTER JOIN sys.dm_os_tasks as dm_ost
ON dm_rq.session_id = dm_ost.session_id
and dm_rq.request_id = dm_ost.request_id
LEFT OUTER JOIN  sys.dm_os_waiting_tasks AS dm_ws with (nolock)
ON dm_es.session_id = dm_ws.session_id
OUTER APPLY sys.dm_exec_sql_text (dm_rq.sql_handle) dm_t 
OUTER APPLY sys.dm_exec_query_plan (dm_rq.plan_handle) dm_qp
--LEFT OUTER JOIN 
--		(SELECT 
--		creation_time,
--		plan_generation_num, 
--		[sql_handle],
--		plan_handle  
--		from sys.dm_exec_query_stats 
--		) AS dm_qs 
--ON CAST('' AS XML).value('xs:hexBinary(sql:column("dm_rq.plan_handle"))', 'VARCHAR(MAX)')   = CAST('' AS XML).value('xs:hexBinary(sql:column("dm_qs.plan_handle"))', 'VARCHAR(MAX)')
WHERE 
dm_es.is_user_process = 1 
--and dm_es.[status] NOT LIKE 'sleeping'
AND 
dm_es.session_id <> @@SPID

/* FOLLOW UP QUERIES--use the follow up queries to view the history logged in the temp table */

select *
from [tempdb].[dbo].[queries_current_sessions]
--where [host_name] like 'swsa400'
order by session_history_run_id, host_name, client_tcp_port asc