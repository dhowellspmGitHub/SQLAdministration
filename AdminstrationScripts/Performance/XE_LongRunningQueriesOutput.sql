If exists (select * from tempdb.sys.tables where name = 'duration_events')
begin
drop table tempdb.dbo.duration_events
end

 --SELECT cast(event_data as xml) FROM sys.fn_xe_file_target_read_file('E:\SQLAdministration\*.xel',NULL, null, null);  
SELECT 
object_name,
CAST(event_data as xml) AS event_data
INTO tempdb.dbo.duration_events
FROM sys.fn_xe_file_target_read_file(N'D:\SQLAdministration\ExtendedEvents\LongRunningQueries*.xel',NULL, null, null)

TRUNCATE TABLE [KFBSQLMgmt].[dbo].[XE_duration_events] 
GO
INSERT INTO [KFBSQLMgmt].[dbo].[XE_duration_events] WITH (TABLOCK)
           ([ts]
           ,[actionname]
           ,[seq]
           ,[trans_id]
           ,[trans_seq]
           ,[duration]
           ,[statement]
           ,[sessionid]
           ,[chostname]
           ,[cappname]
           ,[databasename]
           ,[sql_text]
           ,[plan_handle]
           ,[query_hash])
SELECT 
xed.event_data.value('(@timestamp)[1]', 'datetime2(7)')  as ts
,xed.event_data.value('(@name)[1]', 'varchar(25)')  as actionname
,xed.event_data.value('(action[@name="event_sequence"]/value)[1]','varchar(25)') as seq
,xed.event_data.value('(action[@name="transaction_id"]/value)[1]','bigint') as trans_id
,xed.event_data.value('(action[@name="transaction_sequence"]/value)[1]','bigint') as trans_seq
,(xed.event_data.value('(data[@name="duration"]/value)[1]','bigint')) as duration
,xed.event_data.value('(data[@name="statement"]/value)[1]','varchar(8000)') as [statement]
,xed.event_data.value('(action[@name="session_id"]/value)[1]', 'bigint') as sessionid
,xed.event_data.value('(action[@name="client_hostname"]/value)[1]', 'varchar(50)') as chostname
,xed.event_data.value('(action[@name="client_app_name"]/value)[1]', 'varchar(128)') as cappname
,xed.event_data.value('(action[@name="database_name"]/value)[1]', 'varchar(50)') as databasename
,xed.event_data.value('(action[@name="sql_text"]/value)[1]', 'varchar(8000)') as sql_text
,xed.event_data.value('(action[@name="plan_handle"]/value)[1]', 'varbinary(max)') as plan_handle
,xed.event_data.value('(action[@name="query_hash"]/value)[1]', 'varbinary(max)') as query_hash
FROM tempdb.dbo.duration_events
  CROSS APPLY event_data.nodes('//event') AS xed (event_data)
order by ts desc, seq

