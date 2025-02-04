USE [master]
GO
/* if the instance does not have XP_CMDSHELL enabled, enabled it
This is required to confirm the existence of the instance's default audit path
*/
EXEC sp_configure 'show advanced options', 1;
GO
Reconfigure;
GO
  
EXEC sp_configure 'xp_cmdshell',1
GO
Reconfigure
GO
-- 1 - Variable declaration
DECLARE @shellcmd NVARCHAR(400)
DECLARE @AuditDataPathRoot nvarchar(15)
DECLARE @AuditDataPath nvarchar(50)
DECLARE @InstanceName NVARCHAR(128)
DECLARE @AuditScope NVARCHAR(50)
DECLARE @AuditPurpose NVARCHAR(50)

SET @AuditDataPathRoot = 'D:\SQLAudits\'
SET @AuditScope = 'Server\'
SET @AuditPurpose = 'Security\'

SELECT @InstanceName = (ISNULL(CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128)),'MSSQLSERVER') + N'\')

SET @AuditDataPath = (@AuditDataPathRoot + @InstanceName + @AuditScope + @AuditPurpose)
SET @shellcmd = N'mkdir ' + @AuditDataPath
EXEC [master]..xp_cmdshell @shellcmd

SELECT @AuditDataPath

EXEC sp_configure 'show advanced options', 1;
GO
Reconfigure;
GO
  
EXEC sp_configure 'xp_cmdshell',0
GO
Reconfigure
GO
