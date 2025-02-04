use msdb
go
/*
To purge the backup history for a given database and before a certain date, the MS provided stored procedures in MSDB cannot be used
Either it deletes all backup history before a date or it deletes all backup history for a database.
There is no way to specify purging using both parameters in combination.
Therefore a custom procedure is required.  Per MSSQL documentation, the following MSDB tables are impacted when purging backup history (using the MS stored procedures)
backupfile
backupfilegroup
backupmediafamily
backupmediaset
backupset -- PK = backup_set_id
restorefile
restorefilegroup
restorehistory

BACKUPSET--Contains a row for each backup set. A backup set contains the backup from a single, successful backup operation. RESTORE, RESTORE FILELISTONLY, RESTORE HEADERONLY, and RESTORE VERIFYONLY statements operate on a single backup set within the media set on the specified backup device or devices. 
BACKUPMDIASET--Contains one row for each backup media set. This table is stored in the msdb database.  Media sets cannot contain more than one type of device, so creating a media set that utilizes both a file and a tape is not possible 
BACKUPMEDIAFAMILY--Contains one row for each media family. If a media family resides in a mirrored media set, the family has a separate row for each mirror in the media set. This table is stored in the msdb database. 
BACKUPFILE--Contains one row for each data or log file of a database. The columns describes the file configuration at the time the backup was taken. Whether or not the file is included in the backup is determined by the is_present column. This table is stored in the msdb database. 
BACKUPFILEGROUP--Contains one row for each filegroup in a database at the time of backup. backupfilegroup is stored in the msdb database. 

Even though the database_name is the same, if the database was "replaced" or recreated, the FULL backup of the previous copy cannot be used as the base of a DIFFERENTIAL of the new database with the same name.
So for the backup history/validation, the most recent full must:
--a SQL file based backup (as no validation of the SQL backups by external systems is performed)
--be AFTER the database create date
--be a FULL backup
--the backup file must still exist

*/
use msdb
go

declare @historylookback int = 4
DECLARE @HistoryLookbackDate DATE
SET @HistoryLookbackDate = DATEADD(day, -@historylookback,GETDATE())


SELECT 
RANK () OVER (PARTITION BY [BUS1].[database_name] ORDER BY [BUS1].[backup_finish_date] desc) as BackupOrder, 
[BUS1].[server_name] as ServerName, 
[BUS1].[machine_name] as MachineName, 
isnull(SERVERPROPERTY ('InstanceName'),'Default') as InstanceName, 
[BUS1].[database_name] as DatabaseName, 
CASE CHARINDEX('\\',[BUMF1].[physical_device_name]) WHEN 1 THEN [BUMF1].[physical_device_name] ELSE '\\' + [BUS1].[machine_name] + '\' + REPLACE([BUMF1].[physical_device_name],':','$') END as PhysicalDeviceName, 
CASE CHARINDEX('\\',[BUMF1].[physical_device_name]) WHEN 1 THEN 1 ELSE 0 END as IsUNCPath, 
CASE [BUS1].[type]
WHEN 'D' THEN 'Database' 
WHEN 'I' THEN 'Differential database'
WHEN 'L' THEN 'Log' 
WHEN 'F' THEN 'File or filegroup'
WHEN 'G' THEN 'Differential file'
WHEN 'P' THEN 'Partial'
WHEN 'Q' THEN 'Differential partial'
ELSE 'UNKNOWN'
END AS backup_type, 
[BUMF1].[device_type],
CASE WHEN  CHARINDEX('(local)',[BUMF1].[physical_device_name]) = 1 THEN 'Cohesity'
	 WHEN CHARINDEX('vd_',[BUMF1].[physical_device_name]) = 1 THEN 'Avamar'
	 WHEN CHARINDEX('EMCAPM',[BUMF1].[physical_device_name]) = 1 THEN 'AppSync'
	 ELSE 'Other'
END as BackupPlatform, 
DATENAME(dw,[BUS1].backup_start_date),
CASE WHEN DATEPART(hh,[BUS1].backup_start_date) > 12 THEN CAST(DATENAME(hh,[BUS1].backup_start_date) - 12 AS VARCHAR(4)) + ' PM' ELSE 
CAST(DATEPART(hh,[BUS1].backup_start_date) AS VARCHAR(4)) + ' AM' END,
[BUS1].backup_start_date as BackupStartDate,
[BUS1].backup_finish_date as BackupFinishDate
,[BUMF1].[media_set_id] as MediaSetID
,[BUS1].[backup_set_id] as BackupSetID 
FROM [dbo].[backupset] AS BUS1
INNER JOIN [dbo].[backupmediafamily] AS BUMF1
ON [BUS1].[media_set_id] = [BUMF1].[media_set_id]  
WHERE 
[BUS1].[backup_finish_date] >= @HistoryLookbackDate
--AND [BUS1].[database_name] = @pDatabaseName
--AND [BUMF1].[device_type] = 2
ORDER BY [backup_finish_date] DESC



--SELECT 
--CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
--BUS1.database_name, 
--BUS1.backup_start_date, 
--BUS1.backup_finish_date, 
--BUS1.expiration_date,
--BUS1.[type] ,
--BUS1.database_backup_lsn,
--CASE BUS1.[type]
--WHEN 'D' THEN 'Database' 
--WHEN 'I' THEN 'Differential database'
--WHEN 'L' THEN 'Log' 
--WHEN 'F' THEN 'File or filegroup'
--WHEN 'G' THEN 'Differential file'
--WHEN 'P' THEN 'Partial'
--WHEN 'Q' THEN 'Differential partial'
--ELSE 'UNKNOWN'
--END AS backup_type, 
--BUS1.backup_size
--FROM msdb.dbo.backupset as BUS1
--WHERE 
--[BUS1].[backup_finish_date] < @HistoryLookbackDate
----AND BUS1.database_name LIKE 'propertylocation_dev'




/*
--gets all the media sets--A media set consists of one or more devices of a single type.  
SELECT * FROM msdb.dbo.backupmediaset; 

SELECT b.* FROM msdb.dbo.backupset b 
INNER JOIN msdb.dbo.backupmediaset m ON b.media_set_id = m.media_set_id 
WHERE m.media_set_id = 17837; 

       

SELECT
CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
[database_name],
[backup_start_date],
[backup_finish_date],
[expiration_date],
[type],
[database_backup_lsn],
CASE BUS1.[type]
WHEN 'D' THEN 'Database' 
WHEN 'I' THEN 'Differential database'
WHEN 'L' THEN 'Log' 
WHEN 'F' THEN 'File or filegroup'
WHEN 'G' THEN 'Differential file'
WHEN 'P' THEN 'Partial'
WHEN 'Q' THEN 'Differential partial'
ELSE 'UNKNOWN'
END AS backup_type, 
[backup_size],
[backup_set_id],
[backup_set_uuid],
[media_set_id],
[first_family_number],
[first_media_number],
[last_family_number],
[last_media_number],
[catalog_family_number],
[catalog_media_number],
[position],
[name],
[first_lsn],
[last_lsn],
[checkpoint_lsn],
[database_creation_date],
[database_version],
[machine_name],
[recovery_model],
[begins_log_chain],
[first_recovery_fork_guid],
[last_recovery_fork_guid],
[fork_point_lsn],
[database_guid],
[family_guid],
[differential_base_lsn],
[differential_base_guid]
FROM msdb.dbo.backupset as BUS1
 --ON BMF1.media_set_id = BUS1.media_set_id 
WHERE 
--(CONVERT(datetime, BUS1.backup_start_date, 102) >= GETDATE() - 365) 
--AND 
BUS1.database_name LIKE 'backuptest1'
ORDER BY 
BUS1.database_name, 
BUS1.backup_finish_date 

SELECT 
[SMF1].[database_id]
,[BUMS1].[database_name]
,[BUMS1].[backup_set_id]
,[BUMS1].[media_set_id]
,[BUMF1].device_type
,[BUMS1].[type] as backup_type
,[SMF1].[create_date] as sys_databases_create_date
,BUMS1.[database_creation_date] as backupset_database_create_date
,[BUMS1].[backup_finish_date]
,[bums1].[begins_log_chain]
,[BUMS1].[checkpoint_lsn]
,[bums1].[database_backup_lsn]
FROM master.sys.databases as SMF1
LEFT OUTER JOIN  msdb.dbo.backupset AS BUMS1
ON [BUMS1].[database_name] = [SMF1].[name]

*/





/* 


*/

/*
DECLARE @P1 NVARCHAR(128)
SET @P1 = '%'


SELECT 
[SMF1].[database_id]
,[BUMS1].[database_name]
,[BUMS1].[backup_set_id]
,[BUMS1].[media_set_id]
,[BUMF1].device_type
,[BUMS1].[type] as backup_type
,[SMF1].[create_date] as sys_databases_create_date
,BUMS1.[database_creation_date] as backupset_database_create_date
,[BUMS1].[backup_finish_date]
,[bums1].[begins_log_chain]
,[BUMS1].[checkpoint_lsn]
,[bums1].[database_backup_lsn]
FROM master.sys.databases as SMF1
LEFT OUTER JOIN  msdb.dbo.backupset AS BUMS1
ON [BUMS1].[database_name] = [SMF1].[name]
INNER JOIN 
(SELECT DISTINCT 
media_set_id
,device_type
FROM msdb.dbo.backupmediafamily
) as BUMF1
ON [BUMS1].[media_set_id] = [BUMF1].[media_set_id]
WHERE [database_name] LIKE @p1
--AND [type] = CAST('D' as CHAR(1))
AND [is_damaged] = 0
AND [is_copy_only] = 0
AND ([expiration_date] >= GETDATE() OR [expiration_date] IS NULL)
ORDER BY [BUMS1].[media_set_id]



SELECT 
[SMF1].[database_id]
,[BUMS1].[database_name]
,[BUMS1].[backup_set_id]
,[BUMS1].[media_set_id]
,[BUMF1].device_type
,[BUMS1].[type] as backup_type
,[SMF1].[create_date] as sys_databases_create_date
,BUMS1.[database_creation_date] as backupset_database_create_date
,[BUMS1].[backup_finish_date]
,[bums1].[begins_log_chain]
,[BUMS1].[checkpoint_lsn]
,[bums1].[database_backup_lsn]
FROM  msdb.dbo.backupset AS BUMS1
LEFT OUTER JOIN  master.sys.databases as SMF1
ON [BUMS1].[database_name] = [SMF1].[name]
INNER JOIN 
(SELECT DISTINCT 
media_set_id
,device_type
FROM msdb.dbo.backupmediafamily
) as BUMF1
ON [BUMS1].[media_set_id] = [BUMF1].[media_set_id]
WHERE [database_name] LIKE @p1
--AND [type] = CAST('D' as CHAR(1))
AND [is_damaged] = 0
AND [is_copy_only] = 0
AND ([expiration_date] >= GETDATE() OR [expiration_date] IS NULL)
ORDER BY bums1.backup_finish_date
*/

/*
As seen above, the First LSN of 1st transaction log to be restored matches the CheckpointLSN in the full database backup. From there onwards, you can determine the serial order such that the LastLSN of T-Log backup 1 matches FirstLSN of T-log backup 2 and so on. This is because Transaction Log backups are sequential in nature.

 

ü  For differential backups, you can notice that their DatabaseBackupLSN should be the same as the CheckpointLSN in the full database backup. 

Also note that as differential backups are cumulative in nature, restoring the latest differential backup (identified by larger CheckpointLSN) will save some time in the Restore process.
https://www.mssqltips.com/sqlservertip/3209/understanding-sql-server-log-sequence-numbers-for-backups/

*/

