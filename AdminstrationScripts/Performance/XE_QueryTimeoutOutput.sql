/*
Must change the file path to the actual path used
*/
DECLARE @localfilepath NVARCHAR(256)
SET @localfilepath = N'D:\SQLAdministration\ExtendedEvents\ClientTimeouts*.xel'
If exists (select * from tempdb.sys.tables where name = 'client_timeout_events')
begin
drop table tempdb.dbo.client_timeout_events
end


SELECT 
object_name,
CAST(event_data as xml) AS event_data
INTO tempdb.dbo.client_timeout_events
FROM sys.fn_xe_file_target_read_file(@localfilepath,NULL, null, null)

--EE Timestamps are UTC time--use this equation to convert to local time DATEADD(MILLISECOND,DATEDIFF(MILLISECOND,getutcdate(),GETDATE()),@DT) where @DT is the column or value to convert
SELECT 
DATEADD(MILLISECOND,DATEDIFF(MILLISECOND,getutcdate(),GETDATE()),CAST(xed.event_data.value('(@timestamp)[1]', 'datetime2(7)') AS DATETIME2(7)))  as ts
,xed.event_data.value('(@name)[1]', 'varchar(25)')  as actionname
,xed.event_data.value('(action[@name="event_sequence"]/value)[1]','varchar(25)') as seq
,xed.event_data.value('(action[@name="last_error"]/value)[1]','varchar(2000)') as last_error
,(xed.event_data.value('(data[@name="duration"]/value)[1]','bigint')/1000) as duration_ms
,xed.event_data.value('(data[@name="statement"]/value)[1]','varchar(8000)') as [statement]
,xed.event_data.value('(action[@name="session_id"]/value)[1]', 'bigint') as sessionid
,xed.event_data.value('(action[@name="client_hostname"]/value)[1]', 'varchar(50)') as chostname
,xed.event_data.value('(action[@name="client_hostname"]/value)[1]', 'varchar(50)') as chostname
,xed.event_data.value('(action[@name="client_app_name"]/value)[1]', 'varchar(128)') as cappname
,xed.event_data.value('(action[@name="username"]/value)[1]', 'varchar(50)') as username
,xed.event_data.value('(action[@name="server_principal_name"]/value)[1]', 'varchar(50)') as server_principal_name
,xed.event_data.value('(action[@name="client_pid"]/value)[1]', 'bigint') as client_pid
,xed.event_data.value('(action[@name="database_id"]/value)[1]', 'bigint') as client_pid
,xed.event_data.value('(action[@name="database_name"]/value)[1]', 'varchar(50)') as databasename
,xed.event_data.value('(action[@name="is_system"]/value)[1]', 'bit') as is_system
,xed.event_data.value('(action[@name="sql_text"]/value)[1]', 'varchar(8000)') as sql_text
,xed.event_data.value('(action[@name="query_hash"]/value)[1]', 'varbinary(max)') as query_hash
FROM tempdb.dbo.client_timeout_events
  CROSS APPLY event_data.nodes('//event') AS xed (event_data)
order by ts desc, seq
