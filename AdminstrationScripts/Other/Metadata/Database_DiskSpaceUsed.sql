
SELECT 
@@SERVERNAME as hostname,
db_name() as databasename,
f.name AS [FileName] 
, f.physical_name AS [PhysicalName]
, CAST((f.size/128.0) AS decimal(10,2)) AS [TotalSizeMB]
, CAST(CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS int)/128.0 AS decimal(10,2)) AS [SpaceUsedMB]
, CAST(f.size/128.0 - CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS int)/128.0 AS decimal(10,2)) AS [AvailableSpaceMB]
, [file_id] as fileid
, fg.name AS [FilegroupName]
,GETDATE() as capturetimestamp
INTO #tempdbspaceused
FROM sys.database_files AS f WITH (NOLOCK)
LEFT OUTER JOIN sys.data_spaces AS fg WITH (NOLOCK)
ON f.data_space_id = fg.data_space_id 
order by f.type, f.name
OPTION (RECOMPILE);



WITH CTE AS (
SELECT [ts2].[hostname] 
      ,[ts2].[databasename]
      ,[ts2].[FileName] as dbfilename
      ,[ts2].[PhysicalName] as physicalname
      ,[ts2].[TotalSizeMB] as totalsizeinmb
      ,[ts2].[SpaceUsedMB] as spaceusedinmb
      ,[ts2].[AvailableSpaceMB] as availablespaceinmb
	  ,RANK() Over(partition by [ts2].[databasename],[ts2].[FileName]   order by  [ts2].[capturetimestamp] desc  ) as filerank
	  ,cast(([ts2].[AvailableSpaceMB]/[ts2].[TotalSizeMB])*100 as decimal(6,3)) as percentavailable
      ,[ts2].[fileid]
      ,[ts2].[FilegroupName] as fgname
	  ,[ts2].[capturetimestamp] as filecapturets
  FROM #tempdbspaceused as ts2
  
  )

Select 
t1.hostname
,t1.databasename
,t1.dbfilename
,t1.physicalname
,t1.filerank
,t1.filecapturets
,t2.filecapturets
,t1.percentavailable - t2.percentavailable as changeinpercentavailable
,t1.totalsizeinmb
,t1.totalsizeinmb - t2.totalsizeinmb as changeintotalspace
--,t1.spaceusedinmb
--,t1.spaceusedinmb - t2.spaceusedinmb as changeinspaceused
,t1.availablespaceinmb
,t1.availablespaceinmb - t2.availablespaceinmb as changeinavailablespace
from CTE as t1
left outer join CTE as t2
on 
t1.databasename = t2.databasename
and t1.fileid = t2.fileid
and t1.filerank = t2.filerank -1
--where t1.filerank <= 5
--and t2.filecapturets is not null

drop table #tempdbspaceused