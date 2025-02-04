USE [RUTest1]
GO
/****** Object:  User [SSISSysAdmin]    Script Date: 6/10/2021 4:33:52 PM ******/
--IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'SSISSysAdmin')
--CREATE USER [SSISSysAdmin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[DBO]
--GO


/****** Object:  User [APS06000181]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'APS06000181')
CREATE USER [APS06000181] FOR LOGIN [APS06000181] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EPS06001181]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'EPS06001181')
CREATE USER [EPS06001181] FOR LOGIN [EPS06001181] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [KFBDOM1\NPSNMIDSVC]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'KFBDOM1\NPSNMIDSVC')
CREATE USER [KFBDOM1\NPSNMIDSVC] FOR LOGIN [KFBDOM1\NPSNMIDSVC] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [KFBDOM1\SQL_Admins]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'KFBDOM1\SQL_Admins')
CREATE USER [KFBDOM1\SQL_Admins] FOR LOGIN [KFBDOM1\SQL_Admins]
GO
/****** Object:  User [SQLMgtApp]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'SQLMgtApp')
CREATE USER [SQLMgtApp] FOR LOGIN [SQLMgtApp] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [db_ddlviewer]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_ddlviewer' AND type = 'R')
CREATE ROLE [db_ddlviewer]
GO
/****** Object:  DatabaseRole [db_executor]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_executor' AND type = 'R')
CREATE ROLE [db_executor]
GO
/****** Object:  DatabaseRole [db_reporting]    Script Date: 6/10/2021 4:33:52 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_reporting' AND type = 'R')
CREATE ROLE [db_reporting]
GO
ALTER ROLE [db_executor] ADD MEMBER [APS06000181]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [APS06000181]
GO
ALTER ROLE [db_datareader] ADD MEMBER [APS06000181]
GO
ALTER ROLE [db_executor] ADD MEMBER [EPS06001181]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [EPS06001181]
GO
ALTER ROLE [db_datareader] ADD MEMBER [EPS06001181]
GO
ALTER ROLE [db_executor] ADD MEMBER [KFBDOM1\NPSNMIDSVC]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [KFBDOM1\NPSNMIDSVC]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [KFBDOM1\NPSNMIDSVC]
GO
ALTER ROLE [db_owner] ADD MEMBER [KFBDOM1\SQL_Admins]
GO
ALTER ROLE [db_owner] ADD MEMBER [SQLMgtApp]
GO
