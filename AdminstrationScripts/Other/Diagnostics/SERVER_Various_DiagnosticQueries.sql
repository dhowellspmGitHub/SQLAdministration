
-- SQL Server 2008 and R2 Diagnostic Information Queries
-- Glenn Berry 
-- May 2011
-- http://sqlserverperformance.wordpress.com/
-- Twitter: GlennAlanBerry

-- Instance level queries *******************************
DECLARE @run_time DATETIME
DECLARE @run_sequence INT
SET @run_time = GETDATE()

IF NOT EXISTS (SELECT * FROM MSDB.SYS.tables WHERE name LIKE 'DMV_QUERY_TITLES')
BEGIN
	CREATE TABLE MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID INT, TITLE_DESCRIPTION NVARCHAR(2000), QUERY_NARRATIVE VARCHAR(8000))
END
ELSE
BEGIN
	TRUNCATE TABLE MSDB.DBO.DMV_QUERY_TITLES
END

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(1,'SQL and OS Version information',NULL)

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(2,'Hardware information from SQL Server 2008',NULL)

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(5,'configuration values for instance',NULL)

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(6,'File Names and Paths for TempDB and all user databases in instance', 'Things to look at:
 Are data files and log files on different drives?
 Is everything on the C: drive?
 Is TempDB on dedicated drives?
 Are there multiple data files?')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(7, 'Recovery model, log reuse wait description, log file size, log usage size and compatibility level for all databases on instance',
' Things to look at:
 How many databases are on the instance?
 What recovery models are they using?
 What is the log reuse wait description?
 How full are the transaction logs ?
 What compatibility level are they on?')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(8, 'Calculates average stalls per read, per write, and per total input/output for each database file.','Helps determine which database files on the entire instance have the most I/O bottlenecks')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(9,'total buffer usage by database for current instance','Tells you how much memory (in the buffer pool) is being used by each database on the instance')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(10,'Signal Waits for instance','Signal Waits above 10-15% is usually a sign of CPU pressure')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(11,'logins that are connected and how many sessions they have',null)

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(12,'Average Task Counts (run multiple times)','Sustained values above 10 suggest further investigation in that area')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(13,'Get CPU Utilization History for last 180 minutes (in one minute intervals) This version works with SQL Server 2008 and SQL Server 2008 R2 only', null)

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(14,'basic information about memory amounts and state','You want to see "Available physical memory is high"')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(15,'SQL Server Process Address space info (shows whether locked pages is enabled, among other things)','Want to see 0 for process_physical_memory_low; 0 for process_virtual_memory_low')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(16,'Page Life Expectancy (PLE) value for default instance','PLE is a good measurement of memory pressure.
 Higher PLE is better. Below 300 is generally bad.
 Watch the trend, not the absolute value.')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(17,'Memory Clerk Usage for instance','Look for high value for CACHESTORE_SQLCP (Ad-hoc query plans)')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(18,'Find single-use, ad-hoc queries that are bloating the plan cache','Gives you the text and size of single-use ad-hoc queries that waste space in the plan cache
 Enabling optimize for ad hoc workloads for the instance can help (SQL Server 2008 and 2008 R2 only)
 Enabling forced parameterization for the database can help, but test first!')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(19,'Database specific queries -Individual File Sizes and space available for current database','Look at how large and how full the files are and where they are located. Make sure the transaction log is not full!!')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(20, 'I/O Statistics by file for the current database','This helps you characterize your workload better from an I/O perspective')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(21,'Get VLF count for transaction log for the current database','number of rows equals VLF count. Lower is better! High VLF counts can affect write performance and they can make database restore and recovery take longer')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(22,'Top Cached SPs By Execution Count (SQL 2008)', 'which cached stored procedures are called the most often
 This helps you characterize and baseline your workload')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(23,'Top Cached SPs By Avg Elapsed Time (SQL 2008)','find long-running cached stored procedures that may be easy to optimize with standard query tuning techniques')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(24,'Top Cached SPs By Total Worker time (SQL 2008). Worker time relates to CPU cost','find the most expensive cached stored procedures from a CPU perspective. You should look at this if you see signs of CPU pressure')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(25,' Top Cached SPs By Total Logical Reads (SQL 2008). Logical reads relate to memory pressure','find the most expensive cached stored procedures from a memory perspective  You should look at this if you see signs of memory pressure')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(26,'Top Cached SPs By Total Physical Reads (SQL 2008). Physical reads relate to disk I/O pressure','find the most expensive cached stored procedures from a read I/O perspective. You should look at this if you see signs of I/O pressure or of memory pressure')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(27,'Top Cached SPs By Total Logical Writes (SQL 2008). Logical writes relate to both memory and disk I/O pressure','find the most expensive cached stored procedures from a write I/O perspective. You should look at this if you see signs of I/O pressure or of memory pressure')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(28,'Lists the top statements by average input/output usage for the current database','Helps you find the most expensive statements for I/O by SP')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(29,'Possible Bad NC Indexes (writes > reads)','. Look for indexes with high numbers of writes and zero or very low numbers of reads. Consider your complete workload. Investigate further before dropping an index')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(30,'Missing Indexes current database by Index Advantage','Look at last user seek time, number of user seeks to help determine source and importance. SQL Server is overly eager to add included columns, so beware. Do not just blindly add indexes that show up from this query!!!')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(31,'Find missing index warnings for cached plans in the current database','Note: This query could take some time on a busy instance Helps you connect missing indexes to specific stored procedures. This can help you decide whether to add them or not')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(32,'Breaks down buffers used by current database by object (table, index) in the buffer cache','Tells you what tables and indexes are using the most memory in the buffer cache')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(33,'Get Table names, row counts, and compression status for clustered index or heap','Gives you an idea of table sizes, and possible data compression opportunities')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(34,'When were Statistics last updated on all indexes?','Helps discover possible problems with out-of-date statistics
-- Also gives you an idea which indexes are most active')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(35,'Get fragmentation info for all indexes above a certain size in the current database','Note: This could take some time on a very large database--Helps discover possible problems with out-of-date statistics
-- Also gives you an idea which indexes are most active')

INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(36,' Index Read/Write stats (all tables in current DB)','Show which indexes in the current database are most active')
INSERT INTO MSDB.DBO.DMV_QUERY_TITLES (TITLE_ID,TITLE_DESCRIPTION,QUERY_NARRATIVE )
VALUES
(37,'Index usage','Show which indexes in the current database are most active')
-- SQL and OS Version information for current instance
DECLARE @TITLE_ID INT
SET @TITLE_ID = 1
SELECT TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID,
@run_time as rundatetimestamp,
@@SERVERNAME AS [Server Name],
@@VERSION AS [SQL Server and OS Version Info]
FROM MSDB.DBO.DMV_QUERY_TITLES AS TXT1
;


-- SQL Server 2008 RTM is considered an "unsupported service pack" as of April 13, 2010
-- SQL Server 2008 RTM Builds   SQL Server 2008 SP1 Builds     SQL Server 2008 SP2 Builds
-- Build       Description      Build       Description		 Build     Description
-- 1600        Gold RTM
-- 1763        RTM CU1
-- 1779        RTM CU2
-- 1787        RTM CU3    -->	2531		SP1 RTM
-- 1798        RTM CU4    -->	2710        SP1 CU1
-- 1806        RTM CU5    -->	2714        SP1 CU2 
-- 1812		   RTM CU6    -->	2723        SP1 CU3
-- 1818        RTM CU7    -->	2734        SP1 CU4
-- 1823        RTM CU8    -->	2746		SP1 CU5
-- 1828		   RTM CU9    -->	2757		SP1 CU6
-- 1835		   RTM CU10   -->	2766		SP1 CU7
-- RTM Branch Retired     -->	2775		SP1 CU8		-->  4000	   SP2 RTM
--								2789		SP1 CU9
--								2799		SP1 CU10	
--								2804		SP1 CU11	-->  4266      SP2 CU1		
--								2808		SP1 CU12	-->  4272	   SP2 CU2	
--								2816	    SP1 CU13    -->  4279      SP2 CU3	
--								2821		SP1 CU14	-->  4285	   SP2 CU4					   

-- SQL Server 2008 R2 Builds				SQL Server 2008 R2 SP1 Builds
-- Build			Description				Build		Description
-- 10.50.1092		August 2009 CTP2		
-- 10.50.1352		November 2009 CTP3
-- 10.50.1450		Release Candidate
-- 10.50.1600		RTM
-- 10.50.1702		RTM CU1
-- 10.50.1720		RTM CU2
-- 10.50.1734		RTM CU3
-- 10.50.1746		RTM CU4
-- 10.50.1753		RTM CU5
-- 10.50.1765		RTM CU6	 --->				10.50.2425	SP1 April 2011 CTP
-- 10.50.1777		RTM CU7

-- SQL Server Denali
-- Build			Description
-- 11.00.1055		CTP0
-- 11.00.1103		CTP1

-- SQL Azure Builds (most DMV queries don't work on SQL Azure)
-- Build			Description
-- 10.25.9200		RTM Service Update 1
-- 10.25.9268		RTM Service Update 2
-- 10.25.9331		RTM Service Update 3
-- 10.25.9386		RTM Service Update 4
-- 10.25.9445		RTM Service Update 5
-- 10.25.9501		RTM Service Update 5a
-- 10.25.9640		RTM Service Update 6  (April 2011)

-- Hardware information from SQL Server 2008 -- NOT SQL 2012 COMPATIBLE
-- (Cannot distinguish between HT and multi-core)

SET @TITLE_ID = 2
SELECT TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID,
@run_time as rundatetimestamp,
cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count]
--(physical_memory_in_bytes/1048576) AS [Physical Memory (MB)]
--, sqlserver_start_time --, affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
OPTION (RECOMPILE)

--3
-- Get System Manufacturer and model number from 
-- SQL Server Error log. This query might take a few seconds 
-- if you have not recycled your error log recently
EXEC xp_readerrorlog 0,1,"Manufacturer"; 

--4
-- Get processor description from Windows Registry
EXEC xp_instance_regread 
'HKEY_LOCAL_MACHINE',
'HARDWARE\DESCRIPTION\System\CentralProcessor\0',
'ProcessorNameString';


-- Get configuration values for instance

SET @TITLE_ID = 5
SELECT TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID,
@run_time as rundatetimestamp,
name, value, value_in_use, [description] 
FROM sys.configurations 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
ORDER BY name OPTION (RECOMPILE);

-- Focus on
-- backup compression default
-- clr enabled (only enable if it is needed)
-- lightweight pooling (should be zero)
-- max degree of parallelism (depends on your workload)
-- max server memory (MB) (set to an appropriate value)
-- optimize for ad hoc workloads (should be 1)
-- priority boost (should be zero)


SET @TITLE_ID = 6
-- File Names and Paths for TempDB and all user databases in instance 
SELECT TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID
, @run_time as rundatetimestamp
, DB_NAME([database_id])AS [Database Name]
, [file_id], name, physical_name, type_desc, state_desc
, CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE [database_id] > 4 
AND [database_id] <> 32767
OR [database_id] = 2
ORDER BY DB_NAME([database_id]) OPTION (RECOMPILE);

-- Things to look at:
-- Are data files and log files on different drives?
-- Is everything on the C: drive?
-- Is TempDB on dedicated drives?
-- Are there multiple data files?


-- Recovery model, log reuse wait description, log file size, log usage size 
-- and compatibility level for all databases on instance
SET @TITLE_ID = 7
SELECT TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID
,@run_time as rundatetimestamp
,db.[name] AS [Database Name]
, db.recovery_model_desc AS [Recovery Model]
, db.log_reuse_wait_desc AS [Log Reuse Wait Description]
, ls.cntr_value AS [Log Size (KB)], lu.cntr_value AS [Log Used (KB)]
, CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log Used %]
, db.[compatibility_level] AS [DB Compatibility Level]
, db.page_verify_option_desc AS [Page Verify Option]
, db.is_auto_create_stats_on, db.is_auto_update_stats_on
, db.is_auto_update_stats_async_on, db.is_parameterization_forced
, db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on
FROM sys.databases AS db
INNER JOIN sys.dm_os_performance_counters AS lu 
ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls 
ON db.name = ls.instance_name
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE lu.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE N'Log File(s) Size (KB)%'
AND ls.cntr_value > 0 OPTION (RECOMPILE);

-- Things to look at:
-- How many databases are on the instance?
-- What recovery models are they using?
-- What is the log reuse wait description?
-- How full are the transaction logs ?
-- What compatibility level are they on?


-- Calculates average stalls per read, per write, and per total input/output for each database file. 
SET @TITLE_ID = 8
SELECT TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID
,@run_time as rundatetimestamp
,DB_NAME(fs.database_id) AS [Database Name]
, mf.physical_name, io_stall_read_ms, num_of_reads
,CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms]
,io_stall_write_ms
, num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms]
, io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io]
, CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1))  AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
INNER JOIN sys.master_files AS mf
ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
ORDER BY avg_io_stall_ms DESC OPTION (RECOMPILE);

-- Helps determine which database files on the entire instance have the most I/O bottlenecks


-- Get total buffer usage by database for current instance
SET @TITLE_ID = 9
SELECT 
@TITLE_ID
, @run_time as rundatetimestamp
,DB_NAME(database_id) AS [Database Name]
,COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4 -- system databases
AND database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

-- Tells you how much memory (in the buffer pool) is being used by each database on the instance

-- Clear Wait Stats 
-- DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);

-- Isolate top waits for server instance since last restart or statistics clear
WITH Waits AS
(SELECT wait_type, wait_time_ms / 1000. AS wait_time_s,
100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK',
'SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','WAITFOR', 'LOGMGR_QUEUE','CHECKPOINT_QUEUE',
'REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','BROKER_TO_FLUSH','BROKER_TASK_STOP','CLR_MANUAL_EVENT',
'CLR_AUTO_EVENT','DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
'ONDEMAND_TASK_QUEUE', 'BROKER_EVENTHANDLER'))
SELECT W1.wait_type, 
CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
CAST(W1.pct AS DECIMAL(12, 2)) AS pct,
CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 99 OPTION (RECOMPILE); -- percentage threshold

-- Common Significant Wait types with BOL explanations

-- *** Network Related Waits ***
-- ASYNC_NETWORK_IO		Occurs on network writes when the task is blocked behind the network

-- *** Locking Waits ***
-- LCK_M_IX				Occurs when a task is waiting to acquire an Intent Exclusive (IX) lock
-- LCK_M_IU				Occurs when a task is waiting to acquire an Intent Update (IU) lock
-- LCK_M_S				Occurs when a task is waiting to acquire a Shared lock

-- *** I/O Related Waits ***
-- ASYNC_IO_COMPLETION  Occurs when a task is waiting for I/Os to finish
-- IO_COMPLETION		Occurs while waiting for I/O operations to complete. 
--                      This wait type generally represents non-data page I/Os. Data page I/O completion waits appear 
--                      as PAGEIOLATCH_* waits
-- PAGEIOLATCH_SH		Occurs when a task is waiting on a latch for a buffer that is in an I/O request. 
--                      The latch request is in Shared mode. Long waits may indicate problems with the disk subsystem.
-- PAGEIOLATCH_EX		Occurs when a task is waiting on a latch for a buffer that is in an I/O request. 
--                      The latch request is in Exclusive mode. Long waits may indicate problems with the disk subsystem.
-- WRITELOG             Occurs while waiting for a log flush to complete. 
--                      Common operations that cause log flushes are checkpoints and transaction commits.
-- PAGELATCH_EX			Occurs when a task is waiting on a latch for a buffer that is not in an I/O request. 
--                      The latch request is in Exclusive mode.
-- BACKUPIO				Occurs when a backup task is waiting for data, or is waiting for a buffer in which to store data

-- *** CPU Related Waits ***
-- SOS_SCHEDULER_YIELD  Occurs when a task voluntarily yields the scheduler for other tasks to execute. 
--                      During this wait the task is waiting for its quantum to be renewed.

-- THREADPOOL			Occurs when a task is waiting for a worker to run on. 
--                      This can indicate that the maximum worker setting is too low, or that batch executions are taking 
--                      unusually long, thus reducing the number of workers available to satisfy other batches.
-- CX_PACKET			Occurs when trying to synchronize the query processor exchange iterator 
--						You may consider lowering the degree of parallelism if contention on this wait type becomes a problem

-- Signal Waits for instance
SELECT
10
,@run_time as rundatetimestamp
,CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) AS [%signal (cpu) waits]
, CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) AS [%resource waits]
FROM sys.dm_os_wait_stats OPTION (RECOMPILE);

-- Signal Waits above 10-15% is usually a sign of CPU pressure

--  Get logins that are connected and how many sessions they have 
SELECT 
11
,@run_time as rundatetimestamp
,login_name, COUNT(session_id) AS [session_count] 
FROM sys.dm_exec_sessions 
GROUP BY login_name
ORDER BY COUNT(session_id) DESC OPTION (RECOMPILE);


-- Get Average Task Counts (run multiple times)
SELECT 
12
,@run_time as rundatetimestamp
, AVG(current_tasks_count) AS [Avg Task Count]
, AVG(runnable_tasks_count) AS [Avg Runnable Task Count]
, AVG(pending_disk_io_count) AS [AvgPendingDiskIOCount]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE);

-- Sustained values above 10 suggest further investigation in that area


-- Get CPU Utilization History for last 180 minutes (in one minute intervals)
-- This version works with SQL Server 2008 and SQL Server 2008 R2 only
DECLARE @ts_now bigint 
SELECT @ts_now = (cpu_ticks/(cpu_ticks/ms_ticks)) FROM sys.dm_os_sys_info; 

SET @TITLE_ID = 13
SELECT TOP(50)  TXT1.TITLE_ID, TXT1.TITLE_DESCRIPTION, TXT1.QUERY_NARRATIVE,
@TITLE_ID
,@run_time as rundatetimestamp
,SQLProcessUtilization AS [SQL Server Process CPU Utilization]
, SystemIdle AS [System Idle Process]
, 100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization]
, DATEADD(ms, -1 * (@ts_now - [timestamp])
, GETDATE()) AS [Event Time] 
FROM ( 
	  SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
			AS [SystemIdle], 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
			'int') 
			AS [SQLProcessUtilization], [timestamp] 
	  FROM ( 
			SELECT [timestamp], CONVERT(xml, record) AS [record] 
			FROM sys.dm_os_ring_buffers 
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
			AND record LIKE N'%<SystemHealth>%') AS x 
	  ) AS y 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
ORDER BY record_id DESC OPTION (RECOMPILE);


-- Good basic information about memory amounts and state
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,total_physical_memory_kb
, available_physical_memory_kb
, total_page_file_kb, available_page_file_kb
, system_memory_state_desc
FROM sys.dm_os_sys_memory 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
OPTION (RECOMPILE);

-- You want to see "Available physical memory is high"


-- SQL Server Process Address space info 
--(shows whether locked pages is enabled, among other things)
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, physical_memory_in_use_kb
, locked_page_allocations_kb
, page_fault_count, memory_utilization_percentage
, available_commit_limit_kb, process_physical_memory_low
, process_virtual_memory_low
FROM sys.dm_os_process_memory 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
OPTION (RECOMPILE);

-- You want to see 0 for process_physical_memory_low
-- You want to see 0 for process_virtual_memory_low

-- Page Life Expectancy (PLE) value for default instance
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,counter_name
,cntr_value AS [Page Life Expectancy]
FROM sys.dm_os_performance_counters
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE [object_name] LIKE N'%Manager%' -- Modify this if you have named instances
AND counter_name = N'Page life expectancy' OPTION (RECOMPILE);

-- PLE is a good measurement of memory pressure.
-- Higher PLE is better. Below 300 is generally bad.
-- Watch the trend, not the absolute value.

/*
-- NOT SQL 2012 COMPATIBLE
-- Memory Clerk Usage for instance
-- Look for high value for CACHESTORE_SQLCP (Ad-hoc query plans)
SELECT TOP(20) 
17
,@run_time as rundatetimestamp
,[type] AS [Memory Clerk Type]
, SUM(single_pages_kb) AS [SPA Mem, Kb] 
FROM sys.dm_os_memory_clerks 
GROUP BY [type]  
ORDER BY SUM(single_pages_kb) DESC OPTION (RECOMPILE);
*/
-- CACHESTORE_SQLCP  SQL Plans         These are cached SQL statements or batches that aren't in 
--                                     stored procedures, functions and triggers
-- CACHESTORE_OBJCP  Object Plans      These are compiled plans for stored procedures, 
--                                     functions and triggers
-- CACHESTORE_PHDR   Algebrizer Trees  An algebrizer tree is the parsed SQL text that 
--                                     resolves the table and column names


-- Find single-use, ad-hoc queries that are bloating the plan cache
SELECT TOP(20) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
18
,@run_time as rundatetimestamp
,cp.*
,[text] AS [QueryText], cp.size_in_bytes
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE cp.cacheobjtype = N'Compiled Plan' 
AND cp.objtype = N'Adhoc' 
AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC OPTION (RECOMPILE);

-- Gives you the text and size of single-use ad-hoc queries that waste space in the plan cache
-- Enabling 'optimize for ad hoc workloads' for the instance can help (SQL Server 2008 and 2008 R2 only)
-- Enabling forced parameterization for the database can help, but test first!


-- Database specific queries *****************************************************************

-- **** Switch to a user database *****
USE CC_PROD
GO

DECLARE @run_time DATETIME
DECLARE @run_sequence INT
SET @run_time = GETDATE()
declare @TITLE_ID int

-- Individual File Sizes and space available for current database
SET @TITLE_ID = 19
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,name AS [File Name] 
, physical_name AS [Physical Name], size/128.0 AS [Total Size in MB]
, size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS [Available Space In MB], [file_id]
FROM sys.database_files 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
OPTION (RECOMPILE);

-- Look at how large and how full the files are and where they are located
-- Make sure the transaction log is not full!!
-- I/O Statistics by file for the current database
SET @TITLE_ID = 20
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,DB_NAME(DB_ID()) AS [Database Name],[file_id]
, num_of_reads, num_of_writes
, io_stall_read_ms, io_stall_write_ms
, CAST(100. * io_stall_read_ms/(io_stall_read_ms + io_stall_write_ms) AS DECIMAL(10,1)) AS [IO Stall Reads Pct]
, CAST(100. * io_stall_write_ms/(io_stall_write_ms + io_stall_read_ms) AS DECIMAL(10,1)) AS [IO Stall Writes Pct]
, (num_of_reads + num_of_writes) AS [Writes + Reads], num_of_bytes_read, num_of_bytes_written
, CAST(100. * num_of_reads/(num_of_reads + num_of_writes) AS DECIMAL(10,1)) AS [# Reads Pct]
, CAST(100. * num_of_writes/(num_of_reads + num_of_writes) AS DECIMAL(10,1)) AS [# Write Pct]
, CAST(100. * num_of_bytes_read/(num_of_bytes_read + num_of_bytes_written) AS DECIMAL(10,1)) AS [Read Bytes Pct]
, CAST(100. * num_of_bytes_written/(num_of_bytes_read + num_of_bytes_written) AS DECIMAL(10,1)) AS [Written Bytes Pct]
FROM sys.dm_io_virtual_file_stats(DB_ID(), NULL) 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
OPTION (RECOMPILE);

-- This helps you characterize your workload better from an I/O perspective

--21
-- Get VLF count for transaction log for the current database,
-- number of rows equals VLF count. Lower is better!
DECLARE @T1 TABLE (TITLEID INT, FILEID INT, FILESIZE INT, STARTOFFSET BIGINT, FSEQNO NUMERIC(18,0),  STATUS INT,PARITY INT, CREATELSN NUMERIC(30,0))
INSERT INTO @T1 (TITLEID, FILEID , FILESIZE , STARTOFFSET , FSEQNO ,  STATUS ,PARITY , CREATELSN)
EXEC ('DBCC LOGINFO');

SET @TITLE_ID = 21
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,FILEID 
, FILESIZE 
, STARTOFFSET
, FSEQNO
,[STATUS]
,CASE [STATUS] WHEN 2 THEN 'Active'
ELSE 'Inactive' END as [Status]
, PARITY
, CREATELSN
FROM @T1
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID

-- High VLF counts can affect write performance and they can make database restore and recovery take longer


-- Top Cached SPs By Execution Count (SQL 2008)
SET @TITLE_ID = 22
SELECT TOP(250) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, p.name AS [SP Name], qs.execution_count
, ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second]
, qs.total_worker_time/qs.execution_count AS [AvgWorkerTime], qs.total_worker_time AS [TotalWorkerTime]
,  qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count AS [avg_elapsed_time]
, qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
--WHERE qs.database_id = DB_ID()
ORDER BY qs.execution_count DESC OPTION (RECOMPILE);

-- Tells you which cached stored procedures are called the most often
-- This helps you characterize and baseline your workload


-- Top Cached SPs By Avg Elapsed Time (SQL 2008)
SET @TITLE_ID = 23
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,p.name AS [SP Name], qs.total_elapsed_time/qs.execution_count AS [avg_elapsed_time]
, qs.total_elapsed_time, qs.execution_count, ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time
, GETDATE()), 0) AS [Calls/Second], qs.total_worker_time/qs.execution_count AS [AvgWorkerTime]
, qs.total_worker_time AS [TotalWorkerTime], qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qs.database_id = DB_ID()
ORDER BY avg_elapsed_time DESC OPTION (RECOMPILE);

-- This helps you find long-running cached stored procedures that
-- may be easy to optimize with standard query tuning techniques



-- Top Cached SPs By Total Worker time (SQL 2008). Worker time relates to CPU cost
SET @TITLE_ID = 24
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, p.name AS [SP Name], qs.total_worker_time AS [TotalWorkerTime]
, qs.total_worker_time/qs.execution_count AS [AvgWorkerTime], qs.execution_count
, ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second]
, qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count 
AS [avg_elapsed_time], qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);

-- This helps you find the most expensive cached stored procedures from a CPU perspective
-- You should look at this if you see signs of CPU pressure


-- Top Cached SPs By Total Logical Reads (SQL 2008). Logical reads relate to memory pressure
SET @TITLE_ID = 25
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, p.name AS [SP Name], qs.total_logical_reads AS [TotalLogicalReads]
, qs.total_logical_reads/qs.execution_count AS [AvgLogicalReads],qs.execution_count
, ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second]
, qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count 
AS [avg_elapsed_time], qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_logical_reads DESC OPTION (RECOMPILE);

-- This helps you find the most expensive cached stored procedures from a memory perspective
-- You should look at this if you see signs of memory pressure


-- Top Cached SPs By Total Physical Reads (SQL 2008). Physical reads relate to disk I/O pressure
SET @TITLE_ID = 26
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, p.name AS [SP Name],qs.total_physical_reads AS [TotalPhysicalReads]
, qs.total_physical_reads/qs.execution_count AS [AvgPhysicalReads], qs.execution_count
, qs.total_logical_reads,qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count 
AS [avg_elapsed_time], qs.cached_time 
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qs.database_id = DB_ID()
AND qs.total_physical_reads > 0
ORDER BY qs.total_physical_reads DESC, qs.total_logical_reads DESC OPTION (RECOMPILE);

-- This helps you find the most expensive cached stored procedures from a read I/O perspective
-- You should look at this if you see signs of I/O pressure or of memory pressure
    

-- Top Cached SPs By Total Logical Writes (SQL 2008). 
-- Logical writes relate to both memory and disk I/O pressure 
SET @TITLE_ID = 27
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, p.name AS [SP Name], qs.total_logical_writes AS [TotalLogicalWrites]
, qs.total_logical_writes/qs.execution_count AS [AvgLogicalWrites], qs.execution_count
, ISNULL(qs.execution_count/DATEDIFF(Second, qs.cached_time, GETDATE()), 0) AS [Calls/Second]
, qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count AS [avg_elapsed_time]
, qs.cached_time
FROM sys.procedures AS p
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.[object_id] = qs.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_logical_writes DESC OPTION (RECOMPILE);

-- This helps you find the most expensive cached stored procedures from a write I/O perspective
-- You should look at this if you see signs of I/O pressure or of memory pressure


-- Lists the top statements by average input/output usage for the current database
SET @TITLE_ID = 28
SELECT TOP(50) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(qt.objectid) AS [SP Name]
, (qs.total_logical_reads + qs.total_logical_writes) /qs.execution_count AS [Avg IO]
, SUBSTRING(qt.[text],qs.statement_start_offset/2, 
	(CASE 
		WHEN qs.statement_end_offset = -1 
	 THEN LEN(CONVERT(nvarchar(max), qt.[text])) * 2 
		ELSE qs.statement_end_offset 
	 END - qs.statement_start_offset)/2) AS [Query Text]	
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE qt.[dbid] = DB_ID()
ORDER BY [Avg IO] DESC OPTION (RECOMPILE);

-- Helps you find the most expensive statements for I/O by SP

-- Possible Bad NC Indexes (writes > reads)
SET @TITLE_ID = 29
SELECT 
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(s.[object_id]) AS [Table Name]
, i.name AS [Index Name], i.index_id
, user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads]
, user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND s.database_id = DB_ID()
AND user_updates > (user_seeks + user_scans + user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);

-- Look for indexes with high numbers of writes and zero or very low numbers of reads
-- Consider your complete workload
-- Investigate further before dropping an index


-- Missing Indexes current database by Index Advantage
SET @TITLE_ID = 30
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage]
, migs.last_user_seek, mid.[statement] AS [Database.Schema.Table]
, mid.equality_columns, mid.inequality_columns, mid.included_columns
, migs.unique_compiles, migs.user_seeks, migs.avg_total_user_cost, migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
ON mig.index_handle = mid.index_handle
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE mid.database_id = DB_ID() -- Remove this to see for entire instance
ORDER BY index_advantage DESC OPTION (RECOMPILE);

-- Look at last user seek time, number of user seeks to help determine source and importance
-- SQL Server is overly eager to add included columns, so beware
-- Do not just blindly add indexes that show up from this query!!!


-- Find missing index warnings for cached plans in the current database
-- Note: This query could take some time on a busy instance
SET @TITLE_ID = 31
SELECT TOP(25) TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(objectid) AS [ObjectName]
, query_plan, cp.objtype, cp.usecounts
FROM sys.dm_exec_cached_plans AS cp
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
WHERE CAST(query_plan AS NVARCHAR(MAX)) LIKE N'%MissingIndex%'
AND dbid = DB_ID()
ORDER BY cp.usecounts DESC OPTION (RECOMPILE);

-- Helps you connect missing indexes to specific stored procedures
-- This can help you decide whether to add them or not


-- Breaks down buffers used by current database by object (table, index) in the buffer cache
SET @TITLE_ID = 32
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(p.[object_id]) AS [ObjectName]
, p.index_id, COUNT(*)/128 AS [Buffer size(MB)],  COUNT(*) AS [BufferCount]
--, p.data_compression_desc AS [CompressionType]
FROM sys.allocation_units AS a
INNER JOIN sys.dm_os_buffer_descriptors AS b
ON a.allocation_unit_id = b.allocation_unit_id
INNER JOIN sys.partitions AS p
ON a.container_id = p.hobt_id
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE b.database_id = CONVERT(int,DB_ID())
AND p.[object_id] > 100
GROUP BY p.[object_id], p.index_id
,TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION
--, p.data_compression_desc
ORDER BY [BufferCount] DESC OPTION (RECOMPILE);

-- Tells you what tables and indexes are using the most memory in the buffer cache

/*
-- Get Table names, row counts, and compression status for clustered index or heap
SET @TITLE_ID = 33
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(object_id) AS [ObjectName]
, SUM(Rows) AS [RowCount]
--, data_compression_desc AS [CompressionType]
FROM sys.partitions 
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE index_id < 2 --ignore the partitions from the non-clustered index if any
AND OBJECT_NAME(object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(object_id) NOT LIKE 'queue_%' 
AND OBJECT_NAME(object_id) NOT LIKE 'filestream_tombstone%' 
AND OBJECT_NAME(object_id) NOT LIKE 'fulltext%'
AND OBJECT_NAME(object_id) NOT LIKE 'ifts_comp_fragment%'
GROUP BY object_id
--, data_compression_desc
ORDER BY SUM(Rows) DESC OPTION (RECOMPILE);

-- Gives you an idea of table sizes, and possible data compression opportunities
*/
-- When were Statistics last updated on all indexes?
SET @TITLE_ID = 34
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, o.name
, i.name AS [Index Name]
, STATS_DATE(i.[object_id], i.index_id) AS [Statistics Date]
, s.auto_created, s.no_recompute, s.user_created, st.row_count
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.stats AS s WITH (NOLOCK)
ON i.[object_id] = s.[object_id] 
AND i.index_id = s.stats_id
INNER JOIN sys.dm_db_partition_stats AS st WITH (NOLOCK)
ON o.[object_id] = st.[object_id]
AND i.[index_id] = st.[index_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE o.[type] = 'U'
ORDER BY STATS_DATE(i.[object_id], i.index_id) ASC OPTION (RECOMPILE);  

-- Helps discover possible problems with out-of-date statistics
-- Also gives you an idea which indexes are most active


-- Get fragmentation info for all indexes above a certain size in the current database 
-- Note: This could take some time on a very large database
SET @TITLE_ID = 35
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, DB_NAME(database_id) AS [Database Name]
, OBJECT_NAME(ps.OBJECT_ID) AS [Object Name]
, i.name AS [Index Name], ps.index_id, index_type_desc
, avg_fragmentation_in_percent, fragment_count, page_count
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL ,'LIMITED') AS ps
INNER JOIN sys.indexes AS i 
ON ps.[object_id] = i.[object_id] 
AND ps.index_id = i.index_id
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE database_id = DB_ID()
AND page_count > 500
ORDER BY avg_fragmentation_in_percent DESC OPTION (RECOMPILE);

-- Helps determine whether you have framentation in your relational indexes
-- and how effective your index maintenance strategy is


--- Index Read/Write stats (all tables in current DB)
SET @TITLE_ID = 36
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
, OBJECT_NAME(s.[object_id]) AS [ObjectName]
, i.name AS [IndexName], i.index_id
, s.user_updates AS [Writes], user_seeks + user_scans + user_lookups AS [Reads]
, i.type_desc AS [IndexType], i.fill_factor AS [FillFactor]
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i
ON s.[object_id] = i.[object_id]
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND i.index_id = s.index_id
AND s.database_id = DB_ID()
ORDER BY s.user_updates DESC OPTION (RECOMPILE);

-- Show which indexes in the current database are most active
SET @TITLE_ID = 37
SELECT TXT1.QUERY_NARRATIVE,TXT1.TITLE_DESCRIPTION,
@TITLE_ID
,@run_time as rundatetimestamp
,*
from MSDB.DBO.DMV_QUERY_TITLES
LEFT OUTER JOIN MSDB.DBO.DMV_QUERY_TITLES AS TXT1
ON TXT1.TITLE_ID = @TITLE_ID
