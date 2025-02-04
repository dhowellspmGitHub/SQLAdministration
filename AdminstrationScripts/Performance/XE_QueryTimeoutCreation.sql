/* http://blog.sqlgrease.com/how-to-detect-query-timeout-errors-with-extended-events/ */
CREATE EVENT SESSION [ClientTimeouts] ON SERVER 
ADD EVENT sqlserver.attention(
    ACTION
	(package0.event_sequence
	,package0.last_error
	,sqlserver.session_id
	,sqlserver.client_app_name
	,sqlserver.client_hostname
	,sqlserver.username
	,sqlserver.client_pid
	,sqlserver.database_id
	,sqlserver.database_name
	,sqlserver.is_system
	,sqlserver.query_hash
	,sqlserver.server_principal_name
	,sqlserver.sql_text)
	WHERE (([package0].[equal_boolean]([sqlserver].[is_system],(0))
	AND [package0].[greater_than_uint64]([sqlserver].[database_id],(4))
	AND [package0].[not_equal_unicode_string]([sqlserver].[client_app_name],N'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'))))
,ADD EVENT sqlserver.error_reported(
    ACTION (package0.event_sequence
	,package0.last_error
	,sqlserver.session_id
	,sqlserver.client_app_name
	,sqlserver.client_hostname
	,sqlserver.username
	,sqlserver.client_pid
	,sqlserver.database_id
	,sqlserver.database_name
	,sqlserver.is_system
	,sqlserver.query_hash
	,sqlserver.server_principal_name
	,sqlserver.sql_text)
    WHERE (([package0].[equal_boolean]([sqlserver].[is_system],(0))
	AND [package0].[greater_than_uint64]([sqlserver].[database_id],(4))
	AND [package0].[not_equal_unicode_string]([sqlserver].[client_app_name],N'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'))))
ADD TARGET package0.event_file(SET filename=N'D:\SQLAdministration\ExtendedEvents\ClientTimeouts.xel',max_rollover_files=(5))
WITH 
(MAX_MEMORY=4096 KB
,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS
,MAX_DISPATCH_LATENCY=30 SECONDS
,MAX_EVENT_SIZE=0 KB
,MEMORY_PARTITION_MODE=NONE
,TRACK_CAUSALITY=ON
,STARTUP_STATE=ON)
GO

ALTER EVENT SESSION [ClientTimeouts]  ON SERVER STATE = start
