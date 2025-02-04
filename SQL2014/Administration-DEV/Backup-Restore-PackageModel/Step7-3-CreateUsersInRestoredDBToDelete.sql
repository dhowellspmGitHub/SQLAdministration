USE [RUTest1]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [APS06000181]    Script Date: 8/19/2021 2:45:54 PM ******/
IF NOT EXISTS (SELECT * FROM [master].[sys].[server_principals] WHERE [name] = 'AfterRestoreUser1')
BEGIN
	CREATE LOGIN [AfterRestoreUser1] WITH PASSWORD=N'MJgvDggFrIVcCpinqGguSjPzcalWgPB3w7Wp5DjmNWM=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	ALTER LOGIN [AfterRestoreUser1] ENABLE
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'AfterRestoreUser1')
BEGIN
	/****** Object:  User [APS06000181]    Script Date: 8/19/2021 2:45:35 PM ******/
	CREATE USER [AfterRestoreUser1] FOR LOGIN [AfterRestoreUser1] WITH DEFAULT_SCHEMA=[dbo]
END

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [APS06000181]    Script Date: 8/19/2021 2:45:54 PM ******/
IF NOT EXISTS (SELECT * FROM [master].[sys].[server_principals] WHERE [name] = 'AfterRestoreUser2')
BEGIN
	CREATE LOGIN [AfterRestoreUser2] WITH PASSWORD=N'MJgvDggFrIVcCpinqGguSjPzcalWgPB3w7Wp5DjmNWM=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	ALTER LOGIN [AfterRestoreUser2] ENABLE
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'AfterRestoreUser2')
BEGIN
	/****** Object:  User [APS06000181]    Script Date: 8/19/2021 2:45:35 PM ******/
	CREATE USER [AfterRestoreUser2] FOR LOGIN [AfterRestoreUser2] WITH DEFAULT_SCHEMA=[dbo]
END

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [APS06000181]    Script Date: 8/19/2021 2:45:54 PM ******/
IF NOT EXISTS (SELECT * FROM [master].[sys].[server_principals] WHERE [name] = 'AfterRestoreUser3')
BEGIN
	CREATE LOGIN [AfterRestoreUser3] WITH PASSWORD=N'MJgvDggFrIVcCpinqGguSjPzcalWgPB3w7Wp5DjmNWM=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	ALTER LOGIN [AfterRestoreUser3] ENABLE
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [name] = 'AfterRestoreUser3')
BEGIN
	/****** Object:  User [APS06000181]    Script Date: 8/19/2021 2:45:35 PM ******/
	CREATE USER [AfterRestoreUser3] FOR LOGIN [AfterRestoreUser3] WITH DEFAULT_SCHEMA=[dbo]
END


ALTER ROLE [db_datareader] ADD MEMBER [AfterRestoreUser1]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [AfterRestoreUser1]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [AfterRestoreUser1]
GO

ALTER ROLE [db_datareader] ADD MEMBER [AfterRestoreUser2]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [AfterRestoreUser2]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [AfterRestoreUser2]
GO


ALTER ROLE [db_datareader] ADD MEMBER [AfterRestoreUser3]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [AfterRestoreUser3]
GO
ALTER ROLE [db_ddlviewer] ADD MEMBER [AfterRestoreUser3]
GO
