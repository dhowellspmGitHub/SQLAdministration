USE [tempdb]
GO

/****** Object:  Table [dbo].[prerestore_database_principals]    Script Date: 8/17/2021 7:51:29 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prerestore_database_principals]') AND type in (N'U'))
DROP TABLE [dbo].[prerestore_database_principals]
GO

/****** Object:  Table [dbo].[prerestore_database_principals]    Script Date: 8/17/2021 7:51:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[prerestore_database_principals](
	[TCNum] [int] NULL,
	[databasename] [nvarchar](128) NULL,
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[type] [char](1) NOT NULL,
	[default_schema_name] [sysname] NULL,
	[sid] [varbinary](85) NULL,
	[owning_principal_id] [int] NULL
) ON [PRIMARY]
GO

USE [tempdb]
GO

/****** Object:  Table [dbo].[prerestore_database_role_members]    Script Date: 8/17/2021 7:51:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prerestore_database_role_members]') AND type in (N'U'))
DROP TABLE [dbo].[prerestore_database_role_members]
GO

/****** Object:  Table [dbo].[prerestore_database_role_members]    Script Date: 8/17/2021 7:51:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[prerestore_database_role_members](
	[TCNum] [int] NULL,
	[databasename] [nvarchar](128) NULL,
	[member_principal_id] [int] NOT NULL,
	[role_name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[is_fixed_role] [bit] NOT NULL,
	[principal_name] [sysname] NOT NULL
) ON [PRIMARY]
GO

USE [tempdb]
GO

/****** Object:  Table [dbo].[prerestore_database_role_permissions]    Script Date: 8/17/2021 7:51:49 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prerestore_database_role_permissions]') AND type in (N'U'))
DROP TABLE [dbo].[prerestore_database_role_permissions]
GO

/****** Object:  Table [dbo].[prerestore_database_role_permissions]    Script Date: 8/17/2021 7:51:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[prerestore_database_role_permissions](
	[TCNum] [int] NULL,
	[databasename] [varchar](128) NULL,
	[object_schema_name] [nvarchar](128) NOT NULL,
	[object_name] [sysname] NOT NULL,
	[object_type_desc] [nvarchar](60) NOT NULL,
	[object_type] [char](2) NOT NULL,
	[grantee_principal_id] [int] NOT NULL,
	[permission_type] [char](4) NOT NULL,
	[permission_name] [nvarchar](128) NULL,
	[permission_state] [char](1) NOT NULL,
	[permission_state_desc] [nvarchar](60) NULL,
	[permission_class] [tinyint] NOT NULL,
	[permission_class_desc] [nvarchar](60) NULL,
	[permission_major_object_id] [int] NOT NULL,
	[permission_minor_object_type] [int] NOT NULL
) ON [PRIMARY]
GO

USE [tempdb]
GO

/****** Object:  Table [dbo].[prerestore_database_roles]    Script Date: 8/17/2021 7:51:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prerestore_database_roles]') AND type in (N'U'))
DROP TABLE [dbo].[prerestore_database_roles]
GO

/****** Object:  Table [dbo].[prerestore_database_roles]    Script Date: 8/17/2021 7:51:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[prerestore_database_roles](
	[TCNum] [int] NULL,
	[databasename] [nvarchar](128) NULL,
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[type] [char](1) NOT NULL,
	[default_schema_name] [sysname] NULL,
	[sid] [varbinary](85) NULL,
	[owning_principal_id] [int] NULL
) ON [PRIMARY]
GO




