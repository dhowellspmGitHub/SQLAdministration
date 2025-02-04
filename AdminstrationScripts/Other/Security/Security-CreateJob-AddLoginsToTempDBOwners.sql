USE [master]
GO
SELECT [name]
FROM sysobjects
WHERE type = 'P'
AND OBJECTPROPERTY(id, 'ExecIsStartUp') = 1
GO
IF EXISTS (SELECT [name] FROM sysobjects WHERE type = 'P' AND [name] = 'usp_ReassignDBORoleInTempDB')
BEGIN
DROP PROCEDURE [dbo].[usp_ReassignDBORoleInTempDB]
END
GO

CREATE PROCEDURE [dbo].[usp_ReassignDBORoleInTempDB]
AS
BEGIN
	DECLARE @SPLoginName NVARCHAR(128);
	DECLARE @SPLoginType NVARCHAR(1);
	DECLARE @DBPExists BIT;
	DECLARE @DBPIsDBOInd BIT;
	DECLARE @TSQL NVARCHAR(300)


	--get database principals that are only assigned the ''public'' role.  The public role is a default role that has no real access.  These can be removed from the database
	DECLARE @SPNameTbl TABLE ([UserPrincipal] NVARCHAR(128),[UType] VARCHAR(1), [InTempDBInd] BIT, [HasDBOwnerRoleInd] BIT, [IsProcessed] BIT)

	INSERT INTO @SPNameTbl ([UserPrincipal],[UType], [InTempDBInd], [HasDBOwnerRoleInd], [IsProcessed])
	SELECT
	[MSP1].[name]
	,[MSP1].[type]
	,CASE WHEN [TDBRM2].[DBSID] IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END
	,CASE WHEN [TDBRM2].[HasDBOwnerRoleInd] IS NULL THEN CAST(0 AS BIT) ELSE [HasDBOwnerRoleInd] END
	,0
	FROM [master].[sys].[server_principals] as MSP1
	LEFT OUTER JOIN 
		(
		SELECT [tdp2].[sid] AS DBSID,
		[TDP2].[principal_id] AS db_principal_id,[TDR2].[principal_id] AS db_role_id,CASE [TDR2].[name] WHEN 'db_owner' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS [HasDBOwnerRoleInd]
		FROM [tempdb].[sys].[database_principals] AS [TDP2]
		INNER JOIN [tempdb].[sys].[database_role_members] AS [TDPRM2]
		ON [TDP2].[principal_id] = [TDPRM2].[member_principal_id]
		INNER JOIN [tempdb].[sys].[database_principals] AS [TDR2]
		ON [TDR2].[principal_id] = [TDPRM2].[role_principal_id]
		WHERE [TDP2].[type] IN ('u','s','g')
		AND [TDP2].[name] NOT IN ('dbo','guest','information_schema','sys')
		) AS [TDBRM2]
	ON [MSP1].[sid] = [TDBRM2].[DBSID]
	WHERE [MSP1].[type] IN ('u','s','g')
	AND [MSP1].[principal_id] > 100
	AND [MSP1].[name] NOT LIKE '##%'
 


	WHILE (SELECT COUNT(*) FROM @SPNameTbl WHERE [IsProcessed] = 0) > 0
	BEGIN  
		SET @TSQL = ''
		SELECT TOP 1 @SPLoginName = [UserPrincipal]
		,@SPLoginType = [UType]
		,@DBPExists = [InTempDBInd]
		,@DBPIsDBOInd = [HasDBOwnerRoleInd]
		FROM @SPNameTbl WHERE [IsProcessed] = 0

	
		IF NOT EXISTS (select * from tempdb.sys.database_principals WHERE name = @SPLoginName)
		BEGIN
			print 'creating database principal for login--' + @SPLoginName
			SET @TSQL = 'USE [tempdb];' + CHAR(13) + CHAR(10)
			IF @SPLoginType = N'G'
			BEGIN
			SET @TSQL = @TSQL + 'CREATE USER [' + @SPLoginName + '] FOR LOGIN [' + @SPLoginName + '];' + CHAR(13) + CHAR(10)
			END
			ELSE
			BEGIN
			SET @TSQL = @TSQL + 'CREATE USER [' + @SPLoginName + '] FOR LOGIN [' + @SPLoginName + '] WITH DEFAULT_SCHEMA=[dbo];' + CHAR(13) + CHAR(10)
			END

			SET @TSQL = @TSQL + 'ALTER ROLE [db_owner] ADD MEMBER [' + @SPLoginName +']'
			EXEC sp_executesql @TSQL
			PRINT @TSQL
		END
		UPDATE @SPNameTbl
		SET [IsProcessed] = 1
		WHERE [UserPrincipal] = @SPLoginName
		PRINT 'User processed: ' + @SPLoginName;
		IF (SELECT COUNT(*) FROM @SPNameTbl WHERE [IsProcessed] = 0) = 0
		BREAK  
		ELSE  
		CONTINUE  
	END  
END;
GO

USE [MASTER]
GO
EXEC SP_PROCOPTION usp_ReassignDBORoleInTempDB, 'STARTUP', 'ON'
GO

SELECT [name]
FROM sysobjects
WHERE type = 'P'
AND OBJECTPROPERTY(id, 'ExecIsStartUp') = 1


USE [MASTER]
GO
EXEC SP_PROCOPTION usp_ReassignDBORoleInTempDB, 'STARTUP', 'ON'
GO