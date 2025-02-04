/*
The "sqlservr" process is made up of many different threads, each one generally (but not always) representing a specific user connection. 
If there are a lot of processes running and the CPU is very high, then it's hard to find the exact process eating up CPU using just the SQL Server tools. 
One way to correlate the data between what is running within SQL Server and at the Windows level is to use SPID and KPID values to get the exact process.

Terms:
•SPID is the SQL Server Process ID number and is assigned by SQL Server to each new connection. It starts with one and is globally unique. SPID 1 through 50 are reserved for system uses and are not used for any user connections. 
•KPID is the kernel-process ID. Under SQL Server for Windows this is the thread ID number, also known as "ID Thread," and is assigned by Windows when the thread is created. The Thread ID number is a system-wide identifier that uniquely identifies the thread. KPID is visible by querying the KPID column of master..sysprocesses. It is only filled in for spid numbers four and higher. You can also get KPID/ID Thread from Windows Perfmon using the "Thread" object and the "ID Thread" counter.

Need to find out what SQL Server thread is causing the high CPU. Once we have this ID Thread we can correlate that ID thread (KPID) to the SPID in SQL Server. 
The instructions below use a combination of SQL system tables and Windows Performance Monitor sessions to correlate SQL SPID and Windows thread to identify the specific session causing high CPU usage

Step 1 -- use Performance Monitor to get the SQL thread.
a) Lauch Performance Monitor  
b) Click on Add counters and select the "Thread" object in the drop down. 
c) Select these counters at the same time:
--% Processor Time 
--ID Thread 
--ID Process
--Thread State 
--Thread Wait Reason
c) Since we are looking for "sqlservr" select all of the instances that begin with "sqlservr" from the list box and click Add. 
d) Review the report searching for thread IDs using high CPU--In PM, Press (Ctrl+R) or click on the view Report tab to change from graphical to report view.  Also, the Histogram Bar provides a graphical view of each thread but can be difficult to view if multiple counters are used

Step 2--correlate the Thread ID (KPID) identified in the last step to the SPID. To do this, run the query below.
*/
Declare @PMThreadId int
Set @PMThreadId = 'replace the value with the Thread Id in PM report'
SELECT spid, kpid, dbid, cpu, memusage FROM sysprocesses WHERE kpid= @PMThreadId

--The above query returns the SPID causing the issue. To find how many threads and open transactions this is running, run this query.
DECLARE @ProblemSPID INT
SET @ProblemSPID = 'replace the value with the Thread Id in PM report'
SELECT spid, kpid, status, cpu, memusage, open_tran, dbid FROM sysprocesses WHERE spid=@ProblemSPID


--Finally, get the exact query that is running, we can run DBCC INPUTBUFFER using the SPID.
DBCC INPUTBUFFER(@ProblemSPID)

