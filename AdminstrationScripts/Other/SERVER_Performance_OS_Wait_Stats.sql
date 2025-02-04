 
/*********************************************************************************
Author:		Danny Howell

Date:	02/18/2013

SOURCE: copied from 
sys.dm_os_wait_stats >> http://technet.microsoft.com/en-us/library/ms179984(v=sql.105).aspx

WHAT THIS TELLS YOU:
Provides a high level, overall view of the wait types and performance of the SQL server--good to initiate general investigations--
Returns information about all the waits encountered by threads that executed. You can use this aggregated view to diagnose performance issues with SQL Server and also with specific queries and batches.

Also, gives estimate of completion, indicating how much longer a query will process (only for certain types--see sys.dm_exec_requests link above)
--useful to identify the major resource bottleneck
Various columns that provide important details
--wait_type – this is the name of the wait type. There can be three different kinds of wait types – resource, queue and external.
--waiting_tasks_count – this incremental counter is a good indication of frequent the wait is happening. If this number is very high, it is good indication for us to investigate that particular wait type. It is quite possible that the wait time is considerably low, but the frequency of the wait is much high.
--wait_time_ms – this is total wait accumulated for any type of wait. This is the total wait time and includes singal_wait_time_ms.
--max_wait_time_ms – this indicates the maximum wait type ever occurred for that particular wait type. Using this, one can estimate the intensity of the wait type in past. do not over invest here.
--signal_wait_time_ms – this is the wait time when thread is marked as runnable and it gets to the running state. If the runnable queue is very long, you will find that this wait time becomes high.

SEE ALSO: Review the follow up queries at the end of this file
It is possible to reset the values in this view via a DBCC command. The only other time the stats will be reset is after a SQL server restart. 
*********************************************************************************/
/* This query can be run discretely or can be set up to run in a SQL job and repeat per time increment set in the query
Use the WHILE..BREAK..CONTINUE processing to repeat the query--set the date part by changing the date part and the value in the WHILE statement--also set the same in the BREAK section*/

WHILE DATEPART(minute,GETDATE()) < 30
BEGIN
WAITFOR DELAY '00:00:05'


--move the section from IF to END after the query to set up the loop
IF (SELECT DATEPART(minute,GETDATE())) >= 30
	BREAK
		ELSE
	CONTINUE
END

-- following DMV to see how many runnable task counts there are in your system.
-- If runnable_tasks_count continuously for long time (not once in a while) >= 10, there is CPU pressure (give utmost consideration to runnable_tasks_count-- indicates that a large number of queries, which are assigned to the scheduler for processing, are waiting for its turn to run)
SELECT
scheduler_id,
cpu_id,
current_tasks_count,
runnable_tasks_count,
current_workers_count,
active_workers_count,
work_queue_count,
pending_disk_io_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255

--also check perfmon counters of compilations--tend use good amount of CPU


/* Since this is a cummulative statistic since the last reset, inserting to a table shows change over time but the log table is not necessary to see the current state

To log to a table in tempdb--uncomment the variables and the INSERT statement below--move the DDL for the table before the WHILE statement above
*/
IF NOT EXISTS (SELECT * FROM tempdb.sys.tables where name like 'os_wait_stats' and type like 'U')
BEGIN
CREATE TABLE tempdb.dbo.os_wait_stats
(
wait_history_run_id INT,
wait_history_run_datetime datetime,
[wait_type] [nvarchar](60) NOT NULL,
[waiting_tasks_count] [bigint] NOT NULL,
[wait_time_ms] [bigint] NOT NULL,
[max_wait_time_ms] [bigint] NOT NULL,
[signal_wait_time_ms] [bigint] NOT NULL,
[CurrentDateTime] DATETIME NULL,
[Flag] INT
)
END


DECLARE @RunID INT
DECLARE @RunTime DATETIME
DECLARE @HistoryRetention INT

PRINT 'OS Wait History query started at ' + cast(@RunTime as nvarchar(20)) + ' using Run ID=' + cast(@RunID as nvarchar(8))

-- Populate Table at Time 1
INSERT INTO  tempdb.dbo.os_wait_stats
(
wait_history_run_id,
wait_history_run_datetime,
[wait_type]
,[waiting_tasks_count]
,[wait_time_ms]
,[max_wait_time_ms]
,[signal_wait_time_ms]
)


SELECT 
(@runid + 1),
@runtime,
[wait_type],
[waiting_tasks_count],
[wait_time_ms],
[max_wait_time_ms],
[signal_wait_time_ms]
FROM sys.dm_os_wait_stats
GO;


/* FOLLOW UP QUERIES--use the follow up queries to view the history logged in the temp table */

-- Isolate top waits for server instance since last restart or statistics clear 
-- change the table in the FROM clause to sys.dm_os_wait_stats to use the current values

DECLARE @p1 INT -- percentage threshold 
SET  @p1 = 95;
 
WITH Waits AS ( 
   SELECT  
        wait_type,  
        wait_time_ms / 1000. AS [wait_time_s], 
        100 * wait_time_ms / SUM(wait_time_ms) OVER() AS [pct], 
        ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS [rn] 
FROM  tempdb.dbo.os_wait_stats 
WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE', 
    'SLEEP_TASK','SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','WAITFOR','LOGMGR_QUEUE', 
    'CHECKPOINT_QUEUE','REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','BROKER_TO_FLUSH', 
    'BROKER_TASK_STOP','CLR_MANUAL_EVENT','CLR_AUTO_EVENT','DISPATCHER_QUEUE_SEMAPHORE', 
    'FT_IFTS_SCHEDULER_IDLE_WAIT','XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN')
    AND wait_history_run_id = 
    (SELECT MAX(wait_history_run_id) 
    FROM tempdb.dbo.os_wait_stats)
   )

SELECT W1.wait_type,  
    CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
    CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
    CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
FROM Waits AS W1 
INNER JOIN Waits AS W2 ON W2.rn <= W1.rn 
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct 
HAVING SUM(W2.pct) - W1.pct < @p1


-- Total waits are wait_time_ms (high signal waits indicates CPU pressure)
SELECT 
wait_history_run_id,
wait_history_run_datetime,
'%signal (cpu) waits' = CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)),
'%resource waits'= CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2))
FROM tempdb.dbo.os_wait_stats
group by  wait_history_run_id,
wait_history_run_datetime;

