DECLARE @p1 NVARCHAR(128) = 'RUTest2'
declare @p2  int = 23
DECLARE @Restore_DBPs_Completed_Count int
DECLARE @Restore_DBPs_Failed_Count int
DECLARE @Restore_DBRs_Completed_Count int
DECLARE @Restore_DBRs_Failed_Count int
DECLARE @Restore_DBRPerms_Completed_Count int
DECLARE @Restore_DBRPerms_Failed_Count int
DECLARE @Restore_DBRMs_Completed_Count int
DECLARE @Restore_DBRMs_Failed_Count int
DECLARE @FailureCountTotal int
DECLARE @FailuresInd bit
DECLARE @Restore_Principals_Comments varchar(2000)

--Failed counts include those principals and permissions that were not attempted (completed = FALSE(0) AND failed = FALSE(0))

SELECT @Restore_DBPs_Completed_Count = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_users]
WHERE [databasename] = @p1
AND [restore_completed_ind] = 1

SELECT @Restore_DBPs_Failed_Count = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_users]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 1

SELECT @Restore_DBPs_Failed_Count = @Restore_DBPs_Failed_Count + ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_users]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 0
AND [restore_completed_ind] = 0

SELECT @Restore_DBRs_Completed_Count  = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customroles]
WHERE [databasename] = @p1
AND [restore_completed_ind] = 1

SELECT @Restore_DBRs_Failed_Count  = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customroles]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 1

SELECT @Restore_DBRs_Failed_Count  = @Restore_DBRs_Failed_Count + ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customroles]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 0
AND [restore_completed_ind] = 0


SELECT @Restore_DBRPerms_Completed_Count  = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customrolepermissions]
WHERE [databasename] = @p1
AND [restore_completed_ind] = 1


SELECT @Restore_DBRPerms_Failed_Count  = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customrolepermissions]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 1

SELECT @Restore_DBRPerms_Failed_Count  = @Restore_DBRPerms_Failed_Count + ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_customrolepermissions]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 0
AND [restore_completed_ind] = 0


SELECT @Restore_DBRMs_Completed_Count = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_usersrolemembers]
WHERE [databasename] = @p1
AND [restore_completed_ind] = 1

SELECT @Restore_DBRMs_Failed_Count = ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_usersrolemembers]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 1

SELECT @Restore_DBRMs_Failed_Count =@Restore_DBRMs_Failed_Count + ISNULL(COUNT(*),0)
FROM [dbo].[database_restore_usersrolemembers]
WHERE [databasename] = @p1
AND [restore_failed_ind] = 0
AND [restore_completed_ind] = 0


SELECT @FailureCountTotal = (@Restore_DBPs_Failed_Count  + @Restore_DBRs_Failed_Count + @Restore_DBRPerms_Failed_Count + @Restore_DBRMs_Failed_Count)

IF @FailureCountTotal > 0
BEGIN
SET @FailuresInd = CAST(1 AS BIT)
SET @Restore_Principals_Comments = 'FAILURE: At least one restore action had one or more failure;'
END
ELSE
BEGIN
SET @FailuresInd = CAST(0 AS BIT)
SET @Restore_Principals_Comments = 'COMPLETED: No restore action reported any failures;'
END

SELECT @Restore_Principals_Comments = LEFT((@Restore_Principals_Comments + [Restore_Principals_Comments]),2000)
FROM [dbo].[Databases_Restore_Principals_Summary]
WHERE [DatabaseName] = @p1
AND [Backup_Principals_Job_ID] = @p2

SELECT
@p1 [DatabaseName]
,@p2 [Backup_Principals_Job_ID]
, GETDATE() [Restore_Principals_Task_Endtime] 
, 1 [Restore_Principals_Completed_Ind]
,@FailuresInd [Restore_Principals_Failed_Ind]
,@Restore_DBPs_Completed_Count [Restore_Principals_Completed_Count]
,@Restore_DBPs_Failed_Count [Restore_Principals_Failed_Count]
,@Restore_DBRs_Completed_Count [Restore_CustomRoles_Completed_Count] 
,@Restore_DBRs_Failed_Count [Restore_CustomRoles_Failed_Count]
,@Restore_DBRMs_Completed_Count [Restore_DatabaseRolemembers_Completed_Count]
,@Restore_DBRMs_Failed_Count [Restore_DatabaseRolemembers_Failed_Count]
,@Restore_DBRPerms_Completed_Count [Restore_CustomRolePermissions_Completed_Count]
,@Restore_DBRPerms_Failed_Count [Restore_CustomRolePermissions_Failed_Count] 
