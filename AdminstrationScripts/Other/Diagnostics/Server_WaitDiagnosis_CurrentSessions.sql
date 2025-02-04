
/*
KEY DIAGNOSTIC INFORMATION PROVIDED: 
Below query provides current point in time view of sessions utilizing DMVs and others to identify the CPU and resource waits along with any blocked and blocking sessions
--Is a session being blocked, and if so by what session
--On what the sessions are waiting on
--Resource waits compared to CPU waits--how much time is spent waiting for CPU compared to the resource waits of the waiter list.

EXPLANATION:
When a SQL Server session_id goes into a suspended status, a wait state is assigned indicating the reason why the session_id is suspended.  

sys.dm_os_waiting_tasks--contains currently waiting sessions and displays suspended sessions and reasons for the suspension including the session_id, wait_type and the session’s accumulated wait time for this wait type in the column wait_duration_ms. These are the sessions in the "waiter" list. If the wait is due to blocking where a lock cannot be obtained until another session releases their lock,the session holding as the blocking and blocked resource are shown in the columns blocking_session_id and resource.
total time that is spent waitingsignal_wait _time_ms. Resource waits can be computed by subtracting signal_wait_time_ms from wait_time_ms. A runnable queue is unavoidable with an OLTP 

sys.dm_exec_requests--current runnable queue (where the status is “runnable”). Two columns are of importance indicating what is being waited on:
"Total Wait Time" -- wait_time_ms--The total time that is spent waiting on both non-CPU and CPU resources
"CPU Wait Time" -- signal_wait _time_ms--the time that is spent waiting for CPU in the runnable queue
"Resource waits" -- wait_time_ms minus signal_wait _time_ms (if it is not waiting on CPU, it's waiting on something else)

sys.dm_os_wait_stats--Returns information about all the waits encountered by threads that executed. You can use this aggregated view to diagnose performance issues with SQL Server and also with specific queries and batches. 
Common status values are ‘running’, ‘runnable’ and ‘suspended’, and 'sleeping'.  A session status of ‘Sleeping’ indicates SQL Server is waiting for the next SQL Server command

GUIDELINES:
A low signal (where signal is less than 25% of the total waits) to resource wait ratio indicates there is little CPU pressure.
*/
DECLARE @WaitTypeExclusions TABLE (WaitName NVARCHAR(128))
INSERT INTO @WaitTypeExclusions
VALUES ('DBMIRROR_DBM_EVENT');


WITH [Blocking]
AS (
SELECT w.[session_id]
,w.[wait_duration_ms]
,w.[wait_type]
,w.[resource_description]
,w.[blocking_session_id]
,s.[original_login_name]
,s.[login_name]
,s.[program_name]
,s.[host_name]
,r.[status]
,r.[wait_resource]
,r.[command]
,r.[percent_complete]
,r.[cpu_time]
,r.[total_elapsed_time]
,r.[reads]
,r.[writes]
,r.[logical_reads]
,r.[row_count]
,q.[text]
,q.[dbid]
,p.[query_plan]
,r.[plan_handle]
FROM [sys].[dm_os_waiting_tasks] w
INNER JOIN [sys].[dm_exec_sessions] s 
ON w.[session_id] = s.[session_id]
INNER JOIN [sys].[dm_exec_requests] r 
ON s.[session_id] = r.[session_id]
CROSS APPLY [sys].[dm_exec_sql_text](r.[plan_handle]) q
CROSS APPLY [sys].[dm_exec_query_plan](r.[plan_handle]) p
--WHERE w.[session_id] > 50
--AND w.[wait_type] NOT IN (SELECT WaitName FROM @WaitTypeExclusions)
)

-- Isolate top waits for server instance since last restart or statistics clear

SELECT 
b.[session_id] AS [WaitingSessionID]
,b.[blocking_session_id] AS [BlockingSessionID]
,b.[login_name] AS [WaitingUserSessionLogin]
,b.[original_login_name] AS [WaitingUserConnectionLogin] 
,b.[wait_duration_ms] AS [WaitDuration]
,b.[wait_type] AS [WaitType]
,UPPER(b.[status]) AS [WaitingProcessStatus]
,b.[wait_resource] AS [WaitResource]
,b.[resource_description] AS [WaitResourceDescription]
,b.[program_name] AS [WaitingSessionProgramName]
,b.[host_name] AS [WaitingHost]
,b.[command] AS [WaitingCommandType]
,b.[text] AS [WaitingCommandText]
,b.[row_count] AS [WaitingCommandRowCount]
,b.[percent_complete] AS [WaitingCommandPercentComplete]
,b.[cpu_time] AS [WaitingCommandCPUTime]
,b.[total_elapsed_time] AS [WaitingCommandTotalElapsedTime]
,b.[reads] AS [WaitingCommandReads]
,b.[writes] AS [WaitingCommandWrites]
,b.[logical_reads] AS [WaitingCommandLogicalReads]
-- Optional query diagnostic fields
--,b.[query_plan] AS [WaitingCommandQueryPlan]
--,b.[plan_handle] AS [WaitingCommandPlanHandle]
--Blocking User and Session fields
,s1.[program_name] AS [BlockingSessionProgramName]
,s1.[host_name] AS [BlockingHost]
,s1.[login_name] AS [BlockingSessionLogin]
,s1.[original_login_name] AS [BlockingSessionConnectionLogin]
,UPPER(s1.[status]) AS [BlockingSessionStatus]
,t.[request_mode] AS [WaitRequestMode]
,t.[resource_type] AS [WaitResourceType]
,t.[resource_database_id] AS [WaitResourceDatabaseID]
,DB_NAME(t.[resource_database_id]) AS [WaitResourceDatabaseName]
FROM [Blocking] b
INNER JOIN [sys].[dm_exec_sessions] s1
ON b.[blocking_session_id] = s1.[session_id]
INNER JOIN [sys].[dm_tran_locks] t
ON t.[request_session_id] = b.[session_id]
--WHERE t.[request_status] = 'WAIT'
;
