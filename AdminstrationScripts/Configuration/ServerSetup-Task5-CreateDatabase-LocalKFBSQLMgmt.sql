CREATE DATABASE [KFBSQLMgmt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'KFBSQLMgmt', FILENAME = N'H:\MSSQL01\KFBSQLMgmt.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'KFBSQLMgmt_log', FILENAME = N'I:\MSSQL01\KFBSQLMgmt_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [KFBSQLMgmt] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [KFBSQLMgmt] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET ARITHABORT OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [KFBSQLMgmt] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KFBSQLMgmt] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KFBSQLMgmt] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET  DISABLE_BROKER 
GO
ALTER DATABASE [KFBSQLMgmt] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KFBSQLMgmt] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KFBSQLMgmt] SET  READ_WRITE 
GO
ALTER DATABASE [KFBSQLMgmt] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [KFBSQLMgmt] SET  MULTI_USER 
GO
ALTER DATABASE [KFBSQLMgmt] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [KFBSQLMgmt] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [KFBSQLMgmt] SET DELAYED_DURABILITY = DISABLED 
GO
USE [KFBSQLMgmt]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [KFBSQLMgmt]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [KFBSQLMgmt] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
