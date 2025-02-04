/*
***********************************************************************************************
	Created By:  Danny Howell			
	Created On:  10/05/2008
	Revised On:  02/21/2021
	Description:	This procedure is used to disable all accounts except for those specifically named
	Input Parameters:	The first section (commented out) contains queries that change the default location of new database data and log files and moves the location of the tempdb.  Review prior to running script as these vary from server to server.
	Output Parameters:  NONE
***********************************************************************************************
*/

USE [master]
DECLARE @principal NVARCHAR(128)
DECLARE @tsql NVARCHAR(200)


--DENY CONNECT SQL TO [KFBDOM1\SQL_CODA_DataAdmin]
--GO


DECLARE @todisable TABLE 
(server_principal NVARCHAR(128)
,processed_ind BIT
,[type] NVARCHAR(1))

DECLARE @exemptcredentials TABLE 
(server_principal NVARCHAR(128))


/* NEVER disable system generated/SQL system credentials--Always exclude these */
INSERT INTO @exemptcredentials
VALUES ('SA')
INSERT INTO @exemptcredentials
VALUES ('NT SERVICE\MSSQLSERVER')
INSERT INTO @exemptcredentials
VALUES ('NT SERVICE\SQLSERVERAGENT')
INSERT INTO @exemptcredentials
VALUES ('NT SERVICE\SQLTELEMETRY')
INSERT INTO @exemptcredentials
VALUES ('NT SERVICE\SQLWriter')
INSERT INTO @exemptcredentials
VALUES ('##MS_PolicyEventProcessingLogin##')
INSERT INTO @exemptcredentials
VALUES ('##MS_PolicyTsqlExecutionLogin##')
INSERT INTO @exemptcredentials
VALUES ('##MS_SSISServerCleanupJobLogin##')
INSERT INTO @exemptcredentials
VALUES ('NT SERVICE\Winmgmt')

/* Insert into the exempt table the server principals to NOT DISABLE */
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\SQLServices2018PRD')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\SQLServices2018DEV')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\SQL_Server_SysAdmins')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\SQLMgtApp')
INSERT INTO @exemptcredentials
VALUES ('SQLMgtApp')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\SQL_Admins')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\FTPSQLMaint')
INSERT INTO @exemptcredentials
VALUES ('KFBDOM1\AzureDSCSA')  --Domain account used for Azure services (Azure Migrate/Log Analytics)
INSERT INTO @exemptcredentials
VALUES ('NT AUTHORITY\SYSTEM')
INSERT INTO @exemptcredentials
VALUES ('AzureDSCSA')  --SQL account used for Azure services (Azure Migrate/Log Analytics)


INSERT INTO @todisable 
SELECT [NAME],CAST(0 AS BIT),[type]
FROM [master].[sys].[server_principals]
WHERE [type] IN ('S','U','G')
AND [name] NOT IN
(SELECT server_principal
FROM @exemptcredentials)
AND [is_disabled] = 0

declare @credtype NVARCHAR(1)

SELECT [T1].[server_principal],[t1].[processed_ind],[T2].[is_disabled]
FROM @todisable as T1
LEFT OUTER JOIN [master].[sys].[server_principals] as T2
ON [T1].[server_principal] = [T2].[name]

WHILE (SELECT count(server_principal) FROM @todisable where processed_ind = 0) > 0
BEGIN


	SELECT top 1 @principal = server_principal,@credtype = [TYPE] FROM @todisable where processed_ind = 0
	IF @credtype = 'S'
	BEGIN
		SET @tsql = 'ALTER LOGIN [<principal_name>] DISABLE'
		SET @tsql = REPLACE(@TSQL,'<principal_name>',@principal)
	END
	ELSE
	BEGIN
		SET @tsql = 'DENY CONNECT SQL TO  [<principal_name>]'
		SET @tsql = REPLACE(@TSQL,'<principal_name>',@principal)
	END
	PRINT (N'This credential is being disabled: ' + @principal)
	PRINT @tsql
	EXEC sp_executesql @Tsql

	UPDATE 	@todisable set processed_ind = 1
	WHERE [server_principal] = @principal
END
	
SELECT [T1].[server_principal],[t1].[processed_ind],[T2].[is_disabled]
FROM @todisable as T1
LEFT OUTER JOIN [master].[sys].[server_principals] as T2
ON [T1].[server_principal] = [T2].[name]

