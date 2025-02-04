/* Use this and other TSQL scripts to create databases used to test the database users backup and restore packages.
Each step in building the test databases is a separate query.  In some, like this SQL file, perform a search and replace of the database name to build additional database. For Example, to build 4 databases, replace the RUTest4 value with a different database name, run the script, then repeat (replace/run) for each
Adjust the database file paths as needed.
The following queries are run in this order and at these time:
CREATE THE TEST DATABASES:
Step1-RecreateEmptyRUTest4 (this file) -- create an empty database
Step2-RecreateObjectsInEmptyDB -- create tables, views, procedures and other objects on which security (roles) will be applied
Step3-1-RecreateRUTestUsers -- create users in the database -- the corresponding server principals must exist.  The TSQL file creates the database principal only.  DBPs created without a SP are still created.  However, the package logic does not attempt to restore users that have no server principal.  To test success conditions, the server principals must already exist.  To test out error handling, create DBPs without SPs.  Testing error handling confirms package can is capable of processing as expected
Step3-2-DatabaseRoles-db_ddlviewer_CreateandGrant -- creates a custom DB role for testing role-object assignment restoration
Step3-3-DatabaseRoles-db_executor_CreateandGrant -- creates a custom DB role for testing role-object assignment restoration
Step4-1-RecreateObjectsInTempDB -- creates tables in the TEMPDB database for validation of package processes
Step5-CreateTempTablesforRestoreCompare -- populates the tables created in Step 4.  These statements record DBPs, roles, schemas, role permission prior to performing a backup.  Used to confirm the user backup and restore packages processes all expected records

AT THIS POINT, RUN THE PACKAGES PERFORMING THE DBP BACKUPS
After the backup package runs as expected, run the TSQL scripts in these files:
Step6-BackupConfirmationTests -- confirms the values in the tables created/populated by the SSIS match the values in the TEMPDB database (which should reflect the principals and authorization in the database BEFORE the restore is tried)
Step7-DropPrincipalsBeforeRestorePackage -- simulates a database restore by deleting the existing credentials.

*/

USE [master]
GO

/****** Object:  Database [RUTest4]    Script Date: 8/17/2021 7:24:05 AM ******/
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = 'RUTest4')
BEGIN
ALTER DATABASE [RUTest4] SET  SINGLE_USER WITH NO_WAIT
DROP DATABASE [RUTest4]
END

USE [master]
GO

/****** Object:  Database [RUTest4]    Script Date: 8/9/2021 10:26:50 AM ******/
CREATE DATABASE [RUTest4]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RUTest4_sysdata', FILENAME = N'H:\SQL2016\RUTest4_1.mdf' , SIZE = 6144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [DATAFG1]  DEFAULT
( NAME = N'RUTest4_data_01', FILENAME = N'H:\SQL2016\RUTest4_2.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [SECURITYFG1] 
( NAME = N'RUTest4_security_01', FILENAME = N'H:\SQL2016\RUTest4_3.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RUTest4_log', FILENAME = N'I:\SQL2016\RUTest4_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RUTest4].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [RUTest4] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [RUTest4] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [RUTest4] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [RUTest4] SET ANSI_WARNINGS ON 
GO

ALTER DATABASE [RUTest4] SET ARITHABORT ON 
GO

ALTER DATABASE [RUTest4] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [RUTest4] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [RUTest4] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [RUTest4] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [RUTest4] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [RUTest4] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [RUTest4] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [RUTest4] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [RUTest4] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [RUTest4] SET  DISABLE_BROKER 
GO

ALTER DATABASE [RUTest4] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [RUTest4] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [RUTest4] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [RUTest4] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [RUTest4] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [RUTest4] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [RUTest4] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [RUTest4] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [RUTest4] SET  MULTI_USER 
GO

ALTER DATABASE [RUTest4] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [RUTest4] SET DB_CHAINING OFF 
GO

ALTER DATABASE [RUTest4] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [RUTest4] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [RUTest4] SET DELAYED_DURABILITY = DISABLED 
GO

USE [RUTest4]
GO

EXEC [RUTest4].sys.sp_addextendedproperty @name=N'ApplicationDatabaseSeqID', @value=N'1' 
GO

EXEC [RUTest4].sys.sp_addextendedproperty @name=N'ApplicationID', @value=N'60' 
GO

EXEC [RUTest4].sys.sp_addextendedproperty @name=N'ApplicationName', @value=N'KFB SQL Server Managment' 
GO

USE [master]
GO

ALTER DATABASE [RUTest4] SET  READ_WRITE 
GO


