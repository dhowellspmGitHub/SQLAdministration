CREATE EVENT SESSION [LongRunningQueries] ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(SET collect_statement=(1)
    ACTION(package0.collect_system_time
	,package0.event_sequence
	,sqlos.task_time
	,sqlserver.client_app_name
	,sqlserver.client_hostname
	,sqlserver.database_name
	,sqlserver.plan_handle
	,sqlserver.query_hash
	,sqlserver.query_plan_hash
	,sqlserver.session_id
	,sqlserver.sql_text
	,sqlserver.transaction_id
	,sqlserver.transaction_sequence)
    WHERE ([package0].[greater_than_int64]([duration],(2000000))
	AND [package0].[greater_than_uint64]([sqlserver].[database_id],(4)))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(package0.collect_system_time
	,package0.event_sequence
	,sqlos.task_time
	,sqlserver.client_app_name
	,sqlserver.client_hostname
	,sqlserver.database_name
	,sqlserver.plan_handle
	,sqlserver.query_hash
	,sqlserver.query_plan_hash
	,sqlserver.session_id
	,sqlserver.sql_text
	,sqlserver.transaction_id
	,sqlserver.transaction_sequence)
    WHERE ([package0].[greater_than_int64]([duration],(2000000))
	AND [package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) 
ADD TARGET package0.event_file(SET filename=N'D:\SQLAdministration\ExtendedEvents\LongRunningQueries.xel',max_rollover_files=(10))
WITH (
MAX_MEMORY=4096 KB
,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS
,MAX_DISPATCH_LATENCY=30 SECONDS
,MAX_EVENT_SIZE=0 KB
,MEMORY_PARTITION_MODE=NONE
,TRACK_CAUSALITY=ON
,STARTUP_STATE=ON)
GO


ALTER EVENT SESSION [LongRunningQueries]  ON SERVER STATE = start