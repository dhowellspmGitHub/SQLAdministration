/*
********************************************************************************
Author:		Danny Howell

Date:	02/18/2013

SOURCE: http://blog.sqlauthority.com/2010/05/14/sql-server-find-most-expensive-queries-using-dmv/
http://msdn.microsoft.com/en-us/library/ms189741(v=sql.105).aspx

KEY DIAGNOSTIC INFORMATION PROVIDED: 
This file is composed of two segments:
First segment captures the current accumulated query statistical data from several DMVs. When these queries are run discretely, they give that point in time value of the cumulative metrics.  If set up to run in a SQL job and repeated (by removing the DROP TABLE statement and utilizing the WHILE..BREAK..CONTINUE processing controls), a 'differential' from the prior cummulative values can be determined thereby providing a 'change metric'

/*********************************************************************/
NOTE ON DBID and DMVs--None of the DMV_EXEC_QUERY... DMVs include a database identifier.
The only method is to join the DMV to the DM_EXEC_QUERY_TEXT to obtain the DBID.
However, for adhoc queries this is null.  Internet research confirms MS does not capture the database ID for the adhoc queries.
Therefore, identifying problematic queries FOR A SPECIFIC/BY DATABASE is not possible
/*********************************************************************/

Second Segment: Various diagnostic queries using information capture in the first segment.  Explanation of each is provided before each query

EXPLANATION:
sys.dm_exec_query_stats--Returns aggregate performance statistics for cached query plans The view contains one row per query statement within the cached plan, and the lifetime of the rows are tied to the plan itself. When a plan is removed from the cache, the corresponding rows are eliminated from this view. 

Useful to find out the most expensive queries on SQL Server Box.  Sort by the metric ex. total_worker_time or total_logical_writes to see the query costing the most CPU or disk IO

GUIDELINES:
A low signal (where signal is less than 25% of the total waits) to resource wait ratio indicates there is little CPU pressure.
*/

--First Segment--Capture query statistics in the plan cache information to a temporary table--uncomment the variables and the INSERT statement below--move the DDL for the table before the WHILE statement above.  The query statistics will clear on a service restart or if manually cleared using DBCC
set nocount on
go
IF EXISTS (SELECT * FROM tempdb.sys.tables where name like 'query_stats' and type like 'U')
BEGIN
DROP TABLE tempdb.dbo.query_stats
END

CREATE TABLE tempdb.dbo.query_stats
(
session_history_run_id INT,
session_history_run_datetime datetime,
database_name nvarchar(128),
[db_id] int,
[query_object_id] BIGINT,
query_hash BINARY(8),
query_plan_hash BINARY(8),
execution_count BIGINT,
creation_time DATETIME,
plan_generation_num bigint,
[last_execution_time_date] NVARCHAR(15),
[last_execution_time_time] NVARCHAR(15),
total_worker_time_ms bigint, 
last_worker_time_ms bigint, 
min_worker_time_ms bigint, 
max_worker_time_ms bigint,
total_elapsed_time_ms	bigint,
last_elapsed_time_ms	bigint,
min_elapsed_time_ms	bigint,
max_elapsed_time_ms	bigint,
total_physical_reads bigint, 
last_physical_reads bigint, 
min_physical_reads bigint,  
max_physical_reads bigint,  
total_logical_writes bigint, 
last_logical_writes bigint, 
min_logical_writes bigint, 
max_logical_writes bigint,
total_logical_reads	bigint,
last_logical_reads	bigint,
min_logical_reads	bigint,
max_logical_reads	bigint,
query_text  NVARCHAR(MAX), 
[sql_handle] varbinary(64),
plan_handle varbinary(64),
--[plan] xml
) 

----Use the  to repeat the query--set the date part by changing the date part and the value in the WHILE statement--also set the same in the BREAK section
DECLARE @StartTime DATETIME
DECLARE @RunTimeMinutes INT

DECLARE @RunID INT
DECLARE @RunTime DATETIME
DECLARE @HistoryRetention INT
SET @StartTime = GETDATE()
SET @RunTimeMinutes = 3

----WHILE  DATEPART(minute,GETDATE()) < 30
--WHILE  DATEDIFF(MINUTE,@StartTime,Cast(getdate() as datetime)) < @RunTimeMinutes
--BEGIN

----if not saving to a table\running ad hoc, comment out the @RunId and @Runtime variables; 
----you can also get the execution plan of each query by uncommenting out the dm_eqp.query_plan column and the CROSS APPLY sys.dm_exec_query_plan(plan_handle) as dm_eqp lines but this will greatly increase query run time
 
SELECT @RunID =  (ISNULL(MAX(session_history_run_id),0)) + 1
FROM tempdb.dbo.query_stats
set @RunTime = cast(getdate() as datetime)
PRINT 'Cache History query started at ' + cast(@RunTime as nvarchar(20)) + ' using Run ID=' + cast(@RunID as nvarchar(8))


INSERT INTO [tempdb].[dbo].[query_stats]
	([session_history_run_id]
	,[session_history_run_datetime]
	,[database_name]
	,[db_id]
	,[query_object_id]
	,[query_hash]
	,[query_plan_hash]
	,[execution_count]
	,[creation_time]
	,[plan_generation_num]
	,[last_execution_time_date]
	,[last_execution_time_time]
	,[total_worker_time_ms]
	,[last_worker_time_ms]
	,[min_worker_time_ms]
	,[max_worker_time_ms]
	,[total_elapsed_time_ms]
	,[last_elapsed_time_ms]
	,[min_elapsed_time_ms]
	,[max_elapsed_time_ms]
	,[total_physical_reads]
	,[last_physical_reads]
	,[min_physical_reads]
	,[max_physical_reads]
	,[total_logical_writes]
	,[last_logical_writes]
	,[min_logical_writes]
	,[max_logical_writes]
	,[total_logical_reads]
	,[last_logical_reads]
	,[min_logical_reads]
	,[max_logical_reads]
	,[query_text]
	,[sql_handle]
	,[plan_handle]
	--,[plan]
     )
SELECT 
@RunID
,@RunTime,
db_name(dm_est.[dbid]),
dm_est.[dbid],
--dm_est.[object_id],
0,
dm_qs.query_hash,
dm_qs.query_plan_hash,
dm_qs.execution_count, 
dm_qs.creation_time,
dm_qs.plan_generation_num, 
CONVERT(nvarchar(15),dm_qs.last_execution_time,101) as last_execution_day,
CONVERT(nvarchar(15),dm_qs.last_execution_time, 114) as last_execution_time,
cast(dm_qs.total_worker_time / 1000 as bigint) as total_worker_time_milliseconds, 
cast(dm_qs.last_worker_time  / 1000 as bigint) as last_worker_time_milliseconds,
cast(dm_qs.min_worker_time /1000 as bigint) as min_worker_time_milliseconds,
cast(dm_qs.max_worker_time / 1000 as bigint) as max_worker_time_milliseconds,
cast([total_elapsed_time] / 1000 as bigint) as total_elapsed_time_milliseconds,
cast([last_elapsed_time]/ 1000 as bigint) as last_elapsed_time_milliseconds,
cast([min_elapsed_time] / 1000 as bigint) as min_elapsed_time_milliseconds,
cast([max_elapsed_time] / 1000 as bigint) as max_elapsed_time_milliseconds,
dm_qs.total_physical_reads, 
dm_qs.last_physical_reads, 
dm_qs.min_physical_reads,  
dm_qs.max_physical_reads,  
dm_qs.total_logical_writes, 
dm_qs.last_logical_writes, 
dm_qs.min_logical_writes, 
dm_qs.max_logical_writes, 
[total_logical_reads],
[last_logical_reads],
[min_logical_reads],
[max_logical_reads],
(SELECT TOP 1 SUBSTRING(dm_est.text,statement_start_offset / 2+1 , 
	( (CASE WHEN  dm_qs.statement_end_offset = -1 
	THEN (LEN(CONVERT(nvarchar(max),dm_est.text)) * 2) 
	ELSE dm_qs.statement_end_offset END)  - dm_qs.statement_start_offset) / 2+1))  AS sql_statement,
dm_qs.sql_handle,   
dm_qs.plan_handle
--,dm_eqp.query_plan
FROM sys.dm_exec_query_stats AS dm_qs with (nolock)
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS dm_est  
--CROSS APPLY sys.dm_exec_query_plan(plan_handle) as dm_eqp
--WHERE dm_est.objectid is null

--WAITFOR DELAY '00:00:05'
------move the section from IF to END after the query to set up the loop
----IF (SELECT DATEPART(minute,GETDATE())) >= 30
--IF (DATEDIFF(MINUTE,@StartTime,Cast(getdate() as datetime))) >= @RunTimeMinutes
--	BREAK
--		ELSE
--	CONTINUE
--END


/* FOLLOW UP QUERIES--use the follow up queries to view the history logged in the temp table */

/* Largest IO queriesThe underlying purpose of an index suggested by sys.dm_db_missing_index_columns, is to avoid doing large amounts of IO for the query in question. Therefore, you can expect such queries to rank among the highest IO queries. To find the highest IO queries, you can use the following sample code:
https://www.red-gate.com/simple-talk/blogs/how-to-find-cpu-intensive-queries/
https://blog.heroix.com/blog/sql-server-cpu-dmv-queries
*/


DECLARE @ResultsLabel varchar(100)
SET @ResultsLabel = 'Largest IO queries'

--SELECT --TOP 50
--@ResultsLabel
--,([qs1].[total_logical_reads] + [qs1].[total_logical_writes]) /ISNULL([qs1].[execution_count],1) as [AvgIO]
--,[qs1].[query_text]
--,[qs1].[db_id]
--,[qs1].[query_object_id]
--FROM [tempdb].[dbo].[query_stats] AS qs1
--ORDER BY [AvgIO] DESC


/* CPU pressure-- Top X executed SP's with rankings of metric column--change the ORDER BY clause to sort by metrics
GUIDELINES:
--% Processor Time > 80%  --  SQL Server CPU is under stress
--Processor Queue Length > 2  --   Processes are waiting for CPU cycles
--A low signal (where signal is less than 25% of the total waits) to resource wait ratio indicates there is little CPU pressure.

*/
--declare @ResultsLabel varchar(50)
declare @delimiterleader varchar(1)
declare @delimitertrailer varchar(1)
set @delimiterleader = null --'|"' 
set @delimitertrailer = null -- '"|'
SET @ResultsLabel = 'CPU bound'

SELECT TOP 20
@ResultsLabel as ResultLabel
,qs.session_history_run_id
,qs.session_history_run_datetime
,coalesce(qs_cp.[dbid],qs.[db_id]) as database_id
,coalesce(qs.database_name,db_name(cast(qs_cp.[dbid] as bigint)))
--,qs.query_hash
,qs.last_execution_time_date
,qs.last_execution_time_time
--,qs.plan_generation_num
,qs.query_text AS [QueryText]
,qs.execution_count AS [ExecutionCount]
,qs.total_worker_time_ms AS [TotalWorkerTime]
--,qs.max_logical_reads
--,qs.max_logical_writes
,ROW_NUMBER() OVER (ORDER BY (qs.total_elapsed_time_ms) desc) as [TotalElapsedTimeOrder]
,ROW_NUMBER() OVER (ORDER BY (qs.total_elapsed_time_ms/qs.execution_count) desc) as [DurationOrder]
,ROW_NUMBER() OVER (ORDER BY (qs.execution_count) desc) as [ExecutionCountOrder]
,ISNULL(qs.total_worker_time_ms/qs.execution_count,0) AS [AvgWorkerTime]
,ISNULL(qs.total_elapsed_time_ms/qs.execution_count, 0) AS [AvgElapsedTime]
--,ISNULL(qs.execution_count/
--	(CASE WHEN DATEDIFF(SECOND, qs.creation_time, GetDate()) = 0 THEN 1 ELSE DATEDIFF(SECOND, qs.creation_time, GetDate()) END)
--	, 1) AS [CallsPerSecond]
--,DATEDIFF(Minute, qs.creation_time, GetDate()) AS [AgeInCache]
,@delimiterleader + qs.query_text + @delimitertrailer AS [TSQLStatement]
--,qs.[plan] as execution_plan
FROM tempdb.dbo.query_stats as qs with (nolock)
LEFT OUTER JOIN 
	(SELECT plan_handle, pvt.dbid, pvt.sql_handle
FROM (
    SELECT plan_handle, epa.attribute, epa.value 
    FROM sys.dm_exec_cached_plans with (nolock)
        OUTER APPLY sys.dm_exec_plan_attributes(plan_handle)  AS epa 
    WHERE cacheobjtype = 'Compiled Plan' AND objtype = 'adhoc') AS ecpa 
PIVOT (MAX(ecpa.value) FOR ecpa.attribute IN ("dbid", "sql_handle")) AS pvt) AS qs_cp
ON qs.sql_handle = qs_cp.sql_handle
--where coalesce(qs_cp.[dbid],qs.[db_id]) > 4
--last_execution_time_date >= cast(getdate() as date)
--and qs.execution_count > 5
ORDER BY 
ROW_NUMBER() OVER (ORDER BY (qs.total_elapsed_time_ms/qs.execution_count) desc),
ROW_NUMBER() OVER (ORDER BY (qs.total_elapsed_time_ms) desc),
qs.total_worker_time_ms/qs.execution_count desc
--ISNULL(qs.total_elapsed_time_ms/qs.execution_count, 0) desc, qs.total_worker_time_ms DESC;


/*
Query plan reuse and DMVs -- High query plan reuse is important for OLTP applications where there are many identical transactions. The advantage of plan reuse means you 
will not incur the CPU cost of optimization for each execution of the same plan. The statements with the lowest plan reuse can be found using DMVs as follows:
DMV reports statements with lowest plan reuse
Add a USE database 

 https://technet.microsoft.com/en-us/library/cc645887(v=sql.105).aspx 
 http://blogs.msdn.com/b/sqlprogrammability/archive/2007/01/23/4-0-useful-queries-on-dmv-s-to-understand-plan-cache-behavior.aspx 
*/
 


SET @ResultsLabel = 'Query plan reuse and DMVs'
SELECT TOP 20 
@ResultsLabel
,[qs1].[query_plan_hash] AS [QueryHash]
,COUNT([qs1].[plan_handle]) AS [DistinctPlanHandles]
,rank() OVER (PARTITION BY [qs1].[query_plan_hash] ORDER BY count([qs1].[query_text])) as numberordups
,count([qs1].[query_text]) as SimilarQueries
,sum([qs1].[execution_count]) as CummulativeSimilarQueries
,(SUM([qs1].[total_worker_time_ms])/SUM([qs1].[execution_count])) AS [AvgWorkerTime]
,SUM([qs1].[total_worker_time_ms]) / SUM([qs1].[execution_count]) AS [AvgCPUTime]
,MIN([qs1].[query_text]) AS [StatementText]
FROM tempdb.dbo.query_stats as qs1
WHERE [qs1].[db_id] > 4
GROUP BY [qs1].[query_plan_hash];


--Query Execution Counts--Query Plan hashes are

--GET DESCRIPTION 
--USEFUL HOW?
--*/
--SET @ResultsLabel = 'Query Execution Counts'
--SELECT 
--@ResultsLabel
--,[qs1].[sql_handle]
--,[qs1].[plan_handle]
--,[qs1].[db_id]
--,[qs1].[query_object_id]
--,[qs1].[query_text] as [statement]
--,[cp].[cacheobjtype]
--,[cp].[usecounts]
--,[cp].[size_in_bytes]
--FROM [tempdb].[dbo].[query_stats] AS qs1
--inner join sys.dm_exec_cached_plans as cp 
--on [qs1].[plan_handle] = [cp].[plan_handle]
--where [cp].[plan_handle] = [qs1].[plan_handle]
----and [qs1].[database_id] = db_id()    
--ORDER BY [Usecounts] ASC


--/*
--Query Metrics by QueryPlanHash--Query Plan hashes are

--GET DESCRIPTION 
--USEFUL HOW?
--*/
--SELECT 
--[qs1].[query_plan_hash]
--,sum([qs1].[total_worker_time_ms]) AS [TotalWorkerTime]
--,sum([qs1].[total_worker_time_ms])/(sum([qs1].[execution_count])) AS [AvgWorkerTime]
--,sum([qs1].[execution_count]) AS [ExecutionCount]
--,ISNULL(sum([qs1].[execution_count])/sum(DATEDIFF(Second, [qs1].[creation_time], GetDate())), 0) AS [CallsPerSecond]
--,ISNULL(sum([qs1].[total_elapsed_time_ms])/sum([qs1].[execution_count]), 0) AS [AvgElapsedTime]
--,sum([qs1].[max_logical_reads]) as [max_logical_reads]
--,sum([qs1].[max_logical_writes]) as [max_logical_writes]
--,DATEDIFF(Minute, min([qs1].[creation_time]), GetDate()) AS [AgeInCache(Minutes)]
----,[qs1].[plan] as execution_plan
--FROM tempdb.dbo.query_stats as [qs1]
--where [qs1].[last_execution_time_date] >= cast(getdate() as date)
----and [qs1].[execution_count] > 5
--GROUP BY [qs1].[query_plan_hash]

