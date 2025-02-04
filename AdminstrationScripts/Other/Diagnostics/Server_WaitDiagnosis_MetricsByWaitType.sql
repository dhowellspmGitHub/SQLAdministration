/*
Resource Waits occur when a worker requests access to a resource that is not available because it is being used by another thread, or not yet available.  These are the most common types of waits, and surface as locks, latches, network and I/O.

Signal Waits are the time a session id spends waiting for the CPU to become available to run it.  The time spent here is known as the runnable queue.  Since there is no specific counter to measure CPU Pressure, one must measure the signal wait time.  signal_wait_time is the difference between time the waiting thread was signaled and when it started running

Queue waits occur when a worker is idle, waiting for work to be assigned.  This wait type is most typically seen with system background tasks such as the deadlock monitor and deleted record cleanup tasks.

External Waits  occur when a SQL Server worker is waiting for an external event, such as an extended stored procedure call or a linked server query, to finish. 

Certain wait types are filtered out as they are unimportant
https://www.sqlservercentral.com/blogs/signal-waits-and-resource-waits-a-clarification
https://www.sqlskills.com/blogs/paul/wait-statistics-or-please-tell-me-where-it-hurts/
*/
declare @percentthreshold int
set @percentthreshold = 99

Select 
'Overall Server Wait Condition',
SUM(waiting_tasks_count) as waiting_tasks_count,
sum(signal_wait_time_ms) as signalWaitTimeMs,
cast(100.0 * sum(signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2)) as [Percent_signal waits],
sum(wait_time_ms - signal_wait_time_ms) as resourceWaitTimeMs,
cast(100.0 * sum(wait_time_ms - signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2)) as [pecent_resource waits]
from sys.dm_os_wait_stats;

IF EXISTS (SELECT * FROM [tempdb].[sys].[tables] WHERE [name] = 'waitstatistcs_by_waittype')
BEGIN
DROP TABLE [tempdb].[dbo].[waitstatistcs_by_waittype]
END

CREATE TABLE [tempdb].[dbo].[waitstatistcs_by_waittype]
(wait_type nvarchar(60)
,waiting_tasks_count bigint
,wait_time_s bigint
,signal_wait_time_s bigint
,resource_wait_time_s bigint
,pct_of_all_waits decimal(6,2)
,rn int
)

INSERT INTO [tempdb].[dbo].[waitstatistcs_by_waittype]
           ([wait_type]
           ,[waiting_tasks_count]
           ,[wait_time_s]
           ,[signal_wait_time_s]
		   ,[resource_wait_time_s]
           ,[pct_of_all_waits]
           ,[rn])

(SELECT 
wait_type,
waiting_tasks_count,
wait_time_ms/1000.0 AS wait_time_s,
(signal_wait_time_ms/1000.0) as signal_wait_time_s,
(wait_time_ms - signal_wait_time_ms)/1000.0 as resource_wait_time_s,
100.0 * wait_time_ms/SUM(wait_time_ms) OVER() ,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE [wait_type] NOT IN (
        -- These wait types are almost 100% never a problem and so they are
        -- filtered out to avoid them skewing the results. Click on the URL
        -- for more information.
        N'BROKER_EVENTHANDLER', -- https://www.sqlskills.com/help/waits/BROKER_EVENTHANDLER
        N'BROKER_RECEIVE_WAITFOR', -- https://www.sqlskills.com/help/waits/BROKER_RECEIVE_WAITFOR
        N'BROKER_TASK_STOP', -- https://www.sqlskills.com/help/waits/BROKER_TASK_STOP
        N'BROKER_TO_FLUSH', -- https://www.sqlskills.com/help/waits/BROKER_TO_FLUSH
        N'BROKER_TRANSMITTER', -- https://www.sqlskills.com/help/waits/BROKER_TRANSMITTER
        N'CHECKPOINT_QUEUE', -- https://www.sqlskills.com/help/waits/CHECKPOINT_QUEUE
        N'CHKPT', -- https://www.sqlskills.com/help/waits/CHKPT
        N'CLR_AUTO_EVENT', -- https://www.sqlskills.com/help/waits/CLR_AUTO_EVENT
        N'CLR_MANUAL_EVENT', -- https://www.sqlskills.com/help/waits/CLR_MANUAL_EVENT
        N'CLR_SEMAPHORE', -- https://www.sqlskills.com/help/waits/CLR_SEMAPHORE
        N'CXCONSUMER', -- https://www.sqlskills.com/help/waits/CXCONSUMER
 
        -- Maybe comment these four out if you have mirroring issues
        N'DBMIRROR_DBM_EVENT', -- https://www.sqlskills.com/help/waits/DBMIRROR_DBM_EVENT
        N'DBMIRROR_EVENTS_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_EVENTS_QUEUE
        N'DBMIRROR_WORKER_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_WORKER_QUEUE
        N'DBMIRRORING_CMD', -- https://www.sqlskills.com/help/waits/DBMIRRORING_CMD
 
        N'DIRTY_PAGE_POLL', -- https://www.sqlskills.com/help/waits/DIRTY_PAGE_POLL
        N'DISPATCHER_QUEUE_SEMAPHORE', -- https://www.sqlskills.com/help/waits/DISPATCHER_QUEUE_SEMAPHORE
        N'EXECSYNC', -- https://www.sqlskills.com/help/waits/EXECSYNC
        N'FSAGENT', -- https://www.sqlskills.com/help/waits/FSAGENT
        N'FT_IFTS_SCHEDULER_IDLE_WAIT', -- https://www.sqlskills.com/help/waits/FT_IFTS_SCHEDULER_IDLE_WAIT
        N'FT_IFTSHC_MUTEX', -- https://www.sqlskills.com/help/waits/FT_IFTSHC_MUTEX
 
        -- Maybe comment these six out if you have AG issues
        N'HADR_CLUSAPI_CALL', -- https://www.sqlskills.com/help/waits/HADR_CLUSAPI_CALL
        N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', -- https://www.sqlskills.com/help/waits/HADR_FILESTREAM_IOMGR_IOCOMPLETION
        N'HADR_LOGCAPTURE_WAIT', -- https://www.sqlskills.com/help/waits/HADR_LOGCAPTURE_WAIT
        N'HADR_NOTIFICATION_DEQUEUE', -- https://www.sqlskills.com/help/waits/HADR_NOTIFICATION_DEQUEUE
        N'HADR_TIMER_TASK', -- https://www.sqlskills.com/help/waits/HADR_TIMER_TASK
        N'HADR_WORK_QUEUE', -- https://www.sqlskills.com/help/waits/HADR_WORK_QUEUE
 
        N'KSOURCE_WAKEUP', -- https://www.sqlskills.com/help/waits/KSOURCE_WAKEUP
        N'LAZYWRITER_SLEEP', -- https://www.sqlskills.com/help/waits/LAZYWRITER_SLEEP
        N'LOGMGR_QUEUE', -- https://www.sqlskills.com/help/waits/LOGMGR_QUEUE
        N'MEMORY_ALLOCATION_EXT', -- https://www.sqlskills.com/help/waits/MEMORY_ALLOCATION_EXT
        N'ONDEMAND_TASK_QUEUE', -- https://www.sqlskills.com/help/waits/ONDEMAND_TASK_QUEUE
        N'PARALLEL_REDO_DRAIN_WORKER', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_DRAIN_WORKER
        N'PARALLEL_REDO_LOG_CACHE', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_LOG_CACHE
        N'PARALLEL_REDO_TRAN_LIST', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_TRAN_LIST
        N'PARALLEL_REDO_WORKER_SYNC', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_SYNC
        N'PARALLEL_REDO_WORKER_WAIT_WORK', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_WAIT_WORK
        N'PREEMPTIVE_OS_FLUSHFILEBUFFERS', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_OS_FLUSHFILEBUFFERS 
        N'PREEMPTIVE_XE_GETTARGETSTATE', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_XE_GETTARGETSTATE
        N'PWAIT_ALL_COMPONENTS_INITIALIZED', -- https://www.sqlskills.com/help/waits/PWAIT_ALL_COMPONENTS_INITIALIZED
        N'PWAIT_DIRECTLOGCONSUMER_GETNEXT', -- https://www.sqlskills.com/help/waits/PWAIT_DIRECTLOGCONSUMER_GETNEXT
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', -- https://www.sqlskills.com/help/waits/QDS_PERSIST_TASK_MAIN_LOOP_SLEEP
        N'QDS_ASYNC_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_ASYNC_QUEUE
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
            -- https://www.sqlskills.com/help/waits/QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP
        N'QDS_SHUTDOWN_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_SHUTDOWN_QUEUE
        N'REDO_THREAD_PENDING_WORK', -- https://www.sqlskills.com/help/waits/REDO_THREAD_PENDING_WORK
        N'REQUEST_FOR_DEADLOCK_SEARCH', -- https://www.sqlskills.com/help/waits/REQUEST_FOR_DEADLOCK_SEARCH
        N'RESOURCE_QUEUE', -- https://www.sqlskills.com/help/waits/RESOURCE_QUEUE
        N'SERVER_IDLE_CHECK', -- https://www.sqlskills.com/help/waits/SERVER_IDLE_CHECK
        N'SLEEP_BPOOL_FLUSH', -- https://www.sqlskills.com/help/waits/SLEEP_BPOOL_FLUSH
        N'SLEEP_DBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DBSTARTUP
        N'SLEEP_DCOMSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DCOMSTARTUP
        N'SLEEP_MASTERDBREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERDBREADY
        N'SLEEP_MASTERMDREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERMDREADY
        N'SLEEP_MASTERUPGRADED', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERUPGRADED
        N'SLEEP_MSDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_MSDBSTARTUP
        N'SLEEP_SYSTEMTASK', -- https://www.sqlskills.com/help/waits/SLEEP_SYSTEMTASK
        N'SLEEP_TASK', -- https://www.sqlskills.com/help/waits/SLEEP_TASK
        N'SLEEP_TEMPDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_TEMPDBSTARTUP
        N'SNI_HTTP_ACCEPT', -- https://www.sqlskills.com/help/waits/SNI_HTTP_ACCEPT
        N'SOS_WORK_DISPATCHER', -- https://www.sqlskills.com/help/waits/SOS_WORK_DISPATCHER
        N'SP_SERVER_DIAGNOSTICS_SLEEP', -- https://www.sqlskills.com/help/waits/SP_SERVER_DIAGNOSTICS_SLEEP
        N'SQLTRACE_BUFFER_FLUSH', -- https://www.sqlskills.com/help/waits/SQLTRACE_BUFFER_FLUSH
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', -- https://www.sqlskills.com/help/waits/SQLTRACE_INCREMENTAL_FLUSH_SLEEP
        N'SQLTRACE_WAIT_ENTRIES', -- https://www.sqlskills.com/help/waits/SQLTRACE_WAIT_ENTRIES
        N'VDI_CLIENT_OTHER', -- https://www.sqlskills.com/help/waits/VDI_CLIENT_OTHER
        N'WAIT_FOR_RESULTS', -- https://www.sqlskills.com/help/waits/WAIT_FOR_RESULTS
        N'WAITFOR', -- https://www.sqlskills.com/help/waits/WAITFOR
        N'WAITFOR_TASKSHUTDOWN', -- https://www.sqlskills.com/help/waits/WAITFOR_TASKSHUTDOWN
        N'WAIT_XTP_RECOVERY', -- https://www.sqlskills.com/help/waits/WAIT_XTP_RECOVERY
        N'WAIT_XTP_HOST_WAIT', -- https://www.sqlskills.com/help/waits/WAIT_XTP_HOST_WAIT
        N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', -- https://www.sqlskills.com/help/waits/WAIT_XTP_OFFLINE_CKPT_NEW_LOG
        N'WAIT_XTP_CKPT_CLOSE', -- https://www.sqlskills.com/help/waits/WAIT_XTP_CKPT_CLOSE
        N'XE_DISPATCHER_JOIN', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_JOIN
        N'XE_DISPATCHER_WAIT', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_WAIT
        N'XE_TIMER_EVENT' -- https://www.sqlskills.com/help/waits/XE_TIMER_EVENT
		)
)

--The below query is a combination of several sites including those linked above providing Wait types by total wait times, resource wait times and signal wait times.
--The differentiation between resource and signal waits indicates where potential bottlenecks are
--While there is no definitive value for percent of signal (CPU processing) waits indicating there is a bottleneck, most sites indicate between 15% and 20%.
SELECT 
W1.wait_type,
SUM(W1.waiting_tasks_count) as waiting_tasks_count,
CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
CAST(W1.signal_wait_time_s AS DECIMAL(12, 2)) AS signal_wait_time_s,
CAST(W1.resource_wait_time_s AS DECIMAL(12, 2)) AS resource_wait_time_s,
CAST(W1.pct_of_all_waits AS DECIMAL(12, 2)) AS pct_of_all_waits,
CAST(SUM(W2.pct_of_all_waits) AS DECIMAL(12, 2)) AS running_pct,
(W1.signal_wait_time_s/W1.wait_time_s) * 100 as [%_signal_waits],  -- higher signal waits indicate CPU pressure
(W1.resource_wait_time_s/W1.wait_time_s) * 100 as [%_resource_waits],
CAST(CAST (MAX([W1].[wait_time_s]) as decimal(16,4)) / CAST(MAX([W1].[waiting_tasks_count]) AS DECIMAL (16,4)) AS DECIMAL(10,4)) AS [AvgWait_S],
CAST(CAST (MAX ([W1].[resource_wait_time_s]) as decimal(16,4)) / CAST(MAX ([W1].[waiting_tasks_count]) AS DECIMAL (16,4)) AS DECIMAL (10,4)) AS [AvgRes_S],
CAST(CAST (MAX ([W1].[signal_wait_time_s]) as decimal(16,4)) / CAST(MAX ([W1].[waiting_tasks_count]) AS DECIMAL (16,4)) AS DECIMAL (10,4)) AS [AvgSig_S],
CAST ('https://www.sqlskills.com/help/waits/' + MAX ([W1].[wait_type]) as XML) AS [Help/Info URL]
FROM [tempdb].[dbo].[waitstatistcs_by_waittype] AS W1
INNER JOIN [tempdb].[dbo].[waitstatistcs_by_waittype] AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.signal_wait_time_s, W1.resource_wait_time_s, W1.pct_of_all_waits
HAVING SUM(W2.pct_of_all_waits) - W1.pct_of_all_waits < @percentthreshold OPTION (RECOMPILE); -- percentage threshold

