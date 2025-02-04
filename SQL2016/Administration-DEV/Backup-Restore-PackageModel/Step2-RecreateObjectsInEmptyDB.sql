USE [RUTest1]
GO
/****** Object:  DatabaseRole [db_ddlviewer]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE ROLE [db_ddlviewer]
GO
/****** Object:  DatabaseRole [db_executor]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE ROLE [db_executor]
GO
/****** Object:  DatabaseRole [db_reporting]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE ROLE [db_reporting]
GO
/****** Object:  Schema [err]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [err]
GO
/****** Object:  Schema [linux]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [linux]
GO
/****** Object:  Schema [maint]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [maint]
GO
/****** Object:  Schema [rpt]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [rpt]
GO
/****** Object:  Schema [sec]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [sec]
GO
/****** Object:  Schema [security]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [security]
GO
/****** Object:  Schema [sqlaudit]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [sqlaudit]
GO
/****** Object:  Schema [staging]    Script Date: 8/9/2021 10:26:23 AM ******/
CREATE SCHEMA [staging]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_intToBinary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ufn_intToBinary]
(
 @value INT,
 @fixedSize INT = 10
)
RETURNS VARCHAR(1000)
AS
BEGIN
 DECLARE @result VARCHAR(1000) = '';

 WHILE (@value != 0)
 BEGIN
  IF(@value%2 = 0) 
   SET @Result = '0' + @Result;
  ELSE
   SET @Result = '1' + @Result;
   
  SET @value = @value / 2;
 END;

 IF(@fixedSize IS NOT NULL AND @fixedSize > 0 AND LEN(@Result) < @fixedSize)
 BEGIN
  DECLARE @len INT = @fixedSize;
  DECLARE @padding VARCHAR(1000) = '';
 
  WHILE @len > 0
  BEGIN
   SET @padding = @padding + '0';
   SET @len = @len-1;
  END; 
  SET @result = RIGHT(@padding + @result, @fixedSize);
 END;
 
 RETURN @result;
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_IsAnnualMonthInd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
Description: Function created to distinguish local Windows accounts from deleted domain accounts when using SQL sid joins
Use of function preferred as logic is required across multiple queries/stored procedures and preferred to in-line equations
*/

CREATE FUNCTION [dbo].[ufn_IsAnnualMonthInd]
(
@pDateValue DATE
)
RETURNS BIT
AS 
BEGIN
	DECLARE @RTRN BIT
	DECLARE @AnnualBasisDivisor int = 365
	DECLARE @YearModulo float
	select @YearModulo = DATEDIFF(DAY,@pDateValue,GETDATE())%@AnnualBasisDivisor
	IF @YearModulo = 0
	BEGIN
		set @RTRN = 1
		END
		ELSE
		BEGIN
			set @RTRN = 0
		END
	RETURN (@RTRN) 
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_IsEOMonthInd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
Description: Function created to distinguish local Windows accounts from deleted domain accounts when using SQL sid joins
Use of function preferred as logic is required across multiple queries/stored procedures and preferred to in-line equations
*/
CREATE FUNCTION [dbo].[ufn_IsEOMonthInd]
(
  @pDateValue DATE
)
RETURNS BIT
AS 
BEGIN
	DECLARE @RTRN BIT
	DECLARE @DateVal_EOMDate DATE
	SET @DateVal_EOMDate = CAST(EOMONTH(@pDateValue) AS DATE)
	--get the end of month date for the input date.
	IF DATEDIFF(day,@pdateValue,@DateVal_EOMDate) = 0
	BEGIN
	SET @RTRN  = 1
	END
	ELSE
	BEGIN
	SET @RTRN = 0
	END

	RETURN ( @RTRN ) 
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_LocalorDeletedDomain]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
Description: Function created to distinguish local Windows accounts from deleted domain accounts when using SQL sid joins
Use of function preferred as logic is required across multiple queries/stored procedures and preferred to in-line equations
*/
CREATE FUNCTION [dbo].[ufn_LocalorDeletedDomain]
(
  @name AS VARCHAR(256), @guid UNIQUEIDENTIFIER
)
RETURNS VARCHAR(256)
AS BEGIN
	DECLARE @RTRN BIT
	IF CHARINDEX("KFBDOM1\",@name,1) > 0
	BEGIN
		IF @guid IS NULL
		BEGIN
			SET @RTRN = 1
		END
		ELSE
		BEGIN
			SET @RTRN = 0
		END
	END
	ELSE
		BEGIN
		SET @RTRN = 0
		END
	RETURN ( @RTRN ) 
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_ParseSQLFileName]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
Description: Function created to parse out a single column value containing the full name (path and file name) into two fields--one for the file name alone and one for the path
Use of function preferred as logic is required across multiple queries/stored procedures and preferred to in-line equations
*/
CREATE FUNCTION [dbo].[ufn_ParseSQLFileName] (@filename AS NVARCHAR(128))
RETURNS @retfileinfo TABLE (db_file_name NVARCHAR(128), db_file_path NVARCHAR(128))
AS 
BEGIN
declare @fname NVARCHAR(128)
INSERT @retfileinfo (db_file_name,db_file_path )
SELECT
reverse(substring(reverse(@FILENAME),1,charindex('\', reverse(@FILENAME),1)-1))
,replace(@filename,reverse(substring(reverse(@FILENAME),1,charindex('\', reverse(@FILENAME),1)-1)),'')
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_SIDToString]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION [dbo].[ufn_SIDToString]
(
  @BinSID AS VARBINARY(100)
)
RETURNS VARCHAR(100)
AS BEGIN

  IF LEN(@BinSID) % 4 <> 0 RETURN(NULL)

  DECLARE @StringSID VARCHAR(100)
  DECLARE @i AS INT
  DECLARE @j AS INT

  SELECT @StringSID = 'S-'
     + CONVERT(VARCHAR, CONVERT(INT, CONVERT(VARBINARY, SUBSTRING(@BinSID, 1, 1)))) 
  SELECT @StringSID = @StringSID + '-'
     + CONVERT(VARCHAR, CONVERT(INT, CONVERT(VARBINARY, SUBSTRING(@BinSID, 3, 6))))

  SET @j = 9
  SET @i = LEN(@BinSID)

  WHILE @j < @i
  BEGIN
    DECLARE @val BINARY(4)
    SELECT @val = SUBSTRING(@BinSID, @j, 4)
    SELECT @StringSID = @StringSID + '-'
      + CONVERT(VARCHAR, CONVERT(BIGINT, CONVERT(VARBINARY, REVERSE(CONVERT(VARBINARY, @val))))) 
    SET @j = @j + 4
  END
  RETURN ( @StringSID ) 
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_SplitReportStringINTParametersToTable]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[ufn_SplitReportStringINTParametersToTable](
    @sInputList VARCHAR(8000) -- List of delimited items
  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item INT)

BEGIN

DECLARE @sItem INT
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
  SELECT
   @sItem=CAST(RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))) AS INT),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_SplitReportStringVarcharParametersToTable]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[ufn_SplitReportStringVarcharParametersToTable](
    @sInputList VARCHAR(8000) -- List of delimited items
  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item VARCHAR(128))

BEGIN
DECLARE @sItem INT
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT

  @sItem=CAST(RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))) AS VARCHAR(128)),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_SplitStringToTable]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[ufn_SplitStringToTable](
    @sInputList VARCHAR(8000) -- List of delimited items
  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item VARCHAR(8000))

BEGIN
DECLARE @sItem VARCHAR(8000)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_StringToSID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[ufn_StringToSID]
(
	@xStrSid VARCHAR(100)
)
RETURNS VARBINARY(100)
AS 
BEGIN
            
	DECLARE @xBinSid VARBINARY(100) 

	SET @xBinSid = CAST(CAST(SUBSTRING(@xStrSid , 3,1) AS TINYINT) AS VARBINARY)
	SET @xBinSid = @xBinSid + 0x05
	SET @xBinSid = @xBinSid + CAST(CAST(SUBSTRING(@xStrSid , 5,1) AS TINYINT) AS BINARY(6))

	SET @xStrSid = SUBSTRING(@xStrSid,7,LEN(@xStrSid)-6)

	DECLARE @oneInt BIGINT

	WHILE CHARINDEX('-',@xStrSid) > 0
	BEGIN
		SET @oneInt = CAST(SUBSTRING(@xStrSid,1,CHARINDEX('-',@xStrSid)-1) AS BIGINT)
		SET @xBinSid = @xBinSid + CAST(REVERSE(CAST(@oneInt AS VARBINARY)) AS VARBINARY(4))

		SET @xStrSid = SUBSTRING(@xStrSid,CHARINDEX('-',@xStrSid)+1,LEN(@xStrSid))
	END

	SET @oneInt = CAST(@xStrSid AS BIGINT)
	SET @xBinSid = @xBinSid + CAST(REVERSE(CAST(@oneInt AS VARBINARY)) AS VARBINARY(4))

-- select @xBinSid , suser_sname(@xBinSid)
	RETURN ( @xBinSid ) 
END
GO
/****** Object:  Table [dbo].[ApplicationPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationPrincipals](
	[ApplicationPrincipalID] [int] IDENTITY(1,1) NOT NULL,
	[PrincipalLocalName] [varchar](128) NOT NULL,
	[PrincipalADsamAccountName] [varchar](256) NULL,
	[PrincipalADGUID] [uniqueidentifier] NULL,
	[PrincipalADType] [varchar](1) NULL,
	[EmployeeMasterID] [int] NULL,
 CONSTRAINT [PK_ApplicationPrincipals] PRIMARY KEY NONCLUSTERED 
(
	[ApplicationPrincipalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ApplicationRecoveryPlanProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationRecoveryPlanProperties](
	[ApplicationId] [int] NOT NULL,
	[HasRecoveryPlanInd] [bit] NOT NULL,
	[LastUpdateDt] [date] NOT NULL,
	[RecoveryPriority] [smallint] NULL,
	[ReceoverySequenceOrder] [smallint] NULL,
	[RecoveryPointObjectiveUnit] [smallint] NULL,
	[RecoveryPointScale] [varchar](15) NULL,
	[RecoveryTimeObjectiveUnit] [smallint] NULL,
	[RecoveryTimeObjectiveScale] [varchar](10) NULL,
	[RecoveryDocumentationFileLocation] [varchar](256) NULL,
	[RecoveryDocumentationFileName] [varchar](256) NULL,
	[IncludeInAssetBoxInd] [bit] NULL,
	[RecoveryNotes] [varchar](4000) NULL,
	[IncludeInRecoveryTestsInd] [bit] NULL,
	[DateOfLastRecoveryTest] [date] NULL,
 CONSTRAINT [PK_ApplicationRecoveryPlanProperties] PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ApplicationRolePrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationRolePrincipals](
	[ApplicationId] [int] NOT NULL,
	[LastUpdateDt] [date] NOT NULL,
	[ApplicationRoleID] [int] NOT NULL,
	[ApplicationPrincipalID] [int] NOT NULL,
 CONSTRAINT [PK_ApplicationRolePrincipals] PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC,
	[ApplicationRoleID] ASC,
	[ApplicationPrincipalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ApplicationRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationRoles](
	[ApplicationRoleID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationRoleCommonName] [varchar](50) NULL,
	[ApplicationManagementRoleID] [int] NULL,
	[ApplicationRoleName] [varchar](25) NOT NULL,
	[ApplicationRoleDesc] [varchar](400) NOT NULL,
	[ApplicationRoleType] [varchar](1) NULL,
 CONSTRAINT [PK_ApplicationRoles] PRIMARY KEY NONCLUSTERED 
(
	[ApplicationRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ApplicationId] [int] IDENTITY(0,1) NOT NULL,
	[RetiredInd] [bit] NOT NULL,
	[SQLDBBasedAppInd] [bit] NOT NULL,
	[ApplicationName] [varchar](128) NOT NULL,
	[BusinessCategoryID] [int] NULL,
	[ApplicationCommonName] [varchar](200) NULL,
	[PrimaryBusinessPurposeDesc] [varchar](1024) NULL,
	[KFBMFApplicationCode] [varchar](68) NULL,
	[FinanciallySignificantAppInd] [bit] NULL,
	[KFBDistributedAbbreviations] [varchar](40) NULL,
	[ActiveDirectoryGroupAccessInd] [bit] NULL,
	[ActiveDirectoryGroupTag] [varchar](128) NULL,
	[VendorSuppliedDBInd] [bit] NULL,
	[InternallyDevelopedAppInd] [bit] NULL,
	[AppDBERModelName] [varchar](128) NULL,
	[LastUpdateDt] [date] NOT NULL,
	[OnAppInventorySheetInd] [bit] NULL,
 CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Backup_History_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Backup_History_Detail](
	[Backup_Job_ID] [int] NOT NULL,
	[Database_ID] [int] NOT NULL,
	[Database_Name] [varchar](128) NOT NULL,
	[Database_Accessible_Ind] [bit] NOT NULL,
	[Database_Status] [varchar](128) NOT NULL,
	[Database_Excluded_State_Ind] [bit] NOT NULL,
	[Backup_Task_Starttime] [datetime] NOT NULL,
	[Backup_Task_Endtime] [datetime] NULL,
	[Backup_Performed_Ind] [bit] NOT NULL,
	[Backup_Completed_Ind] [bit] NOT NULL,
	[Backup_Failed_Ind] [bit] NOT NULL,
	[Backup_Path_Used] [varchar](512) NULL,
	[Database_Size_MB] [bigint] NULL,
	[Database_Backup_Comments] [varchar](2000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Backup_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Backup_History_Summary](
	[Backup_Job_ID] [int] IDENTITY(1,1) NOT NULL,
	[ExecutioninstanceGUID] [uniqueidentifier] NOT NULL,
	[Server_Name] [varchar](128) NOT NULL,
	[Backup_Job_Starttime] [datetime] NULL,
	[Backup_Job_Endtime] [datetime] NULL,
	[Initiating_Server] [varchar](100) NULL,
	[Initiating_Job_Name] [varchar](100) NULL,
	[Compression_Options] [varchar](4000) NULL,
	[Databases_ToExclude] [varchar](4000) NULL,
	[Databases_ToProcess] [varchar](4000) NULL,
	[Primary_PathRoot] [varchar](256) NOT NULL,
	[Secondary_PathRoot] [varchar](256) NOT NULL,
	[Path_Subfolder_Name] [varchar](256) NOT NULL,
	[Process_All_Databases] [bit] NOT NULL,
	[Process_IncludeSystemInd] [bit] NOT NULL,
	[Peform_CopyOnly_Ind] [bit] NOT NULL,
	[Perform_Differential_Ind] [bit] NOT NULL,
	[Include_Compression_Ind] [bit] NOT NULL,
	[Databases_Total_Count] [int] NOT NULL,
	[Databases_Completed_Count] [int] NOT NULL,
	[Databases_Failed_Count] [int] NOT NULL,
	[Backup_Summary_Comments] [varchar](2000) NULL,
 CONSTRAINT [PK_Backup_History_Summary] PRIMARY KEY CLUSTERED 
(
	[Backup_Job_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BusinessApplicationServers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessApplicationServers](
	[BusinessApplicationServerID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[First Reported Date] [date] NOT NULL,
	[Latest Reported Date] [date] NULL,
 CONSTRAINT [PK_BusinessApplicatiionServers] PRIMARY KEY CLUSTERED 
(
	[BusinessApplicationServerID] ASC,
	[ApplicationId] ASC,
	[ServerSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[BusinessCategories]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessCategories](
	[BusinessCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessCatgeoryLongDesc] [varchar](4000) NULL,
	[BusinessCategoryDesc] [varchar](128) NOT NULL,
	[BusinessCategoryAbbreviation] [varchar](4) NULL,
 CONSTRAINT [PK_ServerBusinessCategories] PRIMARY KEY CLUSTERED 
(
	[BusinessCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DataAccessRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataAccessRoles](
	[CustomRoleID] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleScope] [varchar](2) NOT NULL,
	[RoleAuthority] [varchar](15) NOT NULL,
	[RoleAuthorityIsLDAP] [bit] NOT NULL,
	[RoleName] [varchar](25) NOT NULL,
	[EnvironmentScope] [varchar](1) NOT NULL,
	[IsProductionRoleInd] [bit] NOT NULL,
	[HighlyPrivilegedRoleInd] [bit] NOT NULL,
	[GrantDescription] [varchar](1000) NOT NULL,
	[PurposeDescription] [varchar](1000) NULL,
	[Abbreviation] [varchar](2) NULL,
	[LastUpdateDt] [date] NOT NULL,
 CONSTRAINT [PK_PrincipalAccessRoles] PRIMARY KEY CLUSTERED 
(
	[CustomRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1],
 CONSTRAINT [IXU_DataAccessRoles_01] UNIQUE NONCLUSTERED 
(
	[CustomRoleID] ASC,
	[RoleScope] ASC,
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DatabaseExclusions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseExclusions](
	[DatabaseName] [varchar](128) NOT NULL,
	[FirstReportedDate] [date] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DatabaseExtendedProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseExtendedProperties](
	[DatabaseExtendedPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseUniqueId] [int] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[ExtendedPropertyName] [nvarchar](128) NOT NULL,
	[ExtendedPropertyValue] [nvarchar](4000) NULL,
	[ExtendedPropertyLength] [int] NOT NULL,
	[IsCustomExtendedProperty] [bit] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_DatabaseExtendedProperties] PRIMARY KEY CLUSTERED 
(
	[DatabaseExtendedPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1],
 CONSTRAINT [IXU_DatabaseExtendedProperties_01] UNIQUE NONCLUSTERED 
(
	[ExtendedPropertyName] ASC,
	[DatabaseUniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DatabaseFiles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseFiles](
	[DatabaseFileID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseUniqueID] [int] NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[FileID] [int] NULL,
	[ETLProcessID] [int] NOT NULL,
	[DatabaseFileURN] [nvarchar](256) NULL,
	[FileGroupName] [nvarchar](128) NULL,
	[FileType] [nvarchar](30) NULL,
	[FileFullName] [nvarchar](128) NOT NULL,
	[FileLogicalName] [nvarchar](128) NULL,
	[Growth] [float] NULL,
	[GrowthType] [nvarchar](30) NULL,
	[IsPrimaryFileInd] [bit] NOT NULL,
	[Size] [float] NULL,
	[UsedSpace] [float] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_DatabaseFiles] PRIMARY KEY CLUSTERED 
(
	[DatabaseFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DatabaseProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseProperties](
	[DatabasePropertyID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseUniqueId] [int] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[DatabasePropertyName] [nvarchar](128) NOT NULL,
	[DatabasePropertyValue] [nvarchar](4000) NULL,
	[DatabasePropertyDataType] [nvarchar](128) NOT NULL,
	[DatabasePropertyLength] [int] NOT NULL,
	[IsCustomExtendedProperty] [bit] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_DatabaseProperties] PRIMARY KEY CLUSTERED 
(
	[DatabasePropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[DatabaseRequests]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseRequests](
	[RequestType] [tinyint] NOT NULL,
	[NewDatabaseRequestID] [int] IDENTITY(1,1) NOT NULL,
	[ProdNonProdBitMap] [tinyint] NOT NULL,
	[ApplicationDescription] [varchar](500) NOT NULL,
	[GroupServedDesc] [varchar](200) NOT NULL,
	[VendorSuppliedDatabase] [bit] NOT NULL,
	[VendorName] [varchar](75) NULL,
	[VendorDocumentationLocation] [varchar](256) NULL,
	[TermLimitedDatabaseInd] [bit] NOT NULL,
	[TermLimitExpectedEndDate] [date] NULL,
	[SQLVersionSpecificInd] [bit] NOT NULL,
	[SpecificSQLVersion] [varchar](10) NULL,
	[SpecificSQLEdition] [varchar](15) NULL,
	[AdditionalAppsInstalledOnSQLServerInd] [bit] NOT NULL,
	[DataOwnerName] [varchar](50) NOT NULL,
	[ProjectLeaderName] [varchar](50) NULL,
	[DeveloperNameorGroup] [varchar](128) NOT NULL,
	[VendorDefinedSQLLoginInd] [bit] NOT NULL,
	[VendorDefinedSQLLoginName] [varchar](50) NULL,
	[DirectAccesstoDatabaseGrantedInd] [bit] NOT NULL,
	[SrvcAcctOSSysAdminRequiredInd] [bit] NOT NULL,
	[SrvcAcctSQLSysAdminRequiredInd] [varchar](10) NOT NULL,
	[DRPlanNeededInd] [bit] NOT NULL,
	[DRRPO] [varchar](15) NULL,
	[DRRTO] [varchar](15) NULL,
	[DRPlanDocumentCompleteInd] [bit] NOT NULL,
	[ApplicationName] [varchar](128) NOT NULL,
 CONSTRAINT [PK_DatabaseRequests] PRIMARY KEY CLUSTERED 
(
	[NewDatabaseRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Databases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Databases](
	[DatabaseUniqueId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[DatabaseGuid] [uniqueidentifier] NULL,
	[SystemDBID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[DatabaseName] [varchar](128) NOT NULL,
	[SystemObjectInd] [bit] NOT NULL,
	[CurrentState] [nvarchar](25) NULL,
	[ReadOnlyInd] [bit] NOT NULL,
	[AccessibleInd] [bit] NOT NULL,
	[DeletedInd] [bit] NOT NULL,
	[CreateDt] [date] NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_Databases] PRIMARY KEY CLUSTERED 
(
	[DatabaseUniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[EmployeeMaster]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeMaster](
	[Empno] [varchar](50) NULL,
	[EmployeeMasterID] [int] IDENTITY(1,1) NOT NULL,
	[AltEmpno] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Statuscode] [varchar](50) NULL,
	[Empcat] [varchar](50) NULL,
	[Jobtitle] [varchar](50) NULL,
	[Hiredate] [varchar](50) NULL,
	[Termdate] [varchar](50) NULL,
	[Deptname] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MgrNum] [varchar](50) NULL,
	[OrigHireDate] [varchar](50) NULL,
	[TermEmplInd] [bit] NULL,
 CONSTRAINT [PK_EmployeeMaster] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ETLProcessCustomErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETLProcessCustomErrors](
	[ETLCustomErrorID] [int] IDENTITY(1,1) NOT NULL,
	[ServerSystemID] [int] NULL,
	[ETLProcessId] [int] NOT NULL,
	[LatestReportedDate] [date] NULL,
	[ErrorSeverityLevel] [int] NULL,
	[PackageName] [nvarchar](256) NULL,
	[PackageTaskName] [nvarchar](256) NULL,
	[CustomErrorText] [nvarchar](4000) NULL,
	[SSISSystemErrorCode] [nvarchar](25) NULL,
	[SSISSystemErrorColumn] [nvarchar](4000) NULL,
	[IssueResolvedInd] [bit] NULL,
	[ResolutionDescription] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ETLProcessCustomErrors] PRIMARY KEY CLUSTERED 
(
	[ETLCustomErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ETLProcesses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETLProcesses](
	[ETLProcessId] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessGroupID] [int] NOT NULL,
	[InitiatingJobName] [nvarchar](128) NOT NULL,
	[ProcessDt] [date] NOT NULL,
	[CurrentRecordsInd] [bit] NOT NULL,
	[ProcessFailedInd] [bit] NULL,
 CONSTRAINT [PK_DBOETLProcessControl] PRIMARY KEY CLUSTERED 
(
	[ETLProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ETLProcessGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETLProcessGroups](
	[ETLProcessGroupID] [int] NOT NULL,
	[ETLProcessGroupName] [nvarchar](50) NOT NULL,
	[ETLProcessGroupLongDescription] [nvarchar](1024) NULL,
 CONSTRAINT [PK_ETLProcessGroups] PRIMARY KEY CLUSTERED 
(
	[ETLProcessGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Index_Defragmentation_History_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Index_Defragmentation_History_Detail](
	[defragmentation_job_id] [int] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_id] [bigint] NOT NULL,
	[index_id] [bigint] NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[index_name] [varchar](128) NOT NULL,
	[user_defined_datatype_count] [int] NULL,
	[excluded_datatype_count] [int] NULL,
	[table_row_count] [int] NOT NULL,
	[index_rebuild_performed_ind] [bit] NULL,
	[index_reorg_performed_ind] [bit] NULL,
	[defragmentation_failed_ind] [bit] NOT NULL,
	[defragmentation_performed_on_Index] [bit] NOT NULL,
	[defragmentation_task_starttime] [datetime] NOT NULL,
	[defragmentation_task_endtime] [datetime] NOT NULL,
	[fragmentationlevel_prerun] [float] NULL,
	[fragmentationlevel_postrun] [float] NULL,
	[page_count_prerun] [bigint] NULL,
	[page_count_postrun] [bigint] NULL,
	[user_seeks] [bigint] NOT NULL,
	[user_scans] [bigint] NOT NULL,
	[user_lookups] [bigint] NOT NULL,
	[user_updates] [bigint] NOT NULL,
	[last_user_seek] [datetime] NULL,
	[last_user_scan] [datetime] NULL,
	[last_user_lookup] [datetime] NULL,
	[last_user_update] [datetime] NULL,
	[index_specific_comments] [varchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Index_Defragmentation_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Index_Defragmentation_History_Summary](
	[defragmentation_job_id] [int] IDENTITY(1,1) NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[defragmentation_performed_ind] [bit] NOT NULL,
	[online_defrag_operations_override_ind] [bit] NOT NULL,
	[last_update_date] [datetime] NOT NULL,
	[defragmentation_job_starttime] [datetime] NULL,
	[defragmentation_job_endtime] [datetime] NULL,
	[index_defragment_agerequirement_at_job_run] [smallint] NOT NULL,
	[index_defragment_minimum_pagecount_at_job_run] [bigint] NOT NULL,
	[index_rebuild_minimum_fragmentation_percent] [float] NOT NULL,
	[index_reorganize_minimum_fragmentation_percent] [float] NOT NULL,
	[table_count] [int] NOT NULL,
	[index_count] [int] NOT NULL,
	[defragmented_Indexes_TotalCount] [int] NOT NULL,
	[defragmenting_errors_count] [int] NOT NULL,
	[defragmentation_comments] [varchar](1000) NULL,
	[defragmentation_failed_ind] [bit] NOT NULL,
	[defragmentation_process_completed_ind] [bit] NOT NULL,
 CONSTRAINT [PK_Index_Defragmentation_History_Summary] PRIMARY KEY CLUSTERED 
(
	[defragmentation_job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MaintenanceIndexDefragmentationSummaries]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaintenanceIndexDefragmentationSummaries](
	[MaintenanceIndexDefragmentationSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[defragmentation_job_id] [int] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[defragmentation_performed_ind] [bit] NOT NULL,
	[online_defrag_operations_override_ind] [bit] NOT NULL,
	[last_update_date] [datetime] NOT NULL,
	[defragmentation_job_starttime] [datetime] NULL,
	[defragmentation_job_endtime] [datetime] NULL,
	[index_defragment_agerequirement_at_job_run] [smallint] NOT NULL,
	[index_defragment_minimum_pagecount_at_job_run] [bigint] NOT NULL,
	[index_rebuild_minimum_fragmentation_percent] [float] NOT NULL,
	[index_reorganize_minimum_fragmentation_percent] [float] NOT NULL,
	[table_count] [int] NOT NULL,
	[index_count] [int] NOT NULL,
	[defragmented_Indexes_TotalCount] [int] NOT NULL,
	[defragmenting_errors_count] [int] NOT NULL,
	[defragmentation_comments] [varchar](1000) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_MaintenanceIndexDefragmentationSummaries] PRIMARY KEY CLUSTERED 
(
	[MaintenanceIndexDefragmentationSummaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[MaintenanceStatisticsUpdateSummaries]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaintenanceStatisticsUpdateSummaries](
	[MaintenanceStatisticsUpdateSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[statssummary_job_id] [int] NOT NULL,
	[statsupdate_job_date] [datetime] NOT NULL,
	[statsupdate_process_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[max_age_of_last_fullscan] [int] NOT NULL,
	[partial_scan_percentage_used] [int] NOT NULL,
	[full_scan_override] [bit] NOT NULL,
	[process_objects_type_code] [int] NOT NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[maximum_mod_counter_percent] [int] NOT NULL,
	[statsupdate_job_starttime] [datetime] NULL,
	[statsupdate_job_endtime] [datetime] NULL,
	[table_count] [int] NOT NULL,
	[statistic_count_total] [int] NOT NULL,
	[statistic_count_updated] [int] NOT NULL,
	[statsupdate_errors_count] [int] NOT NULL,
	[statsupdate_comments] [varchar](1000) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_MaintenanceStatisticsUpdateSummaries] PRIMARY KEY CLUSTERED 
(
	[MaintenanceStatisticsUpdateSummaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[OSSKUs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OSSKUs](
	[OSSKUID] [int] NULL,
	[OSDescription] [nvarchar](255) NULL,
	[OSSKUName] [nvarchar](255) NULL,
	[OSEdition] [nvarchar](255) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[OSVersions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OSVersions](
	[dwMajorVersion] [smallint] NULL,
	[OSVersionID] [nvarchar](15) NULL,
	[OSProductType] [int] NULL,
	[dwMinorVersion] [smallint] NULL,
	[Operatingsystem] [nvarchar](255) NULL,
	[OSName] [nvarchar](255) NULL,
	[OSVersion] [int] NULL,
	[OSRelease] [nvarchar](255) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerClientNetworkProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerClientNetworkProtocolProperties](
	[ClientProtocolPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ClientProtocolID] [int] NULL,
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ClientProtocolName] [nvarchar](30) NOT NULL,
	[ClientProtocolURN] [nvarchar](256) NOT NULL,
	[ProtocolPropertyDisplayName] [nvarchar](50) NULL,
	[ProtocolPropertyValue] [nvarchar](100) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerClientNetworkProtocolProperties] PRIMARY KEY CLUSTERED 
(
	[ClientProtocolPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerClientNetworkProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerClientNetworkProtocols](
	[ClientProtocolID] [int] IDENTITY(1,1) NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ClientProtocolName] [nvarchar](30) NOT NULL,
	[ClientProtocolDisplayName] [nvarchar](50) NOT NULL,
	[ClientProtocolOrder] [int] NOT NULL,
	[ClientProtocolState] [nvarchar](25) NULL,
	[ClientProtocolIsEnabledInd] [bit] NOT NULL,
	[ClientProtocolURN] [nvarchar](256) NULL,
	[ClientNetLibrary] [nvarchar](25) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerClientNetworkProtocols] PRIMARY KEY CLUSTERED 
(
	[ClientProtocolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerConfigurations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerConfigurations](
	[ServerConfigurationPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessID] [int] NOT NULL,
	[ConfigurationPropertyName] [nvarchar](128) NOT NULL,
	[ConfigurationValue] [nvarchar](128) NULL,
	[RunTimeValue] [nvarchar](128) NULL,
	[Description] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[MaximumValue] [nvarchar](50) NULL,
	[MininumValue] [nvarchar](50) NULL,
	[IsAdvancedInd] [bit] NULL,
	[IsDynamicInd] [bit] NULL,
	[ConfigurationNumber] [nvarchar](20) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerConfigurations] PRIMARY KEY CLUSTERED 
(
	[ServerConfigurationPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerInstanceDataCollectorConfigStores]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerInstanceDataCollectorConfigStores](
	[SIDataCollectorConfigStoreID] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ParameterName] [nvarchar](128) NOT NULL,
	[ParameterValue] [nvarchar](255) NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerInstanceDataCollectorConfigStores] PRIMARY KEY NONCLUSTERED 
(
	[SIDataCollectorConfigStoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1],
 CONSTRAINT [IX_ServerInstanceDataCollectorConfigStores_01] UNIQUE NONCLUSTERED 
(
	[ServerInstanceId] ASC,
	[ETLProcessId] ASC,
	[ParameterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerInstances]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerInstances](
	[ServerInstanceId] [int] IDENTITY(1,1) NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[InstanceURN] [nvarchar](256) NULL,
	[ManagedBySQLDBAsInd] [bit] NULL,
	[RetiredInd] [bit] NOT NULL,
	[InstanceState] [nvarchar](30) NULL,
	[NamedInstanceInd] [bit] NOT NULL,
	[WinAuthUserCanConnectToSystemInd] [bit] NOT NULL,
	[SQLAuthUserCanConnectToSystemInd] [bit] NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerInstances] PRIMARY KEY CLUSTERED 
(
	[ServerInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerNetworkProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerNetworkProtocolProperties](
	[ServerProtocolPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerNetworkProtocolsId] [int] NULL,
	[ServerProtocolURN] [nvarchar](256) NULL,
	[ServerProtocolName] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyDataType] [nvarchar](30) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerNetworkProtocolProperties] PRIMARY KEY CLUSTERED 
(
	[ServerProtocolPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerNetworkProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerNetworkProtocols](
	[ServerNetworkProtocolsId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessID] [int] NOT NULL,
	[ServerProtocolURN] [nvarchar](256) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[HasMultiIPAddressesInd] [bit] NOT NULL,
	[EnabledInd] [bit] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[State] [nvarchar](30) NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerNetworkProtocols] PRIMARY KEY CLUSTERED 
(
	[ServerNetworkProtocolsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerNetworkProtocolsIPAddresses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerNetworkProtocolsIPAddresses](
	[ServerNetworkProtocolsIPAddressesId] [int] IDENTITY(1,1) NOT NULL,
	[ServerNetworkProtocolsId] [int] NULL,
	[ETLProcessID] [int] NOT NULL,
	[ServerInstanceId] [int] NULL,
	[IPAddressName] [nvarchar](128) NOT NULL,
	[IPAddressURN] [nvarchar](256) NULL,
	[IPAddress] [nvarchar](50) NOT NULL,
	[State] [nvarchar](30) NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerNetworkProtocolsIPAddresses] PRIMARY KEY CLUSTERED 
(
	[ServerNetworkProtocolsIPAddressesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerNetworkProtocolsIPAddressProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerNetworkProtocolsIPAddressProperties](
	[ServerIPAProperties] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerNetworkProtocolsIPAddressesId] [int] NULL,
	[IPAddressURN] [nvarchar](256) NULL,
	[IPAddressName] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyDataType] [nvarchar](30) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerNetworkProtocolIPAddressProps] PRIMARY KEY CLUSTERED 
(
	[ServerIPAProperties] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerNetworkWMIIPAddresses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerNetworkWMIIPAddresses](
	[ServerNetworkWMIIPAddressesID] [int] IDENTITY(1,1) NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[IPAddress] [varchar](30) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Index] [int] NOT NULL,
	[FirstReportedDate] [date] NULL,
	[ETLProcessId] [int] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerNetworkWMIIPAddresses] PRIMARY KEY CLUSTERED 
(
	[ServerNetworkWMIIPAddressesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerPhysicalDisks]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerPhysicalDisks](
	[ServerPhysicalDiskID] [int] IDENTITY(1,1) NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[LocalDeviceId] [nvarchar](3) NOT NULL,
	[DiskID] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](128) NOT NULL,
	[DriveType] [int] NOT NULL,
	[FileSystem] [nvarchar](50) NOT NULL,
	[FreeSpace] [bigint] NOT NULL,
	[DiskSize] [bigint] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerPhysicalDisks] PRIMARY KEY CLUSTERED 
(
	[ServerPhysicalDiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerPrincipalsLogins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerPrincipalsLogins](
	[UserId] [varchar](128) NOT NULL,
	[ServerNameId] [varchar](128) NOT NULL,
	[ApplicationDatabaseSeqID] [smallint] NULL,
	[IsRestrictedUser] [bit] NOT NULL,
	[AssignedDatabaseName] [varchar](128) NULL,
	[CurrentPassword] [varchar](128) NULL,
	[UserPlatform] [varchar](15) NULL,
	[UserType] [varchar](25) NOT NULL,
	[PrimaryApplicationID] [int] NULL,
	[ApplicationCreatedForName] [varchar](128) NULL,
	[UserRequestedBy] [varchar](50) NULL,
	[ApprovedBy] [varchar](50) NULL,
	[CreateDate] [date] NULL,
	[LastModifiedDate] [date] NULL,
	[Description] [varchar](300) NULL,
	[Creator] [varchar](128) NULL,
	[EnvironmentUsedIn] [varchar](15) NULL,
	[PreviousPassword] [varchar](128) NULL,
	[UserRetiredInd] [bit] NULL,
 CONSTRAINT [PK_ServerPrincipalLogins] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[ServerNameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerProperties](
	[ServerPropertiesId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyDataType] [nvarchar](128) NULL,
	[PropertyValueLength] [int] NULL,
	[PropertyValue] [varchar](256) NULL,
	[FirstReportedDate] [date] NULL,
	[ETLProcessId] [int] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerProperties] PRIMARY KEY NONCLUSTERED 
(
	[ServerPropertiesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Servers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servers](
	[ServerSystemID] [int] IDENTITY(1,1) NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[LocalHostDescription] [nvarchar](256) NULL,
	[ExcludeFromETLProcessesInd] [bit] NOT NULL,
	[ExcludeFromWMIDataLoadInd] [bit] NULL,
	[ExcludeFromServiceRestartInd] [char](10) NULL,
	[UsedByAppSyncInd] [bit] NULL,
	[RetiredInd] [bit] NOT NULL,
	[ReplacedByHost] [nvarchar](255) NULL,
	[InKFBDOM1Domain] [bit] NULL,
	[ManagedBySQLDBAsInd] [bit] NOT NULL,
	[MonitoredbySQLToolsInd] [bit] NULL,
	[OSManufacturer] [nvarchar](30) NULL,
	[UsageScope] [varchar](50) NOT NULL,
	[OSFullVersion] [nvarchar](128) NULL,
	[PrimaryDataProcessModelType] [varchar](25) NULL,
	[OSVersionID] [nvarchar](15) NULL,
	[OSVersion] [int] NULL,
	[OSRelease] [nvarchar](10) NULL,
	[OSSKUId] [int] NULL,
	[OSEdition] [nvarchar](30) NULL,
	[OSCaption] [nvarchar](128) NULL,
	[OSName] [nvarchar](20) NULL,
	[ProductionInd] [bit] NOT NULL,
	[OSLanguage] [int] NULL,
	[OSType] [int] NULL,
	[WindowsDirectory] [nvarchar](256) NULL,
	[OSProductType] [int] NULL,
	[OSBuildNumber] [nvarchar](20) NULL,
	[ServicePackMajorVersion] [nvarchar](15) NULL,
	[ServicePackMinorVersion] [nvarchar](15) NULL,
	[CSDVersion] [nvarchar](128) NULL,
	[BusinessCategoryID] [int] NULL,
	[PrimaryApplicationUsedFor] [nvarchar](100) NULL,
	[DateAdded] [date] NOT NULL,
	[SMOVersionCompatibility] [int] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerHostSystems] PRIMARY KEY CLUSTERED 
(
	[ServerSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [DATAFG1],
 CONSTRAINT [IUX_Servers_01] UNIQUE NONCLUSTERED 
(
	[HostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[ServerServices]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerServices](
	[ServerServicesId] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerSystemID] [int] NOT NULL,
	[ServerInstanceId] [int] NULL,
	[ServicesURN] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[Description] [nvarchar](4000) NULL,
	[PathName] [nvarchar](512) NULL,
	[ServiceAccount] [nvarchar](50) NULL,
	[Name] [nvarchar](128) NOT NULL,
	[State] [nvarchar](25) NULL,
	[Type] [nvarchar](128) NOT NULL,
	[StartMode] [nvarchar](128) NULL,
	[ServicesState] [nvarchar](25) NULL,
	[HostName] [varchar](128) NOT NULL,
	[instanceName] [nvarchar](128) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerServices] PRIMARY KEY CLUSTERED 
(
	[ServerServicesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1],
 CONSTRAINT [IX_ServerServices_01] UNIQUE NONCLUSTERED 
(
	[ETLProcessId] ASC,
	[ServicesURN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SMOServerProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMOServerProperties](
	[MinVersionMajor] [float] NULL,
	[MinVersionMinor] [float] NULL,
	[PropertyName] [nvarchar](255) NULL,
	[SMOReference] [nvarchar](256) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SQLAgentJobs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLAgentJobs](
	[SQLJobsID] [int] IDENTITY(1,1) NOT NULL,
	[JobGuid] [uniqueidentifier] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[JobName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[JobURN] [nvarchar](256) NULL,
	[JobType] [nvarchar](20) NULL,
	[JobState] [nvarchar](25) NULL,
	[VersionNumber] [int] NULL,
	[LastModifiedDt] [datetime] NULL,
	[CreatedDt] [datetime] NOT NULL,
	[HasStepsInd] [bit] NOT NULL,
	[IsEnabledInd] [bit] NOT NULL,
	[HasScheduleInd] [bit] NOT NULL,
	[StartStepID] [int] NULL,
	[LastRunDt] [datetime] NULL,
	[NextRunDt] [datetime] NULL,
	[LastRunOutcome] [nvarchar](25) NULL,
	[OriginatingServer] [nvarchar](128) NULL,
	[EmailLevel] [nvarchar](15) NULL,
	[NextRunScheduleID] [int] NULL,
	[OperatorToEmail] [nvarchar](75) NULL,
	[JobCategoryID] [int] NULL,
	[JobCategory] [nvarchar](128) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_SQLAgentJobs] PRIMARY KEY CLUSTERED 
(
	[SQLJobsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SQLAgentJobSchedules]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLAgentJobSchedules](
	[SQLJobScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[FirstReportedDate] [date] NULL,
	[ETLProcessId] [int] NOT NULL,
	[SQLJobsID] [int] NOT NULL,
	[LatestReportedDate] [date] NULL,
	[ActiveEndDate] [datetime] NOT NULL,
	[ActiveEndTimeOfDay] [time](7) NOT NULL,
	[ActiveStartDate] [datetime] NOT NULL,
	[ActiveStartTimeOfDay] [time](7) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[FrequencyInterval] [int] NOT NULL,
	[FrequencyRecurrenceFactor] [int] NOT NULL,
	[FrequencyRelativeIntervals] [int] NOT NULL,
	[FrequencySubDayInterval] [int] NOT NULL,
	[FrequencySubDayTypes] [varchar](20) NOT NULL,
	[FrequencyTypes] [varchar](20) NOT NULL,
	[ID] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[JobCount] [int] NOT NULL,
	[ScheduleUid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SQLAgentJobSchedule] PRIMARY KEY CLUSTERED 
(
	[SQLJobScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SQLAgentJobSteps]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLAgentJobSteps](
	[SQLJobStepID] [int] IDENTITY(1,1) NOT NULL,
	[CommandExecutionSuccessCode] [nvarchar](40) NULL,
	[SQLJobsID] [int] NOT NULL,
	[JobStepURN] [nvarchar](512) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[JobDatabaseName] [nvarchar](128) NOT NULL,
	[LastRunOutcome] [varchar](30) NOT NULL,
	[JobID] [int] NOT NULL,
	[OnFailAction] [varchar](30) NOT NULL,
	[JobStepName] [nvarchar](128) NOT NULL,
	[OnFailStep] [varchar](30) NOT NULL,
	[OnSuccessAction] [varchar](30) NOT NULL,
	[OnSuccessStep] [varchar](30) NOT NULL,
	[FirstReportedDate] [date] NULL,
	[StepCommand] [varchar](4000) NULL,
	[LatestReportedDate] [date] NULL,
	[LastRunDuration] [int] NOT NULL,
	[RetryAttempts] [int] NOT NULL,
	[RetryInterval] [varchar](30) NOT NULL,
	[State] [varchar](30) NULL,
 CONSTRAINT [PK_SQLAgentStepJobs] PRIMARY KEY CLUSTERED 
(
	[SQLJobStepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SQLAgentSchedules]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLAgentSchedules](
	[SQLJobSchedulerID] [int] IDENTITY(1,1) NOT NULL,
	[JobScheduleID] [int] NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[CreatedDt] [datetime] NOT NULL,
	[JobScheduleGUID] [uniqueidentifier] NOT NULL,
	[IsEnabledInd] [bit] NOT NULL,
	[JobCount] [int] NOT NULL,
	[JobScheduleURN] [nvarchar](256) NULL,
	[FrequencyInterval] [int] NULL,
	[FrequencyRecurrenceFactor] [int] NULL,
	[FrequencyRelativeIntervals] [nvarchar](10) NULL,
	[FrequencyIntervalBitMap] [varchar](40) NULL,
	[FrequencySubDayInterval] [int] NULL,
	[FrequencySubDayTypes] [nvarchar](10) NULL,
	[FrequencyTypes] [nvarchar](25) NULL,
	[ActiveStartDt] [datetime] NULL,
	[ActiveStartTimeOfDay] [nvarchar](10) NULL,
	[ActiveEndDt] [datetime] NULL,
	[ActiveEndTimeOfDay] [nvarchar](10) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SQLServerVersions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLServerVersions](
	[SQLMajorMinorVersion] [nvarchar](6) NOT NULL,
	[SQLVersionDescription] [nvarchar](35) NOT NULL,
	[DatabaseCompatibilityLevel] [int] NULL,
	[CurrentSPorCUBuild] [int] NULL,
	[CurrentInterimBuild] [int] NULL,
	[MSKBArticle] [varchar](15) NULL,
	[PatchReleaseDt] [date] NULL,
	[MSKBArticleURL] [varchar](512) NULL,
	[LastReviewDt] [date] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SSISDB_Catalog_Packages]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSISDB_Catalog_Packages](
	[folder_id] [bigint] NOT NULL,
	[project_id] [bigint] NOT NULL,
	[ETLProcessID] [int] NOT NULL,
	[validation_status] [varchar](1) NULL,
	[last_validation_time] [datetimeoffset](7) NULL,
	[package_id] [bigint] NOT NULL,
	[name] [nvarchar](260) NOT NULL,
	[description] [nvarchar](1024) NULL,
	[package_format_version] [int] NULL,
	[version_major] [int] NULL,
	[version_minor] [int] NULL,
	[version_build] [int] NULL,
	[version_comments] [nvarchar](1024) NULL,
	[version_guid] [uniqueidentifier] NULL,
	[entry_point] [bit] NULL,
	[ServerInstanceID] [int] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_SSISDB_Catalog_Packages] PRIMARY KEY CLUSTERED 
(
	[ServerInstanceID] ASC,
	[DatabaseName] ASC,
	[folder_id] ASC,
	[project_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[SSISDB_Catalog_Projects]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSISDB_Catalog_Projects](
	[folder_id] [bigint] NOT NULL,
	[FolderName] [nvarchar](128) NOT NULL,
	[ETLProcessID] [int] NOT NULL,
	[FolderDescription] [nvarchar](1024) NULL,
	[project_id] [bigint] NOT NULL,
	[ProjectName] [nvarchar](128) NOT NULL,
	[project_format_version] [int] NULL,
	[deployed_by_name] [nvarchar](128) NULL,
	[last_deployed_time] [datetimeoffset](7) NULL,
	[created_time] [datetimeoffset](7) NULL,
	[validation_status] [varchar](1) NULL,
	[last_validation_time] [datetimeoffset](7) NULL,
	[ServerInstanceID] [int] NOT NULL,
	[DatabaseName] [nvarchar](6) NOT NULL,
	[LatestReportedDate] [date] NOT NULL,
 CONSTRAINT [PK_SSISDB_Catalog_Projects] PRIMARY KEY CLUSTERED 
(
	[ServerInstanceID] ASC,
	[DatabaseName] ASC,
	[FolderName] ASC,
	[ProjectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [dbo].[Statistics_Update_History_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistics_Update_History_Detail](
	[statssummary_job_id] [int] NOT NULL,
	[database_id] [int] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_id] [bigint] NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[statistic_id] [int] NOT NULL,
	[statistic_name] [varchar](128) NOT NULL,
	[table_row_count] [bigint] NOT NULL,
	[statsupdate_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[statsupdate_failed_ind] [bit] NULL,
	[statsupdate_fromindexdefrag] [bit] NULL,
	[statsupdate_scan_type_performed] [int] NOT NULL,
	[statsupdate_task_starttime] [datetime] NULL,
	[statsupdate_task_endtime] [datetime] NULL,
	[auto_created] [bit] NULL,
	[user_created] [bit] NULL,
	[system_last_updated] [datetime] NULL,
	[rows_sampled] [bigint] NULL,
	[modification_counter] [bigint] NULL,
	[statistic_specific_comments] [varchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statistics_Update_History_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistics_Update_History_PriorValues](
	[statssummary_job_id] [int] NOT NULL,
	[table_id] [bigint] NOT NULL,
	[statistic_id] [int] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[statistic_name] [varchar](128) NOT NULL,
	[index_statistic_ind] [bit] NOT NULL,
	[table_row_count] [bigint] NOT NULL,
	[priordetail_scan_type_performed] [int] NOT NULL,
	[priordetail_statsupdate_performedind] [bit] NOT NULL,
	[priordetail_last_update_date] [datetime] NULL,
	[most_recent_full_scan_date] [datetime] NULL,
	[percentage_rows_modified] [decimal](18, 3) NULL,
	[percentage_rows_sampled_priorupdate] [decimal](18, 3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statistics_Update_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistics_Update_History_Summary](
	[statssummary_job_id] [int] IDENTITY(1,1) NOT NULL,
	[statsupdate_job_date] [datetime] NOT NULL,
	[statsupdate_process_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[max_age_of_last_fullscan] [int] NOT NULL,
	[partial_scan_percentage_used] [int] NOT NULL,
	[full_scan_override] [bit] NOT NULL,
	[process_objects_type_code] [int] NOT NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[maximum_mod_counter_percent] [int] NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[statsupdate_job_starttime] [datetime] NULL,
	[statsupdate_job_endtime] [datetime] NULL,
	[table_count] [int] NOT NULL,
	[statistic_count_total] [int] NOT NULL,
	[statistic_count_updated] [int] NOT NULL,
	[statsupdate_errors_count] [int] NOT NULL,
	[statsupdate_comments] [varchar](1000) NULL,
 CONSTRAINT [PK_Statistics_Update_History_Summary] PRIMARY KEY CLUSTERED 
(
	[statssummary_job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xeoutput]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeoutput](
	[name] [nvarchar](max) NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[timestamp (UTC)] [datetimeoffset](7) NULL,
	[xml_report] [nvarchar](max) NULL,
	[task_time] [decimal](20, 0) NULL,
	[client_app_name] [nvarchar](max) NULL,
	[client_hostname] [nvarchar](max) NULL,
	[database_id] [bigint] NULL,
	[database_name] [nvarchar](max) NULL,
	[nt_username] [nvarchar](max) NULL,
	[session_id] [int] NULL,
	[username] [nvarchar](max) NULL,
	[duration] [decimal](20, 0) NULL,
	[file_id] [int] NULL,
	[file_type] [nvarchar](max) NULL,
	[is_automatic] [bit] NULL,
	[total_size_kb] [decimal](20, 0) NULL,
	[size_change_kb] [bigint] NULL,
	[file_name] [nvarchar](max) NULL,
	[sql_text] [nvarchar](max) NULL
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [maint].[DBCC_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [maint].[DBCC_History_Summary](
	[dbcc_job_id] [int] IDENTITY(1,1) NOT NULL,
	[dbcc_job_date] [datetime] NOT NULL,
	[dbcc_process_completed_ind] [bit] NOT NULL,
	[dbcc_performed_ind] [bit] NOT NULL,
	[dbcc_failed_ind] [bit] NOT NULL,
	[max_age_of_checkdb] [int] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[database_dbi_dbccLastKnownGood] [datetime] NULL,
	[table_count] [bigint] NOT NULL,
	[dbcc_command_type] [varchar](100) NOT NULL,
	[dbcc_job_starttime] [datetime] NULL,
	[dbcc_job_endtime] [datetime] NULL,
	[dbcc_errors_count] [int] NOT NULL,
	[dbcc_output] [varchar](8000) NULL,
	[dbcc_comments] [varchar](1000) NULL,
 CONSTRAINT [PK_DBCC_History_Summary] PRIMARY KEY CLUSTERED 
(
	[dbcc_job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [maint].[DBCC_Info_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [maint].[DBCC_Info_Detail](
	[database_name] [varchar](128) NULL,
	[parentobject] [varchar](255) NULL,
	[object] [varchar](255) NULL,
	[field] [varchar](255) NULL,
	[Value] [varchar](255) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [maint].[IndexDefragmentationSummaries]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [maint].[IndexDefragmentationSummaries](
	[MaintenanceIndexDefragmentationSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[defragmentation_job_id] [int] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[defragmentation_performed_ind] [bit] NOT NULL,
	[online_defrag_operations_override_ind] [bit] NOT NULL,
	[last_update_date] [datetime] NOT NULL,
	[defragmentation_job_starttime] [datetime] NULL,
	[defragmentation_job_endtime] [datetime] NULL,
	[index_defragment_agerequirement_at_job_run] [smallint] NOT NULL,
	[index_defragment_minimum_pagecount_at_job_run] [bigint] NOT NULL,
	[index_rebuild_minimum_fragmentation_percent] [float] NOT NULL,
	[index_reorganize_minimum_fragmentation_percent] [float] NOT NULL,
	[table_count] [int] NOT NULL,
	[index_count] [int] NOT NULL,
	[defragmented_Indexes_TotalCount] [int] NOT NULL,
	[defragmenting_errors_count] [int] NOT NULL,
	[defragmentation_comments] [varchar](1000) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_MaintenanceIndexDefragmentationSummaries] PRIMARY KEY CLUSTERED 
(
	[MaintenanceIndexDefragmentationSummaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [maint].[StatisticsUpdateSummaries]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [maint].[StatisticsUpdateSummaries](
	[MaintenanceStatisticsUpdateSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[statssummary_job_id] [int] NOT NULL,
	[statsupdate_job_date] [datetime] NOT NULL,
	[statsupdate_process_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[max_age_of_last_fullscan] [int] NOT NULL,
	[partial_scan_percentage_used] [int] NOT NULL,
	[full_scan_override] [bit] NOT NULL,
	[process_objects_type_code] [int] NOT NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[maximum_mod_counter_percent] [int] NOT NULL,
	[statsupdate_job_starttime] [datetime] NULL,
	[statsupdate_job_endtime] [datetime] NULL,
	[table_count] [int] NOT NULL,
	[statistic_count_total] [int] NOT NULL,
	[statistic_count_updated] [int] NOT NULL,
	[statsupdate_errors_count] [int] NOT NULL,
	[statsupdate_comments] [varchar](1000) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_MaintenanceStatisticsUpdateSummaries] PRIMARY KEY CLUSTERED 
(
	[MaintenanceStatisticsUpdateSummaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [rpt].[ReportCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[ReportCustomizations](
	[ReportName] [nvarchar](128) NOT NULL,
	[DashboardID] [int] NULL,
	[DashboardCategoryGroupID] [int] NOT NULL,
	[ReportCustomizationID] [int] IDENTITY(1,1) NOT NULL,
	[DashboardCategoryName] [varchar](30) NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[ReportPublished] [bit] NULL,
 CONSTRAINT [PK_ReportCustomizations] PRIMARY KEY CLUSTERED 
(
	[ReportCustomizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [rpt].[ReportObjectCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[ReportObjectCustomizations](
	[ReportCustomizationID] [int] NOT NULL,
	[ReportObjectName] [varchar](50) NOT NULL,
	[ReportCustomizationScope] [varchar](25) NULL,
	[ReportObjectDisplayName] [varchar](50) NULL,
	[GUID] [uniqueidentifier] NULL,
	[TextContent] [varchar](4000) NULL,
 CONSTRAINT [PK_ReportObjectCustomizations] PRIMARY KEY CLUSTERED 
(
	[ReportCustomizationID] ASC,
	[ReportObjectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ADGroupMembers](
	[ADGroupMembersID] [int] IDENTITY(1,1) NOT NULL,
	[IsNestedGroupInd] [bit] NULL,
	[ADGroupGUID] [uniqueidentifier] NOT NULL,
	[ADUsersGUID] [uniqueidentifier] NOT NULL,
	[GroupMembershipStartDate] [date] NOT NULL,
	[GroupMembershipEndDate] [date] NULL,
	[CurrentGroupMembershipInd] [bit] NOT NULL,
	[ETLProcessID] [int] NOT NULL,
 CONSTRAINT [PK_DBO_ADGroupMembers] PRIMARY KEY NONCLUSTERED 
(
	[ADGroupMembersID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1],
 CONSTRAINT [IUX_ADGroupMembers_02] UNIQUE NONCLUSTERED 
(
	[ADGroupGUID] ASC,
	[ADUsersGUID] ASC,
	[GroupMembershipStartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ADGroups](
	[ADGroupId] [int] IDENTITY(1,1) NOT NULL,
	[GUId] [uniqueidentifier] NOT NULL,
	[sid] [varbinary](85) NULL,
	[ETLProcessId] [int] NOT NULL,
	[adsPath] [varchar](4000) NULL,
	[groupType] [int] NULL,
	[samAccountName] [varchar](256) NULL,
	[distinguishedName] [varchar](4000) NULL,
	[cn] [varchar](128) NULL,
	[Description] [varchar](512) NULL,
	[SecurityGroupInd] [bit] NULL,
	[DisplayName] [varchar](512) NULL,
	[objectCategory] [varchar](4000) NULL,
	[Name] [varchar](128) NULL,
	[whenChanged] [datetime] NULL,
	[department] [varchar](128) NULL,
	[whenCreated] [datetime] NULL,
	[samAccountType] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[managedBy] [varchar](4000) NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_DBO_ADGroups] PRIMARY KEY CLUSTERED 
(
	[ADGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ADOUs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ADOUs](
	[GUId] [uniqueidentifier] NOT NULL,
	[DistinguishedName] [varchar](4000) NULL,
	[adsPath] [varchar](4000) NULL,
	[objectCategory] [varchar](4000) NULL,
	[objectClass] [varchar](500) NOT NULL,
	[Name] [varchar](128) NULL,
	[UsersLoadFailureInd] [bit] NULL,
 CONSTRAINT [PK_DBO_ADOUs] PRIMARY KEY CLUSTERED 
(
	[GUId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ADUsers](
	[ADUsersId] [int] IDENTITY(1,1) NOT NULL,
	[GUId] [uniqueidentifier] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[containerADSPath] [varchar](4000) NULL,
	[samAccountName] [varchar](256) NULL,
	[GivenName] [varchar](128) NULL,
	[SN] [varchar](128) NULL,
	[Manager] [varchar](4000) NULL,
	[Title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectCategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samAccountType] [bigint] NULL,
	[primaryGroup] [int] NULL,
	[Description] [varchar](512) NULL,
	[DisplayName] [varchar](512) NULL,
	[department] [varchar](128) NULL,
	[userAccountControl] [bigint] NULL,
	[userAccountDisabledInd] [bit] NOT NULL,
	[WhenChanged] [datetime] NULL,
	[WhenCreated] [datetime] NULL,
	[DistinguishedName] [varchar](4000) NULL,
	[Name] [varchar](128) NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_DBO_ADUsers] PRIMARY KEY CLUSTERED 
(
	[ADUsersId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ErrorHandling_ADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ErrorHandling_ADGroupMembers](
	[groupguid] [uniqueidentifier] NOT NULL,
	[userguid] [uniqueidentifier] NOT NULL,
	[groupname] [varchar](128) NULL,
	[groupmemberseq] [int] NULL,
	[usersamaccountname] [varchar](128) NULL,
	[groupdistinguishedname] [varchar](4000) NULL,
	[userdistinguishedname] [varchar](4000) NULL,
	[structuredObjectClass] [varchar](128) NULL,
	[groupmembercountinAD] [int] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [sec].[ErrorHandling_ADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ErrorHandling_ADGroups](
	[adspath] [varchar](4000) NULL,
	[distinguishedname] [varchar](4000) NULL,
	[samaccountname] [varchar](256) NULL,
	[grouptype] [int] NULL,
	[guid] [uniqueidentifier] NULL,
	[cn] [varchar](128) NULL,
	[description] [varchar](512) NULL,
	[issecuritygroup] [bit] NULL,
	[displayname] [varchar](512) NULL,
	[objectcategory] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[samaccounttype] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[sid] [varbinary](85) NULL,
	[department] [varchar](128) NULL,
	[managedBy] [varchar](4000) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [sec].[ErrorHandling_ADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sec].[ErrorHandling_ADUsers](
	[guid] [uniqueidentifier] NULL,
	[samaccountname] [varchar](256) NOT NULL,
	[sn] [varchar](128) NULL,
	[givenname] [varchar](128) NULL,
	[manager] [varchar](4000) NULL,
	[title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectcategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samaccounttype] [bigint] NULL,
	[primarygroup] [int] NULL,
	[description] [varchar](512) NULL,
	[displayname] [varchar](512) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[distinguishedname] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[containteradspath] [varchar](4000) NULL,
	[sid] [varbinary](85) NULL,
	[department] [varchar](128) NULL,
	[useraccountcontrol] [bigint] NULL,
	[useraccountdisabledind] [bit] NULL,
	[objectclass] [varchar](4000) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [security].[ADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADGroupMembers](
	[ADGroupMembersID] [int] IDENTITY(1,1) NOT NULL,
	[IsNestedGroupInd] [bit] NOT NULL,
	[ADGroupGUID] [uniqueidentifier] NOT NULL,
	[ADUsersGUID] [uniqueidentifier] NOT NULL,
	[ETLProcessStartID] [int] NOT NULL,
	[ETLProcessEndID] [int] NOT NULL,
	[SCDCurrentRecordInd] [bit] NOT NULL,
 CONSTRAINT [PK_ADGroupMembers] PRIMARY KEY NONCLUSTERED 
(
	[ADGroupMembersID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1],
 CONSTRAINT [IUX_ADGroupMembers_01] UNIQUE NONCLUSTERED 
(
	[ADGroupGUID] ASC,
	[ADUsersGUID] ASC,
	[ETLProcessStartID] ASC,
	[ETLProcessEndID] ASC,
	[IsNestedGroupInd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ADGroupMembersKeyViolations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADGroupMembersKeyViolations](
	[ADGroupId] [int] NULL,
	[ETLProcessId] [int] NULL,
	[IsNestedGroupInd] [bit] NULL,
	[ADUserId] [int] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADGroups](
	[ADGroupId] [int] IDENTITY(1,1) NOT NULL,
	[GUId] [uniqueidentifier] NOT NULL,
	[sid] [varbinary](85) NULL,
	[ETLProcessId] [int] NOT NULL,
	[adsPath] [varchar](4000) NULL,
	[groupType] [int] NULL,
	[samAccountName] [varchar](256) NULL,
	[distinguishedName] [varchar](4000) NULL,
	[cn] [varchar](128) NULL,
	[Description] [varchar](512) NULL,
	[SecurityGroupInd] [bit] NULL,
	[DisplayName] [varchar](512) NULL,
	[objectCategory] [varchar](4000) NULL,
	[Name] [varchar](128) NULL,
	[whenChanged] [datetime] NULL,
	[department] [varchar](128) NULL,
	[whenCreated] [datetime] NULL,
	[samAccountType] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[SCDCurrentRecordInd] [bit] NULL,
	[ChangeTypeCd] [int] NULL,
 CONSTRAINT [PK_ADGroups] PRIMARY KEY CLUSTERED 
(
	[ADGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ADOUs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADOUs](
	[GUId] [uniqueidentifier] NOT NULL,
	[DistinguishedName] [varchar](4000) NULL,
	[adsPath] [varchar](4000) NULL,
	[objectCategory] [varchar](4000) NULL,
	[objectClass] [varchar](500) NOT NULL,
	[Name] [varchar](128) NULL,
	[UsersLoadFailureInd] [bit] NULL,
 CONSTRAINT [PK_ADOUs] PRIMARY KEY CLUSTERED 
(
	[GUId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADUsers](
	[ADUsersId] [int] IDENTITY(1,1) NOT NULL,
	[GUId] [uniqueidentifier] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[sid] [varbinary](85) NULL,
	[containerADSPath] [varchar](4000) NULL,
	[samAccountName] [varchar](256) NULL,
	[GivenName] [varchar](128) NULL,
	[SN] [varchar](128) NULL,
	[Manager] [varchar](4000) NULL,
	[Title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectCategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samAccountType] [bigint] NULL,
	[primaryGroup] [int] NULL,
	[Description] [varchar](512) NULL,
	[DisplayName] [varchar](512) NULL,
	[department] [varchar](128) NULL,
	[userAccountControl] [bigint] NULL,
	[userAccountDisabledInd] [bit] NOT NULL,
	[WhenChanged] [datetime] NULL,
	[WhenCreated] [datetime] NULL,
	[DistinguishedName] [varchar](4000) NULL,
	[Name] [varchar](128) NULL,
	[SCDCurrentRecordInd] [bit] NULL,
	[ChangeTypeCd] [int] NOT NULL,
 CONSTRAINT [PK_ADUsers] PRIMARY KEY CLUSTERED 
(
	[ADUsersId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ADUsersExport]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ADUsersExport](
	[DisplayName] [varchar](512) NULL,
	[samAccountName] [varchar](128) NULL,
	[ouName] [varchar](128) NULL,
	[GUId] [varchar](150) NULL,
	[ObjectClass] [varchar](128) NULL,
	[AccountStatus] [varchar](50) NULL,
	[DistinguishedName] [varchar](4000) NULL,
	[SID] [varchar](150) NULL,
	[Department] [varchar](128) NULL,
	[CommonName] [varchar](128) NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[AuditingChangeCodes]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[AuditingChangeCodes](
	[AuditingId] [int] IDENTITY(1,1) NOT NULL,
	[AuditScope] [varchar](25) NOT NULL,
	[ChangeTypeCd] [int] NOT NULL,
	[ChangeTypeShortDescription] [varchar](15) NOT NULL,
	[ChangeTypeReportingDescription] [varchar](128) NULL,
 CONSTRAINT [PK_AuditingChangeCodes] PRIMARY KEY CLUSTERED 
(
	[AuditingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[DatabasePrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[DatabasePrincipals](
	[DatabasePrincipalsId] [int] IDENTITY(1,1) NOT NULL,
	[ServerId] [int] NULL,
	[DatabaseID] [int] NULL,
	[ETLProcessId] [int] NULL,
	[PrincipalId] [int] NOT NULL,
	[SID] [varbinary](85) NULL,
	[UserName] [varchar](128) NULL,
	[CreateDt] [datetime] NULL,
	[ModifyDt] [datetime] NULL,
	[ChangeTypeCd] [int] NOT NULL,
	[SCDCurrentRecordInd] [bit] NOT NULL,
	[DatabaseUniqueID] [int] NULL,
 CONSTRAINT [PK_DatabasePrincipals] PRIMARY KEY CLUSTERED 
(
	[DatabasePrincipalsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[DatabaseRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[DatabaseRoleMembers](
	[ETLProcessId] [int] NOT NULL,
	[DatabasePrincipalsId] [int] NOT NULL,
	[DatabaseRolesId] [int] NOT NULL,
 CONSTRAINT [PK_Database_Role_Members] PRIMARY KEY CLUSTERED 
(
	[DatabasePrincipalsId] ASC,
	[DatabaseRolesId] ASC,
	[ETLProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[DatabaseRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[DatabaseRoles](
	[DatabaseRolesId] [int] IDENTITY(1,1) NOT NULL,
	[ServerId] [int] NOT NULL,
	[DatabaseID] [int] NOT NULL,
	[PrincipalId] [int] NOT NULL,
	[SID] [varbinary](85) NULL,
	[Name] [varchar](128) NULL,
	[Type] [char](1) NULL,
	[CustomRoleInd] [bit] NOT NULL,
	[InheritedServerRoleId] [int] NULL,
	[ReportingShortDescription] [varchar](25) NULL,
	[ReportingLongDescription] [varchar](256) NULL,
	[ModifyDt] [datetime] NULL,
	[CreateDt] [datetime] NULL,
	[SCDCurrentRecordInd] [bit] NOT NULL,
	[ChangeTypeCd] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[DatabaseUniqueID] [int] NULL,
 CONSTRAINT [PK_Database_Roles] PRIMARY KEY CLUSTERED 
(
	[DatabaseRolesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[Databases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[Databases](
	[ETLProcessId] [int] NOT NULL,
	[ServerId] [int] NOT NULL,
	[DatabaseID] [int] NOT NULL,
	[DatabaseName] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Database] PRIMARY KEY CLUSTERED 
(
	[ServerId] ASC,
	[DatabaseID] ASC,
	[ETLProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADGroupMembers](
	[groupguid] [uniqueidentifier] NULL,
	[userguid] [uniqueidentifier] NULL,
	[ETLProcessId] [int] NULL,
	[ErroredTaskName] [varchar](128) NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADGroupMembersKeyViolations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADGroupMembersKeyViolations](
	[userguid] [uniqueidentifier] NULL,
	[ADGroupId] [int] NULL,
	[ETLProcessId] [int] NULL,
	[groupguid] [uniqueidentifier] NULL,
	[ErroredTaskName] [varchar](128) NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADGroups](
	[adspath] [varchar](4000) NULL,
	[distinguishedname] [varchar](4000) NULL,
	[samaccountname] [varchar](256) NULL,
	[grouptype] [int] NULL,
	[guid] [uniqueidentifier] NULL,
	[cn] [varchar](128) NULL,
	[description] [varchar](512) NULL,
	[issecuritygroup] [bit] NULL,
	[displayname] [varchar](512) NULL,
	[objectcategory] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[samaccounttype] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[sid] [binary](85) NULL,
	[department] [varchar](128) NULL,
	[ETLProcessId_Prior] [int] NULL,
	[ETLProcessID_New] [int] NULL,
	[ChangeTypeCd_ExistingRecords] [int] NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADGroupsMembersInsertErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADGroupsMembersInsertErrors](
	[ADGroupId] [int] NULL,
	[ETLProcessId] [int] NULL,
	[IsNestedGroupInd] [bit] NULL,
	[ADUserId] [int] NULL,
	[SecurityGroupInd] [bit] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADGroupsSCDErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADGroupsSCDErrors](
	[adspath] [varchar](4000) NULL,
	[distinguishedname] [varchar](4000) NULL,
	[samaccountname] [varchar](256) NULL,
	[grouptype] [int] NULL,
	[guid] [uniqueidentifier] NULL,
	[cn] [varchar](128) NULL,
	[description] [varchar](512) NULL,
	[issecuritygroup] [bit] NULL,
	[displayname] [varchar](512) NULL,
	[objectcategory] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[samaccounttype] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[sid] [binary](85) NULL,
	[department] [varchar](128) NULL,
	[ETLProcessId_Prior] [int] NULL,
	[ETLProcessID_New] [int] NULL,
	[ChangeTypeCd_ExistingRecords] [int] NULL,
	[SCDCurrentRecordInd] [bit] NULL,
	[ChangeTypeCd_NewRecords] [int] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADUsers](
	[guid] [uniqueidentifier] NULL,
	[samaccountname] [varchar](256) NULL,
	[sn] [varchar](128) NULL,
	[givenname] [varchar](128) NULL,
	[manager] [varchar](4000) NULL,
	[title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectcategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samaccounttype] [bigint] NULL,
	[primarygroup] [int] NULL,
	[description] [varchar](512) NULL,
	[displayname] [varchar](512) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[distinguishedname] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[containteradspath] [varchar](4000) NULL,
	[sid] [binary](85) NULL,
	[department] [varchar](128) NULL,
	[useraccountcontrol] [bigint] NULL,
	[useraccountdisabledind] [bit] NULL,
	[objectclass] [varchar](4000) NULL,
	[ETLProcessId_Prior] [int] NULL,
	[ETLProcessId_New] [int] NULL,
	[ChangeTypeCd_ExistingRecords] [int] NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ADUsersSCDErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ADUsersSCDErrors](
	[guid] [uniqueidentifier] NULL,
	[samaccountname] [varchar](256) NULL,
	[sn] [varchar](128) NULL,
	[givenname] [varchar](128) NULL,
	[manager] [varchar](4000) NULL,
	[title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectcategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samaccounttype] [bigint] NULL,
	[primarygroup] [int] NULL,
	[description] [varchar](512) NULL,
	[displayname] [varchar](512) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[distinguishedname] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[containteradspath] [varchar](4000) NULL,
	[sid] [binary](85) NULL,
	[department] [varchar](128) NULL,
	[useraccountcontrol] [bigint] NULL,
	[useraccountdisabledind] [bit] NULL,
	[objectclass] [varchar](4000) NULL,
	[ETLProcessId_Prior] [int] NULL,
	[ETLProcessId_New] [int] NULL,
	[ChangeTypeCd_ExistingRecords] [int] NULL,
	[SCDCurrentRecordInd] [bit] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [security].[ErrorHandling_DatabaseRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_DatabaseRoleMembers](
	[RolePrincipalId] [int] NULL,
	[PrincipalID] [int] NULL,
	[DatabaseId] [int] NULL,
	[ServerId] [int] NULL,
	[DatabasePrincipalsId] [int] NULL,
	[ETLProcessId] [int] NULL,
	[ErrorDescription] [varchar](25) NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ErrorHandling_ServerRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ErrorHandling_ServerRoleMembers](
	[ServerID] [int] NULL,
	[ETLProcessID] [int] NULL,
	[RolePrincipalID] [int] NULL,
	[Principal_ID] [int] NULL,
	[ErrorDescription] [varchar](25) NULL
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ETLProcessControl]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ETLProcessControl](
	[ETLProcessId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessDt] [date] NULL,
	[ETLProcessGroupID] [int] NULL,
	[InitiatingJobName] [varchar](128) NULL,
	[CurrentRecordsInd] [bit] NOT NULL,
	[ProcessFailedInd] [bit] NULL,
 CONSTRAINT [PK_ETLProcessControl] PRIMARY KEY CLUSTERED 
(
	[ETLProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[RolesReporting]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[RolesReporting](
	[RoleScope] [varchar](128) NOT NULL,
	[RoleReportingID] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [varchar](128) NOT NULL,
	[ReportingDescription] [varchar](128) NULL,
	[Definition] [varchar](512) NULL,
	[InheritedServerRoleInd] [bit] NOT NULL,
	[InheritedServerRoleID] [int] NOT NULL,
	[AccesstoAllDatabasesInd] [bit] NOT NULL,
	[SysAdminInd] [bit] NOT NULL,
	[CustomRoleInd] [bit] NOT NULL,
 CONSTRAINT [PK_RolesReporting_v2] PRIMARY KEY CLUSTERED 
(
	[RoleReportingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ServerPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ServerPrincipals](
	[ServerPrincipalsId] [int] IDENTITY(1,1) NOT NULL,
	[ServerId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[PrincipalId] [int] NOT NULL,
	[SQLSid] [varbinary](85) NOT NULL,
	[Name] [varchar](128) NULL,
	[CreateDt] [datetime] NULL,
	[ModifiedDt] [datetime] NULL,
	[ServerPrincipalTypeCd] [char](1) NULL,
	[IsDisabledind] [bit] NULL,
	[ADAccountInd] [bit] NOT NULL,
	[ADGroupInd] [bit] NOT NULL,
	[SCDCurrentRecordInd] [bit] NOT NULL,
	[ChangeTypeCd] [int] NOT NULL,
 CONSTRAINT [PK_ServerPrincipals] PRIMARY KEY CLUSTERED 
(
	[ServerPrincipalsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ServerRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ServerRoleMembers](
	[ETLProcessId] [int] NOT NULL,
	[ServerPrincipalsId] [int] NOT NULL,
	[ServerRoleId] [int] NOT NULL,
 CONSTRAINT [PK_ServerRoleMembers] PRIMARY KEY CLUSTERED 
(
	[ETLProcessId] ASC,
	[ServerPrincipalsId] ASC,
	[ServerRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[ServerRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ServerRoles](
	[ServerRoleId] [int] IDENTITY(1,1) NOT NULL,
	[ServerId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[RolePrincipalId] [int] NOT NULL,
	[SID] [varbinary](85) NULL,
	[Name] [varchar](128) NULL,
	[AccessToAllDatabasesInd] [bit] NOT NULL,
	[CustomRoleInd] [bit] NOT NULL,
	[SysAdminInd] [bit] NOT NULL,
	[CreateDt] [datetime] NULL,
	[ModifyDt] [datetime] NULL,
	[ReportingShortDescription] [varchar](25) NULL,
	[ReportingLongDescription] [varchar](256) NULL,
	[SCDCurrentRecordInd] [bit] NOT NULL,
	[ChangeTypeCd] [int] NOT NULL,
 CONSTRAINT [PK_ServerRoles] PRIMARY KEY CLUSTERED 
(
	[ServerRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [security].[Servers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[Servers](
	[ServerId] [int] NOT NULL,
	[ProductionServerInd] [bit] NULL,
	[ServerName] [varchar](128) NOT NULL,
	[AuditDiscontinuedInd] [bit] NOT NULL,
	[ReplacedByServerName] [varchar](128) NULL,
	[IncludeInAuditingReportInd] [bit] NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerReportingName] [varchar](256) NULL,
	[InstanceName] [nvarchar](128) NULL,
	[ServerInstanceID] [int] NULL,
 CONSTRAINT [PK_securityServers] PRIMARY KEY CLUSTERED 
(
	[ServerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1],
 CONSTRAINT [IX_ServerName] UNIQUE NONCLUSTERED 
(
	[ServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECURITYFG1]
) ON [SECURITYFG1]
GO
/****** Object:  Table [sqlaudit].[AuditControls]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[AuditControls](
	[AuditDefinitionID] [int] IDENTITY(1,1) NOT NULL,
	[AuditStartDate] [date] NULL,
	[Scope] [varchar](20) NOT NULL,
	[AuditMethod] [varchar](30) NULL,
	[AuditName] [varchar](128) NOT NULL,
	[LoadProcess] [nvarchar](30) NULL,
	[LoadSourceName] [varchar](30) NULL,
	[Description] [varchar](2000) NOT NULL,
	[ActiveInd] [bit] NOT NULL,
	[AuditEndate] [date] NULL,
 CONSTRAINT [PK_AuditControls] PRIMARY KEY CLUSTERED 
(
	[AuditDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[AuditDefinitions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[AuditDefinitions](
	[AuditDefinitionID] [int] NOT NULL,
	[AuditActiveInd] [bit] NOT NULL,
	[AuditStartDate] [date] NOT NULL,
	[ReferenceId] [int] NOT NULL,
	[ReferenceTableName] [nvarchar](128) NOT NULL,
	[AuditDataSourceName] [varchar](40) NOT NULL,
	[AuditEndDate] [char](10) NULL,
	[LastUpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AuditDefinitions] PRIMARY KEY NONCLUSTERED 
(
	[ReferenceId] ASC,
	[ReferenceTableName] ASC,
	[AuditDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAuditControls]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAuditControls](
	[AuditDefinitionID] [int] NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ActiveInd] [bit] NOT NULL,
	[ServerAuditStartDate] [date] NULL,
	[ServerAuditEndDate] [date] NULL,
 CONSTRAINT [PK_ServerAuditControls] PRIMARY KEY CLUSTERED 
(
	[AuditDefinitionID] ASC,
	[ServerInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAuditETLStatus]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAuditETLStatus](
	[AuditDefinitionID] [int] NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerAuditProcessActiveInd] [bit] NULL,
	[ServerAuditProcessSuccessInd] [bit] NULL,
	[ServerAuditETLProcessStartTime] [datetime] NOT NULL,
	[ServerAuditETLProcessEndTime] [datetime] NULL,
	[ServerAuditETLRowsProcessed] [bigint] NOT NULL,
 CONSTRAINT [PK_ServerAuditETLStatus] PRIMARY KEY NONCLUSTERED 
(
	[AuditDefinitionID] ASC,
	[ServerInstanceId] ASC,
	[ETLProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAuditOutputs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAuditOutputs](
	[ServerAuditOutputID] [bigint] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerAuditsID] [int] NOT NULL,
	[ServerInstanceID] [int] NOT NULL,
	[audit_id] [int] NOT NULL,
	[action_id] [varchar](4) NOT NULL,
	[event_time_date] [date] NULL,
	[audit_file_offset] [bigint] NOT NULL,
	[event_time_time] [time](7) NULL,
	[class_type] [varchar](2) NOT NULL,
	[database_name] [nvarchar](128) NULL,
	[database_principal_id] [int] NULL,
	[database_principal_name] [nvarchar](128) NULL,
	[ipaddress] [varchar](16) NULL,
	[event_time] [datetime2](7) NOT NULL,
	[pooled_connection] [bit] NULL,
	[file_name] [nvarchar](260) NOT NULL,
	[is_column_permission] [bit] NULL,
	[object_id] [int] NULL,
	[object_name] [nvarchar](128) NULL,
	[schema_name] [nvarchar](128) NULL,
	[sequence_number] [int] NULL,
	[server_instance_name] [nvarchar](128) NULL,
	[server_principal_id] [int] NULL,
	[server_principal_name] [nvarchar](128) NULL,
	[server_principal_sid] [varbinary](85) NULL,
	[session_id] [int] NULL,
	[session_server_principal_name] [nvarchar](128) NULL,
	[statement] [nvarchar](4000) NULL,
	[succeeded] [bit] NULL,
	[target_database_principal_id] [int] NULL,
	[target_database_principal_name] [nvarchar](128) NULL,
	[target_server_principal_id] [int] NULL,
	[target_server_principal_name] [nvarchar](128) NULL,
	[target_server_principal_sid] [varbinary](85) NULL,
	[user_defined_event_id] [int] NULL,
	[user_defined_information] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ServerAuditOutputs] PRIMARY KEY CLUSTERED 
(
	[ServerAuditOutputID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAudits]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAudits](
	[ServerAuditsID] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerInstanceID] [int] NOT NULL,
	[audit_id] [int] NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[audit_guid] [uniqueidentifier] NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[principal_id] [int] NULL,
	[type] [char](2) NOT NULL,
	[type_desc] [nvarchar](60) NULL,
	[on_failure] [tinyint] NULL,
	[on_failure_desc] [nvarchar](60) NULL,
	[is_state_enabled] [bit] NULL,
	[queue_delay] [int] NULL,
	[predicate] [nvarchar](3000) NULL,
	[max_file_size] [bigint] NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
	[max_files] [int] NULL,
	[max_rollover_files] [int] NULL,
	[log_file_path] [nvarchar](260) NULL,
	[reserve_disk_space] [int] NULL,
	[log_file_name] [nvarchar](260) NULL,
 CONSTRAINT [PK_ServerAudits] PRIMARY KEY CLUSTERED 
(
	[ServerAuditsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAuditSpecificationDetails]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAuditSpecificationDetails](
	[ServerAuditSpecificationDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[ServerAuditSpecificationsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[server_specification_id] [int] NOT NULL,
	[audit_action_id] [char](4) NOT NULL,
	[audit_action_name] [nvarchar](60) NULL,
	[class] [tinyint] NOT NULL,
	[class_desc] [nvarchar](60) NULL,
	[major_id] [int] NOT NULL,
	[minor_id] [int] NOT NULL,
	[audited_principal_id] [int] NOT NULL,
	[audited_result] [nvarchar](60) NULL,
	[is_group] [bit] NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerAuditSpecificationDetails] PRIMARY KEY CLUSTERED 
(
	[ServerAuditSpecificationDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerAuditSpecifications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerAuditSpecifications](
	[ServerAuditSpecificationsID] [int] IDENTITY(1,1) NOT NULL,
	[ServerAuditsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[server_specification_id] [int] NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[audit_guid] [uniqueidentifier] NULL,
	[is_state_enabled] [bit] NULL,
	[FirstReportedDate] [date] NOT NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerAuditSpecifications] PRIMARY KEY CLUSTERED 
(
	[ServerAuditSpecificationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerDefaultTraces]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerDefaultTraces](
	[DefaultTraceID] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerName] [nvarchar](256) NULL,
	[EventName] [nvarchar](128) NULL,
	[subclass_name] [nvarchar](128) NULL,
	[TextData] [ntext] NULL,
	[DatabaseID] [int] NULL,
	[TransactionID] [bigint] NULL,
	[LineNumber] [int] NULL,
	[HostName] [nvarchar](256) NULL,
	[ClientProcessID] [int] NULL,
	[ApplicationName] [nvarchar](256) NULL,
	[LoginName] [nvarchar](256) NULL,
	[SPID] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Permissions] [bigint] NULL,
	[EventSubClass] [int] NULL,
	[ObjectID] [int] NULL,
	[Success] [int] NULL,
	[EventClass] [int] NULL,
	[ObjectType] [int] NULL,
	[State] [int] NULL,
	[Error] [int] NULL,
	[ObjectName] [nvarchar](256) NULL,
	[DatabaseName] [nvarchar](256) NULL,
	[OwnerName] [nvarchar](256) NULL,
	[RoleName] [nvarchar](256) NULL,
	[TargetUserName] [nvarchar](256) NULL,
	[DBUserName] [nvarchar](256) NULL,
	[TargetLoginName] [nvarchar](256) NULL,
	[XactSequence] [bigint] NULL,
	[EventSequence] [bigint] NULL,
	[SessionLoginName] [nvarchar](256) NULL,
	[NTUserName] [nvarchar](256) NULL,
	[NTDomainName] [nvarchar](256) NULL,
	[Duration] [bigint] NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[CPU] [int] NULL,
	[Severity] [int] NULL,
	[IndexID] [int] NULL,
	[IntegerData] [int] NULL,
	[NestLevel] [int] NULL,
	[Mode] [int] NULL,
	[Handle] [int] NULL,
	[FileName] [nvarchar](256) NULL,
	[ColumnPermissions] [int] NULL,
	[LinkedServerName] [nvarchar](256) NULL,
	[ProviderName] [nvarchar](256) NULL,
	[MethodName] [nvarchar](256) NULL,
	[RowCounts] [bigint] NULL,
	[RequestID] [int] NULL,
	[BigintData1] [bigint] NULL,
	[BigintData2] [bigint] NULL,
	[GUID] [uniqueidentifier] NULL,
	[IntegerData2] [int] NULL,
	[ObjectID2] [bigint] NULL,
	[Type] [int] NULL,
	[OwnerID] [int] NULL,
	[ParentName] [nvarchar](256) NULL,
	[IsSystem] [int] NULL,
	[Offset] [int] NULL,
	[SourceDatabaseID] [int] NULL,
	[GroupID] [int] NULL,
 CONSTRAINT [PK_ServerDefaultTraces] PRIMARY KEY CLUSTERED 
(
	[DefaultTraceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESecLogOnOutput]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESecLogOnOutput](
	[ServerXESecLogOnOutputID] [int] IDENTITY(1,1) NOT NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[ServerInstanceID] [int] NOT NULL,
	[ETLProcessID] [int] NOT NULL,
	[timestamp] [datetime2](7) NOT NULL,
	[timestamp_date] [date] NULL,
	[timestamp_time] [time](3) NULL,
	[actionname] [varchar](25) NOT NULL,
	[session_id] [int] NOT NULL,
	[client_app_name] [varchar](128) NULL,
	[client_hostname] [varchar](50) NULL,
	[client_connection_id] [varbinary](max) NULL,
	[database_id] [int] NULL,
	[database_name] [varchar](50) NULL,
	[is_system] [bit] NULL,
	[nt_username] [varchar](128) NULL,
	[server_principal_name] [varchar](128) NULL,
	[server_principal_sid] [varbinary](max) NULL,
	[session_nt_username] [varchar](128) NULL,
	[session_principal_name] [varchar](128) NULL,
	[username] [varchar](128) NULL,
 CONSTRAINT [PK_ServerXESecLogOnOutput] PRIMARY KEY CLUSTERED 
(
	[ServerXESecLogOnOutputID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESessionActions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESessionActions](
	[ServerXESessionActionsID] [int] IDENTITY(1,1) NOT NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[event_session_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[name] [nvarchar](256) NULL,
	[package] [nvarchar](256) NULL,
	[module] [nvarchar](256) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerXESessionActions] PRIMARY KEY CLUSTERED 
(
	[ServerXESessionActionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESessionEvents]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESessionEvents](
	[ServerXESessionEventsID] [int] IDENTITY(1,1) NOT NULL,
	[event_session_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[package] [nvarchar](256) NOT NULL,
	[module] [nvarchar](256) NOT NULL,
	[predicate] [nvarchar](3000) NULL,
	[predicate_xml] [nvarchar](3000) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
 CONSTRAINT [PK_ServerXESessionEvents] PRIMARY KEY CLUSTERED 
(
	[ServerXESessionEventsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESessionFields]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESessionFields](
	[ServerXESessionFieldsID] [int] IDENTITY(1,1) NOT NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[event_session_id] [int] NOT NULL,
	[object_id] [int] NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[value] [nvarchar](256) NOT NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerXESessionFields] PRIMARY KEY CLUSTERED 
(
	[ServerXESessionFieldsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESessions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESessions](
	[ServerXESessionsID] [int] IDENTITY(1,1) NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[ServerInstanceId] [int] NOT NULL,
	[event_session_id] [int] NULL,
	[name] [nvarchar](256) NOT NULL,
	[memory_partition_mode_desc] [nvarchar](256) NOT NULL,
	[event_retention_mode] [nchar](1) NULL,
	[event_retention_mode_desc] [nvarchar](256) NULL,
	[max_dispatch_latency] [int] NULL,
	[max_memory] [int] NULL,
	[max_event_size] [int] NULL,
	[memory_partition_mode] [nchar](1) NULL,
	[track_causality] [bit] NULL,
	[startup_state] [bit] NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerXESessions] PRIMARY KEY CLUSTERED 
(
	[ServerXESessionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[ServerXESessionTargets]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[ServerXESessionTargets](
	[ServerXESessionTargetsID] [int] IDENTITY(1,1) NOT NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[ETLProcessId] [int] NOT NULL,
	[event_session_id] [int] NOT NULL,
	[target_id] [int] NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[package] [nvarchar](256) NOT NULL,
	[module] [nvarchar](256) NULL,
	[FirstReportedDate] [date] NULL,
	[LatestReportedDate] [date] NULL,
 CONSTRAINT [PK_ServerXESessionTargets] PRIMARY KEY CLUSTERED 
(
	[ServerXESessionTargetsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATAFG1]
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[SQLErrorLogs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[SQLErrorLogs](
	[SQLErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ServerInstanceID] [int] NULL,
	[ETLProcessID] [int] NULL,
	[LogDate] [datetime] NULL,
	[ProcessInfo] [nvarchar](50) NULL,
	[Text] [nvarchar](max) NULL
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[SQLProfilerEventColumns]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[SQLProfilerEventColumns](
	[SQLVersionMajor] [int] NULL,
	[ColumnNumber] [int] NULL,
	[ColumnName] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [sqlaudit].[SQLProfilerEvents]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sqlaudit].[SQLProfilerEvents](
	[SQLVersionMajor] [int] NOT NULL,
	[EventNumber] [int] NOT NULL,
	[EventName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpADGMLoadErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpADGMLoadErrors](
	[usersamaccountname] [varchar](256) NULL,
	[userguid] [uniqueidentifier] NULL,
	[groupmemberseq] [int] NULL,
	[groupguid] [uniqueidentifier] NULL,
	[groupname] [varchar](256) NULL,
	[groupdistinguishedname] [varchar](4000) NULL,
	[userdistinguishedname] [varchar](4000) NULL,
	[structuredObjectClass] [varchar](128) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[VariableObjectDistinguishedName] [nvarchar](4000) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpADGroupMembers](
	[groupguid] [uniqueidentifier] NOT NULL,
	[userguid] [uniqueidentifier] NOT NULL,
	[groupname] [varchar](128) NULL,
	[groupmemberseq] [int] NULL,
	[usersamaccountname] [varchar](128) NULL,
	[groupdistinguishedname] [varchar](4000) NULL,
	[userdistinguishedname] [varchar](4000) NULL,
	[structuredObjectClass] [varchar](128) NULL,
	[groupmembercountinAD] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[tmpADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpADGroups](
	[adspath] [varchar](4000) NULL,
	[distinguishedname] [varchar](4000) NULL,
	[samaccountname] [varchar](256) NULL,
	[grouptype] [int] NULL,
	[guid] [uniqueidentifier] NULL,
	[cn] [varchar](128) NULL,
	[description] [varchar](512) NULL,
	[issecuritygroup] [bit] NULL,
	[displayname] [varchar](512) NULL,
	[objectcategory] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[samaccounttype] [bigint] NULL,
	[schemaentry] [varchar](4000) NULL,
	[schemaclassname] [varchar](256) NULL,
	[sid] [varbinary](85) NULL,
	[department] [varchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[tmpADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpADUsers](
	[guid] [uniqueidentifier] NULL,
	[samaccountname] [varchar](256) NOT NULL,
	[sn] [varchar](128) NULL,
	[givenname] [varchar](128) NULL,
	[manager] [varchar](4000) NULL,
	[title] [varchar](128) NULL,
	[cn] [varchar](128) NULL,
	[objectcategory] [varchar](4000) NULL,
	[userprincipalname] [varchar](256) NULL,
	[samaccounttype] [bigint] NULL,
	[primarygroup] [int] NULL,
	[description] [varchar](512) NULL,
	[displayname] [varchar](512) NULL,
	[whenchanged] [datetime] NULL,
	[whencreated] [datetime] NULL,
	[distinguishedname] [varchar](4000) NULL,
	[name] [varchar](128) NULL,
	[containteradspath] [varchar](4000) NULL,
	[sid] [varbinary](85) NULL,
	[department] [varchar](128) NULL,
	[useraccountcontrol] [bigint] NULL,
	[useraccountdisabledind] [bit] NULL,
	[objectclass] [varchar](4000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[tmpAuditXESecLogOnFileOutput]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpAuditXESecLogOnFileOutput](
	[ServerInstanceID] [int] NOT NULL,
	[event_data_date] [date] NULL,
	[event_data_time] [time](3) NULL,
	[HostName] [nvarchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[object_name] [nvarchar](60) NOT NULL,
	[event_data_ts] [datetime2](7) NOT NULL,
	[event_data] [varchar](8000) NULL,
	[event_data_xml] [xml] NULL
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpAuditXESecLogOnOutput]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpAuditXESecLogOnOutput](
	[ServerInstanceID] [int] NOT NULL,
	[ServerXESessionsID] [int] NOT NULL,
	[timestamp] [datetime2](7) NULL,
	[timestamp_date] [date] NULL,
	[timestamp_time] [time](3) NULL,
	[actionname] [varchar](25) NULL,
	[session_id] [int] NULL,
	[client_app_name] [varchar](128) NULL,
	[client_hostname] [varchar](50) NULL,
	[client_connection_id] [varbinary](max) NULL,
	[database_id] [int] NULL,
	[database_name] [varchar](50) NULL,
	[is_system] [bit] NULL,
	[nt_username] [varchar](128) NULL,
	[server_principal_name] [varchar](128) NULL,
	[server_principal_sid] [varbinary](max) NULL,
	[session_nt_username] [varchar](128) NULL,
	[session_principal_name] [varchar](128) NULL,
	[username] [varchar](128) NULL
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabaseExtProps]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabaseExtProps](
	[ServerSystemID] [int] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[ExtendedPropertyName] [nvarchar](128) NOT NULL,
	[ExtendedPropertyValue] [nvarchar](4000) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabaseFiles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabaseFiles](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[FileID] [int] NOT NULL,
	[DatabaseFileURN] [nvarchar](256) NOT NULL,
	[FileGroupName] [nvarchar](128) NULL,
	[FileLogicalName] [nvarchar](128) NULL,
	[FileType] [nvarchar](30) NULL,
	[FileFullName] [nvarchar](128) NOT NULL,
	[Growth] [float] NULL,
	[GrowthType] [nvarchar](30) NULL,
	[IsPrimaryFileInd] [bit] NOT NULL,
	[Size] [float] NULL,
	[UsedSpace] [float] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabasePrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabasePrincipals](
	[principal_id] [int] NULL,
	[ServerID] [int] NULL,
	[DatabaseID] [int] NULL,
	[sid] [varbinary](85) NULL,
	[CREATE_DATE] [datetime] NULL,
	[MODIFY_DATE] [datetime] NULL,
	[UserName] [varchar](128) NULL,
	[ETLProcess_ID] [int] NULL,
	[ETLProcess_ID_Prior] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabaseProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabaseProperties](
	[ServerSystemID] [int] NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[DatabasePropertyName] [nvarchar](128) NOT NULL,
	[DatabasePropertyValue] [nvarchar](4000) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabaseRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabaseRoleMembers](
	[RolePrincipalId] [int] NULL,
	[PrincipalID] [int] NULL,
	[DatabaseId] [int] NULL,
	[ServerId] [int] NULL,
	[ETLProcess_ID] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabaseRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabaseRoles](
	[principal_id] [int] NULL,
	[ServerId] [int] NULL,
	[DatabaseId] [int] NULL,
	[TYPE] [varchar](1) NULL,
	[sid] [varbinary](85) NULL,
	[CREATE_DATE] [datetime] NULL,
	[MODIFY_DATE] [datetime] NULL,
	[Name] [varchar](128) NULL,
	[ETLProcess_ID] [int] NULL,
	[ETLProcess_ID_Prior] [int] NULL,
	[CustomRoleInd] [bit] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpDatabases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpDatabases](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[DatabaseGuid] [uniqueidentifier] NOT NULL,
	[SystemDBID] [int] NOT NULL,
	[DatabaseURN] [nvarchar](256) NOT NULL,
	[DatabaseName] [varchar](128) NOT NULL,
	[SystemObjectInd] [bit] NOT NULL,
	[CurrentState] [nvarchar](25) NULL,
	[ReadOnlyInd] [bit] NOT NULL,
	[AccessibleInd] [bit] NOT NULL,
	[CreateDt] [date] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpSecDatabases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpSecDatabases](
	[Name] [nvarchar](128) NULL,
	[Database_ID] [int] NULL,
	[ServerID] [int] NULL,
	[ETLProcess_ID] [int] NULL,
	[DatabaseName] [varchar](128) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerAuditOutputs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerAuditOutputs](
	[ServerAuditsID] [int] NOT NULL,
	[audit_id] [int] NOT NULL,
	[serverinstanceid] [int] NOT NULL,
	[action_id] [varchar](4) NOT NULL,
	[additional_information] [xml] NULL,
	[audit_file_offset] [bigint] NOT NULL,
	[event_time_date] [date] NULL,
	[class_type] [varchar](2) NOT NULL,
	[event_time_time] [time](7) NULL,
	[database_name] [nvarchar](128) NULL,
	[database_principal_id] [int] NULL,
	[database_principal_name] [nvarchar](128) NULL,
	[event_time] [datetime2](7) NOT NULL,
	[file_name] [nvarchar](260) NOT NULL,
	[is_column_permission] [bit] NULL,
	[object_id] [int] NULL,
	[object_name] [nvarchar](128) NULL,
	[permission_bitmask] [varbinary](16) NULL,
	[schema_name] [nvarchar](128) NULL,
	[sequence_number] [int] NULL,
	[server_instance_name] [nvarchar](128) NULL,
	[server_principal_id] [int] NULL,
	[server_principal_name] [nvarchar](128) NULL,
	[server_principal_sid] [varbinary](85) NULL,
	[session_id] [int] NULL,
	[session_server_principal_name] [nvarchar](128) NULL,
	[statement] [nvarchar](4000) NULL,
	[succeeded] [bit] NULL,
	[target_database_principal_id] [int] NULL,
	[target_database_principal_name] [nvarchar](128) NULL,
	[target_server_principal_id] [int] NULL,
	[target_server_principal_name] [nvarchar](128) NULL,
	[target_server_principal_sid] [varbinary](85) NULL,
	[user_defined_event_id] [int] NULL,
	[user_defined_information] [nvarchar](4000) NULL
) ON [DATAFG1] TEXTIMAGE_ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerClientNetworkProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerClientNetworkProtocolProperties](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ClientProtocolName] [nvarchar](30) NULL,
	[ClientProtocolURN] [nvarchar](256) NOT NULL,
	[ClientProtocolPropertyDisplayName] [nvarchar](50) NULL,
	[ClientProtocolPropertyValue] [nvarchar](100) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerClientNetworkProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerClientNetworkProtocols](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ClientProtocolURN] [nvarchar](256) NOT NULL,
	[ClientProtocolDisplayName] [nvarchar](50) NULL,
	[ClientProtocolName] [nvarchar](30) NULL,
	[ClientProtocolOrder] [int] NULL,
	[ClientProtocolState] [nvarchar](25) NULL,
	[ClientProtocolIsEnabledInd] [bit] NULL,
	[ClientNetLibrary] [nvarchar](25) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerConfigurations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerConfigurations](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[InstanceURN] [nvarchar](256) NOT NULL,
	[ConfigurationPropertyName] [nvarchar](128) NOT NULL,
	[ConfigurationValue] [nvarchar](128) NULL,
	[RunTimeValue] [nvarchar](128) NULL,
	[Description] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[MaximumValue] [nvarchar](50) NULL,
	[MinimumValue] [nvarchar](50) NULL,
	[IsAdvancedInd] [bit] NULL,
	[IsDynamicInd] [bit] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerInstances]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerInstances](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[InstanceURN] [nvarchar](256) NOT NULL,
	[InstanceState] [nvarchar](30) NOT NULL,
	[InKFBDOM1Domain] [bit] NULL,
	[WinAuthUserCanConnectToSystemInd] [bit] NOT NULL,
	[SQLAuthUserCanConnectToSystemInd] [bit] NOT NULL,
	[NamedInstanceInd] [bit] NOT NULL,
	[RetiredInd] [bit] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerNetworkProtocolsIPAddresses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerNetworkProtocolsIPAddresses](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ServerProtocolURN] [nvarchar](256) NOT NULL,
	[IPAddressURN] [nvarchar](256) NOT NULL,
	[IPAddressName] [nvarchar](128) NOT NULL,
	[IPAddress] [nvarchar](50) NOT NULL,
	[State] [nvarchar](30) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerNetworkProtocolsIPAddressProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerNetworkProtocolsIPAddressProperties](
	[ServerSystemID] [int] NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[IPAddressURN] [nvarchar](256) NOT NULL,
	[IPAddressName] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerPrincipals](
	[principal_id] [int] NULL,
	[ServerId] [int] NULL,
	[SID] [varbinary](85) NULL,
	[CreateDt] [datetime] NULL,
	[ModifiedDt] [datetime] NULL,
	[ServerPrincipalTypeCd] [varchar](1) NULL,
	[IsDisabledInd] [bit] NULL,
	[ADAccountInd] [bit] NULL,
	[ADGroupInd] [bit] NULL,
	[ETLProcess_ID_Prior] [int] NULL,
	[ETLProcess_ID] [int] NULL,
	[Name] [varchar](128) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerProperties](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[InstanceURN] [nvarchar](256) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [varchar](256) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerProtocolProperties](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[ServerProtocolURN] [nvarchar](256) NOT NULL,
	[ServerProtocolName] [nvarchar](128) NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerProtocols](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ETLProcessDt] [date] NOT NULL,
	[InstanceURN] [nvarchar](256) NOT NULL,
	[ServerProtocolURN] [nvarchar](256) NOT NULL,
	[ServerProtocolName] [nvarchar](128) NOT NULL,
	[ServerProtocolDisplayName] [nvarchar](128) NOT NULL,
	[ServerProtocolState] [nvarchar](30) NOT NULL,
	[ServerProtocolEnabledInd] [bit] NOT NULL,
	[ServerProtocolHasMultipleAddressesInd] [bit] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerRoleMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerRoleMembers](
	[RolePrincipalID] [int] NULL,
	[Principal_ID] [int] NULL,
	[ETLProcess_ID] [int] NULL,
	[ServerID] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpServerRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpServerRoles](
	[RolePrincipalId] [int] NULL,
	[ServerID] [int] NULL,
	[IsSysAdmin] [bit] NULL,
	[SID] [varbinary](85) NULL,
	[create_date] [datetime] NULL,
	[modify_date] [datetime] NULL,
	[AccessToAllDatabases] [bit] NULL,
	[CustomRoleInd] [bit] NULL,
	[Name] [varchar](128) NULL,
	[ETLProcess_ID] [int] NULL,
	[ETLProcess_ID_Prior] [int] NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpSQLAgentJobs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpSQLAgentJobs](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[JobGuid] [uniqueidentifier] NOT NULL,
	[JobName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[JobURN] [nvarchar](256) NULL,
	[JobType] [nvarchar](20) NULL,
	[JobState] [nvarchar](25) NULL,
	[VersionNumber] [int] NULL,
	[LastModifiedDt] [datetime] NULL,
	[CreatedDt] [datetime] NOT NULL,
	[HasStepsInd] [bit] NOT NULL,
	[IsEnabledInd] [bit] NOT NULL,
	[HasScheduleInd] [bit] NOT NULL,
	[StartStepID] [int] NULL,
	[LastRunDt] [datetime] NULL,
	[NextRunDt] [datetime] NULL,
	[LastRunOutcome] [nvarchar](25) NULL,
	[OriginatingServer] [nvarchar](128) NULL,
	[EmailLevel] [nvarchar](15) NULL,
	[NextRunScheduleID] [int] NULL,
	[OperatorToEmail] [nvarchar](75) NULL,
	[JobCategoryID] [int] NULL,
	[JobCategory] [nvarchar](128) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpSQLAgentJobSchedules]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpSQLAgentJobSchedules](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[JobGuid] [uniqueidentifier] NOT NULL,
	[ActiveEndDate] [datetime] NOT NULL,
	[ActiveEndTimeOfDay] [time](7) NOT NULL,
	[ActiveStartDate] [datetime] NOT NULL,
	[ActiveStartTimeOfDay] [time](7) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[FrequencyInterval] [int] NOT NULL,
	[FrequencyRecurrenceFactor] [int] NOT NULL,
	[FrequencyRelativeIntervals] [int] NOT NULL,
	[FrequencySubDayInterval] [int] NOT NULL,
	[FrequencySubDayTypes] [varchar](20) NOT NULL,
	[FrequencyTypes] [varchar](20) NOT NULL,
	[ID] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[JobCount] [int] NOT NULL,
	[ScheduleUid] [uniqueidentifier] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpSQLAgentJobSteps]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpSQLAgentJobSteps](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[JobGuid] [uniqueidentifier] NOT NULL,
	[JobStepURN] [nvarchar](512) NOT NULL,
	[JobID] [int] NOT NULL,
	[JobStepName] [nvarchar](128) NOT NULL,
	[JobDatabaseName] [nvarchar](128) NOT NULL,
	[StepCommand] [varchar](4000) NULL,
	[CommandExecutionSuccessCode] [nvarchar](40) NULL,
	[LastRunDuration] [int] NOT NULL,
	[LastRunOutcome] [varchar](30) NOT NULL,
	[OnFailAction] [varchar](30) NOT NULL,
	[OnFailStep] [varchar](30) NOT NULL,
	[OnSuccessAction] [varchar](30) NOT NULL,
	[OnSuccessStep] [varchar](30) NOT NULL,
	[RetryAttempts] [int] NOT NULL,
	[RetryInterval] [varchar](30) NOT NULL,
	[State] [varchar](30) NULL
) ON [DATAFG1]
GO
/****** Object:  Table [staging].[tmpSQLServices]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[tmpSQLServices](
	[ServerSystemID] [int] NOT NULL,
	[HostName] [varchar](128) NOT NULL,
	[InstanceName] [nvarchar](128) NOT NULL,
	[ServicesURN] [nvarchar](256) NOT NULL,
	[Name] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[Type] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[PathName] [nvarchar](512) NULL,
	[ServiceAccount] [nvarchar](50) NOT NULL,
	[ServicesState] [nvarchar](25) NULL,
	[State] [nvarchar](25) NULL,
	[StartMode] [nvarchar](128) NULL,
	[ETLProcessDt] [date] NOT NULL
) ON [DATAFG1]
GO
/****** Object:  View [security].[vw_ETLProcessId_Current]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [security].[vw_ETLProcessId_Current] AS
SELECT ET.ETLProcessId
FROM [security].[ETLProcessControl] ET
WHERE (CurrentRecordsInd = 1)
GO
/****** Object:  View [security].[vw_ServerPrincipals_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerPrincipals_CurrentETLProcessId] AS
SELECT 
SP1.ETLProcessId, 
SP1.ServerId, 
SP1.PrincipalId, 
SP1.CreateDt, 
SP1.ChangeTypeCd, 
SP1.IsDisabledind, 
SP1.ModifiedDt, 
SP1.ADGroupInd, 
SP1.Name, 
SP1.ServerPrincipalTypeCd, 
SP1.SQLSid, 
SP1.ADAccountInd, SP1.ServerPrincipalsId, SP1.SCDCurrentRecordInd
FROM [security].[ServerPrincipals] AS SP1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON SP1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_ServerPrincipals_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [security].[vw_ServerPrincipals_CurrentValues]
AS
SELECT 
	[SPCP1].[ETLProcessId]
	,[SPCP1].[ServerId]
	,[SPCP1].[PrincipalId]
	,[SPCP1].[CreateDt]
	,[SPCP1].[ChangeTypeCd]
	,[SPCP1].[IsDisabledind]
	,[SPCP1].[ModifiedDt]
	,[SPCP1].[ADGroupInd]
	,[SPCP1].[Name]
	,[SPCP1].[ServerPrincipalTypeCd]
	,[SPCP1].[SQLSid]
	,[SPCP1].[ADAccountInd]
	,[SPCP1].[ServerPrincipalsId]
	,[SPCP1].[SCDCurrentRecordInd]
FROM [security].[vw_ServerPrincipals_CurrentETLProcessId] AS SPCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON SPCP1.ETLProcessId = E1.ETLProcessId
WHERE     (SPCP1.ChangeTypeCd >= 0)
GO
/****** Object:  View [security].[vw_ETLProcessID_Prior]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [security].[vw_ETLProcessID_Prior] AS
SELECT MAX(ET.ETLProcessId) as PriorETLProcessID
FROM [security].[ETLProcessControl] ET
WHERE (CurrentRecordsInd = 0)
GO
/****** Object:  View [security].[vw_ServerPrincipals_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerPrincipals_PriorETLProcessId] AS
SELECT 
SP1.ETLProcessId, 
SP1.ServerId, 
SP1.ChangeTypeCd, 
SP1.PrincipalId, 
SP1.ServerPrincipalTypeCd, 
SP1.ADGroupInd, 
SP1.SQLSid, 
SP1.Name, 
SP1.ModifiedDt, 
SP1.CreateDt, 
SP1.ADAccountInd, 
SP1.IsDisabledind, SP1.ServerPrincipalsId, SP1.SCDCurrentRecordInd
FROM [security].[ServerPrincipals] AS SP1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON SP1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_ServerPrincipals_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [security].[vw_ServerPrincipals_PriorValues]
AS
SELECT 
	[SPCP1].[ETLProcessId]
	,[SPCP1].[ServerId]
	,[SPCP1].[PrincipalId]
	,[SPCP1].[CreateDt]
	,[SPCP1].[ChangeTypeCd]
	,[SPCP1].[IsDisabledind]
	,[SPCP1].[ModifiedDt]
	,[SPCP1].[ADGroupInd]
	,[SPCP1].[Name]
	,[SPCP1].[ServerPrincipalTypeCd]
	,[SPCP1].[SQLSid]
	,[SPCP1].[ADAccountInd]
	,[SPCP1].[ServerPrincipalsId]
	,[SPCP1].[SCDCurrentRecordInd]
FROM [security].[vw_ServerPrincipals_CurrentETLProcessId] AS SPCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON SPCP1.ETLProcessId = E1.ETLProcessId
LEFT OUTER JOIN [security].[vw_ServerPrincipals_PriorETLProcessId] AS SPPP2
ON [SPCP1].[ServerId] = [SPPP2].[ServerId]
AND [SPCP1].[SQLSid] = [SPPP2].[SQLSID]
WHERE     (SPCP1.ChangeTypeCd <= 0)
AND ([SPCP1].[SQLSID]) IS NULL
UNION
SELECT [ETLProcessId]
      ,[ServerId]
      ,[ChangeTypeCd]
      ,[PrincipalId]
      ,[ServerPrincipalTypeCd]
      ,[ADGroupInd]
      ,[SQLSid]
      ,[Name]
      ,[ModifiedDt]
      ,[CreateDt]
      ,[ADAccountInd]
      ,[IsDisabledind]
      ,[ServerPrincipalsId]
      ,[SCDCurrentRecordInd]
  FROM [security].[vw_ServerPrincipals_PriorETLProcessId] AS SPPP1
WHERE ([SPPP1].[ChangeTypeCd] >= 0)
GO
/****** Object:  View [security].[vw_ServerRoleMembers_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoleMembers_CurrentETLProcessId] AS
SELECT [SRM1].[ETLProcessId]
      ,[SRM1].[ServerPrincipalsId]
      ,[SRM1].[ServerRoleId]
FROM [security].[ServerRoleMembers] AS SRM1
 INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
 ON SRM1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_ServerRoleMembers_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoleMembers_PriorETLProcessId] AS
SELECT [SRM1].[ETLProcessId]
      ,[SRM1].[ServerPrincipalsId]
      ,[SRM1].[ServerRoleId]
FROM [security].[ServerRoleMembers] AS SRM1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON SRM1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_ServerRoles_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoles_CurrentETLProcessId] AS
SELECT 
[SR1].[ServerId]
,[SR1].[RolePrincipalId]
,[SR1].[SID]
,[SR1].[Name]
,[SR1].[AccessToAllDatabasesInd]
,[SR1].[SysAdminInd]
,[SR1].[CreateDt]
,[SR1].[ModifyDt]
,[SR1].[ChangeTypeCd], SR1.ServerRoleId, SR1.ETLProcessId, SR1.CustomRoleInd, SR1.ReportingShortDescription, SR1.ReportingLongDescription, SR1.SCDCurrentRecordInd
FROM [security].[ServerRoles] AS SR1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON SR1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_ServerRoles_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoles_CurrentValues]
AS
SELECT [SRCP1].[ServerId]
      ,[SRCP1].[RolePrincipalId]
      ,[SRCP1].[SID]
      ,[SRCP1].[Name]
      ,[SRCP1].[AccessToAllDatabasesInd]
      ,[SRCP1].[SysAdminInd]
      ,[SRCP1].[CreateDt]
      ,[SRCP1].[ModifyDt]
      ,[SRCP1].[ChangeTypeCd]
      ,[SRCP1].[ServerRoleId]
      ,[SRCP1].[ETLProcessId]
      ,[SRCP1].[CustomRoleInd]
      ,[SRCP1].[ReportingShortDescription]
      ,[SRCP1].[ReportingLongDescription]
      ,[SRCP1].[SCDCurrentRecordInd]
FROM [security].[vw_ServerRoles_CurrentETLProcessId] AS SRCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON SRCP1.ETLProcessId = E1.ETLProcessId
WHERE     (SRCP1.ChangeTypeCd >= 0)
GO
/****** Object:  View [security].[vw_ServerRoles_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoles_PriorETLProcessId] AS
SELECT 
[SR1].[ServerId]
,[SR1].[RolePrincipalId]
,[SR1].[SID]
,[SR1].[Name]
,[SR1].[AccessToAllDatabasesInd]
,[SR1].[SysAdminInd]
,[SR1].[CreateDt]
,[SR1].[ModifyDt]
,[SR1].[ChangeTypeCd], SR1.ServerRoleId, SR1.ETLProcessId, SR1.CustomRoleInd, SR1.ReportingShortDescription, SR1.ReportingLongDescription, SR1.SCDCurrentRecordInd
FROM [security].[ServerRoles] AS SR1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON SR1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_ServerRoles_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ServerRoles_PriorValues]
AS
SELECT [SRCP1].[ServerId]
      ,[SRCP1].[RolePrincipalId]
      ,[SRCP1].[SID]
      ,[SRCP1].[Name]
      ,[SRCP1].[AccessToAllDatabasesInd]
      ,[SRCP1].[SysAdminInd]
      ,[SRCP1].[CreateDt]
      ,[SRCP1].[ModifyDt]
      ,[SRCP1].[ChangeTypeCd]
      ,[SRCP1].[ServerRoleId]
      ,[SRCP1].[ETLProcessId]
      ,[SRCP1].[CustomRoleInd]
      ,[SRCP1].[ReportingShortDescription]
      ,[SRCP1].[ReportingLongDescription]
      ,[SRCP1].[SCDCurrentRecordInd]
 FROM [security].[vw_ServerRoles_CurrentETLProcessId] AS SRCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON SRCP1.ETLProcessId = E1.ETLProcessId
LEFT OUTER JOIN [security].[vw_ServerRoles_PriorETLProcessId] AS SRPP2
ON [SRCP1].[ServerId] = [SRPP2].[ServerId]
AND [SRCP1].[SID] = [SRPP2].[SID]
WHERE     (SRCP1.ChangeTypeCd <= 0)
AND ([SRCP1].[SID]) IS NULL
UNION
SELECT [ServerId]
      ,[RolePrincipalId]
      ,[SID]
      ,[Name]
      ,[AccessToAllDatabasesInd]
      ,[SysAdminInd]
      ,[CreateDt]
      ,[ModifyDt]
      ,[ChangeTypeCd]
      ,[ServerRoleId]
      ,[ETLProcessId]
      ,[CustomRoleInd]
      ,[ReportingShortDescription]
      ,[ReportingLongDescription]
      ,[SCDCurrentRecordInd]
  FROM [security].[vw_ServerRoles_PriorETLProcessId] AS SRPP1
WHERE ([SRPP1].[ChangeTypeCd] >=0)
GO
/****** Object:  View [security].[vw_ADGroups_SecurityGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [security].[vw_ADGroups_SecurityGroups] AS
SELECT 
ADG1.ADGroupId, 
ADG1.GUId, 
ADG1.sid, 
ADG1.ETLProcessId, 
ADG1.adsPath, 
ADG1.groupType, 
ADG1.samAccountName, 
ADG1.distinguishedName, 
ADG1.cn, ADG1.Description, 
ADG1.DisplayName, 
ADG1.objectCategory, 
ADG1.Name, 
ADG1.whenChanged, 
ADG1.department, 
ADG1.whenCreated, 
ADG1.samAccountType, 
ADG1.schemaentry, 
ADG1.schemaclassname, 
ADG1.SCDCurrentRecordInd, 
ADG1.ChangeTypeCd, 
ADG1.SecurityGroupInd
FROM security.ADGroups ADG1
WHERE (ADG1.SecurityGroupInd = 1)
GO
/****** Object:  View [security].[vw_ADGroupMembers_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE VIEW [security].[vw_ADGroupMembers_CurrentETLProcessId] AS
SELECT 
ADGM1.[ADGroupGUID]
,ADGM1.[ADUsersGUID]
,ADGM1.IsNestedGroupInd
,CAST(1 AS BIT) AS [SecurityGroupInd]
,ADGM1.ETLProcessStartID
,ADGM1.ETLProcessEndID
FROM [security].[ADGroupMembers] AS ADGM1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON ADGM1.ETLProcessEndID = E1.[ETLProcessId]
WHERE ADGM1.[ADGroupGUID] IN (SELECT DISTINCT [GUID]
FROM [security].[vw_ADGroups_SecurityGroups])
GO
/****** Object:  View [security].[vw_ADGroupMembers_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE VIEW [security].[vw_ADGroupMembers_PriorETLProcessId] 
AS
SELECT 
ADGM1.[ADGroupGUID]
,ADGM1.[ADUsersGUID]
,ADGM1.IsNestedGroupInd
,CAST(1 AS BIT) AS [SecurityGroupInd]
,ADGM1.ETLProcessStartID
,ADGM1.ETLProcessEndID
FROM [security].[ADGroupMembers] AS ADGM1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON ADGM1.ETLProcessEndID = E1.[PriorETLProcessID]
WHERE ADGM1.[ADGroupGUID] IN (SELECT DISTINCT [GUID]
FROM [security].[vw_ADGroups_SecurityGroups])
GO
/****** Object:  View [security].[vw_ADGroups_ApplicationNames]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [security].[vw_ADGroups_ApplicationNames]
AS
SELECT 
[ETLProcessId]
      ,[samAccountName]
	  ,CASE WHEN CHARINDEX('_',[samAccountName],5) > 5 
	  THEN SUBSTRING([SAMACCOUNTNAME],5,CHARINDEX('_',[samAccountName],5) - 5)
	  ELSE SUBSTRING([SAMACCOUNTNAME],5,len(samaccountname)) END AS ApplicationName
      ,[Name]
      ,[SCDCurrentRecordInd]
      ,[ChangeTypeCd]
   FROM [security].[vw_ADGroups_SecurityGroups]
  where samAccountName like 'SQL[_]%'
  and SCDCurrentRecordInd = 1
  --order by samAccountName
GO
/****** Object:  View [security].[vw_ADGroups_CurrentETLProcessID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE VIEW [security].[vw_ADGroups_CurrentETLProcessID] AS
SELECT [ADG1].[ADGroupId]
      ,[ADG1].[GUId]
      ,[ADG1].[sid]
      ,[ADG1].[ETLProcessId]
      ,[ADG1].[adsPath]
      ,[ADG1].[groupType]
      ,[ADG1].[samAccountName]
      ,[ADG1].[distinguishedName]
      ,[ADG1].[cn]
      ,[ADG1].[Description]
      ,[ADG1].[SecurityGroupInd]
      ,[ADG1].[DisplayName]
      ,[ADG1].[objectCategory]
      ,[ADG1].[Name]
      ,[ADG1].[whenChanged]
      ,[ADG1].[department]
      ,[ADG1].[whenCreated]
      ,[ADG1].[samAccountType]
      ,[ADG1].[schemaentry]
      ,[ADG1].[schemaclassname]
      ,[ADG1].[SCDCurrentRecordInd]
      ,[ADG1].[ChangeTypeCd]
FROM [security].[vw_ADGroups_SecurityGroups] AS ADG1
INNER JOIN [security].[vw_ETLProcessId_Current] as E1
ON ADG1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_ADGroups_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADGroups_CurrentValues]
AS
SELECT     
	[ADGCP1].[ADGroupId],
	[ADGCP1].[GUId],
	[ADGCP1].[sid],
	[ADGCP1].[ETLProcessId],
	[ADGCP1].[adsPath],
	[ADGCP1].[groupType],
	[ADGCP1].[samAccountName],
	[ADGCP1].[distinguishedName],
	[ADGCP1].[cn], [ADGCP1].[Description],
	[ADGCP1].[SecurityGroupInd],
	[ADGCP1].[DisplayName],
	[ADGCP1].[objectCategory],
	[ADGCP1].[Name], 
	[ADGCP1].[whenChanged],
	[ADGCP1].[department],
	[ADGCP1].[whenCreated],
	[ADGCP1].[samAccountType],
	[ADGCP1].[schemaentry],
	[ADGCP1].[schemaclassname], 
	[ADGCP1].[SCDCurrentRecordInd],
	[ADGCP1].[ChangeTypeCd]
FROM         [security].vw_ADGroups_CurrentETLProcessID AS ADGCP1 
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON ADGCP1.ETLProcessId = E1.ETLProcessId
WHERE     (ADGCP1.ChangeTypeCd >= 0)
GO
/****** Object:  View [security].[vw_ADGroups_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADGroups_PriorETLProcessId] AS
SELECT [ADG1].[ADGroupId]
      ,[ADG1].[GUId]
      ,[ADG1].[sid]
      ,[ADG1].[ETLProcessId]
      ,[ADG1].[adsPath]
      ,[ADG1].[groupType]
      ,[ADG1].[samAccountName]
      ,[ADG1].[distinguishedName]
      ,[ADG1].[cn]
      ,[ADG1].[Description]
      ,[ADG1].[SecurityGroupInd]
      ,[ADG1].[DisplayName]
      ,[ADG1].[objectCategory]
      ,[ADG1].[Name]
      ,[ADG1].[whenChanged]
      ,[ADG1].[department]
      ,[ADG1].[whenCreated]
      ,[ADG1].[samAccountType]
      ,[ADG1].[schemaentry]
      ,[ADG1].[schemaclassname]
      ,[ADG1].[SCDCurrentRecordInd]
      ,[ADG1].[ChangeTypeCd]
FROM [security].[vw_ADGroups_SecurityGroups] AS ADG1
INNER JOIN [security].[vw_ETLProcessId_Prior] as E1
ON ADG1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_ADGroups_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADGroups_PriorValues]
AS
SELECT     
	[ADGCP1].[ADGroupId],
	[ADGCP1].[GUId],
	[ADGCP1].[sid],
	[ADGCP1].[ETLProcessId],
	[ADGCP1].[adsPath],
	[ADGCP1].[groupType],
	[ADGCP1].[samAccountName],
	[ADGCP1].[distinguishedName],
	[ADGCP1].[cn],
	[ADGCP1].[Description],
	[ADGCP1].[SecurityGroupInd],
	[ADGCP1].[DisplayName],
	[ADGCP1].[objectCategory],
	[ADGCP1].[Name], 
	[ADGCP1].[whenChanged],
	[ADGCP1].[department],
	[ADGCP1].[whenCreated],
	[ADGCP1].[samAccountType],
	[ADGCP1].[schemaentry],
	[ADGCP1].[schemaclassname], 
	[ADGCP1].[SCDCurrentRecordInd],
	[ADGCP1].[ChangeTypeCd]
FROM         [security].vw_ADGroups_CurrentETLProcessID AS ADGCP1 
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON ADGCP1.ETLProcessId = E1.ETLProcessId
WHERE     (ADGCP1.ChangeTypeCd <= 0)
AND [ADGCP1].[GUId] NOT IN 
	(SELECT DISTINCT 
      [GUId]
      FROM [security].[vw_ADGroups_PriorETLProcessId])
UNION
SELECT [ADGPP1].[ADGroupId]
      ,[ADGPP1].[GUId]
      ,[ADGPP1].[sid]
      ,[ADGPP1].[ETLProcessId]
      ,[ADGPP1].[adsPath]
      ,[ADGPP1].[groupType]
      ,[ADGPP1].[samAccountName]
      ,[ADGPP1].[distinguishedName]
      ,[ADGPP1].[cn]
      ,[ADGPP1].[Description]
      ,[ADGPP1].[SecurityGroupInd]
      ,[ADGPP1].[DisplayName]
      ,[ADGPP1].[objectCategory]
      ,[ADGPP1].[Name]
      ,[ADGPP1].[whenChanged]
      ,[ADGPP1].[department]
      ,[ADGPP1].[whenCreated]
      ,[ADGPP1].[samAccountType]
      ,[ADGPP1].[schemaentry]
      ,[ADGPP1].[schemaclassname]
      ,[ADGPP1].[SCDCurrentRecordInd]
      ,[ADGPP1].[ChangeTypeCd]
  FROM [security].[vw_ADGroups_PriorETLProcessId] AS [ADGPP1]
  WHERE ([ADGPP1].[ChangeTypeCd] >=0)
GO
/****** Object:  View [security].[vw_ADUsers_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADUsers_CurrentETLProcessId] AS
SELECT [ADU1].[ADUsersId]
      ,[ADU1].[GUId]
      ,[ADU1].[ETLProcessId]
      ,[ADU1].[sid]
      ,[ADU1].[containerADSPath]
      ,[ADU1].[samAccountName]
      ,[ADU1].[GivenName]
      ,[ADU1].[SN]
      ,[ADU1].[Manager]
      ,[ADU1].[Title]
      ,[ADU1].[cn]
      ,[ADU1].[objectCategory]
      ,[ADU1].[userprincipalname]
      ,[ADU1].[samAccountType]
      ,[ADU1].[primaryGroup]
      ,[ADU1].[Description]
      ,[ADU1].[DisplayName]
      ,[ADU1].[department]
      ,[ADU1].[userAccountControl]
      ,[ADU1].[userAccountDisabledInd]
      ,[ADU1].[WhenChanged]
      ,[ADU1].[WhenCreated]
      ,[ADU1].[DistinguishedName]
      ,[ADU1].[Name]
      ,[ADU1].[SCDCurrentRecordInd]
      ,[ADU1].[ChangeTypeCd]
FROM [security].[ADUsers] AS ADU1
INNER JOIN [security].[vw_ETLProcessId_Current] as E1
ON ADU1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_ADUsers_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADUsers_CurrentValues]
AS
SELECT [ADUCP1].[ADUsersId]
      ,[ADUCP1].[GUId]
      ,[ADUCP1].[ETLProcessId]
      ,[ADUCP1].[sid]
      ,[ADUCP1].[containerADSPath]
      ,[ADUCP1].[samAccountName]
      ,[ADUCP1].[GivenName]
      ,[ADUCP1].[SN]
      ,[ADUCP1].[Manager]
      ,[ADUCP1].[Title]
      ,[ADUCP1].[cn]
      ,[ADUCP1].[objectCategory]
      ,[ADUCP1].[userprincipalname]
      ,[ADUCP1].[samAccountType]
      ,[ADUCP1].[primaryGroup]
      ,[ADUCP1].[Description]
      ,[ADUCP1].[DisplayName]
      ,[ADUCP1].[department]
      ,[ADUCP1].[userAccountControl]
      ,[ADUCP1].[userAccountDisabledInd]
      ,[ADUCP1].[WhenChanged]
      ,[ADUCP1].[WhenCreated]
      ,[ADUCP1].[DistinguishedName]
      ,[ADUCP1].[Name]
      ,[ADUCP1].[SCDCurrentRecordInd]
      ,[ADUCP1].[ChangeTypeCd]
  FROM [security].[vw_ADUsers_CurrentETLProcessId] AS ADUCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON ADUCP1.ETLProcessId = E1.ETLProcessId
WHERE     (ADUCP1.ChangeTypeCd >= 0)
GO
/****** Object:  View [security].[vw_ADUsers_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADUsers_PriorETLProcessId] AS
SELECT [ADU1].[ADUsersId]
      ,[ADU1].[GUId]
      ,[ADU1].[ETLProcessId]
      ,[ADU1].[sid]
      ,[ADU1].[containerADSPath]
      ,[ADU1].[samAccountName]
      ,[ADU1].[GivenName]
      ,[ADU1].[SN]
      ,[ADU1].[Manager]
      ,[ADU1].[Title]
      ,[ADU1].[cn]
      ,[ADU1].[objectCategory]
      ,[ADU1].[userprincipalname]
      ,[ADU1].[samAccountType]
      ,[ADU1].[primaryGroup]
      ,[ADU1].[Description]
      ,[ADU1].[DisplayName]
      ,[ADU1].[department]
      ,[ADU1].[userAccountControl]
      ,[ADU1].[userAccountDisabledInd]
      ,[ADU1].[WhenChanged]
      ,[ADU1].[WhenCreated]
      ,[ADU1].[DistinguishedName]
      ,[ADU1].[Name]
      ,[ADU1].[SCDCurrentRecordInd]
      ,[ADU1].[ChangeTypeCd]
FROM [security].[ADUsers] AS ADU1
INNER JOIN [security].[vw_ETLProcessId_Prior] as E1
ON ADU1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_ADUsers_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_ADUsers_PriorValues]
AS
SELECT [ADUCP1].[ADUsersId]
      ,[ADUCP1].[GUId]
      ,[ADUCP1].[ETLProcessId]
      ,[ADUCP1].[sid]
      ,[ADUCP1].[containerADSPath]
      ,[ADUCP1].[samAccountName]
      ,[ADUCP1].[GivenName]
      ,[ADUCP1].[SN]
      ,[ADUCP1].[Manager]
      ,[ADUCP1].[Title]
      ,[ADUCP1].[cn]
      ,[ADUCP1].[objectCategory]
      ,[ADUCP1].[userprincipalname]
      ,[ADUCP1].[samAccountType]
      ,[ADUCP1].[primaryGroup]
      ,[ADUCP1].[Description]
      ,[ADUCP1].[DisplayName]
      ,[ADUCP1].[department]
      ,[ADUCP1].[userAccountControl]
      ,[ADUCP1].[userAccountDisabledInd]
      ,[ADUCP1].[WhenChanged]
      ,[ADUCP1].[WhenCreated]
      ,[ADUCP1].[DistinguishedName]
      ,[ADUCP1].[Name]
      ,[ADUCP1].[SCDCurrentRecordInd]
      ,[ADUCP1].[ChangeTypeCd]
  FROM [security].[vw_ADUsers_CurrentETLProcessId] AS ADUCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON ADUCP1.ETLProcessId = E1.ETLProcessId
WHERE     (ADUCP1.ChangeTypeCd <= 0)
AND [ADUCP1].[GUId] NOT IN 
	(SELECT DISTINCT
	[GUId]
	FROM [security].[vw_ADUsers_PriorETLProcessId])
UNION
SELECT [ADUsersId]
      ,[GUId]
      ,[ETLProcessId]
      ,[sid]
      ,[containerADSPath]
      ,[samAccountName]
      ,[GivenName]
      ,[SN]
      ,[Manager]
      ,[Title]
      ,[cn]
      ,[objectCategory]
      ,[userprincipalname]
      ,[samAccountType]
      ,[primaryGroup]
      ,[Description]
      ,[DisplayName]
      ,[department]
      ,[userAccountControl]
      ,[userAccountDisabledInd]
      ,[WhenChanged]
      ,[WhenCreated]
      ,[DistinguishedName]
      ,[Name]
      ,[SCDCurrentRecordInd]
      ,[ChangeTypeCd]
  FROM [security].[vw_ADUsers_PriorETLProcessId] AS [ADUPP1]
WHERE ([ADUPP1].[ChangeTypeCd] >= 0)
GO
/****** Object:  View [dbo].[vw_Applications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Applications] AS
SELECT 
[BA1].[ApplicationId]
,RIGHT('000' + CAST([BA1].[ApplicationId] AS VARCHAR(3)),3) AS FormattedApplicationID
,[BA1].[RetiredInd]
,[BA1].[SQLDBBasedAppInd]
,[BA1].[ApplicationName]
,[BA1].[BusinessCategoryID]
,[BA1].[FinanciallySignificantAppInd]
,[BA1].[KFBMFApplicationCode]
,[BA1].[ApplicationCommonName]
,[BA1].[ActiveDirectoryGroupTag]
,[BA1].[InternallyDevelopedAppInd]
,[BA1].[PrimaryBusinessPurposeDesc]
,[BA1].[AppDBERModelName]
,[BA1].[KFBDistributedAbbreviations]
,[BA1].[VendorSuppliedDBInd]
,[BA1].[LastUpdateDt]
,[BA1].[ActiveDirectoryGroupAccessInd]
FROM [dbo].[Applications] BA1
GO
/****** Object:  View [dbo].[vw_BusinessCategories]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_BusinessCategories] AS
SELECT BC.BusinessCategoryID BusinessCategoryID, BC.BusinessCategoryDesc BusinessCategoryDesc, BC.BusinessCatgeoryLongDesc BusinessCategoryLongDesc, BC.BusinessCategoryAbbreviation
FROM dbo.BusinessCategories BC
GO
/****** Object:  View [dbo].[vw_DatabaseExtendedProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DatabaseExtendedProperties] AS
SELECT DBP1.DatabaseExtendedPropertyID, DBP1.ExtendedPropertyName, DBP1.DatabaseURN, DBP1.ExtendedPropertyValue, DBP1.ExtendedPropertyLength, DBP1.IsCustomExtendedProperty, DBP1.DatabaseUniqueId, DBP1.ETLProcessId, DBP1.FirstReportedDate, DBP1.LatestReportedDate
FROM [dbo].[DatabaseExtendedProperties] AS DBP1
GO
/****** Object:  View [dbo].[vw_Databases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Databases] AS
SELECT DB1.DatabaseUniqueId, DB1.ServerInstanceId, DB1.DatabaseGuid, DB1.DatabaseURN, DB1.DatabaseName, DB1.ReadOnlyInd, DB1.SystemObjectInd, DB1.SystemDBID, DB1.AccessibleInd, DB1.CurrentState, DB1.ETLProcessId, DB1.DeletedInd, DB1.CreateDt, DB1.FirstReportedDate, DB1.LatestReportedDate
FROM [dbo].[Databases] AS DB1
GO
/****** Object:  View [dbo].[vw_DatabaseApplications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_DatabaseApplications] AS
SELECT DB1.DatabaseUniqueId, DB1.ServerInstanceId, DBApp1.ApplicationId ApplicationId, DBApp1.ApplicationName ApplicationName, DBApp1.BusinessCategoryID BusinessCategoryID, DBApp1.BusinessCategoryDesc BusinessCategoryDesc
FROM [dbo].[vw_Databases] AS DB1
LEFT OUTER JOIN
	(SELECT
	[DBEP1].DatabaseUniqueId
	,[App1].[ApplicationId]
	,[App1].[ApplicationName]
	,[BC1].[BusinessCategoryID]
	,[BC1].[BusinessCategoryDesc]
	FROM [dbo].[vw_Applications] AS App1
	INNER JOIN
	(SELECT 
	[DatabaseUniqueId]
	,[ExtendedPropertyName]
	,[ExtendedPropertyValue]
	FROM [dbo].[vw_DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID%'
	AND [ExtendedPropertyValue] NOT LIKE 'Need Value'
	AND ISNUMERIC([ExtendedPropertyValue]) = 1
	) AS DBEP1
	ON [DBEP1].[ExtendedPropertyValue] = [App1].[ApplicationId]
	LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC1
	ON [App1].[BusinessCategoryID] = [BC1].[BusinessCategoryID]
	) AS DBApp1
	ON [DB1].[DatabaseUniqueId] = [DBApp1].[DatabaseUniqueId]
GO
/****** Object:  View [dbo].[vw_DatabaseFiles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DatabaseFiles] AS
SELECT 
DBF1.DatabaseFileID, 
DBF1.DatabaseUniqueID, 
DBF1.ETLProcessID, 
DBF1.DatabaseFileURN, 
DBF1.FileGroupName, 
DBF1.FileID, 
DBF1.FileLogicalName, 
DBF1.LatestReportedDate, 
DBF1.DatabaseURN, 
DBF1.FileType, 
DBF1.IsPrimaryFileInd, 
DBF1.FileFullName, 
DBF1.Growth, 
DBF1.GrowthType, 
DBF1.[Size],
DBF1.[UsedSpace]
FROM DatabaseFiles DBF1
GO
/****** Object:  View [dbo].[vw_ServerInstances]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerInstances] AS
SELECT 
[ServerInstanceId] AS ServerInstanceID
,[ServerSystemID] AS ServerSystemID
,[NamedInstanceInd] AS NamedInstanceInd
,[InstanceName] AS InstanceName
,[InstanceURN] AS InstanceURN
,[ManagedBySQLDBAsInd] AS ManagedBySQLDBAsInd
,[WinAuthUserCanConnectToSystemInd] AS WinAuthUserCanConnectToSystemInd
,[SQLAuthUserCanConnectToSystemInd] AS SQLAuthUserCanConnectToSystemInd
,[RetiredInd] AS RetiredInd
,[ETLProcessId] AS ETLProcessId
,[InstanceState] AS InstanceState
,[FirstReportedDate] AS FirstReportedDate
,[LatestReportedDate] AS LatestReportedDate
FROM dbo.[ServerInstances]
GO
/****** Object:  View [dbo].[vw_Servers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Servers] AS
SELECT 
S1.ServerSystemID,
S1.HostName,
S1.RetiredInd,
S1.ExcludeFromETLProcessesInd,
S1.ExcludeFromWMIDataLoadInd,
S1.ExcludeFromServiceRestartInd,
S1.UsedByAppSyncInd,
S1.ReplacedByHost,
S1.SMOVersionCompatibility,
S1.InKFBDOM1Domain,
S1.ManagedBySQLDBAsInd,
S1.MonitoredbySQLToolsInd,
S1.UsageScope,
S1.PrimaryDataProcessModelType,
S1.LocalHostDescription,
S1.BusinessCategoryID,
S1.PrimaryApplicationUsedFor,
S1.OSName,
S1.OSVersion,
S1.OSManufacturer,
S1.OSEdition,
S1.OSFullVersion,
S1.ProductionInd,
S1.OSRelease,
S1.OSCaption,
S1.OSVersionID,
S1.OSSKUId,
S1.OSLanguage,
S1.OSType,
S1.WindowsDirectory,
S1.OSProductType,
S1.OSBuildNumber,
S1.ServicePackMajorVersion,
S1.ServicePackMinorVersion,
S1.CSDVersion,
S1.DateAdded,
S1.LatestReportedDate
FROM dbo.[Servers] AS S1
GO
/****** Object:  View [dbo].[vw_DatabaseFiles_UserDatabases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_DatabaseFiles_UserDatabases] AS
SELECT 
S1.HostName, 
SI1.InstanceName, 
DB1.ServerInstanceId, 
DB1.DatabaseName, 
DB1.CreateDt, 
DB1.SystemObjectInd, 
DBF1.[Size] AS [Size],
DBF1.ETLProcessID AS ETLProcessID,
DBF1.DatabaseFileID AS DatabaseFileID,
DB1.CurrentState,
DBF1.FileID AS FileID,
DBF1.FileType AS FileType,
DBF1.DatabaseUniqueID AS DatabaseUniqueID,
substring([DBF1].[FileFullName],1,1) AS Drive,
DBF1.FileFullName AS FileFullName,
DBF1.FileLogicalName AS FileLogicalName
FROM [dbo].[vw_Databases] AS [DB1]
LEFT OUTER JOIN 
 (SELECT [DatabaseFileID]
      ,[DatabaseUniqueID]
      ,[DatabaseURN]
      ,[ETLProcessID]
      ,[FileID]
      ,[DatabaseFileURN]
      ,[FileGroupName]
      ,[FileType]
      ,[FileFullName]
      ,[FileLogicalName]
	  ,[Size]
      ,[LatestReportedDate]
  FROM [dbo].[vw_DatabaseFiles]
  WHERE [LatestReportedDate] = CAST(GETDATE() AS DATE)
  ) AS [DBF1]
ON [DB1].DatabaseUniqueId = [DBF1].[DatabaseUniqueID]
INNER JOIN [dbo].[vw_ServerInstances] AS [SI1]
ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceID]
INNER JOIN [dbo].[vw_Servers] AS [S1]
ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
GO
/****** Object:  View [security].[vw_DatabasePrincipals_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabasePrincipals_CurrentETLProcessId] AS
SELECT 
[DBP1].[DatabasePrincipalsId]
,[DBP1].[ETLProcessId]
,[DBP1].[ServerId]
,[DBP1].[DatabaseID]
,[DBP1].[PrincipalId]
,[DBP1].[ChangeTypeCd]
,[DBP1].[SID]
,[DBP1].[UserName]
,[DBP1].[CreateDt]
,[DBP1].[ModifyDt], DBP1.SCDCurrentRecordInd
FROM         [security].[DatabasePrincipals] AS DBP1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON DBP1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_DatabasePrincipals_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabasePrincipals_CurrentValues]
AS
SELECT [DBPC1].[DatabasePrincipalsId]
      ,[DBPC1].[ETLProcessId]
      ,[DBPC1].[ServerId]
      ,[DBPC1].[DatabaseID]
      ,[DBPC1].[PrincipalId]
      ,[DBPC1].[ChangeTypeCd]
      ,[DBPC1].[SID]
      ,[DBPC1].[UserName]
      ,[DBPC1].[CreateDt]
      ,[DBPC1].[ModifyDt]
      ,[DBPC1].[SCDCurrentRecordInd]
  FROM [security].[vw_DatabasePrincipals_CurrentETLProcessId] AS DBPC1 
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON DBPC1.ETLProcessId = E1.ETLProcessId
WHERE DBPC1.ChangeTypeCd >= 0
GO
/****** Object:  View [security].[vw_DatabasePrincipals_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabasePrincipals_PriorETLProcessId] AS
SELECT 
[DBP1].[DatabasePrincipalsId]
,[DBP1].[ETLProcessId]
,[DBP1].[ServerId]
,[DBP1].[DatabaseID]
,[DBP1].[PrincipalId]
,[DBP1].[ChangeTypeCd]
,[DBP1].[SID]
,[DBP1].[UserName]
,[DBP1].[CreateDt]
,[DBP1].[ModifyDt], DBP1.SCDCurrentRecordInd
FROM         [security].[DatabasePrincipals] AS DBP1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON DBP1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_DatabasePrincipals_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabasePrincipals_PriorValues]
AS
SELECT [DBPC1].[DatabasePrincipalsId]
      ,[DBPC1].[ETLProcessId]
      ,[DBPC1].[ServerId]
      ,[DBPC1].[DatabaseID]
      ,[DBPC1].[PrincipalId]
      ,[DBPC1].[ChangeTypeCd]
      ,[DBPC1].[SID]
      ,[DBPC1].[UserName]
      ,[DBPC1].[CreateDt]
      ,[DBPC1].[ModifyDt]
      ,[DBPC1].[SCDCurrentRecordInd]
  FROM [security].[vw_DatabasePrincipals_CurrentETLProcessId] AS DBPC1 
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON DBPC1.ETLProcessId = E1.ETLProcessId
LEFT OUTER JOIN [security].[vw_DatabasePrincipals_PriorETLProcessId] AS DBPP2
ON [DBPC1].[ServerId] = [DBPP2].[ServerId]
AND [DBPC1].[DatabaseID] = [DBPP2].[DatabaseID]
AND [DBPC1].[SID] = [DBPP2].[SID] 
WHERE (DBPC1.ChangeTypeCd <= 0)
AND [DBPP2].[SID] IS NULL
UNION
SELECT [DatabasePrincipalsId]
      ,[ETLProcessId]
      ,[ServerId]
      ,[DatabaseID]
      ,[PrincipalId]
      ,[ChangeTypeCd]
      ,[SID]
      ,[UserName]
      ,[CreateDt]
      ,[ModifyDt]
      ,[SCDCurrentRecordInd]
  FROM [security].[vw_DatabasePrincipals_PriorETLProcessId] AS DBPP1
WHERE ([DBPP1].[ChangeTypeCd] >= 0)
GO
/****** Object:  View [security].[vw_DatabaseRoleMembers_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoleMembers_CurrentETLProcessId] AS
SELECT [DBRM1].[ETLProcessId]
      ,[DBRM1].[DatabasePrincipalsId]
      ,[DBRM1].[DatabaseRolesId]
FROM [security].[DatabaseRoleMembers] AS DBRM1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON DBRM1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_DatabaseRoleMembers_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoleMembers_PriorETLProcessId] AS
SELECT [DBRM1].[ETLProcessId]
      ,[DBRM1].[DatabasePrincipalsId]
      ,[DBRM1].[DatabaseRolesId]
FROM [security].[DatabaseRoleMembers] AS DBRM1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON DBRM1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_DatabaseRoles_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoles_CurrentETLProcessId] AS
SELECT 
	[DBR1].[DatabaseRolesId]
	,[DBR1].[ETLProcessId]
	,[DBR1].[ServerId]
	,[DBR1].[DatabaseID]
	,[DBR1].[PrincipalId]
	,[DBR1].[ChangeTypeCd]
	,[DBR1].[Name]
	,[DBR1].[Type]
	,[DBR1].[ModifyDt]
	,[DBR1].[CreateDt], DBR1.SID, DBR1.CustomRoleInd, DBR1.InheritedServerRoleId, DBR1.SCDCurrentRecordInd, DBR1.ReportingShortDescription, DBR1.ReportingLongDescription
FROM        [security].[DatabaseRoles] AS DBR1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON DBR1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [security].[vw_DatabaseRoles_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoles_CurrentValues]
AS
SELECT [DBRCP1].[DatabaseRolesId]
      ,[DBRCP1].[ETLProcessId]
      ,[DBRCP1].[ServerId]
      ,[DBRCP1].[DatabaseID]
      ,[DBRCP1].[PrincipalId]
      ,[DBRCP1].[ChangeTypeCd]
      ,[DBRCP1].[Name]
      ,[DBRCP1].[Type]
      ,[DBRCP1].[ModifyDt]
      ,[DBRCP1].[CreateDt]
      ,[DBRCP1].[SID]
      ,[DBRCP1].[CustomRoleInd]
      ,[DBRCP1].[InheritedServerRoleId]
      ,[DBRCP1].[SCDCurrentRecordInd]
      ,[DBRCP1].[ReportingShortDescription]
      ,[DBRCP1].[ReportingLongDescription]
 FROM [security].[vw_DatabaseRoles_CurrentETLProcessId] AS DBRCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON DBRCP1.ETLProcessId = E1.ETLProcessId
WHERE     (DBRCP1.ChangeTypeCd >= 0)
GO
/****** Object:  View [security].[vw_DatabaseRoles_PriorETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoles_PriorETLProcessId] AS
SELECT 
	[DBR1].[DatabaseRolesId]
	,[DBR1].[ETLProcessId]
	,[DBR1].[ServerId]
	,[DBR1].[DatabaseID]
	,[DBR1].[PrincipalId]
	,[DBR1].[ChangeTypeCd]
	,[DBR1].[Name]
	,[DBR1].[Type]
	,[DBR1].[ModifyDt]
	,[DBR1].[CreateDt], DBR1.SID, DBR1.CustomRoleInd, DBR1.InheritedServerRoleId, DBR1.ReportingShortDescription, DBR1.ReportingLongDescription, DBR1.SCDCurrentRecordInd
FROM        [security].[DatabaseRoles] AS DBR1
INNER JOIN [security].[vw_ETLProcessID_Prior] AS E1
ON DBR1.ETLProcessId = E1.PriorETLProcessID
GO
/****** Object:  View [security].[vw_DatabaseRoles_PriorValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [security].[vw_DatabaseRoles_PriorValues]
AS
SELECT [DBRCP1].[DatabaseRolesId]
      ,[DBRCP1].[ETLProcessId]
      ,[DBRCP1].[ServerId]
      ,[DBRCP1].[DatabaseID]
      ,[DBRCP1].[PrincipalId]
      ,[DBRCP1].[ChangeTypeCd]
      ,[DBRCP1].[Name]
      ,[DBRCP1].[Type]
      ,[DBRCP1].[ModifyDt]
      ,[DBRCP1].[CreateDt]
      ,[DBRCP1].[SID]
      ,[DBRCP1].[CustomRoleInd]
      ,[DBRCP1].[InheritedServerRoleId]
      ,[DBRCP1].[SCDCurrentRecordInd]
      ,[DBRCP1].[ReportingShortDescription]
      ,[DBRCP1].[ReportingLongDescription]
 FROM [security].[vw_DatabaseRoles_CurrentETLProcessId] AS DBRCP1
INNER JOIN [security].vw_ETLProcessId_Current AS E1 
ON DBRCP1.ETLProcessId = E1.ETLProcessId
LEFT OUTER JOIN [security].[vw_DatabaseRoles_PriorETLProcessId] AS DBPP2
ON DBRCP1.[ServerId] = DBPP2.ServerId
AND DBRCP1.DatabaseID = DBPP2.DatabaseID
AND DBRCP1.[SID] = DBPP2.[SID]
WHERE     (DBRCP1.ChangeTypeCd <= 0)
AND [DBRCP1].[SID] IS NULL
UNION
SELECT [DBPP1].[DatabaseRolesId]
      ,[DBPP1].[ETLProcessId]
      ,[DBPP1].[ServerId]
      ,[DBPP1].[DatabaseID]
      ,[DBPP1].[PrincipalId]
      ,[DBPP1].[ChangeTypeCd]
      ,[DBPP1].[Name]
      ,[DBPP1].[Type]
      ,[DBPP1].[ModifyDt]
      ,[DBPP1].[CreateDt]
      ,[DBPP1].[SID]
      ,[DBPP1].[CustomRoleInd]
      ,[DBPP1].[InheritedServerRoleId]
      ,[DBPP1].[ReportingShortDescription]
      ,[DBPP1].[ReportingLongDescription]
      ,[DBPP1].[SCDCurrentRecordInd]
  FROM [security].[vw_DatabaseRoles_PriorETLProcessId] AS DBPP1
WHERE ([DBPP1].[ChangeTypeCd] >= 0)
GO
/****** Object:  View [security].[vw_Databases_CurrentETLProcessId]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [security].[vw_Databases_CurrentETLProcessId] AS
SELECT [DB1].[ETLProcessId]
      ,[DB1].[ServerId]
      ,[DB1].[DatabaseID]
      ,[DB1].[DatabaseName]
  FROM [security].[Databases] AS DB1
INNER JOIN [security].[vw_ETLProcessId_Current] AS E1
ON DB1.ETLProcessId = E1.ETLProcessId
GO
/****** Object:  View [dbo].[vw_ETLProcesses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ETLProcesses] AS
SELECT ETLProcesses.ETLProcessId ETLProcessId, ETLProcesses.ETLProcessGroupID ETLProcessGroupID, ETLProcesses.InitiatingJobName InitiatingJobName, ETLProcesses.ProcessDt ProcessDt, ETLProcesses.CurrentRecordsInd CurrentRecordsInd, ETLProcesses.ProcessFailedInd ProcessFailedInd
FROM            dbo.ETLProcesses
GO
/****** Object:  View [rpt].[vw_ETLCustomErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [rpt].[vw_ETLCustomErrors] AS
SELECT 
[ETLCE1].[ServerSystemID]
,[S1].HostName
,[ETLCE1].[ETLProcessId]
,[S1].[OSFullVersion]
,[ETLCE1].[ErrorSeverityLevel]
,[ETLCE1].[PackageName]
,[ETLCE1].[PackageTaskName]
,[ETLCE1].[CustomErrorText]
,[ETLCE1].[SSISSystemErrorCode]
,[ETLCE1].[SSISSystemErrorColumn]
,[ETLCE1].[IssueResolvedInd]
,[ETLCE1].[ResolutionDescription], ETLCE1.LatestReportedDate
FROM [dbo].[VW_servers] as S1
INNER JOIN [dbo].[ETLProcessCustomErrors] AS ETLCE1
on [S1].[ServerSystemID] = [ETLCE1].[ServerSystemID]
where [S1].[RetiredInd] = 0
and [S1].[ManagedBySQLDBAsInd] = 1
and [S1].[InKFBDOM1Domain] = 1
AND [ETLCE1].[ETLProcessId] = (select max([etlprocessid]) from [dbo].[vw_ETLProcesses])
GO
/****** Object:  View [dbo].[vw_ServerProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerProperties] AS
SELECT
[ServerInstanceId] AS ServerInstanceId
,[PropertyValue] AS PropertyValue
,[PropertyName] AS PropertyName
,[ServerPropertiesId] AS ServerPropertiesId
,[PropertyDataType] AS PropertyDataType
,[PropertyValueLength] AS PropertyValueLength
,[LatestReportedDate] AS LatestReportedDate
,[FirstReportedDate] AS FirstReportedDate
,[ETLProcessId] AS ETLProcessId
FROM dbo.ServerProperties
GO
/****** Object:  View [dbo].[vw_SQLServerVersions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SQLServerVersions] AS
SELECT 
SQLV.SQLMajorMinorVersion AS SQLMajorMinorVersion
,SQLV.SQLVersionDescription AS SQLVersionDescription
,SQLV.DatabaseCompatibilityLevel AS DatabaseCompatibilityLevel
,SQLV.CurrentSPorCUBuild CurrentSPorCUBuild
,SQLV.CurrentInterimBuild CurrentInterimBuild
,SQLV.LastReviewDt LatestUpdateDt
,SQLV.MSKBArticle AS KBArticle
,SQLV.MSKBArticleURL AS KBArticleURL
,'https://support.microsoft.com/en-us/help/321185/how-to-determine-the-version-edition-and-update-level-of-sql-server-an' as SourceURL
FROM dbo.SQLServerVersions AS SQLV
GO
/****** Object:  View [dbo].[vw_ServerInstance_VersionProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE VIEW [dbo].[vw_ServerInstance_VersionProperties]
AS
-- Because the ServerProperties table is a normalized table, the server properties values (for the SharePoint list) must be pivoted to denormalize the properties.
-- a special view was created for this purpose as this denormalized, pivot view is used in a variety of procedures and views.		
-- Create a dataset to return to the SP List including some data values from the Servers and ServerInstances tables along with the pivoted ServerProperties
-- Complete server build information available from Microsoft (latest URL: https://support.microsoft.com/en-us/help/321185/how-to-determine-the-version-edition-and-update-level-of-sql-server-an)
WITH CTE (ServerInstanceID, PropertyValue, PropertynAME)
AS (
	SELECT vSP2.ServerInstanceID, vSP2.PropertyValue, vSP2.PropertynAME FROM [dbo].[vw_ServerProperties] AS vSP2
	INNER JOIN
		(SELECT ServerInstanceID, PropertyValue, PropertyName, MAX(ServerPropertiesId) as ServerPropertiesID FROM [dbo].[vw_ServerProperties] AS vSP2
		GROUP BY ServerInstanceID, PropertyValue, PropertyName) AS vSP1
	ON vSP2.ServerPropertiesId = vSP1.ServerPropertiesID
	) 

SELECT 
	[PV1].[ServerInstanceID] AS ServerInstanceID,
	[Status] AS SQLStatus,
	CASE [PV1].[EngineEdition] WHEN 'EnterpriseOrDeveloper' THEN 'Enterprise' ELSE [PV1].[EngineEdition] END as EngineEdition,
	[PV1].[IsClustered] AS IsClustered,
	case when patindex('%86%',[PV1].[Platform]) > 0 then '32 Bit' else '64 Bit' END AS SQLPlatform,
	[SQLV1].[SQLVersionDescription] AS SQLVersionDescription,
	[SQLV1].[DatabaseCompatibilityLevel],
	[PV1].[Product] AS SQLProduct,
	[PV1].[ProductLevel] AS SQLProductLevel,
	[PV1].[VersionString] AS SQLVersionString ,
	(cast([PV1].[VersionMajor] as decimal(5,2)) + cast((cast([PV1].[VersionMinor] as numeric(5,2))/100) as numeric(3,2))) as SQLMajorMinorVersion,
	[PV1].[VersionMajor] AS SQLVersionMajor,
	[PV1].[VersionMinor] AS SQLVersionMinor,
	[PV1].[BuildNumber] AS SQLBuildNumber,
	[SQLV1].[CurrentSPorCUBuild],
	[SQLV1].[CurrentInterimBuild],
	[SQLV1].[KBArticle],
	CASE WHEN [PV1].[BuildNumber] >= [SQLV1].[CurrentSPorCUBuild] THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END as [SPorCUCompliant],
	CASE WHEN [PV1].[BuildNumber] >= [SQLV1].[CurrentInterimBuild] THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END as [InterimUpdateCompliant]
	FROM
	(
		SELECT  ServerInstanceID, PropertyValue, PropertynAME
		FROM CTE) as SPr1
		PIVOT
		(
		MAX(PropertyValue)
		FOR PropertyName in 
		([BuildNumber],
		[EngineEdition],
		[IsClustered],
		[Platform],
		[Product],
		[ProductLevel],
		[Status],
		[VersionMajor],
		[VersionMinor],
		[VersionString]
		)
		) AS PV1
LEFT OUTER JOIN [dbo].[vw_SQLServerVersions] AS SQLV1
ON (cast([VersionMajor] as decimal(5,2)) + cast((cast([VersionMinor] as numeric(5,2))/100) as numeric(3,2)))  = [SQLV1].[SQLMajorMinorVersion]
GO
/****** Object:  View [dbo].[vw_ServerNetworkProtocolsIPAddresses]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerNetworkProtocolsIPAddresses] AS
SELECT 
[SNPIPA].[ServerNetworkProtocolsIPAddressesId] AS ServerNetworkProtocolsIPAddressesId
,[SNPIPA].[IPAddress] AS IPAddress
,[SNPIPA].[ETLProcessID] AS ETLProcessID
,[SNPIPA].[IPAddressName] AS IPAddressName
,[SNPIPA].[State] AS State
,[SNPIPA].[ServerInstanceId] AS ServerInstanceId
,[SNPIPA].[LatestReportedDate] AS [LatestReportDate]
,[SNPIPA].[FirstReportedDate] AS [FirstReportedDate]
,[SNPIPA].[IPAddressURN] AS IPAddressURN
FROM [dbo].[ServerNetworkProtocolsIPAddresses] AS SNPIPA
GO
/****** Object:  View [dbo].[vw_ServerInstances_InventoryDiagram]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE VIEW [dbo].[vw_ServerInstances_InventoryDiagram]
AS
SELECT 
[SHS1].ServerSystemID
,[NIPA1].[ServerInstanceID]
,[BC1].[BusinessCategoryDesc]
,[SHS1].[HostName]
,[NIPA1].[InstanceName]
,[NIPA1].[IPAddress]
,[SHS1].[ProductionInd] AS ProductionBitInd
,CASE [SHS1].[ProductionInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS ProductionInd
,CASE [SHS1].[InKFBDOM1Domain] WHEN 1 THEN 'Yes' ELSE 'No' END AS InKFBDOM1Domain
,[NIPA1].[NamedInstanceInd]
,[SHS1].[OSCaption]
,[NIPA1].[SQLEdition]
,ISNULL([SHS1].[UsageScope],'Unknown') AS [UsageScope]
,ISNULL([SHS1].[PrimaryDataProcessModelType],'Unknown') AS [PrimaryDataProcessModelType]
,ISNULL([SHS1].[LocalHostDescription],'Not Available') AS [LocalHostDescription]
,[SHS1].[UsedByAppSyncInd]
,CONVERT(VARCHAR(15),[SHS1].[LatestReportedDate],101) AS LatestReportedDate
,[NIPA1].[SQLVersion]
,[NIPA1].[SQLFullVersion]
,[NIPA1].[SQLVersionDescription]
,[NIPA1].[SQLProductLevel]
,[NIPA1].[CurrentSPorCUBuild]
,[NIPA1].[CurrentInterimBuild]
,[NIPA1].[KBArticle]
,[NIPA1].[SPorCUCompliant]
,[NIPA1].[InterimUpdateCompliant]
from [dbo].[vw_Servers] AS SHS1
LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC1
ON [SHS1].[BusinessCategoryID] = [BC1].[BusinessCategoryID]
LEFT OUTER JOIN
(
SELECT 
[SI].[ServerSystemID]
,ISNULL([SI].[ServerInstanceID],0) as ServerInstanceID
,[SI].[InstanceName]
,[SI].[NamedInstanceInd]
,[SIVP1].[EngineEdition] AS SQLEdition
,ISNULL([SNPIPA].[IPAddress],'Not Retrieved') as [IPAddress]
,[SNPIPA].[IPAddressName]
,CAST([SIVP1].[SQLMajorMinorVersion] AS NUMERIC(5,2)) AS SQLVersion
,CAST([SIVP1].[SQLMajorMinorVersion] AS NVARCHAR(6)) + '.' + RIGHT((CAST('0000' AS VARCHAR(4)) + CAST([SIVP1].[SQLBuildNumber] AS VARCHAR(6))),4) AS SQLFullVersion
,[SIVP1].[SQLVersionDescription]
,[SIVP1].[SQLProductLevel]
,[SIVP1].[CurrentSPorCUBuild]
,[SIVP1].[CurrentInterimBuild]
,[SIVP1].[SPorCUCompliant]
,[SIVP1].[InterimUpdateCompliant]
,[SIVP1].[KBArticle]
FROM [DBO].[vw_ServerInstances] AS SI 
LEFT OUTER JOIN 
	(
	SELECT DISTINCT
	[ServerInstanceId]
	,[IPAddress]
	,[IPAddressName]
	,[ETLProcessID]	
	FROM	[DBO].[vw_ServerNetworkProtocolsIPAddresses] 
	WHERE [IPAddress] LIKE '10.%'
	AND ([LatestReportDate] IS NULL)
	) AS SNPIPA
ON [SI].[ServerInstanceID] = [SNPIPA].[ServerInstanceId]
AND [SI].[ETLProcessId] = [SNPIPA].[ETLProcessID]
LEFT OUTER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
ON [SI].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
WHERE [SI].[RetiredInd] = 0
) AS NIPA1
ON [SHS1].[ServerSystemID] = [NIPA1].[ServerSystemID]
WHERE 
ISNULL([SHS1].[RetiredInd],0) = 0
GO
/****** Object:  View [dbo].[vw_Applications_Databases]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Applications_Databases]
AS
SELECT 
[APP1].[ApplicationName]
,[APP1].[FormattedApplicationID]
,[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DBAID].[ExtendedPropertyValue] AS [ApplicationID]
,DBAppSeqID.[ApplicationDatabaseSeqID]
FROM [dbo].[Databases] AS DB1
INNER JOIN
(
SELECT 
[IDBEP1].[Databaseuniqueid]
,[IDBEP1].[ExtendedPropertyValue]
FROM [dbo].[DatabaseExtendedProperties] AS IDBEP1
INNER JOIN
	(
	SELECT [DatabaseURN]
	,MAX([DatabaseExtendedPropertyID]) AS MRDBID
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
	GROUP BY [DatabaseURN]
	) AS DBMID
ON [IDBEP1].[DatabaseExtendedPropertyID] = [DBMID].[MRDBID]) AS [DBAID]
ON [DB1].[DatabaseUniqueId] = [DBAID].DatabaseUniqueId
LEFT OUTER JOIN
(
	SELECT 
	[IDBEP1].[Databaseuniqueid]
	,[IDBEP1].[ExtendedPropertyValue] as [ApplicationDatabaseSeqID]
	FROM [dbo].[DatabaseExtendedProperties] AS IDBEP1
	INNER JOIN
		(
		SELECT [DatabaseURN]
		,MAX([DatabaseExtendedPropertyID]) AS MRDBID
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
		GROUP BY [DatabaseURN]
		) as dbe3
	on idbep1.DatabaseExtendedPropertyID = dbe3.MRDBID
) AS DBAppSeqID
ON DB1.DatabaseUniqueId = [DBAppSeqID].[DatabaseUniqueId]
LEFT OUTER JOIN [dbo].[vw_Applications] AS [APP1]
ON [DBAID].ExtendedPropertyValue = [APP1].[ApplicationId]
GO
/****** Object:  View [dbo].[vw_ServerInstances_MDWStatus]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[vw_ServerInstances_MDWStatus]
AS
SELECT [t1].[ServerSystemID]
      ,[t1].[ServerInstanceID]
      ,[t1].[HostName]
      ,[t1].[InstanceName]
      ,[t1].[IPAddress]
      ,[t1].[ProductionBitInd]
      ,[t1].[NamedInstanceInd]
      ,[t1].[SQLVersion]
      ,[t1].[SQLVersionDescription]
      ,[t2].[ParameterValue]
  FROM [dbo].[vw_ServerInstances_InventoryDiagram] as t1
  left outer join 
  (select serverinstanceid, parametervalue
  from  [dbo].[ServerInstanceDataCollectorConfigStores]
  where ParameterName = 'CollectorEnabled') as t2
  ON T1.ServerInstanceID = T2.ServerInstanceId
  where InKFBDOM1Domain = 'yes'
GO
/****** Object:  View [dbo].[vw_ApplicationPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ApplicationPrincipals] AS
SELECT AP1.ApplicationPrincipalID, AP1.PrincipalLocalName, AP1.PrincipalADsamAccountName, AP1.PrincipalADGUID, AP1.PrincipalADType, AP1.EmployeeMasterID
FROM dbo.ApplicationPrincipals AP1
GO
/****** Object:  View [dbo].[vw_ApplicationRolePrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ApplicationRolePrincipals] AS
SELECT ARP1.ApplicationId, ARP1.LastUpdateDt, ARP1.ApplicationRoleID, ARP1.ApplicationPrincipalID
FROM dbo.ApplicationRolePrincipals ARP1
GO
/****** Object:  View [dbo].[vw_ApplicationRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ApplicationRoles] AS
SELECT 
BAR1.ApplicationRoleID
, BAR1.ApplicationRoleName
, BAR1.ApplicationRoleCommonName
, BAR1.ApplicationRoleDesc
, BAR1.ApplicationRoleType
, BAR1.ApplicationManagementRoleID
FROM dbo.ApplicationRoles AS [BAR1]
GO
/****** Object:  View [dbo].[vw_Applications_Staffing]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_Applications_Staffing] 
AS
/*
The relationship between Applications, ApplicationRoles and ApplicationPrincipals uses a join table using the three PK columns
To return all applications, including those for which no roles or role principals are assigned the Applications table 
must be joined to a complete set of ApplicationRoles including those roles not assigned to a principal.
This requires a UNION of those roles with no principals to those roles assigned a principal
*/
SELECT 
[BAP1].ApplicationId
,[BAP1].RetiredInd
,[BAP1].SQLDBBasedAppInd
,[BAP1].ApplicationName
,[BAP1].BusinessCategoryID
,[BAP1].ApplicationCommonName
,[BAP1].PrimaryBusinessPurposeDesc
,[BAP1].KFBMFApplicationCode
,[BAP1].FinanciallySignificantAppInd
,[BAP1].KFBDistributedAbbreviations 
,[BAP1].ActiveDirectoryGroupAccessInd
,[BAP1].ActiveDirectoryGroupTag
,[BAP1].VendorSuppliedDBInd
,[BAP1].InternallyDevelopedAppInd
,[BAP1].AppDBERModelName
,[BAP1].LastUpdateDt
,[BAR1].[ApplicationRoleID]
,[BAR1].[ApplicationRoleDesc]
,[BAR1].[ApplicationRoleName]
,[BAR1].[ApplicationRoleCommonName]
,[BAR1].[ApplicationRoleType]
,[BAR1].[ApplicationManagementRoleID]
,[BAPR1].[ApplicationPrincipalID]
,[BAPR1].[PrincipalLocalName]
,[BAPR1].[LastUpdateDt] AS [RolePrincipalLastUpdateDt]
,[BAPR1].[PrincipalADGUID]
,[BAPR1].[PrincipalADType]
,[BAPR1].[EmployeeMasterID]
FROM [dbo].[vw_Applications] AS [BAP1]
CROSS JOIN [dbo].[vw_ApplicationRoles] AS [BAR1]
LEFT OUTER JOIN 
(
SELECT 
[TA1].[ApplicationId]
,[TA2].[ApplicationRoleID]
,0 AS [ApplicationPrincipalID]
,NULL AS [PrincipalADGUID]
,NULL AS [PrincipalADType]
,NULL AS [EmployeeMasterID]
,NULL AS [PrincipalLocalName]
,CAST(GETDATE() AS DATE) AS [LastUpdateDt]
FROM [dbo].[vw_Applications] AS [TA1]
LEFT OUTER JOIN [dbo].[vw_ApplicationRolePrincipals] AS [TA4]
ON [TA1].[ApplicationId] = [TA4].[ApplicationId]
CROSS JOIN [dbo].[vw_ApplicationRoles] AS [TA2]
WHERE [TA4].[ApplicationId] IS NULL
AND [TA1].[ApplicationId] <> 0
UNION
SELECT 
[TB1].[ApplicationId]
,[TB2].[ApplicationRoleID]
,[TA5].[ApplicationPrincipalID]
,[TA5].[PrincipalADGUID]
,[TA5].[PrincipalADType]
,[TA5].[EmployeeMasterID]
,[TA5].[PrincipalLocalName]
,[TB4].[LastUpdateDt]
FROM [dbo].[vw_Applications] AS [TB1]
INNER JOIN [dbo].[vw_ApplicationRolePrincipals] AS [TB4]
ON [TB1].[ApplicationId] = [TB4].[ApplicationId]
INNER JOIN [dbo].[vw_ApplicationRoles] AS [TB2]
ON [TB4].[ApplicationRoleID] = [TB2].[ApplicationRoleID]
LEFT OUTER JOIN [dbo].[vw_ApplicationPrincipals] AS [TA5]
ON [TB4].[ApplicationPrincipalID] = [TA5].[ApplicationPrincipalID]
) AS [BAPR1]
ON [BAP1].[ApplicationId] = [BAPR1].[ApplicationID]
AND [BAR1].[ApplicationRoleID] = [BAPR1].[ApplicationRoleID]
GO
/****** Object:  View [rpt].[vw_Servers_ApplicationCounts]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [rpt].[vw_Servers_ApplicationCounts]
AS
SELECT 
[SHS1].[ServerSystemID]
,[SHS1].[HostName]
,[SHS1].[ProductionInd]
,[SHS1].[OSCaption]
,[SHS1].[LocalHostDescription]		
,[S1].[InstanceName]
,[SIVP1].[SQLVersionDescription]
,[SIVP1].[EngineEdition]
,[SIVP1].[SQLProductLevel]
,[SIVP1].[SQLVersionString]
,[DB2].[ApplicationCount] AS NumberOfDifferentAppsOnInstance
,[PV1].[Processors]
,[PV1].[PhysicalMemory]
FROM [dbo].[vw_Servers] AS SHS1
LEFT OUTER JOIN [dbo].[vw_ServerInstances]   AS S1
ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
LEFT OUTER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
LEFT OUTER JOIN
	(SELECT 
	[DB1].[ServerInstanceId]
	,COUNT(DISTINCT [DBApp1].[ApplicationId]) AS ApplicationCount
	FROM [dbo].[vw_Databases] AS DB1
	INNER JOIN [dbo].[vw_DatabaseApplications] AS DBApp1
	ON DB1.DatabaseUniqueId = DBApp1.DatabaseUniqueId
	WHERE 		[DB1].[SystemObjectInd] = 0
	and DB1.DeletedInd = 0
	GROUP BY
	[DB1].[ServerInstanceId]
	) AS DB2
ON [S1].[ServerInstanceID] = [DB2].[ServerInstanceId]
LEFT OUTER JOIN
	(SELECT  ServerInstanceID, PropertyValue, PropertynAME
	FROM [dbo].[ServerProperties]) as SPr1
	PIVOT
	(
	MAX(PropertyValue)
	FOR PropertyName in 
	([Processors],
	[PhysicalMemory]
	)) AS PV1
ON [S1].[ServerInstanceID] = [PV1].ServerInstanceId
WHERE 
[SHS1].[ProductionInd] BETWEEN 1 AND 1
AND [S1].[RetiredInd] = 0
GO
/****** Object:  View [rpt].[vw_Servers_DatabaseCountByApplication]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [rpt].[vw_Servers_DatabaseCountByApplication]
AS
SELECT
[SHS1].[ServerSystemID]
,[SHS1].[HostName]
,[SHS1].[ProductionInd]
,[SHS1].[OSCaption]
,[SHS1].[LocalHostDescription]		
,[S1].[InstanceName]
,[SIVP1].[SQLVersionDescription]
,[SIVP1].[EngineEdition]
,[SIVP1].[SQLProductLevel]
,[SIVP1].[SQLVersionString]
,[DB2].[ApplicationId]
,[DB2].[ApplicationName]
,[DB2].[ActiveDatabasesCount] AS DatabaseCountByApplication
,[PV1].[Processors]
,[PV1].[PhysicalMemory]
FROM [dbo].[vw_Servers] AS SHS1
LEFT OUTER JOIN  [dbo].[vw_ServerInstances] AS S1
ON [SHS1].[ServerSystemID] = [S1].[ServerSystemID] 
LEFT OUTER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
LEFT OUTER JOIN
	(SELECT 
	[DB1].[ServerInstanceId]
	,[DBApp1].[ApplicationId]
	,[DBApp1].[ApplicationName]
	,COUNT([DB1].[SystemDBId]) AS ActiveDatabasesCount
	FROM [dbo].[vw_Databases] AS DB1
	INNER JOIN [dbo].[vw_DatabaseApplications] AS DBApp1
	ON DB1.DatabaseUniqueId = DBApp1.DatabaseUniqueId
	WHERE 		[DB1].[SystemObjectInd] = 0
	and DB1.DeletedInd = 0
	GROUP BY
	[DB1].[ServerInstanceId]
	,[DBApp1].[ApplicationId]
	,[DBApp1].[ApplicationName]
	) AS DB2
ON [S1].[ServerInstanceID] = [DB2].[ServerInstanceId]
LEFT OUTER JOIN
	(SELECT  ServerInstanceID, PropertyValue, PropertynAME
	FROM [dbo].[ServerProperties]) as SPr1
	PIVOT
	(
	MAX(PropertyValue)
	FOR PropertyName in 
	([Processors],
	[PhysicalMemory]
	)) AS PV1
ON [S1].[ServerInstanceID] = [PV1].ServerInstanceId
WHERE 
ISNULL([S1].[RetiredInd],0) = 0
GO
/****** Object:  View [dbo].[vw_SSIS_Catalog_Package_by_ServerInstance]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Update Views SQL

CREATE VIEW [dbo].[vw_SSIS_Catalog_Package_by_ServerInstance]
AS
SELECT 
[SINV1].[HostName]
,[SINV1].[InstanceName]
,[SINV1].[SQLVersion]
,[SINV1].[InKFBDOM1Domain]
,[SCP1].[ETLProcessID]
,[SCP1].[LatestReportedDate]
,[name]
,[description]
,[package_format_version]
,[version_major]
,[version_minor]
,[version_build]
FROM [dbo].[vw_ServerInstances_InventoryDiagram] as SINV1
LEFT OUTER JOIN [dbo].[SSISDB_Catalog_Packages] AS SCP1
ON [SCP1].[sERVERInstanceID] = [SINV1].[ServerInstanceID]
WHERE [SINV1].[SQLVersion] >= 11
AND [SINV1].[InKFBDOM1Domain] = 'YES'
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_EE_ReadClientTimeout]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ufn_EE_ReadClientTimeout]
(
      -- Add the parameters for the function here
      @xel varchar(500),
      @xem varchar(500)
)
RETURNS TABLE
AS
RETURN
(
with qry as (
select
theNodes.event_data.value('(action[@name="database_name"]/value)[1]','varchar(50)')
           as database_name,
theNodes.event_data.value('(action[@name="client_hostname"]/value)[1]','varchar(50)')
           as client_hostname,
theNodes.event_data.value('(action[@name="client_app_name"]/value)[1]','varchar(50)')
           as client_app_name,
theNodes.event_data.value('(data[@name="duration"]/value)[1]','bigint') as duration,
theNodes.event_data.value('(action[@name="sql_text"]/value)[1]','varchar(4000)') as sql_text,
theNodes.event_data.value('(action[@name="user_name"]/value)[1]','varchar(50)') as user_name,
theNodes.event_data.value('(action[@name="is_system"]/value)[1]','varchar(50)') as is_system,
theNodes.event_data.value('(action[@name="nt_user_name"]/value)[1]','varchar(50)')
           as nt_user_name,
theNodes.event_data.value('(action[@name="server_principal_name"]/value)[1]','varchar(50)')
           as server_principal_name
from
      (select convert(xml,event_data) event_data
            from
       sys.fn_xe_file_target_read_file(@xel, @xem, NULL, NULL)) as theData
cross apply theData.event_data.nodes('//event') theNodes(event_data)
       )
select database_name,client_hostname,client_app_name,
            duration,sql_text,user_name,is_system,
            nt_user_name,server_principal_name
             from qry
 )
GO
/****** Object:  View [dbo].[vw_ApplicationRecoveryPlanProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ApplicationRecoveryPlanProperties]
AS
SELECT 
[ApplicationId]
,[HasRecoveryPlanInd]
,[LastUpdateDt]
,[RecoveryPriority]
,[ReceoverySequenceOrder]
,[RecoveryPointObjectiveUnit]
,[RecoveryPointScale]
,[RecoveryTimeObjectiveUnit]
,[RecoveryTimeObjectiveScale]
,[RecoveryDocumentationFileLocation]
,[RecoveryDocumentationFileName]
,[IncludeInAssetBoxInd]
,[RecoveryNotes]
,[IncludeInRecoveryTestsInd]
,[DateOfLastRecoveryTest]
FROM [dbo].[ApplicationRecoveryPlanProperties]
GO
/****** Object:  View [dbo].[vw_DataAccessRoles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DataAccessRoles] AS
SELECT 
[CustomRoleID]
,RIGHT(('00' + CAST([CustomRoleID] AS VARCHAR(2))),2) AS FormattedCustomRoleID
,[RoleScope]
,[RoleAuthority]
,[RoleAuthorityIsLDAP]
,[RoleName]
,[EnvironmentScope]
,[IsProductionRoleInd]
,[HighlyPrivilegedRoleInd]
,[GrantDescription]
,[PurposeDescription]
,[Abbreviation]
,[LastUpdateDt]
FROM [dbo].[DataAccessRoles]
GO
/****** Object:  View [dbo].[vw_DatabaseExtendedProperties_CurrentValues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_DatabaseExtendedProperties_CurrentValues] AS
SELECT 
DBP1.DatabaseExtendedPropertyID
,DBP1.ExtendedPropertyName
,DBP1.DatabaseURN
,DBP1.ExtendedPropertyValue
,DBP1.ExtendedPropertyLength
,DBP1.IsCustomExtendedProperty
,DBP1.DatabaseUniqueId
,DBP1.ETLProcessId
,DBP1.FirstReportedDate
,DBP1.LatestReportedDate
FROM [dbo].[DatabaseExtendedProperties] AS DBP1
INNER JOIN 
	(SELECT 
	MAX([DB1].[DatabaseUniqueID]) AS MRDBUID
	FROM [dbo].[Databases] AS DB1
	INNER JOIN [dbo].[ServerInstances] AS SI1
	ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
	INNER JOIN [dbo].[Servers] AS S1
	ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
	WHERE [DB1].[DeletedInd] = 0
	AND [SI1].[RetiredInd] = 0
	AND [S1].[RetiredInd] = 0
	GROUP BY [DB1].[DatabaseName]
) AS DB2
ON DBP1.[DatabaseUniqueId] = [DB2].[MRDBUID]
GO
/****** Object:  View [dbo].[vw_DatabaseProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DatabaseProperties] 
AS
SELECT 
[DBP1].[DatabasePropertyID], 
[DBP1].[DatabaseURN], 
[DBP1].[DatabasePropertyName], 
[DBP1].[DatabasePropertyValue], 
[DBP1].[DatabasePropertyDataType], 
[DBP1].[DatabaseUniqueId], 
[DBP1].[DatabasePropertyLength], 
[DBP1].[IsCustomExtendedProperty], 
[DBP1].[ETLProcessId], 
[DBP1].[FirstReportedDate], 
[DBP1].[LatestReportedDate]
FROM [dbo].[DatabaseProperties] AS DBP1
WHERE [DBP1].[IsCustomExtendedProperty] = 0
GO
/****** Object:  View [dbo].[vw_Index_Defragmentation_History_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Index_Defragmentation_History_Detail]
AS
SELECT [defragmentation_job_id]
      ,[schema_name]
      ,[table_id]
      ,[index_id]
      ,[table_name]
      ,[index_name]
      ,[user_defined_datatype_count]
      ,[excluded_datatype_count]
      ,[table_row_count]
      ,[index_rebuild_performed_ind]
      ,[index_reorg_performed_ind]
      ,[defragmentation_failed_ind]
      ,[defragmentation_performed_on_Index]
      ,[defragmentation_task_starttime]
      ,[defragmentation_task_endtime]
      ,[fragmentationlevel_prerun]
      ,[fragmentationlevel_postrun]
      ,[page_count_prerun]
      ,[page_count_postrun]
      ,[user_seeks]
      ,[user_scans]
      ,[user_lookups]
      ,[user_updates]
      ,[last_user_seek]
      ,[last_user_scan]
      ,[last_user_lookup]
      ,[last_user_update]
      ,[index_specific_comments]
  FROM [dbo].[Index_Defragmentation_History_Detail]
GO
/****** Object:  View [dbo].[vw_Index_Defragmentation_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Index_Defragmentation_History_Summary]
AS
SELECT [defragmentation_job_id]
      ,[executioninstanceGUID]
      ,[initiating_job_scheduler_application_name]
      ,[initiating_job_name]
      ,[server_name]
      ,[database_id]
      ,[database_name]
      ,[database_accessible_ind]
      ,[defragmentation_performed_ind]
      ,[online_defrag_operations_override_ind]
      ,[last_update_date]
      ,[defragmentation_job_starttime]
      ,[defragmentation_job_endtime]
      ,[index_defragment_agerequirement_at_job_run]
      ,[index_defragment_minimum_pagecount_at_job_run]
      ,[index_rebuild_minimum_fragmentation_percent]
      ,[index_reorganize_minimum_fragmentation_percent]
      ,[table_count]
      ,[index_count]
      ,[defragmented_Indexes_TotalCount]
      ,[defragmenting_errors_count]
      ,[defragmentation_comments]
  FROM [dbo].[Index_Defragmentation_History_Summary]
GO
/****** Object:  View [dbo].[vw_ServerClientNetworkProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerClientNetworkProtocolProperties] AS
SELECT Se.ClientProtocolPropertyID ClientProtocolPropertyID, Se.ServerSystemID HostSystemID, Se.ClientProtocolID ClientProtocolID, Se.ETLProcessId ETLProcessId, Se.ClientProtocolName ClientProtocolName, Se.ProtocolPropertyValue ProtocolPropertyValue, Se.ClientProtocolURN ClientProtocolURN, Se.ProtocolPropertyDisplayName ProtocolPropertyDisplayName, Se.FirstReportedDate, Se.LatestReportedDate
FROM dbo.ServerClientNetworkProtocolProperties Se
GO
/****** Object:  View [dbo].[vw_ServerClientNetworkProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerClientNetworkProtocols] AS
SELECT Se.ClientProtocolID ClientProtocolID, Se.ServerSystemID ServerSystemID, Se.ETLProcessId ETLProcessId, Se.ClientProtocolName ClientProtocolName, Se.ClientProtocolState ClientProtocolState, Se.ClientProtocolDisplayName ClientProtocolDisplayName, Se.ClientProtocolOrder ClientProtocolOrder, Se.ClientNetLibrary ClientNetLibrary, Se.ClientProtocolIsEnabledInd ClientProtocolIsEnabledInd, Se.ClientProtocolURN ClientProtocolURN, Se.FirstReportedDate, Se.LatestReportedDate
FROM dbo.ServerClientNetworkProtocols Se
GO
/****** Object:  View [dbo].[vw_ServerConfigurations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerConfigurations] AS
SELECT se.ServerInstanceId ServerId, se.ConfigurationValue ConfigurationValue, se.ConfigurationPropertyName ConfigurationPropertyName, se.ServerConfigurationPropertyId ServerConfigurationPropertyId, se.RunTimeValue RunTimeValue, se.Description Description, se.DisplayName DisplayName, se.ETLProcessID ETLProcessID, se.ConfigurationNumber ConfigurationNumber, se.MaximumValue MaximumValue, se.MininumValue MininumValue, se.IsDynamicInd IsDynamicInd, se.IsAdvancedInd IsAdvancedInd, se.FirstReportedDate, se.LatestReportedDate
FROM dbo.ServerConfigurations se
GO
/****** Object:  View [dbo].[vw_ServerNetworkProtocolProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerNetworkProtocolProperties] AS
SELECT Se.ServerProtocolPropertyID ServerProtocolPropertyID, Se.ETLProcessId ETLProcessId, Se.ServerNetworkProtocolsId ServerNetworkProtocolsId, Se.ServerProtocolName ServerProtocolName, Se.ServerProtocolURN ServerProtocolURN, Se.PropertyName PropertyName, Se.PropertyDataType PropertyDataType, Se.PropertyValue PropertyValue, Se.FirstReportedDate, Se.LatestReportedDate
FROM dbo.ServerNetworkProtocolProperties Se
GO
/****** Object:  View [dbo].[vw_ServerNetworkProtocols]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerNetworkProtocols] AS
SELECT SNP.ServerNetworkProtocolsId ServerNetworkProtocolsId, SNP.ServerInstanceId ServerInstanceId, SNP.ETLProcessID ETLProcessID, SNP.HasMultiIPAddressesInd HasMultiIPAddressesInd, SNP.DisplayName DisplayName, SNP.ServerProtocolURN ServerProtocolURN, SNP.EnabledInd EnabledInd, SNP.State State, SNP.Name Name, SNP.FirstReportedDate, SNP.LatestReportedDate
FROM [dbo].[ServerNetworkProtocols] AS [SNP]
GO
/****** Object:  View [dbo].[vw_ServerNetworkProtocolsIPAddressProperties]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerNetworkProtocolsIPAddressProperties] AS
SELECT SNPIPAP.ServerIPAProperties ServerIPAProperties, SNPIPAP.ETLProcessId ETLProcessId, SNPIPAP.IPAddressName IPAddressName, SNPIPAP.ServerNetworkProtocolsIPAddressesId ServerNetworkProtocolsIPAddressesId, SNPIPAP.PropertyValue PropertyValue, SNPIPAP.IPAddressURN IPAddressURN, SNPIPAP.PropertyDataType PropertyDataType, SNPIPAP.PropertyName PropertyName, SNPIPAP.FirstReportedDate, SNPIPAP.LatestReportedDate
FROM dbo.ServerNetworkProtocolsIPAddressProperties AS [SNPIPAP]
GO
/****** Object:  View [dbo].[vw_ServerPhysicalDisks]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerPhysicalDisks] AS
SELECT SPD1.ServerPhysicalDiskID, SPD1.ServerSystemID, SPD1.HostName, SPD1.LocalDeviceId, SPD1.DiskID, SPD1.Description, SPD1.DriveType, SPD1.FileSystem, SPD1.FreeSpace, SPD1.DiskSize, SPD1.ETLProcessId, SPD1.LatestReportedDate
FROM [dbo].[ServerPhysicalDisks] AS SPD1
GO
/****** Object:  View [dbo].[vw_ServerPrincipalsLogins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_ServerPrincipalsLogins] AS
SELECT 
[SPL1].[UserId]
,[SPL1].[ServerNameId]
,[SPL1].[ApplicationDatabaseSeqID]
,[SPL1].[IsRestrictedUser]
,[SPL1].[CurrentPassword]
,[SPL1].[AssignedDatabaseName]
,[SPL1].[UserPlatform]
,[SPL1].[UserType]
,[SPL1].[PrimaryApplicationID]
,[SPL1].[ApplicationCreatedForName]
,[SPL1].[UserRequestedBy]
,[SPL1].[ApprovedBy]
,[SPL1].[CreateDate]
,[SPL1].[LastModifiedDate]
,[SPL1].[Description]
,[SPL1].[Creator]
,[SPL1].[EnvironmentUsedIn]
,[SPL1].[PreviousPassword]
,[SPL1].[UserRetiredInd]
FROM [dbo].[ServerPrincipalsLogins] AS SPL1
GO
/****** Object:  View [dbo].[vw_ServerProperties_CurrentETLProcessID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerProperties_CurrentETLProcessID] AS
SELECT Se.ServerPropertiesId, Se.ServerInstanceId, Se.PropertyName, Se.PropertyDataType, Se.PropertyValueLength, Se.PropertyValue, Se.ETLProcessId
FROM dbo.ServerProperties Se
WHERE [Se].[ETLProcessID] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses])
GO
/****** Object:  View [dbo].[vw_ServerServices]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ServerServices] AS
SELECT SS1.ServerServicesId ServerServicesId, SS1.ServerSystemID ServerSystemID, SS1.ETLProcessId ETLProcessId, SS1.LatestReportedDate LastUpdateDt, SS1.ServerInstanceId ServerId, SS1.DisplayName DisplayName, SS1.Description Description, SS1.ServicesURN ServicesURN, SS1.Type Type, SS1.State State, SS1.ServicesState ServicesState, SS1.HostName HostName, SS1.ServiceAccount ServiceAccount, SS1.Name Name, SS1.instanceName instanceName, SS1.PathName PathName, SS1.StartMode StartMode, SS1.FirstReportedDate
FROM dbo.ServerServices SS1
GO
/****** Object:  View [dbo].[vw_SQLAgentJobs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SQLAgentJobs] AS
SELECT SAJ1.ServerInstanceId, SAJ1.SQLJobsID, SAJ1.JobName, SAJ1.JobGuid, SAJ1.Description, SAJ1.JobURN, SAJ1.JobType, SAJ1.JobState, SAJ1.VersionNumber, SAJ1.LastModifiedDt, SAJ1.CreatedDt, SAJ1.HasStepsInd, SAJ1.IsEnabledInd, SAJ1.HasScheduleInd, SAJ1.StartStepID, SAJ1.LastRunDt, SAJ1.NextRunDt, SAJ1.LastRunOutcome, SAJ1.OriginatingServer, SAJ1.EmailLevel, SAJ1.NextRunScheduleID, SAJ1.OperatorToEmail, SAJ1.JobCategoryID, SAJ1.JobCategory, SAJ1.ETLProcessId, SAJ1.FirstReportedDate, SAJ1.LatestReportedDate
FROM [dbo].[SQLAgentJobs] AS SAJ1
GO
/****** Object:  View [dbo].[vw_SQLJobSchedules]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SQLJobSchedules] AS
SELECT SAS1.SQLJobSchedulerID, SAS1.ServerInstanceId, SAS1.JobScheduleID, SAS1.JobScheduleGUID, SAS1.JobScheduleURN, SAS1.CreatedDt, SAS1.IsEnabledInd, SAS1.JobCount, SAS1.FrequencyInterval, SAS1.FrequencyRecurrenceFactor, SAS1.FrequencyRelativeIntervals, SAS1.FrequencyIntervalBitMap, SAS1.FrequencySubDayInterval, SAS1.FrequencySubDayTypes, SAS1.FrequencyTypes, SAS1.ActiveStartDt, SAS1.ActiveStartTimeOfDay, SAS1.ActiveEndDt, SAS1.ActiveEndTimeOfDay, SAS1.ETLProcessId, SAS1.FirstReportedDate, SAS1.LatestReportedDate
FROM [dbo].[SQLAgentSchedules] AS SAS1
GO
/****** Object:  View [dbo].[vw_Statistics_Update_History_Detail]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Statistics_Update_History_Detail]
AS

SELECT 
[SUHD].[statssummary_job_id]
,[SUHD].[database_id]
,[SUHD].[schema_name]
,[SUHD].[table_id]
,[SUHD].[table_name]
,[SUHD].[statistic_id]
,[SUHD].[statistic_name]
,[SUHD].[table_row_count]
,[SUHD].[statsupdate_completed_ind]
,[SUHD].[statsupdate_performed_ind]
,[SUHD].[statsupdate_failed_ind]
,[SUHD].[statsupdate_fromindexdefrag]
,[SUHD].[statsupdate_scan_type_performed]
,[SUHD].[statsupdate_task_starttime]
,[SUHD].[statsupdate_task_endtime]
,[SUHD].[auto_created]
,[SUHD].[user_created]
,[SUHD].[system_last_updated]
,[SUHD].[rows_sampled]
,[SUHD].[modification_counter]
,[SUHD].[statistic_specific_comments]
  FROM [dbo].[Statistics_Update_History_Detail] AS SUHD
GO
/****** Object:  View [dbo].[vw_Statistics_Update_History_Summary]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Statistics_Update_History_Summary]
AS
SELECT 
[SUHS].[statssummary_job_id]
,[SUHS].[statsupdate_job_date]
,[SUHS].[statsupdate_process_completed_ind]
,[SUHS].[statsupdate_performed_ind]
,[SUHS].[executioninstanceGUID]
,[SUHS].[initiating_job_scheduler_application_name]
,[SUHS].[initiating_job_name]
,[SUHS].[max_age_of_last_fullscan]
,[SUHS].[partial_scan_percentage_used]
,[SUHS].[full_scan_override]
,[SUHS].[process_objects_type_code]
,[SUHS].[maximum_mod_counter_percent]
,[SUHS].[server_name]
,[SUHS].[database_id]
,[SUHS].[database_name]
,[SUHS].[database_accessible_ind]
,[SUHS].[statsupdate_job_starttime]
,[SUHS].[statsupdate_job_endtime]
,[SUHS].[table_count]
,[SUHS].[statistic_count_total]
,[SUHS].[statistic_count_updated]
,[SUHS].[statsupdate_errors_count]
,[SUHS].[statsupdate_comments]
FROM [dbo].[Statistics_Update_History_Summary] AS [SUHS]
GO
/****** Object:  View [rpt].[vw_ReportCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [rpt].[vw_ReportCustomizations]
AS
SELECT 
[ReportCustomizationID]
,[DashboardID]
,[DashboardCategoryGroupID]
,[DashboardCategoryName]
,[ReportName]
,[GUID]
,[ReportPublished]
FROM [rpt].[ReportCustomizations]
GO
/****** Object:  View [rpt].[vw_ReportObjectCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [rpt].[vw_ReportObjectCustomizations] AS
SELECT ReportObjectCustomizations.ReportCustomizationID, ReportObjectCustomizations.ReportObjectName, ReportObjectCustomizations.ReportCustomizationScope, ReportObjectCustomizations.ReportObjectDisplayName, ReportObjectCustomizations.GUID, ReportObjectCustomizations.TextContent
FROM [rpt].[ReportObjectCustomizations]
GO
/****** Object:  View [sec].[vw_ADGroupMembers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [sec].[vw_ADGroupMembers]
AS
SELECT 
[ADGroupMembersID]
,[IsNestedGroupInd]
,[ADGroupGUID]
,[ADUsersGUID]
,[GroupMembershipStartDate]
,[GroupMembershipEndDate]
,[CurrentGroupMembershipInd]
,[ETLProcessID]
FROM [sec].[ADGroupMembers]
GO
/****** Object:  View [sec].[vw_ADGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sec].[vw_ADGroups]
AS
SELECT 
[ADGroupId]
,[GUId]
,[sid]
,[ETLProcessId]
,[adsPath]
,[groupType]
,[samAccountName]
,[distinguishedName]
,[cn]
,[Description]
,[SecurityGroupInd]
,[DisplayName]
,[objectCategory]
,[Name]
,[whenChanged]
,[department]
,[whenCreated]
,[samAccountType]
,[schemaentry]
,[schemaclassname]
,[managedBy]
,[FirstReportedDate]
,[LatestReportedDate]
FROM [sec].[ADGroups]
GO
/****** Object:  View [sec].[vw_ADUsers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sec].[vw_ADUsers]
AS
SELECT 
[ADUsersId]
,[GUId]
,[ETLProcessId]
,[sid]
,[containerADSPath]
,[samAccountName]
,[GivenName]
,[SN]
,[Manager]
,[Title]
,[cn]
,[objectCategory]
,[userprincipalname]
,[samAccountType]
,[primaryGroup]
,[Description]
,[DisplayName]
,[department]
,[userAccountControl]
,[userAccountDisabledInd]
,[WhenChanged]
,[WhenCreated]
,[DistinguishedName]
,[Name]
,[FirstReportedDate]
,[LatestReportedDate]
FROM [sec].[ADUsers]
GO
/****** Object:  View [security].[vw_ADGroups_DistributionGroups]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Update Views SQL

CREATE VIEW [security].[vw_ADGroups_DistributionGroups] AS
SELECT 
ADG1.ADGroupId, 
ADG1.GUId, 
ADG1.sid, 
ADG1.ETLProcessId, 
ADG1.adsPath, 
ADG1.groupType, 
ADG1.samAccountName, 
ADG1.distinguishedName, 
ADG1.cn, ADG1.Description, 
ADG1.DisplayName, 
ADG1.objectCategory, 
ADG1.Name, 
ADG1.whenChanged, 
ADG1.department, 
ADG1.whenCreated, 
ADG1.samAccountType, 
ADG1.schemaentry, 
ADG1.schemaclassname, 
ADG1.SCDCurrentRecordInd, 
ADG1.ChangeTypeCd, 
ADG1.SecurityGroupInd
FROM security.ADGroups ADG1
WHERE (ADG1.SecurityGroupInd = 1)
GO
/****** Object:  View [security].[vw_ADUsers_ActiveAccounts]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [security].[vw_ADUsers_ActiveAccounts] AS
SELECT 
[ADU1].[ADUsersId]
,[ADU1].[ChangeTypeCd]
,[ADU1].[cn]
,[ADU1].[containerADSPath]
,[ADU1].[department]
,[ADU1].[Description]
,[ADU1].[DisplayName]
,[ADU1].[DistinguishedName]
,[ADU1].[ETLProcessId]
,[ADU1].[GivenName]
,[ADU1].[GUId]
,[ADU1].[Manager]
,[ADU1].[Name]
,[ADU1].[objectCategory]
,[ADU1].[primaryGroup]
,[ADU1].[samAccountName]
,[ADU1].[samAccountType]
,[ADU1].[SCDCurrentRecordInd]
,[ADU1].[sid]
,[ADU1].[SN]
,[ADU1].[Title]
,[ADU1].[userAccountControl]
,[ADU1].[userAccountDisabledInd]
,[ADU1].[userprincipalname]
,[ADU1].[WhenChanged]
,[ADU1].[WhenCreated]
FROM [security].[ADUsers] AS [ADU1]
WHERE [ADU1].[SCDCurrentRecordInd] = 1
AND [ADU1].[userAccountDisabledInd] = 0
GO
/****** Object:  View [security].[vw_RolesReporting]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [security].[vw_RolesReporting]
AS
SELECT 
[RoleReportingID]
,[RoleScope]
,[SystemName]
,[ReportingDescription]
,[Definition]
,[InheritedServerRoleInd]
,[InheritedServerRoleID]
,[AccesstoAllDatabasesInd]
,[SysAdminInd]
,[CustomRoleInd]
FROM [security].[RolesReporting]
GO
ALTER TABLE [dbo].[ApplicationPrincipals]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationPrincipals_EmployeeMaster_01] FOREIGN KEY([EmployeeMasterID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeMasterID])
GO
ALTER TABLE [dbo].[ApplicationPrincipals] CHECK CONSTRAINT [FK_ApplicationPrincipals_EmployeeMaster_01]
GO
ALTER TABLE [dbo].[ApplicationRecoveryPlanProperties]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRecoveryPlanProperties_Applications_01] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[ApplicationRecoveryPlanProperties] CHECK CONSTRAINT [FK_ApplicationRecoveryPlanProperties_Applications_01]
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRolePrincipals_ApplicationPrincipals_01] FOREIGN KEY([ApplicationPrincipalID])
REFERENCES [dbo].[ApplicationPrincipals] ([ApplicationPrincipalID])
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals] CHECK CONSTRAINT [FK_ApplicationRolePrincipals_ApplicationPrincipals_01]
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRolePrincipals_ApplicationRoles_01] FOREIGN KEY([ApplicationRoleID])
REFERENCES [dbo].[ApplicationRoles] ([ApplicationRoleID])
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals] CHECK CONSTRAINT [FK_ApplicationRolePrincipals_ApplicationRoles_01]
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRolePrincipals_Applications_01] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[ApplicationRolePrincipals] CHECK CONSTRAINT [FK_ApplicationRolePrincipals_Applications_01]
GO
ALTER TABLE [dbo].[ApplicationRoles]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRoles_ApplicationRoles_01] FOREIGN KEY([ApplicationManagementRoleID])
REFERENCES [dbo].[ApplicationRoles] ([ApplicationRoleID])
GO
ALTER TABLE [dbo].[ApplicationRoles] CHECK CONSTRAINT [FK_ApplicationRoles_ApplicationRoles_01]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [FK_Applications_BusinessCategories_01] FOREIGN KEY([BusinessCategoryID])
REFERENCES [dbo].[BusinessCategories] ([BusinessCategoryID])
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [FK_Applications_BusinessCategories_01]
GO
ALTER TABLE [dbo].[Backup_History_Detail]  WITH CHECK ADD  CONSTRAINT [FK_Backup_History_Detail_Backup_History_Summary_01] FOREIGN KEY([Backup_Job_ID])
REFERENCES [dbo].[Backup_History_Summary] ([Backup_Job_ID])
GO
ALTER TABLE [dbo].[Backup_History_Detail] CHECK CONSTRAINT [FK_Backup_History_Detail_Backup_History_Summary_01]
GO
ALTER TABLE [dbo].[BusinessApplicationServers]  WITH CHECK ADD  CONSTRAINT [FK_BusinessAppServers_BusinessApp_01] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[BusinessApplicationServers] CHECK CONSTRAINT [FK_BusinessAppServers_BusinessApp_01]
GO
ALTER TABLE [dbo].[BusinessApplicationServers]  WITH CHECK ADD  CONSTRAINT [FK_BusinessAppServers_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[BusinessApplicationServers] CHECK CONSTRAINT [FK_BusinessAppServers_Servers_01]
GO
ALTER TABLE [dbo].[Databases]  WITH CHECK ADD  CONSTRAINT [FK_Database_ServerInstance_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[Databases] CHECK CONSTRAINT [FK_Database_ServerInstance_01]
GO
ALTER TABLE [dbo].[Databases]  WITH CHECK ADD  CONSTRAINT [FK_Databases_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[Databases] CHECK CONSTRAINT [FK_Databases_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ETLProcessCustomErrors]  WITH CHECK ADD  CONSTRAINT [FK_ETLProcessCustomErrorLog_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ETLProcessCustomErrors] CHECK CONSTRAINT [FK_ETLProcessCustomErrorLog_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ETLProcessCustomErrors]  WITH CHECK ADD  CONSTRAINT [FK_ETLProcessCustomErrors_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[ETLProcessCustomErrors] CHECK CONSTRAINT [FK_ETLProcessCustomErrors_Servers_01]
GO
ALTER TABLE [dbo].[ETLProcesses]  WITH CHECK ADD  CONSTRAINT [FK_ETLProcesses_ETLProcessGroups_01] FOREIGN KEY([ETLProcessGroupID])
REFERENCES [dbo].[ETLProcessGroups] ([ETLProcessGroupID])
GO
ALTER TABLE [dbo].[ETLProcesses] CHECK CONSTRAINT [FK_ETLProcesses_ETLProcessGroups_01]
GO
ALTER TABLE [dbo].[Index_Defragmentation_History_Detail]  WITH CHECK ADD  CONSTRAINT [FK_Index Defrag_detail_index_defrag_summary_01] FOREIGN KEY([defragmentation_job_id])
REFERENCES [dbo].[Index_Defragmentation_History_Summary] ([defragmentation_job_id])
GO
ALTER TABLE [dbo].[Index_Defragmentation_History_Detail] CHECK CONSTRAINT [FK_Index Defrag_detail_index_defrag_summary_01]
GO
ALTER TABLE [dbo].[ServerClientNetworkProtocols]  WITH CHECK ADD  CONSTRAINT [FK_ServerClientProtocols_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[ServerClientNetworkProtocols] CHECK CONSTRAINT [FK_ServerClientProtocols_Servers_01]
GO
ALTER TABLE [dbo].[ServerConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_ServerConfigurations_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[ServerConfigurations] CHECK CONSTRAINT [FK_ServerConfigurations_ServerInstances_01]
GO
ALTER TABLE [dbo].[ServerInstanceDataCollectorConfigStores]  WITH CHECK ADD  CONSTRAINT [FK_SIDataCollectorConfigStores_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ServerInstanceDataCollectorConfigStores] CHECK CONSTRAINT [FK_SIDataCollectorConfigStores_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ServerInstanceDataCollectorConfigStores]  WITH CHECK ADD  CONSTRAINT [FK_SIDataCollectorConfigStores_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[ServerInstanceDataCollectorConfigStores] CHECK CONSTRAINT [FK_SIDataCollectorConfigStores_ServerInstances_01]
GO
ALTER TABLE [dbo].[ServerInstances]  WITH CHECK ADD  CONSTRAINT [FK_ServerInstances_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ServerInstances] CHECK CONSTRAINT [FK_ServerInstances_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ServerInstances]  WITH CHECK ADD  CONSTRAINT [FK_ServerInstances_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[ServerInstances] CHECK CONSTRAINT [FK_ServerInstances_Servers_01]
GO
ALTER TABLE [dbo].[ServerNetworkProtocolProperties]  WITH CHECK ADD  CONSTRAINT [FK_ServerNetProtocols_ServerNetProtocolProps_01] FOREIGN KEY([ServerNetworkProtocolsId])
REFERENCES [dbo].[ServerNetworkProtocols] ([ServerNetworkProtocolsId])
GO
ALTER TABLE [dbo].[ServerNetworkProtocolProperties] CHECK CONSTRAINT [FK_ServerNetProtocols_ServerNetProtocolProps_01]
GO
ALTER TABLE [dbo].[ServerNetworkProtocols]  WITH CHECK ADD  CONSTRAINT [FK_ServerNetworkProtocols_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[ServerNetworkProtocols] CHECK CONSTRAINT [FK_ServerNetworkProtocols_ServerInstances_01]
GO
ALTER TABLE [dbo].[ServerNetworkProtocolsIPAddresses]  WITH CHECK ADD  CONSTRAINT [FK_ServerNetProtocolsIPA_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[ServerNetworkProtocolsIPAddresses] CHECK CONSTRAINT [FK_ServerNetProtocolsIPA_ServerInstances_01]
GO
ALTER TABLE [dbo].[ServerNetworkProtocolsIPAddressProperties]  WITH CHECK ADD  CONSTRAINT [FK_ServerNetIPAddressProps_ServerNetProtocolsIPAdds_01] FOREIGN KEY([ServerNetworkProtocolsIPAddressesId])
REFERENCES [dbo].[ServerNetworkProtocolsIPAddresses] ([ServerNetworkProtocolsIPAddressesId])
GO
ALTER TABLE [dbo].[ServerNetworkProtocolsIPAddressProperties] CHECK CONSTRAINT [FK_ServerNetIPAddressProps_ServerNetProtocolsIPAdds_01]
GO
ALTER TABLE [dbo].[ServerPhysicalDisks]  WITH CHECK ADD  CONSTRAINT [FK_ServerPhysicalDisks_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ServerPhysicalDisks] CHECK CONSTRAINT [FK_ServerPhysicalDisks_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ServerPhysicalDisks]  WITH CHECK ADD  CONSTRAINT [FK_ServerPhysicalDisks_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[ServerPhysicalDisks] CHECK CONSTRAINT [FK_ServerPhysicalDisks_Servers_01]
GO
ALTER TABLE [dbo].[ServerProperties]  WITH CHECK ADD  CONSTRAINT [FK_ServerProperties_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ServerProperties] CHECK CONSTRAINT [FK_ServerProperties_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ServerProperties]  WITH CHECK ADD  CONSTRAINT [FK_ServerProperties_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[ServerProperties] CHECK CONSTRAINT [FK_ServerProperties_ServerInstances_01]
GO
ALTER TABLE [dbo].[Servers]  WITH CHECK ADD  CONSTRAINT [FK_Servers_ServerBusinessCategories_01] FOREIGN KEY([BusinessCategoryID])
REFERENCES [dbo].[BusinessCategories] ([BusinessCategoryID])
GO
ALTER TABLE [dbo].[Servers] CHECK CONSTRAINT [FK_Servers_ServerBusinessCategories_01]
GO
ALTER TABLE [dbo].[ServerServices]  WITH CHECK ADD  CONSTRAINT [FK_ServerServices_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[ServerServices] CHECK CONSTRAINT [FK_ServerServices_ETLProcesses_01]
GO
ALTER TABLE [dbo].[ServerServices]  WITH CHECK ADD  CONSTRAINT [FK_ServerServices_Servers_01] FOREIGN KEY([ServerSystemID])
REFERENCES [dbo].[Servers] ([ServerSystemID])
GO
ALTER TABLE [dbo].[ServerServices] CHECK CONSTRAINT [FK_ServerServices_Servers_01]
GO
ALTER TABLE [dbo].[SQLAgentJobs]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobs_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[SQLAgentJobs] CHECK CONSTRAINT [FK_SQLAgentJobs_ETLProcesses_01]
GO
ALTER TABLE [dbo].[SQLAgentJobs]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobs_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[SQLAgentJobs] CHECK CONSTRAINT [FK_SQLAgentJobs_ServerInstances_01]
GO
ALTER TABLE [dbo].[SQLAgentJobSchedules]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobSchedules_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[SQLAgentJobSchedules] CHECK CONSTRAINT [FK_SQLAgentJobSchedules_ETLProcesses_01]
GO
ALTER TABLE [dbo].[SQLAgentJobSchedules]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobSchedules_SQLAgentJobs_01] FOREIGN KEY([SQLJobsID])
REFERENCES [dbo].[SQLAgentJobs] ([SQLJobsID])
GO
ALTER TABLE [dbo].[SQLAgentJobSchedules] CHECK CONSTRAINT [FK_SQLAgentJobSchedules_SQLAgentJobs_01]
GO
ALTER TABLE [dbo].[SQLAgentJobSteps]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobSteps_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[SQLAgentJobSteps] CHECK CONSTRAINT [FK_SQLAgentJobSteps_ETLProcesses_01]
GO
ALTER TABLE [dbo].[SQLAgentJobSteps]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentJobSteps_SQLAgentJobs_01] FOREIGN KEY([SQLJobsID])
REFERENCES [dbo].[SQLAgentJobs] ([SQLJobsID])
GO
ALTER TABLE [dbo].[SQLAgentJobSteps] CHECK CONSTRAINT [FK_SQLAgentJobSteps_SQLAgentJobs_01]
GO
ALTER TABLE [dbo].[SQLAgentSchedules]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentSchedules_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [dbo].[SQLAgentSchedules] CHECK CONSTRAINT [FK_SQLAgentSchedules_ETLProcesses_01]
GO
ALTER TABLE [dbo].[SQLAgentSchedules]  WITH CHECK ADD  CONSTRAINT [FK_SQLAgentSchedules_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [dbo].[SQLAgentSchedules] CHECK CONSTRAINT [FK_SQLAgentSchedules_ServerInstances_01]
GO
ALTER TABLE [dbo].[Statistics_Update_History_Detail]  WITH CHECK ADD  CONSTRAINT [FK_Statistics_Update_Detail_Statistics_Update_summary_01] FOREIGN KEY([statssummary_job_id])
REFERENCES [dbo].[Statistics_Update_History_Summary] ([statssummary_job_id])
GO
ALTER TABLE [dbo].[Statistics_Update_History_Detail] CHECK CONSTRAINT [FK_Statistics_Update_Detail_Statistics_Update_summary_01]
GO
ALTER TABLE [security].[ADGroupMembers]  WITH CHECK ADD  CONSTRAINT [FK_ADGroupMembers_ETLProcessControl_01] FOREIGN KEY([ETLProcessStartID])
REFERENCES [security].[ETLProcessControl] ([ETLProcessId])
GO
ALTER TABLE [security].[ADGroupMembers] CHECK CONSTRAINT [FK_ADGroupMembers_ETLProcessControl_01]
GO
ALTER TABLE [security].[ADGroupMembers]  WITH CHECK ADD  CONSTRAINT [FK_ADGroupMembers_ETLProcessControl_02] FOREIGN KEY([ETLProcessEndID])
REFERENCES [security].[ETLProcessControl] ([ETLProcessId])
GO
ALTER TABLE [security].[ADGroupMembers] CHECK CONSTRAINT [FK_ADGroupMembers_ETLProcessControl_02]
GO
ALTER TABLE [security].[DatabaseRoleMembers]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseRoleMembers_DatabasePrincipals_01] FOREIGN KEY([DatabasePrincipalsId])
REFERENCES [security].[DatabasePrincipals] ([DatabasePrincipalsId])
GO
ALTER TABLE [security].[DatabaseRoleMembers] CHECK CONSTRAINT [FK_DatabaseRoleMembers_DatabasePrincipals_01]
GO
ALTER TABLE [security].[DatabaseRoleMembers]  WITH CHECK ADD  CONSTRAINT [FK_DatabaseRoleMembers_DatabaseRoles_01] FOREIGN KEY([DatabaseRolesId])
REFERENCES [security].[DatabaseRoles] ([DatabaseRolesId])
GO
ALTER TABLE [security].[DatabaseRoleMembers] CHECK CONSTRAINT [FK_DatabaseRoleMembers_DatabaseRoles_01]
GO
ALTER TABLE [security].[Databases]  WITH CHECK ADD  CONSTRAINT [FK_Databases_Servers_01] FOREIGN KEY([ServerId])
REFERENCES [security].[Servers] ([ServerId])
GO
ALTER TABLE [security].[Databases] CHECK CONSTRAINT [FK_Databases_Servers_01]
GO
ALTER TABLE [security].[ServerRoleMembers]  WITH CHECK ADD  CONSTRAINT [FK_ServerRoleMembers_ServerPrincipals_01] FOREIGN KEY([ServerPrincipalsId])
REFERENCES [security].[ServerPrincipals] ([ServerPrincipalsId])
GO
ALTER TABLE [security].[ServerRoleMembers] CHECK CONSTRAINT [FK_ServerRoleMembers_ServerPrincipals_01]
GO
ALTER TABLE [security].[ServerRoleMembers]  WITH CHECK ADD  CONSTRAINT [FK_ServerRoleMembers_ServerRoles_01] FOREIGN KEY([ServerRoleId])
REFERENCES [security].[ServerRoles] ([ServerRoleId])
GO
ALTER TABLE [security].[ServerRoleMembers] CHECK CONSTRAINT [FK_ServerRoleMembers_ServerRoles_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditControls]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditControls_AuditControls_01] FOREIGN KEY([AuditDefinitionID])
REFERENCES [sqlaudit].[AuditControls] ([AuditDefinitionID])
GO
ALTER TABLE [sqlaudit].[ServerAuditControls] CHECK CONSTRAINT [FK_ServerAuditControls_AuditControls_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditControls]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditControls_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [sqlaudit].[ServerAuditControls] CHECK CONSTRAINT [FK_ServerAuditControls_ServerInstances_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditETLStatus]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditETLStatus_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [sqlaudit].[ServerAuditETLStatus] CHECK CONSTRAINT [FK_ServerAuditETLStatus_ETLProcesses_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditETLStatus]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditETLStatus_ServerAuditControls_01] FOREIGN KEY([AuditDefinitionID], [ServerInstanceId])
REFERENCES [sqlaudit].[ServerAuditControls] ([AuditDefinitionID], [ServerInstanceId])
GO
ALTER TABLE [sqlaudit].[ServerAuditETLStatus] CHECK CONSTRAINT [FK_ServerAuditETLStatus_ServerAuditControls_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditSpecificationDetails]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditSpecDetails_ServerAuditSpecs_01] FOREIGN KEY([ServerAuditSpecificationsID])
REFERENCES [sqlaudit].[ServerAuditSpecifications] ([ServerAuditSpecificationsID])
GO
ALTER TABLE [sqlaudit].[ServerAuditSpecificationDetails] CHECK CONSTRAINT [FK_ServerAuditSpecDetails_ServerAuditSpecs_01]
GO
ALTER TABLE [sqlaudit].[ServerAuditSpecifications]  WITH CHECK ADD  CONSTRAINT [FK_ServerAuditSpecifications_ServerAudits_01] FOREIGN KEY([ServerAuditsID])
REFERENCES [sqlaudit].[ServerAudits] ([ServerAuditsID])
GO
ALTER TABLE [sqlaudit].[ServerAuditSpecifications] CHECK CONSTRAINT [FK_ServerAuditSpecifications_ServerAudits_01]
GO
ALTER TABLE [sqlaudit].[ServerDefaultTraces]  WITH CHECK ADD  CONSTRAINT [FK_ServerDefaultTraces_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [sqlaudit].[ServerDefaultTraces] CHECK CONSTRAINT [FK_ServerDefaultTraces_ServerInstances_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionActions]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionActions_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [sqlaudit].[ServerXESessionActions] CHECK CONSTRAINT [FK_ServerXESessionActions_ETLProcesses_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionActions]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionActions_ServerXESessions_01] FOREIGN KEY([ServerXESessionsID])
REFERENCES [sqlaudit].[ServerXESessions] ([ServerXESessionsID])
GO
ALTER TABLE [sqlaudit].[ServerXESessionActions] CHECK CONSTRAINT [FK_ServerXESessionActions_ServerXESessions_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionEvents]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionEvents_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [sqlaudit].[ServerXESessionEvents] CHECK CONSTRAINT [FK_ServerXESessionEvents_ETLProcesses_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionEvents]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionEvents_ServerXESessions_01] FOREIGN KEY([ServerXESessionsID])
REFERENCES [sqlaudit].[ServerXESessions] ([ServerXESessionsID])
GO
ALTER TABLE [sqlaudit].[ServerXESessionEvents] CHECK CONSTRAINT [FK_ServerXESessionEvents_ServerXESessions_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionFields]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionFields_ServerXESessions_01] FOREIGN KEY([ServerXESessionsID])
REFERENCES [sqlaudit].[ServerXESessions] ([ServerXESessionsID])
GO
ALTER TABLE [sqlaudit].[ServerXESessionFields] CHECK CONSTRAINT [FK_ServerXESessionFields_ServerXESessions_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessions]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessions_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [sqlaudit].[ServerXESessions] CHECK CONSTRAINT [FK_ServerXESessions_ETLProcesses_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessions]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessions_ServerInstances_01] FOREIGN KEY([ServerInstanceId])
REFERENCES [dbo].[ServerInstances] ([ServerInstanceId])
GO
ALTER TABLE [sqlaudit].[ServerXESessions] CHECK CONSTRAINT [FK_ServerXESessions_ServerInstances_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionTargets]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionTargets_ETLProcesses_01] FOREIGN KEY([ETLProcessId])
REFERENCES [dbo].[ETLProcesses] ([ETLProcessId])
GO
ALTER TABLE [sqlaudit].[ServerXESessionTargets] CHECK CONSTRAINT [FK_ServerXESessionTargets_ETLProcesses_01]
GO
ALTER TABLE [sqlaudit].[ServerXESessionTargets]  WITH CHECK ADD  CONSTRAINT [FK_ServerXESessionTargets_ServerXESessions_01] FOREIGN KEY([ServerXESessionsID])
REFERENCES [sqlaudit].[ServerXESessions] ([ServerXESessionsID])
GO
ALTER TABLE [sqlaudit].[ServerXESessionTargets] CHECK CONSTRAINT [FK_ServerXESessionTargets_ServerXESessions_01]
GO
/****** Object:  StoredProcedure [dbo].[Find_Text_In_SP]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[Find_Text_In_SP]
@StringToFind varchar(100) 
AS 
DECLARE @WCStringToFind VARCHAR(100)
   SET @WCStringToFind = '%' + @StringToFind + '%'
 --  SELECT Distinct 
 --  DB_NAME() AS DatabaseSearched,
 --  @StringToFind as StringToFind,
 --  SO.Name
 --  FROM sysobjects SO (NOLOCK)
 --  INNER JOIN syscomments SC (NOLOCK) on SO.Id = SC.ID
 --  AND SO.Type in ('P','FN','TF')
	--AND SC.Text LIKE @WCStringToFind
 --  ORDER BY SO.Name

	SELECT Distinct 
	DB_NAME() AS DatabaseSearched,
	@StringToFind as StringToFind,
	so.object_id as ObjectId,
	SCHEMA_NAME(so.schema_id) as schemaName,
	SO.Name, 
	so.type_desc,
	SC.colid,
	SC.[text]
	FROM sys.objects SO (NOLOCK)
	INNER JOIN sys.syscomments SC (NOLOCK) on SO.object_Id = SC.ID
	AND SO.Type in ('V','P','FN','TF')
	AND SC.Text LIKE @WCStringToFind
	ORDER BY so.type_desc, SCHEMA_NAME(so.schema_id), SO.Name, SC.colid
GO
/****** Object:  StoredProcedure [dbo].[sp_ssis_addlogentry]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_ssis_addlogentry]  @event sysname,  @computer nvarchar(128),  @operator nvarchar(128),  @source nvarchar(1024),  @sourceid uniqueidentifier,  @executionid uniqueidentifier,  @starttime datetime,  @endtime datetime,  @datacode int,  @databytes image,  @message nvarchar(2048)AS  INSERT INTO sysssislog (      event,      computer,      operator,      source,      sourceid,      executionid,      starttime,      endtime,      datacode,      databytes,      message )  VALUES (      @event,      @computer,      @operator,      @source,      @sourceid,      @executionid,      @starttime,      @endtime,      @datacode,      @databytes,      @message )  RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationPrincipals_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationPrincipals table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationPrincipals_Ins] (
@PrincipalLocalName varchar(128)
,@PrincipalADsamAccountName varchar(256)
,@PrincipalADGUID uniqueidentifier
,@PrincipalADType varchar(1)
,@EmployeeMasterID int
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
		
	BEGIN TRAN
	--Certain fields, if NULL values are passed, can be set to default values (logical defaults set here in the procedure, not database defined defaults)
		INSERT INTO [dbo].[ApplicationPrincipals]
		([PrincipalLocalName]
		,[PrincipalADsamAccountName]
		,[PrincipalADGUID]
		,[PrincipalADType]
		,[EmployeeMasterID])
     VALUES
		(
		@PrincipalLocalName
		,@PrincipalADsamAccountName
		,@PrincipalADGUID
		,@PrincipalADType
		,@EmployeeMasterID
		)

		-- Begin Return Select of record just added
		SELECT 
		[ApplicationPrincipalID]
		,[PrincipalLocalName]
		,[PrincipalADsamAccountName]
		,[PrincipalADGUID]
		,[PrincipalADType]
		,[EmployeeMasterID]
		FROM [dbo].[ApplicationPrincipals]
		WHERE  [ApplicationPrincipalID] = SCOPE_IDENTITY();
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationPrincipals_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationRoles table.
Procedure standardizes operation for inserting records to the table.
DateAdded is not included here as this will only be set during insert operations
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationPrincipals_Upd] (
@ApplicationPrincipalID INT
,@PrincipalLocalName varchar(128)
,@PrincipalADsamAccountName varchar(128)
,@PrincipalADGUID uniqueidentifier
,@PrincipalADType varchar(1)
,@EmployeeMasterID int
)
AS 
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON  
--Set default and non-null values
BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationPrincipalID'
	IF @ApplicationPrincipalID  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationPrincipalID input parameter in the procedure %s.  Please provide a valid ApplicationPrincipalID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1;
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[ApplicationPrincipals] WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationPrincipalID does not exist in the ApplicationPrincipals table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1; 
		END
	END
		
		BEGIN TRAN
		
		--Set any NULL values passed in the procedure parameters equal to the value currently in the table to prevent NULL errors and prevent overwriting current values with incorrect nulls.
		SELECT 
		@PrincipalADsamAccountName= ISNULL(@PrincipalADsamAccountName,[PrincipalADsamAccountName])
		,@PrincipalLocalName = ISNULL(@PrincipalLocalName,[PrincipalLocalName])	
		,@PrincipalADType = ISNULL(@PrincipalADType,[PrincipalADType])
		,@EmployeeMasterID = ISNULL(@EmployeeMasterID,[EmployeeMasterID])
		FROM [dbo].[ApplicationPrincipals]
		WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID
	
		UPDATE [dbo].[ApplicationPrincipals]
		SET [PrincipalADsamAccountName] = @PrincipalADsamAccountName
		,[PrincipalLocalName] = @PrincipalLocalName
		,[PrincipalADType] = @PrincipalADType
		,[EmployeeMasterID] = @EmployeeMasterID
		WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID
		
	COMMIT TRANSACTION
	-- Begin Return Select of record just added
	SELECT [ApplicationPrincipalID]
	,[PrincipalLocalName]
	,[PrincipalADsamAccountName]
	,[PrincipalADGUID]
	,[PrincipalADType]
	,[EmployeeMasterID]
	FROM [dbo].[ApplicationPrincipals]
	WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID
	
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationRolePrincipals_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationRolePrincipals table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationRolePrincipals_Ins] (
@ApplicationId int
,@ApplicationRoleID int
,@ApplicationPrincipalID int
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @lastupdatedt DATE = GETDATE()
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationID'
	IF @ApplicationId  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationID input parameter in the procedure %s.  Please provide a valid ApplicationID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationID] = @ApplicationId)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationID does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END

	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationRoleID'
	IF @ApplicationRoleID  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationRoleID input parameter in the procedure %s.  Please provide a valid ApplicationRoleID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationRoles] WHERE [ApplicationRoleID] = @ApplicationRoleID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationRoleID does not exist in the ApplicationRoless table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END


	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationPrincipalID'
	IF @ApplicationPrincipalID  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationPrincipalID input parameter in the procedure %s.  Please provide a valid ApplicationPrincipalID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationPrincipals] WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationPrincipalID does not exist in the ApplicationPrincipals table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END

	BEGIN TRAN
	
	INSERT INTO [dbo].[ApplicationRolePrincipals]
	([ApplicationId]
	,[ApplicationRoleID]
	,[ApplicationPrincipalID]
	,[LastUpdateDt]
	)
	VALUES
	(@ApplicationId
	,@ApplicationRoleID
	,@ApplicationPrincipalID
	,@LastUpdateDt
	)
	COMMIT TRANSACTION

	SELECT [ApplicationId]
	,[ApplicationRoleID]
	,[ApplicationPrincipalID]
	,[LastUpdateDt]
	FROM [dbo].[vw_ApplicationRolePrincipals]
	WHERE
	[ApplicationId] = @ApplicationId 
	AND [ApplicationRoleID] = @ApplicationRoleID
	AND [ApplicationPrincipalID] = @ApplicationPrincipalID

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationRolePrincipals_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationRolePrincipals table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationRolePrincipals_Upd] (
@ApplicationId_Current int
,@ApplicationRoleID_Current int
,@ApplicationPrincipalID_Current int
,@ApplicationId_New int
,@ApplicationRoleID_New int
,@ApplicationPrincipalID_New int

)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @LastUpdateDt DATE = GETDATE()
	--Confirm the record to update exists
	IF NOT EXISTS (SELECT * FROM [dbo].[ApplicationRolePrincipals] WHERE [ApplicationID] = @ApplicationId_Current AND [ApplicationRoleID] = @ApplicationRoleID_Current AND [ApplicationPrincipalID] = @ApplicationPrincipalID_Current)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationID does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1; 
	END

	--Validate individual parameters exist in the respective parent tables
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationID_New'
	IF @ApplicationId_New  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the input parameters in the procedure %s.  The values passed for the current record to update cannot be found in the table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationID] = @ApplicationId_New)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationID does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1; 

		END
	END

	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationRoleID'
	IF @ApplicationRoleID_New  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationRoleID input parameter in the procedure %s.  Please provide a valid ApplicationRoleID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationRoles] WHERE [ApplicationRoleID] = @ApplicationRoleID_New)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationRoleID does not exist in the ApplicationRoless table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1; 

		END
	END


	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationPrincipalID'
	IF @ApplicationPrincipalID_New  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationPrincipalID input parameter in the procedure %s.  Please provide a valid ApplicationPrincipalID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationPrincipals] WHERE [ApplicationPrincipalID] = @ApplicationPrincipalID_New)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationPrincipalID does not exist in the ApplicationPrincipals table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1;
		END
	END




	BEGIN TRAN
		UPDATE [dbo].[ApplicationRolePrincipals]
		SET [ApplicationId] = @ApplicationId_New
		,[ApplicationRoleID] = @ApplicationRoleID_New
		,[ApplicationPrincipalID] = @ApplicationPrincipalID_New
		,[LastUpdateDt] = @LastUpdateDt
		WHERE 
		[ApplicationId] = @ApplicationId_Current
		AND [ApplicationRoleID] = @ApplicationRoleID_Current
		AND [ApplicationPrincipalID] = @ApplicationPrincipalID_Current
		
	COMMIT TRANSACTION

	SELECT [ApplicationId]
	,[ApplicationRoleID]
	,[ApplicationPrincipalID]
	,[LastUpdateDt]
	FROM [dbo].[vw_ApplicationRolePrincipals]
	WHERE
	[ApplicationId] = @ApplicationId_New
	AND [ApplicationRoleID] = @ApplicationRoleID_New
	AND [ApplicationPrincipalID] = @ApplicationPrincipalID_New

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationRoles_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationRoles table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationRoles_Ins] (
@ApplicationRoleName varchar(25),
@ApplicationRoleCommonName varchar(25),
@ApplicationRoleDesc varchar(400),
@ApplicationRoleType varchar(1),
@ApplicationManagementRoleID int
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null for new Servers, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	SET @currObject = 'ApplicationRoleName'
	IF @ApplicationRoleName IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	SET @currObject = 'ApplicationRoleDesc'
	IF @ApplicationRoleDesc IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	SET @currObject = 'ApplicationManagementRoleID'
	IF @ApplicationManagementRoleID IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[ApplicationRoles] WHERE [ApplicationRoleId] = @ApplicationManagementRoleID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - ApplicationManagementRoleID must exist as an Application Role in the ApplicationRoles table prior to making it a related record.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END
	
	BEGIN TRAN
	--Certain fields, if NULL values are passed, can be set to default values (logical defaults set here in the procedure, not database defined defaults)
		SET @ApplicationRoleType = ISNULL(@ApplicationRoleType,N'S')

		INSERT INTO [dbo].[ApplicationRoles]
			([ApplicationManagementRoleID]
			,[ApplicationRoleName]
			,[ApplicationRoleCommonName]
			,[ApplicationRoleDesc]
			,[ApplicationRoleType])
		VALUES
			(@ApplicationManagementRoleID
			,@ApplicationRoleName
			,@ApplicationRoleCommonName
			,@ApplicationRoleDesc
			,@ApplicationRoleType
			)
		-- Begin Return Select of record just added
		SELECT 
		[ApplicationRoleID]
		,[ApplicationRoleName]
		,[ApplicationRoleCommonName]
		,[ApplicationRoleDesc]
		,[ApplicationRoleType]
		,[ApplicationManagementRoleID]
		FROM [dbo].[ApplicationRoles]
		WHERE  [ApplicationRoleID] = SCOPE_IDENTITY();
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplicationRoles_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ApplicationRoles table.
Procedure standardizes operation for inserting records to the table.
DateAdded is not included here as this will only be set during insert operations
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ApplicationRoles_Upd] (
@ApplicationRoleID int,
@ApplicationRoleName varchar(50),
@ApplicationRoleCommonName varchar(50),
@ApplicationRoleDesc varchar(400),
@ApplicationRoleType varchar(1),
@ApplicationManagementRoleID int)
AS 
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON  
--Set default and non-null values
BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationRoleID'
	IF @ApplicationRoleID  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationRoleID input parameter in the procedure %s.  Please provide a valid ApplicationRoleID  value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationRoles] WHERE [ApplicationRoleId] = @ApplicationRoleID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationRoleID does not exist in the ApplicationRoles table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END
		
	SET @currObject = 'ApplicationManagementRoleID'
	IF @ApplicationManagementRoleID IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_ApplicationRoles] WHERE [ApplicationRoleId] = @ApplicationManagementRoleID)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - ApplicationManagementRoleID must exist as an Application Role in the ApplicationRoles table prior to making it a related record.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 

		END
	END

	BEGIN TRAN
		
		--Set any NULL values passed in the procedure parameters equal to the value currently in the table to prevent NULL errors and prevent overwriting current values with incorrect nulls.
		SELECT
		@ApplicationManagementRoleID = ISNULL(@ApplicationManagementRoleID,[ApplicationManagementRoleID])
		,@ApplicationRoleName = ISNULL(@ApplicationRoleName,[ApplicationRoleName])
		,@ApplicationRoleCommonName  = ISNULL(@ApplicationRoleCommonName,[ApplicationRoleCommonName])
		,@ApplicationRoleDesc = ISNULL(@ApplicationRoleDesc,[ApplicationRoleDesc])
		,@ApplicationRoleType = ISNULL(@ApplicationRoleType,[ApplicationRoleType])
		FROM [dbo].[vw_ApplicationRoles]
		WHERE [ApplicationRoleID] = @ApplicationRoleID
	
		UPDATE [dbo].[ApplicationRoles]
		SET 
		[ApplicationManagementRoleID] = @ApplicationManagementRoleID
		,[ApplicationRoleName] = @ApplicationRoleName
		,[ApplicationRoleCommonName] = @ApplicationRoleCommonName
		,[ApplicationRoleDesc] = @ApplicationRoleDesc
		,[ApplicationRoleType] = @ApplicationRoleType
		WHERE [ApplicationRoleID] = @ApplicationRoleID
		
	COMMIT TRANSACTION
		-- Begin Return Select of record just added
		SELECT [ApplicationRoleID]
		,[ApplicationRoleDesc]
		,[ApplicationRoleName]
		,[ApplicationRoleCommonName]
		,[ApplicationRoleType]
		,[ApplicationManagementRoleID]
		FROM [dbo].[vw_ApplicationRoles]
		WHERE [ApplicationRoleID] = @ApplicationRoleID

END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Applications_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on Applications table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_Applications_Ins] (
@ApplicationName VARCHAR(128),
@ApplicationCommonName VARCHAR(200),
@PrimaryBusinessPurposeDesc VARCHAR(1024),
@BusinessCategoryID INT,
@RetiredInd BIT,
@SQLDBBasedAppInd BIT,
@FinanciallySignificantAppInd BIT,
@ActiveDirectoryGroupAccessInd BIT,
@ActiveDirectoryGroupTag VARCHAR(50),
@InternallyDevelopedAppInd BIT,
@VendorSuppliedDBInd BIT,
@AppDBERModelName VARCHAR(128),
@KFBDistributedAbbreviations VARCHAR(40),
@KFBMFApplicationCode VARCHAR(68)
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
BEGIN TRY
	BEGIN TRAN
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'Application ID'
	IF @ApplicationName IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	DECLARE @LastUpdateDt as Date
	SET @LastUpdateDt = CAST(GETDATE() AS DATE)

	SET @RetiredInd = ISNULL(@RetiredInd,cast(0 as bit))
	SET @SQLDBBasedAppInd = ISNULL(@SQLDBBasedAppInd,CAST(1 AS BIT))
	SET @BusinessCategoryID = ISNULL(@BusinessCategoryID,1)
	SET @FinanciallySignificantAppInd = ISNULL(@FinanciallySignificantAppInd,0)
	SET @VendorSuppliedDBInd = ISNULL(@VendorSuppliedDBInd,0)
	SET @InternallyDevelopedAppInd = ISNULL(@InternallyDevelopedAppInd,1)
	SET @ActiveDirectoryGroupAccessInd = COALESCE(@ActiveDirectoryGroupAccessInd,0)
	SET @ApplicationCommonName = COALESCE(@ApplicationCommonName,@ApplicationName,NULL)

	--The following parameter/table values are allowed nulls but will be reviewed and corrected if set to nulls
	SET @PrimaryBusinessPurposeDesc = ISNULL(@PrimaryBusinessPurposeDesc,NULL)
	SET @KFBMFApplicationCode = ISNULL(@KFBMFApplicationCode,NULL)
	SET @KFBDistributedAbbreviations = ISNULL(@KFBDistributedAbbreviations,NULL)
	SET @AppDBERModelName = ISNULL(@AppDBERModelName,NULL)
	
	INSERT INTO [dbo].[Applications]
		([RetiredInd]
		,[SQLDBBasedAppInd]
		,[ApplicationName]
		,[BusinessCategoryID]
		,[ApplicationCommonName]
		,[PrimaryBusinessPurposeDesc]
		,[KFBMFApplicationCode]
		,[FinanciallySignificantAppInd]
		,[KFBDistributedAbbreviations]
		,[ActiveDirectoryGroupAccessInd]
		,[ActiveDirectoryGroupTag]
		,[VendorSuppliedDBInd]
		,[InternallyDevelopedAppInd]
		,[AppDBERModelName]
		,[LastUpdateDt])
	SELECT
		[RetiredInd] = @RetiredInd,
		[SQLDBBasedAppInd] = @SQLDBBasedAppInd,
		[ApplicationName] = @ApplicationName,
		[BusinessCategoryID] = @BusinessCategoryID,
		[ApplicationCommonName] = @ApplicationCommonName,
		[PrimaryBusinessPurposeDesc] = @PrimaryBusinessPurposeDesc,
		[KFBMFApplicationCode] = @KFBMFApplicationCode,
		[FinanciallySignificantAppInd] = @FinanciallySignificantAppInd,
		[KFBDistributedAbbreviations] = @KFBDistributedAbbreviations,
		[ActiveDirectoryGroupAccessInd] = @ActiveDirectoryGroupAccessInd,
		[ActiveDirectoryGroupTag] = @ActiveDirectoryGroupTag, 
		[VendorSuppliedDBInd] = @VendorSuppliedDBInd,
		[InternallyDevelopedAppInd] = @InternallyDevelopedAppInd,
		[AppDBERModelName] = @AppDBERModelName,
		[LastUpdateDt] = @LastUpdateDt

		SELECT 
			[T1].[ApplicationId],
			[T1].[ApplicationName],
			[T1].[ApplicationCommonName],
			[T1].[PrimaryBusinessPurposeDesc],
			[T1].[BusinessCategoryID],
			[T2].[BusinessCategoryDesc],
			[T1].[RetiredInd],
			[T1].[SQLDBBasedAppInd],
			[T1].[FinanciallySignificantAppInd],
			[T1].[InternallyDevelopedAppInd],
			[T1].[VendorSuppliedDBInd],
			[T1].[AppDBERModelName],
			[T1].[KFBDistributedAbbreviations],
			[T1].[KFBMFApplicationCode],
			[T1].[LastUpdateDt]
		FROM [dbo].[Applications] AS T1
		LEFT OUTER JOIN [dbo].[BusinessCategories] AS T2
		ON [T1].[BusinessCategoryID] = [T2].[BusinessCategoryID]
		WHERE  [T1].[ApplicationId] = SCOPE_IDENTITY();
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Applications_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized UPDATE operation on Applications table.
Procedure standardizes operation for updating records.
DateAdded is not included here as this will only be set during update operations
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_Applications_Upd] (
@ApplicationId int
,@RetiredInd bit
,@SQLDBBasedAppInd bit
,@ApplicationName varchar(128)
,@BusinessCategoryID int
,@ApplicationCommonName varchar(200)
,@PrimaryBusinessPurposeDesc varchar(1024)
,@KFBMFApplicationCode varchar(68)
,@FinanciallySignificantAppInd bit
,@KFBDistributedAbbreviations varchar(40)
,@ActiveDirectoryGroupAccessInd bit
,@ActiveDirectoryGroupTag varchar(128)
,@VendorSuppliedDBInd bit
,@InternallyDevelopedAppInd bit
,@AppDBERModelName varchar(128)

)
AS 
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON  
--Set default and non-null values
BEGIN TRY
DECLARE @LastUpdateDt date = GETDATE()

	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'ApplicationId'
	IF @ApplicationId  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ApplicationId input parameter in the procedure %s.  Please provide a valid ApplicationID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1;
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationId] = @ApplicationId)
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - The input ApplicationID does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1; 
		END
	END
		BEGIN TRAN
		--Set any NULL values passed in the procedure parameters equal to the value currently in the table to prevent NULL errors and prevent overwriting current values with incorrect nulls.
			SELECT 
			@RetiredInd = ISNULL(@RetiredInd,[RetiredInd])
			,@SQLDBBasedAppInd = ISNULL(@SQLDBBasedAppInd,[SQLDBBasedAppInd])
			,@ApplicationName = ISNULL(@ApplicationName,[ApplicationName])
			,@BusinessCategoryID = ISNULL(@BusinessCategoryID,[BusinessCategoryID])
			,@ApplicationCommonName = ISNULL(@ApplicationCommonName,[ApplicationCommonName])
			,@PrimaryBusinessPurposeDesc = ISNULL(@PrimaryBusinessPurposeDesc,[PrimaryBusinessPurposeDesc])
			,@KFBMFApplicationCode = ISNULL(@KFBMFApplicationCode,[KFBMFApplicationCode])
			,@FinanciallySignificantAppInd = ISNULL(@FinanciallySignificantAppInd,[FinanciallySignificantAppInd])
			,@KFBDistributedAbbreviations = ISNULL(@KFBDistributedAbbreviations,[KFBDistributedAbbreviations])
			,@ActiveDirectoryGroupAccessInd = ISNULL(@ActiveDirectoryGroupAccessInd,[ActiveDirectoryGroupAccessInd])
			,@ActiveDirectoryGroupTag = ISNULL(@ActiveDirectoryGroupTag,[ActiveDirectoryGroupTag])
			,@VendorSuppliedDBInd = ISNULL(@VendorSuppliedDBInd,[VendorSuppliedDBInd])
			,@InternallyDevelopedAppInd = ISNULL(@InternallyDevelopedAppInd,[InternallyDevelopedAppInd])
			,@AppDBERModelName = ISNULL(@AppDBERModelName,[AppDBERModelName])
			FROM [dbo].[vw_Applications]
			WHERE [ApplicationID] = @ApplicationID

			UPDATE [dbo].[Applications]
			SET 
			[RetiredInd] = @RetiredInd
			,[SQLDBBasedAppInd] = @SQLDBBasedAppInd
			,[ApplicationName] = @ApplicationName
			,[BusinessCategoryID] = @BusinessCategoryID
			,[ApplicationCommonName] = @ApplicationCommonName
			,[PrimaryBusinessPurposeDesc] = @PrimaryBusinessPurposeDesc
			,[KFBMFApplicationCode] = @KFBMFApplicationCode
			,[FinanciallySignificantAppInd] = @FinanciallySignificantAppInd
			,[KFBDistributedAbbreviations] = @KFBDistributedAbbreviations
			,[ActiveDirectoryGroupAccessInd] = @ActiveDirectoryGroupAccessInd
			,[ActiveDirectoryGroupTag] = @ActiveDirectoryGroupTag
			,[VendorSuppliedDBInd] = @VendorSuppliedDBInd
			,[InternallyDevelopedAppInd] = @InternallyDevelopedAppInd
			,[AppDBERModelName] = @AppDBERModelName
			,[LastUpdateDt] = @LastUpdateDt
			WHERE [ApplicationID] = @ApplicationID
		
		COMMIT TRANSACTION
	-- Begin Return Select of record just added

		SELECT [ApplicationId]
		,[RetiredInd]
		,[SQLDBBasedAppInd]
		,[ApplicationName]
		,[BusinessCategoryID]
		,[ApplicationCommonName]
		,[PrimaryBusinessPurposeDesc]
		,[KFBMFApplicationCode]
		,[FinanciallySignificantAppInd]
		,[KFBDistributedAbbreviations]
		,[ActiveDirectoryGroupAccessInd]
		,[ActiveDirectoryGroupTag]
		,[VendorSuppliedDBInd]
		,[InternallyDevelopedAppInd]
		,[AppDBERModelName]
		,[LastUpdateDt]
		FROM [dbo].[vw_Applications]
		WHERE [ApplicationID] = @ApplicationID
	
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataAccessRoles_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on Applications table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_DataAccessRoles_Ins] (
@RoleScope varchar(2)
,@RoleAuthority varchar(15)
,@RoleName varchar(25)
,@RoleAuthorityISLDAP BIT
,@IsProductionRoleInd BIT
,@GrantDescription varchar(1000)
,@PurposeDescription varchar(1000)
,@Abbreviation varchar(2)
,@LastUpdateDt date
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
-- RoleScope--Is one of two values (SI, DB) for Server Instance or Database
BEGIN TRY
	BEGIN TRAN
	DECLARE @EnvironmentScope VARCHAR(1)
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'RoleAuthority'
	IF ISNULL(CHARINDEX(UPPER(@RoleAuthority),UPPER('ActiveDirectory')),0) +  ISNULL(CHARINDEX(UPPER(@RoleAuthority),UPPER('SQLServer')),0) = 0
	--IF both don't match, then throw an error
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Only ActiveDirectory or SQLServer are valid values'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	SELECT @RoleAuthorityISLDAP = COALESCE(@RoleAuthorityISLDAP,0)
	SET @currObject = 'IsProductionRoleInd'
	IF @IsProductionRoleInd IS NULL
	--IF both don't match, then throw an error
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Role must indicate if the role used in production environments (1 = true/yes) or non-production environments (0 = false/no)'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
		
	IF ISNULL(CHARINDEX(@RoleScope,'SI'),0) +  ISNULL(CHARINDEX(@RoleScope,'DB'),0) = 0
	BEGIN
		SET @currObject = 'RoleScope'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Only SI for Server Instance or DB for Database are valid values'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	SELECT @EnvironmentScope = CASE WHEN @IsProductionRoleInd = 1 THEN 'P' ELSE 'N' END, @LastUpdateDt = CAST(GETDATE() AS DATE)
		
	INSERT INTO [dbo].[DataAccessRoles]
	([RoleScope]
	,[RoleAuthority]
	,[RoleName]
	,[RoleAuthorityISLDAP]
	,[EnvironmentScope]
	,[IsProductionRoleInd]
	,[GrantDescription]
	,[PurposeDescription]
	,[Abbreviation]
	,[LastUpdateDt])
	VALUES
	(
	@RoleScope
	,@RoleAuthority
	,@RoleName
	,@RoleAuthorityISLDAP
	,@EnvironmentScope
	,@IsProductionRoleInd
	,@GrantDescription
	,@PurposeDescription
	,@Abbreviation
	,@LastUpdateDt)
	
	COMMIT TRANSACTION
	SELECT 
	[CustomRoleID]
	,RIGHT(('000' + CAST([CustomRoleID] AS VARCHAR(3))),3) AS FormattedCustomRoleID
	,[RoleScope]
	,[RoleAuthority]
	,[RoleName]
	,[RoleAuthorityISLDAP]
	,[EnvironmentScope]
	,[IsProductionRoleInd]
	,[GrantDescription]
	,[PurposeDescription]
	,[Abbreviation]
	,[LastUpdateDt]
	FROM [dbo].[DataAccessRoles]
	WHERE  [CustomRoleID] = SCOPE_IDENTITY();
END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataAccessRoles_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized UPDATE operation on DataAccessRoles table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_DataAccessRoles_Upd] (
@CustomRoleID bigint
,@RoleScope varchar(2)
,@RoleAuthority varchar(15)
,@RoleAuthorityISLDAP BIT
,@RoleName varchar(25)
,@IsProductionRoleInd BIT
,@GrantDescription varchar(1000)
,@PurposeDescription varchar(1000)
,@Abbreviation varchar(2)
,@LastUpdateDt date
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
-- RoleScope--Is one of two values (SI, DB) for Server Instance or Database
BEGIN TRY
	BEGIN TRAN
	DECLARE @EnvironmentScope VARCHAR(1)
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'RoleAuthority'
	IF ISNULL(CHARINDEX(UPPER(@RoleAuthority),UPPER('ActiveDirectory')),0) +  ISNULL(CHARINDEX(UPPER(@RoleAuthority),UPPER('SQLServer')),0) = 0
	--IF both don't match, then throw an error
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Only ActiveDirectory or SQLServer are valid values'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	SET @currObject = 'IsProductionRoleInd'
	IF @IsProductionRoleInd IS NULL
	--IF both don't match, then throw an error
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Role must indicate if the role used in production environments (1 = true/yes) or non-production environments (0 = false/no)'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
		
		
	IF ISNULL(CHARINDEX(@RoleScope,'SI'),0) +  ISNULL(CHARINDEX(@RoleScope,'DB'),0) = 0
	BEGIN
		SET @currObject = 'RoleScope'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - Invalid values was passed to the input parameter.  Only SI for Server Instance or DB for Database are valid values'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	SELECT @EnvironmentScope = CASE WHEN @IsProductionRoleInd = 1 THEN 'P' ELSE 'N' END, @LastUpdateDt = CAST(GETDATE() AS DATE)
	
	UPDATE [dbo].[DataAccessRoles]
	SET [RoleName] = @RoleName
	,[RoleAuthorityISLDAP] = @RoleAuthorityISLDAP
	,[EnvironmentScope] = @EnvironmentScope
	,[IsProductionRoleInd] = @IsProductionRoleInd
	,[GrantDescription] = @GrantDescription
	,[PurposeDescription] = @PurposeDescription
	,[Abbreviation] = @Abbreviation
	,[LastUpdateDt] = @LastUpdateDt
	WHERE [CustomRoleID] = @CustomRoleID
	AND [RoleScope] = @RoleScope
	AND [RoleAuthority] = @RoleAuthority;

	COMMIT TRANSACTION
	SELECT 
	[CustomRoleID]
	,RIGHT(('000' + CAST([CustomRoleID] AS VARCHAR(3))),3) AS FormattedCustomRoleID
	,[RoleScope]
	,[RoleAuthority]
	,[RoleAuthorityISLDAP]
	,[RoleName]
	,[EnvironmentScope]
	,[IsProductionRoleInd]
	,[GrantDescription]
	,[PurposeDescription]
	,[Abbreviation]
	,[LastUpdateDt]
	FROM [dbo].[DataAccessRoles]
	WHERE  [CustomRoleID] = @CustomRoleID
	AND [RoleScope] = @RoleScope
	AND [RoleAuthority] = @RoleAuthority;
END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_AssignAppIDs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_DatabaseExtendedProperties_AssignAppIDs]
AS
BEGIN
/*
Description: This stored procedure automates the creation of DatabaseExtendedProperties (DBEP) for ApplicationID (AppID) and ApplicationDatabaseSeqID (AppSeqID) as part of the ETL process.
The DBEP values are derived from the database and then updated or added to the Database's ExtendedProperties on the physical database.  The DBEP table is the system
of record and NOT the values on the actual database.  The ETL process takes care of updating the values on the physical database.

Assigning the AppID is a logical business process--the first time a database is created, the AppID must be assigned manually.
AppSeqID are reused--the database with the same exact name are assigned the same AppSeqID
Because all assignments are done based upon database name, the fundamental business and technical assumption requires that no database with the same name is used by more than one application
A database name can be repeated for databases used by the same 'application' (regardless of version) on different servers.  But no two applications can have a database of the exact same name
Database names must be unique across applications but can be repeated within the boundary of an application.
Example: The Application XYZ can have two databases on two different servers both named DatabaseABC.  This is valid
However, what is not allowed is Application XYZ has a database named DatabaseABC AND Application 123 also has a database named DatabaseABC

This process attempts to do four things
1) Look for databases with the same name and create an AppID record if one does not exist
2) For Databases without an assigned AppID, compare the existing list of Database AppIDs by DatabaseName and update the missing AppIDs--this assumes that a database with the same name is used by the same application (hence the reason for the primary assumption)
3) Once the known AppIDs are assigned, assign the AppSeqID--This is determined using a RANK function partitioned by ApplicationID ordered by Database Name and current AppSeqID
Databases with unknown AppSeqID (new databases for an application) are at the upper end of the ranking (higher number) so that AppSeqID is not reused.
Portions of the below procedure explain what is occurring
4) After all processing can be done, it is still possible that some newly discovered databases do not have an AppID assigned.  Because these new databases do not have a matching record by name
to an existing database, the AppID could not be determined.  The output of the stored procedure must be used to manually run UPDATE dbo.DatabaseExtendedProperties statements for each database.
This manual update is the application of the logical business process

*/
--Find the Databases with no matching records in the DBEP table for AppID 
--using left outer join of the Databases table to the DBEP where DBEP join key is null--have no matching records
--These have no record in the DBEP table for AppID.  Even though the value is not known add them to the table with NULL values.  
--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
	INSERT INTO [dbo].[DatabaseExtendedProperties]
	([DatabaseUniqueId]
	,[DatabaseURN]
	,[ExtendedPropertyName]
	,[ExtendedPropertyValue]
	,[ExtendedPropertyLength]
	,[IsCustomExtendedProperty]
	,[ETLProcessId]
	,[FirstReportedDate]
	,[LatestReportedDate])
	SELECT 
	[DB1].[DatabaseUniqueId]
	,[DB1].[DatabaseURN]
	,'ApplicationID'
	,NULL
	,0
	,1
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is null;

	--Find the Databases with matching records in the DBEP table for AppID but the value is unknown
	--using left outer join of the Databases table to the DBEP where DBEP value is null 
	--These have no record in the DBEP table for AppID.  Even though the value is not known add them to the table with NULL values.  
	--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
	--These databases are not yet assigned an application sequence ID but have a record in the DBEP table.  They could be used to update the ApplicationID if there are other databases by the same name 
	--By inserting the missing ApplicationIDs to DBEP before creating a table variable, databases that have known appIDs can be processed
	--Create a table variable containing the NULL DBEP AppIDs.  This is used later to update the DBEP with the known applicationIDs
	--Insert into the table variable using left outer join of the Databases table to the DBEP where DBEP value is null.  LOJ key is NOT null but the value for AppID is 
	DECLARE @DBAPPIDUPDATES TABLE ([DatabaseUniqueID] INT, [DatabaseName] NVARCHAR(128), [DatabaseURN] NVARCHAR(256),[ApplicationID] INT);
	INSERT INTO @DBAPPIDUPDATES (DatabaseUniqueID,DatabaseName,DatabaseURN,[ApplicationID])
	SELECT 
	[DB1].[DatabaseUniqueId]
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,CAST([ExtendedPropertyValue] as int) as [ApplicationID]
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is NOT null
	and [dbp1].ExtendedPropertyValue IS NULL;

	--Create a temporary table of AppIDs by distinct database name.  This required to eliminate duplicate entries and find the unique databasename-AppID combinations
	DECLARE @DBAPPID TABLE ([DatabaseName] NVARCHAR(128), [ApplicationID] INT);
	INSERT INTO @DBAPPID([DatabaseName],[ApplicationID] )
	SELECT
	[DB1].[DatabaseName]
	,CAST([dbp1].[ExtendedPropertyValue] AS INT)
	FROM [dbo].[Databases] AS DB1
	INNER JOIN
		(SELECT 
		[DatabaseUniqueId]
		,[ExtendedPropertyName]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
		AND [ExtendedPropertyValue] IS NOT NULL) as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	GROUP BY
	[DB1].[DatabaseName]
	,[ExtendedPropertyValue];

	--Update the @DBAPPSEQIDUPDATES with known Databases' AppIDs.  
	UPDATE @DBAPPIDUPDATES
	SET [ApplicationID] = t2.ApplicationID
	FROM @DBAPPIDUPDATES AS T1
	INNER JOIN @DBAPPID AS T2
	ON T1.DatabaseName = t2.DatabaseName;
	
	--As all the AppIDs were added to the DBEP table, update the table with the known AppIDs
	--Those that are newly added databases remain NULL and are provided in the procedure output
	UPDATE DBO.DatabaseExtendedProperties 
	set [ExtendedPropertyValue] = OT1.[ApplicationID] 
	FROM DBO.DatabaseExtendedProperties AS OT2
	INNER JOIN @DBAPPIDUPDATES AS OT1
	ON OT2.DatabaseUniqueId = OT1.DatabaseUniqueID
	and OT2.[ExtendedPropertyName] = 'ApplicationID';

	--Post task validation
	--1) There should not be any database with more than one AppID.  However, must first consolidate DBEP AppID records as a Database (by name) may have multiple values due to Database historical records
	SELECT 
	[ODB1].DatabaseName
	,COUNT([ODB1].[ApplicationID]) AS AppIDCount
	FROM
	(
	SELECT 
	[DB1].[DatabaseName]
	,[DBP3].[ExtendedPropertyValue] AS ApplicationID
	FROM [dbo].[Databases] AS DB1
	INNER JOIN
		(SELECT
		[DatabaseUniqueId], [ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties]
		WHERE [ExtendedPropertyName] = 'ApplicationID'
		AND [ExtendedPropertyValue] IS NOT NULL) AS DBP3
	ON [DB1].[DatabaseUniqueId] = [DBP3].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	GROUP BY 
	[DB1].[DatabaseName]
	,[DBP3].[ExtendedPropertyValue]
	) AS ODB1
	GROUP BY [ODB1].[DatabaseName]
	HAVING COUNT([ODB1].[ApplicationID]) > 1


	--Finally, return a table of records that require manual AppID assignment or other issues
	SELECT 
	1 AS [ChangeType]
	,'PostTaskValidation' AS [ProcessStep]
	,'ApplicationID' AS [DBEPName]
	,'No Record in DBEP' AS [Condition]
	,'Manually Add the DBEP with ApplicationID' as [CorrectiveAction]
	,[DB1].[DatabaseUniqueId]
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,[DB1].[ServerInstanceId]
	,[SIID].[HostName]
	,[SIID].[InstanceName]
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	,CAST([ExtendedPropertyValue] as int) as EPV
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseURN]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
		) as DBP1
	ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
	LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SIID
	ON [DB1].[ServerInstanceId] = [SIID].[ServerInstanceID]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseURN] is null
	UNION ALL
	SELECT 
	1 AS [ChangeType]
	,'PostTaskValidation' AS [ProcessStep]
	,'ApplicationID' AS [DBEPName]
	,'Record in DBEP but NULL' AS [Condition]
	,'Manually Update with ApplicationID' as [CorrectiveAction]
	,[DB1].[DatabaseUniqueId]
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,[DB1].[ServerInstanceId]
	,[SIID].[HostName]
	,[SIID].[InstanceName]
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	,CAST([ExtendedPropertyValue] as int) as EPV
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
	(
	SELECT 
	[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
	) as DBP1
	ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
	LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SIID
	ON [DB1].[ServerInstanceId] = [SIID].[ServerInstanceID]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseURN] is NOT null
	and [DBP1].[ExtendedPropertyValue] is null

END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_AssignAppSeqIDs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_DatabaseExtendedProperties_AssignAppSeqIDs]
AS
BEGIN
/*
Description: This stored procedure automates the creation of DatabaseExtendedProperties (DBEP) for ApplicationID (AppID) and ApplicationDatabaseSeqID (AppSeqID) as part of the ETL process.
This procedure assumes that the [dbo].[usp_DatabaseExtendedProperties_AssignAppIDs] has run before this one.
It must execute before attempting to assign AppSeqIDs to another database of the same name else the AppSeqID do not know the AppID to which a database is assgined

The DBEP values are derived from the database and then updated or added to the Database's ExtendedProperties on the physical database.  The DBEP table is the system
of record and NOT the values on the actual database.  The ETL process takes care of updating the values on the physical database.

Assigning the AppID is a logical business process--the first time a database is created, the AppID must be assigned manually.
AppSeqID are reused--the database with the same exact name are assigned the same AppSeqID
Because all assignments are done based upon database name, the fundamental business and technical assumption requires that no database with the same name is used by more than one application
A database name can be repeated for databases used by the same 'application' (regardless of version) on different servers.  But no two applications can have a database of the exact same name
Database names must be unique across applications but can be repeated within the boundary of an application.
Example: The Application XYZ can have two databases on two different servers both named DatabaseABC.  This is valid
However, what is not allowed is Application XYZ has a database named DatabaseABC AND Application 123 also has a database named DatabaseABC

This process attempts to do four things
1) Look for databases with the same name and create an AppID record if one does not exist
2) For Databases without an assigned AppID, compare the existing list of Database AppIDs by DatabaseName and update the missing AppIDs--this assumes that a database with the same name is used by the same application (hence the reason for the primary assumption)
3) Once the known AppIDs are assigned, assign the AppSeqID--This is determined using a RANK function partitioned by ApplicationID ordered by Database Name and current AppSeqID
Databases with unknown AppSeqID (new databases for an application) are at the upper end of the ranking (higher number) so that AppSeqID is not reused.
Portions of the below procedure explain what is occurring
4) After all processing can be done, it is still possible that some newly discovered databases do not have an AppID assigned.  Because these new databases do not have a matching record by name
to an existing database, the AppID could not be determined.  The output of the stored procedure must be used to manually run UPDATE dbo.DatabaseExtendedProperties statements for each database.

*/

--Similar to the AppIDs, add the AppSeqIDs to the DBEP table but exclude databases that have unknown (NULL) AppIDs
--using left outer join of the Databases table to the DBEP where DBEP value is null 
--These have no record in the DBEP table for AppSeqID.  
--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
--These databases are not yet assigned an application sequence ID but have a record in the DBEP table.  
--By inserting the missing AppSeqIDs to DBEP before creating a table variable, databases that have known appIDs but have not yet been assigned an AppSeqId can be processed
--Create a table variable containing the NULL DBEP AppSeqIDs.  
--Insert into the table variable using left outer join of the Databases table to the DBEP where DBEP value is null.  LOJ key is NOT null but the value for AppID is 
	INSERT INTO [dbo].[DatabaseExtendedProperties]
	([DatabaseUniqueId]
	,[DatabaseURN]
	,[ExtendedPropertyName]
	,[ExtendedPropertyValue]
	,[ExtendedPropertyLength]
	,[IsCustomExtendedProperty]
	,[ETLProcessId]
	,[FirstReportedDate]
	,[LatestReportedDate])
	SELECT 
	[DB1].[DatabaseUniqueId]
	,[DB1].[DatabaseURN]
	,'ApplicationDatabaseSeqID'
	,NULL
	,0
	,1
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is null
	AND [DB1].[DatabaseUniqueId] NOT IN
		(SELECT DISTINCT DatabaseUniqueId
		 FROM DBO.DatabaseExtendedProperties 
		WHERE [ExtendedPropertyName] = 'ApplicationID'
		AND [ExtendedPropertyValue] IS NULL);

	--Once the AppIDs are processed, the procedure moves on to assign the AppSeqID
	--Find the Databases with matching records in the DBEP table for AppSeqID but the value is unknown
	--If these match existing databases, their DBEP.ExtendedPropertyvalue will be updated for DBEP ExtendedPropertyName = AppSeqID
	--Ones that can be assigned AppSeqID have been assigned an ApplicationID using the above queries)
	--Similar to the AppID process, create a temporary table
	DECLARE @DBAPPSEQIDUPDATES TABLE ([DatabaseUniqueID] INT, [DatabaseName] NVARCHAR(128), [DatabaseURN] NVARCHAR(256),[ApplicationID] INT, [ApplicationDatabaseSeqID] INT);
	INSERT INTO @DBAPPSEQIDUPDATES (DatabaseUniqueID,DatabaseName,DatabaseURN,[ApplicationID], [ApplicationDatabaseSeqID])
	SELECT 
	--'ApplicationDatabaseSeqID--NULL Record in DBEP--Should be updated by CTE'
	[DBP1].DatabaseUniqueId
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,CAST([DBP2].[ExtendedPropertyValue] AS INT) as ApplicationID
	,CAST([DBP1].[ExtendedPropertyValue] AS INT) as ApplicationDatabaseSeqID
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[DatabaseURN]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	LEFT OUTER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[DatabaseURN]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP2
	ON [DB1].[DatabaseUniqueId] = [DBP2].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is NOT null
	and [DBP1].[ExtendedPropertyValue] IS NULL
	AND [DB1].[DatabaseUniqueId] NOT IN
		(SELECT DISTINCT DatabaseUniqueId
		 FROM DBO.DatabaseExtendedProperties 
		WHERE [ExtendedPropertyName] = 'ApplicationID'
		AND [ExtendedPropertyValue] IS NULL);


	--Update the DBEP for ApplicationIDs for those matching an existing database by name
	--Create a table of databases with their assigned application IDs and known application seq IDs
	--this is used later to process updates to AppSeqID based upon RANK of the current AppDBSeq and Database Name
	DECLARE @DBAPPSEQID TABLE ([DatabaseName] NVARCHAR(128), [ApplicationID] INT, [ApplicationDatabaseSeqID] INT NULL);
	INSERT INTO @DBAPPSEQID([DatabaseName],[ApplicationDatabaseSeqID] )
	SELECT
	[DB1].[DatabaseName]
	,CAST([dbp1].[ExtendedPropertyValue] AS INT)
	FROM [dbo].[Databases] AS DB1
	INNER JOIN
	(
	SELECT 
	[DatabaseUniqueId]
	,[ExtendedPropertyName]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
	AND [ExtendedPropertyValue] IS NOT NULL
	) as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	GROUP BY
	[DB1].[DatabaseName]
	,[ExtendedPropertyValue];

	UPDATE @DBAPPSEQID 
	SET [ApplicationID] = T2.ApplicationID
	FROM @DBAPPSEQID AS T1
	INNER JOIN
		(SELECT
		[DB1].[DatabaseName]
		,CAST([ExtendedPropertyValue] as int) as ApplicationID
		FROM [dbo].[Databases] AS DB1
		INNER JOIN 
			(SELECT 
			[DatabaseUniqueId]
			,[ExtendedPropertyValue]
			FROM [dbo].[DatabaseExtendedProperties] 
			WHERE [ExtendedPropertyName] = 'ApplicationID'
			) as DBP1
		ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
		WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
		GROUP BY
		[DB1].[DatabaseName]
		,[ExtendedPropertyValue]) AS T2
	ON T1.DatabaseName = T2.DatabaseName;

	--Update the @DBAPPSEQIDUPDATES with known Databases' AppSeqIDs. 
	UPDATE @DBAPPSEQIDUPDATES
	SET [ApplicationDatabaseSeqID] = t2.ApplicationDatabaseSeqID
	FROM @DBAPPSEQIDUPDATES AS T1
	INNER JOIN @DBAPPSEQID AS T2
	ON T1.DatabaseName = t2.DatabaseName
	AND T1.ApplicationID = T2.ApplicationID;

	--Use the temporary databases with known AppID and both known and yet to be assigned AppSeqID
	--By assigning a very high value to NULL (unassigned) AppSeqID, a RANK function partitioned by AppID ordered by AppSeqID and DatabaseName
	--should put the databases in the correct order.  Existing databases with assigned AppSeqID will have a Rank order = to previously assigned AppSeqID
	--The databases NOT yet assigned AppSeqID are ranked at the upper end of the partition.  Because their rank order is higher than 
	--previously assigned AppSeqID, this rank order becomes the AppSeqID to assign to the database.
	WITH APPCTE ([DatabaseName],[ApplicationID],[ApplicationDatabaseSeqID],[NewAppSeqID]) --[ApplicationName],
	AS
	(SELECT
	[T1].[DatabaseName]
	,[T1].[ApplicationID]
	,[T1].[ApplicationDatabaseSeqID]
	,RANK () OVER (PARTITION BY [T1].[ApplicationID] ORDER BY [ApplicationDatabaseSeqID] asc, [DATABASENAME] ASC ) AS NewApplicationSequenceID
	FROM 
		(SELECT DISTINCT
		DatabaseName,[ApplicationID], ISNULL([ApplicationDatabaseSeqID],999999) AS [ApplicationDatabaseSeqID]
		FROM @DBAPPSEQIDUPDATES 
		UNION
		SELECT DISTINCT
		[DatabaseName], [ApplicationID], [ApplicationDatabaseSeqID]
		FROM @DBAPPSEQID 
		) AS [T1]
	)

	--Update the temporary AppSeqID update table with these new rankings
	UPDATE @DBAPPSEQIDUPDATES
	SET [ApplicationDatabaseSeqID] = [t2].[NewAppSeqID]
	FROM @DBAPPSEQIDUPDATES AS T1
	INNER JOIN APPCTE AS T2
	ON T1.DatabaseName = t2.DatabaseName
	AND T1.ApplicationID = T2.ApplicationID
	WHERE t1.ApplicationDatabaseSeqID IS NULL

	--if there are ANY records where the appseqid is NOT null and the 'New' App Seq ID is different than the current value--do not process as there is a mix up in the seq assignments
	UPDATE DBO.DatabaseExtendedProperties 
	set [ExtendedPropertyValue] = OT1.[ApplicationDatabaseSeqID] 
	FROM DBO.DatabaseExtendedProperties AS OT2
	INNER JOIN @DBAPPSEQIDUPDATES AS OT1
	ON OT2.DatabaseUniqueId = OT1.DatabaseUniqueID
	AND OT2.ExtendedPropertyName = 'ApplicationDatabaseSeqID'


	--Post task validation
	--1) There should not be any database with multiple AppSeqID--if there is there is an error in applying the rank logic
	SELECT 
	[DB1].[DatabaseName]
	,[DBP3].[ExtendedPropertyValue] AS ApplicationID
	,COUNT([DBP3].[AppSeqIDAssignedCount]) AS [DatabasesMultipleAppSeqIDsCount]
	FROM [dbo].[Databases] AS DB1
	INNER JOIN
		(
		SELECT [DBAppID].[DatabaseUniqueId], [DBAppID].[ExtendedPropertyValue],COUNT([DBAppSeqID].[AppSeqID]) AS AppSeqIDAssignedCount
		FROM [dbo].[DatabaseExtendedProperties] AS DBAppID
		INNER JOIN 
			(
			SELECT [DatabaseUniqueId], [ExtendedPropertyValue] AS AppSeqID, COUNT(*) AS AppSeqIDCount
			FROM [dbo].[DatabaseExtendedProperties]
			WHERE [ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
			AND [ExtendedPropertyValue] IS NOT NULL
			GROUP BY [DatabaseUniqueId], [ExtendedPropertyValue]
			) AS DBAppSeqID
		ON [DBAppID].[DatabaseUniqueId] = [DBAppSeqID].[DatabaseUniqueId]
		WHERE [DBAppID].[ExtendedPropertyName] = 'ApplicationID'
		AND [DBAppID].[ExtendedPropertyValue] IS NOT NULL
		GROUP BY [DBAppID].[DatabaseUniqueId], [DBAppID].[ExtendedPropertyValue]
		HAVING COUNT([DBAppSeqID].[AppSeqID])  > 1
		) AS DBP3
	ON [DB1].[DatabaseUniqueId] = [DBP3].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	GROUP BY 
	[DB1].[DatabaseName]
	,[DBP3].[ExtendedPropertyValue]

	SELECT 
	2 AS [ChangeType]
	,'PostTaskValidation' AS [ProcessStep]
	,'ApplicationDatabaseSeqID' AS [DBEPName]
	,'NO Record in DBEP' AS [Condition]
	,'Rerun Stored Procedure should add the AppSeqID once AppID is assigned' as [CorrectiveAction]
	,[DB1].[DatabaseUniqueId]
	,[DB1].[ServerInstanceId]
	,[SIID].[HostName]
	,[SIID].[InstanceName]
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	,CAST([ExtendedPropertyValue] as int) as EPV
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
	(
	SELECT 
	[DatabaseUniqueId]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
	) as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SIID
	ON [DB1].[ServerInstanceId] = [SIID].[ServerInstanceID]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is null
	UNION ALL
	SELECT 
	2 AS [ChangeType]
	,'PostTaskValidation' AS [ProcessStep]
	,'ApplicationDatabaseSeqID' AS [DBEPName]
	,'Record in DBEP but NULL' AS [Condition]
	,'Rerun Stored Procedure should add the AppSeqID once AppID is assigned' as [CorrectiveAction]
	,[DB1].[DatabaseUniqueId]
	,[DB1].[ServerInstanceId]
	,[SIID].[HostName]
	,[SIID].[InstanceName]
	,[DB1].[DatabaseName]
	,[DB1].[DatabaseURN]
	,[DB1].[ETLProcessId]
	,[DB1].[FirstReportedDate]
	,[DB1].[LatestReportedDate]
	,CAST([ExtendedPropertyValue] as int) as EPV
	FROM [dbo].[Databases] AS DB1
	LEFT OUTER JOIN 
	(
	SELECT 
	[DatabaseUniqueId]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
	) as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SIID
	ON [DB1].[ServerInstanceId] = [SIID].[ServerInstanceID]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	AND [DBP1].[DatabaseUniqueId] is NOT null
	AND [DBP1].[ExtendedPropertyValue] is NULL

END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_CreateNew]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_DatabaseExtendedProperties_CreateNew]
AS
BEGIN
/*
Description: This stored procedure automates the creation of DatabaseExtendedProperties (DBEP) for ApplicationID (AppID) and ApplicationDatabaseSeqID (AppSeqID) as part of the ETL process.
The DBEP values are derived from the database and then updated or added to the Database's ExtendedProperties on the physical database.  The DBEP table is the system
of record and NOT the values on the actual database.  The ETL process takes care of updating the values on the physical database.

Assigning the AppID is a logical business process--the first time a database is created, the AppID must be assigned manually.
AppSeqID are reused--the database with the same exact name are assigned the same AppSeqID
Because all assignments are done based upon database name, the fundamental business and technical assumption requires that no database with the same name is used by more than one application
A database name can be repeated for databases used by the same 'application' (regardless of version) on different servers.  But no two applications can have a database of the exact same name
Database names must be unique across applications but can be repeated within the boundary of an application.
Example: The Application XYZ can have two databases on two different servers both named DatabaseABC.  This is valid
However, what is not allowed is Application XYZ has a database named DatabaseABC AND Application 123 also has a database named DatabaseABC

This process attempts to do four things
1) Look for databases with the same name and create an AppID record if one does not exist
2) For Databases without an assigned AppID, compare the existing list of Database AppIDs by DatabaseName and update the missing AppIDs--this assumes that a database with the same name is used by the same application (hence the reason for the primary assumption)
3) Once the known AppIDs are assigned, assign the AppSeqID--This is determined using a RANK function partitioned by ApplicationID ordered by Database Name and current AppSeqID
Databases with unknown AppSeqID (new databases for an application) are at the upper end of the ranking (higher number) so that AppSeqID is not reused.
Portions of the below procedure explain what is occurring
4) After all processing can be done, it is still possible that some newly discovered databases do not have an AppID assigned.  Because these new databases do not have a matching record by name
to an existing database, the AppID could not be determined.  The output of the stored procedure must be used to manually run UPDATE dbo.DatabaseExtendedProperties statements for each database.
This manual update is the application of the logical business process

*/
--Find the Databases with no matching records in the DBEP table for AppID 
--using left outer join of the Databases table to the DBEP where DBEP join key is null--have no matching records
--These have no record in the DBEP table for AppID.  Even though the value is not known add them to the table with NULL values.  
--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
INSERT INTO [dbo].[DatabaseExtendedProperties]
([DatabaseUniqueId]
,[DatabaseURN]
,[ExtendedPropertyName]
,[ExtendedPropertyValue]
,[ExtendedPropertyLength]
,[IsCustomExtendedProperty]
,[ETLProcessId]
,[FirstReportedDate]
,[LatestReportedDate])
SELECT 
[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseURN]
,'ApplicationID'
,NULL
,0
,1
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is null;

--Find the Databases with matching records in the DBEP table for AppID but the value is unknown
--using left outer join of the Databases table to the DBEP where DBEP value is null 
--These have no record in the DBEP table for AppID.  Even though the value is not known add them to the table with NULL values.  
--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
--These databases are not yet assigned an application sequence ID but have a record in the DBEP table.  They could be used to update the ApplicationID if there are other databases by the same name 
--By inserting the missing ApplicationIDs to DBEP before creating a table variable, databases that have known appIDs can be processed
--Create a table variable containing the NULL DBEP AppIDs.  This is used later to update the DBEP with the known applicationIDs
--Insert into the table variable using left outer join of the Databases table to the DBEP where DBEP value is null.  LOJ key is NOT null but the value for AppID is 
DECLARE @DBAPPIDUPDATES TABLE ([DatabaseUniqueID] INT, [DatabaseName] NVARCHAR(128), [DatabaseURN] NVARCHAR(256),[ApplicationID] INT);
INSERT INTO @DBAPPIDUPDATES (DatabaseUniqueID,DatabaseName,DatabaseURN,[ApplicationID])
SELECT 
[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,CAST([ExtendedPropertyValue] as int) as [ApplicationID]
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is NOT null
and [dbp1].ExtendedPropertyValue IS NULL;

--Create a temporary table of AppIDs by distinct database name.  This required to eliminate duplicate entries and find the unique databasename-AppID combinations
DECLARE @DBAPPID TABLE ([DatabaseName] NVARCHAR(128), [ApplicationID] INT);
INSERT INTO @DBAPPID([DatabaseName],[ApplicationID] )
SELECT
[DB1].[DatabaseName]
,CAST([dbp1].[ExtendedPropertyValue] AS INT)
FROM [dbo].[Databases] AS DB1
INNER JOIN
	(SELECT 
	[DatabaseUniqueId]
	,[ExtendedPropertyName]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
	AND [ExtendedPropertyValue] IS NOT NULL) as DBP1
ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
GROUP BY
[DB1].[DatabaseName]
,[ExtendedPropertyValue];

--Update the @DBAPPSEQIDUPDATES with known Databases' AppIDs.  
UPDATE @DBAPPIDUPDATES
SET [ApplicationID] = t2.ApplicationID
FROM @DBAPPIDUPDATES AS T1
INNER JOIN @DBAPPID AS T2
ON T1.DatabaseName = t2.DatabaseName
AND T1.ApplicationID = T2.ApplicationID;

--As all the AppIDs were added to the DBEP table, update the table with the known AppIDs
--Those that are newly added databases remain NULL and are provided in the procedure output
UPDATE DBO.DatabaseExtendedProperties 
set [ExtendedPropertyValue] = OT1.[ApplicationID] 
FROM DBO.DatabaseExtendedProperties AS OT2
INNER JOIN @DBAPPIDUPDATES AS OT1
ON OT2.DatabaseUniqueId = OT1.DatabaseUniqueID
and OT2.[ExtendedPropertyName] = 'ApplicationID';

--Similar to the AppIDs, add the AppSeqIDs to the DBEP table but exclude databases that have unknown (NULL) AppIDs
--using left outer join of the Databases table to the DBEP where DBEP value is null 
--These have no record in the DBEP table for AppSeqID.  
--The NULL values may be updated from the below queries if the database is a copy/restore/move/recreation of a prior database with the same name
--These databases are not yet assigned an application sequence ID but have a record in the DBEP table.  
--By inserting the missing AppSeqIDs to DBEP before creating a table variable, databases that have known appIDs but have not yet been assigned an AppSeqId can be processed
--Create a table variable containing the NULL DBEP AppSeqIDs.  
--Insert into the table variable using left outer join of the Databases table to the DBEP where DBEP value is null.  LOJ key is NOT null but the value for AppID is 
INSERT INTO [dbo].[DatabaseExtendedProperties]
([DatabaseUniqueId]
,[DatabaseURN]
,[ExtendedPropertyName]
,[ExtendedPropertyValue]
,[ExtendedPropertyLength]
,[IsCustomExtendedProperty]
,[ETLProcessId]
,[FirstReportedDate]
,[LatestReportedDate])
SELECT 
[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseURN]
,'ApplicationDatabaseSeqID'
,NULL
,0
,1
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is null
AND [DB1].[DatabaseUniqueId] NOT IN
	(SELECT DISTINCT DatabaseUniqueId
	 FROM DBO.DatabaseExtendedProperties 
	WHERE [ExtendedPropertyName] = 'ApplicationID'
	AND [ExtendedPropertyValue] IS NULL);

--Once the AppIDs are processed, the procedure moves on to assign the AppSeqID
--Find the Databases with matching records in the DBEP table for AppSeqID but the value is unknown
--If these match existing databases, their DBEP.ExtendedPropertyvalue will be updated for DBEP ExtendedPropertyName = AppSeqID
--Ones that can be assigned AppSeqID have been assigned an ApplicationID using the above queries)
--Similar to the AppID process, create a temporary table
DECLARE @DBAPPSEQIDUPDATES TABLE ([DatabaseUniqueID] INT, [DatabaseName] NVARCHAR(128), [DatabaseURN] NVARCHAR(256),[ApplicationID] INT, [ApplicationDatabaseSeqID] INT);
INSERT INTO @DBAPPSEQIDUPDATES (DatabaseUniqueID,DatabaseName,DatabaseURN,[ApplicationID], [ApplicationDatabaseSeqID])
SELECT 
--'ApplicationDatabaseSeqID--NULL Record in DBEP--Should be updated by CTE'
[DBP1].DatabaseUniqueId
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,CAST([DBP2].[ExtendedPropertyValue] AS INT) as ApplicationID
,CAST([DBP1].[ExtendedPropertyValue] AS INT) as ApplicationDatabaseSeqID
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseUniqueId]
	,[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseUniqueId]
	,[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID') as DBP2
ON [DB1].[DatabaseURN] = [DBP2].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is NOT null
and [DBP1].[ExtendedPropertyValue] IS NULL
AND [DB1].[DatabaseUniqueId] NOT IN
	(SELECT DISTINCT DatabaseUniqueId
	 FROM DBO.DatabaseExtendedProperties 
	WHERE [ExtendedPropertyName] = 'ApplicationID'
	AND [ExtendedPropertyValue] IS NULL);


--Update the DBEP for ApplicationIDs for those matching an existing database by name
--Create a table of databases with their assigned application IDs and known application seq IDs
--this is used later to process updates to AppSeqID based upon RANK of the current AppDBSeq and Database Name
DECLARE @DBAPPSEQID TABLE ([DatabaseName] NVARCHAR(128), [ApplicationID] INT, [ApplicationDatabaseSeqID] INT NULL);
INSERT INTO @DBAPPSEQID([DatabaseName],[ApplicationDatabaseSeqID] )
SELECT
[DB1].[DatabaseName]
,CAST([dbp1].[ExtendedPropertyValue] AS INT)
FROM [dbo].[Databases] AS DB1
INNER JOIN
(
SELECT 
[DatabaseUniqueId]
,[ExtendedPropertyName]
,[ExtendedPropertyValue]
FROM [dbo].[DatabaseExtendedProperties] 
WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
AND [ExtendedPropertyValue] IS NOT NULL
) as DBP1
ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
GROUP BY
[DB1].[DatabaseName]
,[ExtendedPropertyValue];

UPDATE @DBAPPSEQID 
SET [ApplicationID] = T2.ApplicationID
FROM @DBAPPSEQID AS T1
INNER JOIN
	(SELECT
	[DB1].[DatabaseName]
	,CAST([ExtendedPropertyValue] as int) as ApplicationID
	FROM [dbo].[Databases] AS DB1
	INNER JOIN 
		(SELECT 
		[DatabaseUniqueId]
		,[ExtendedPropertyValue]
		FROM [dbo].[DatabaseExtendedProperties] 
		WHERE [ExtendedPropertyName] = 'ApplicationID'
		) as DBP1
	ON [DB1].[DatabaseUniqueId] = [DBP1].[DatabaseUniqueId]
	WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
	GROUP BY
	[DB1].[DatabaseName]
	,[ExtendedPropertyValue]) AS T2
ON T1.DatabaseName = T2.DatabaseName;

--Update the @DBAPPSEQIDUPDATES with known Databases' AppSeqIDs. 
UPDATE @DBAPPSEQIDUPDATES
SET [ApplicationDatabaseSeqID] = t2.ApplicationDatabaseSeqID
FROM @DBAPPSEQIDUPDATES AS T1
INNER JOIN @DBAPPSEQID AS T2
ON T1.DatabaseName = t2.DatabaseName
AND T1.ApplicationID = T2.ApplicationID;

--Use the temporary databases with known AppID and both known and yet to be assigned AppSeqID
--By assigning a very high value to NULL (unassigned) AppSeqID, a RANK function partitioned by AppID ordered by AppSeqID and DatabaseName
--should put the databases in the correct order.  Existing databases with assigned AppSeqID will have a Rank order = to previously assigned AppSeqID
--The databases NOT yet assigned AppSeqID are ranked at the upper end of the partition.  Because their rank order is higher than 
--previously assigned AppSeqID, this rank order becomes the AppSeqID to assign to the database.
WITH APPCTE ([DatabaseName],[ApplicationID],[ApplicationDatabaseSeqID],[NewAppSeqID]) --[ApplicationName],
AS
(SELECT
[T1].[DatabaseName]
,[T1].[ApplicationID]
,[T1].[ApplicationDatabaseSeqID]
,RANK () OVER (PARTITION BY [T1].[ApplicationID] ORDER BY [ApplicationDatabaseSeqID] asc, [DATABASENAME] ASC ) AS NewApplicationSequenceID
FROM 
	(SELECT DISTINCT
	DatabaseName,[ApplicationID], ISNULL([ApplicationDatabaseSeqID],999999) AS [ApplicationDatabaseSeqID]
	FROM @DBAPPSEQIDUPDATES 
	UNION
	SELECT DISTINCT
	[DatabaseName], [ApplicationID], [ApplicationDatabaseSeqID]
	FROM @DBAPPSEQID 
	) AS [T1]
)

--Update the temporary AppSeqID update table with these new rankings
UPDATE @DBAPPSEQIDUPDATES
SET [ApplicationDatabaseSeqID] = [t2].[NewAppSeqID]
FROM @DBAPPSEQIDUPDATES AS T1
INNER JOIN APPCTE AS T2
ON T1.DatabaseName = t2.DatabaseName
AND T1.ApplicationID = T2.ApplicationID

--if there are ANY records where the appseqid is NOT null and the 'New' App Seq ID is different than the current value--do not process as there is a mix up in the seq assignments
UPDATE DBO.DatabaseExtendedProperties 
set [ExtendedPropertyValue] = OT1.[ApplicationDatabaseSeqID] 
FROM DBO.DatabaseExtendedProperties AS OT2
INNER JOIN @DBAPPSEQIDUPDATES AS OT1
ON OT2.DatabaseUniqueId = OT1.DatabaseUniqueID
AND OT2.ExtendedPropertyName = 'ApplicationDatabaseSeqID'


--Post task validation
--1) There should not be any database with more than one AppID.  However, must first consolidate DBEP AppID records as a Database (by name) may have multiple values due to Database historical records
SELECT 
[ODB1].DatabaseName
,COUNT([ODB1].[ApplicationID]) AS AppIDCount
FROM
(
SELECT 
[DB1].[DatabaseName]
,[DBP3].[ExtendedPropertyValue] AS ApplicationID
FROM [dbo].[Databases] AS DB1
INNER JOIN
	(SELECT
	[DatabaseUniqueId], [ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties]
	WHERE [ExtendedPropertyName] = 'ApplicationID'
	AND [ExtendedPropertyValue] IS NOT NULL) AS DBP3
ON [DB1].[DatabaseUniqueId] = [DBP3].[DatabaseUniqueId]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
GROUP BY 
[DB1].[DatabaseName]
,[DBP3].[ExtendedPropertyValue]
) AS ODB1
GROUP BY [ODB1].[DatabaseName]
HAVING COUNT([ODB1].[ApplicationID]) > 1


--2) There should not be any database with multiple AppSeqID--if there is there is an error in applying the rank logic
SELECT 
[DB1].[DatabaseName]
,[DBP3].[ExtendedPropertyValue] AS ApplicationID
,COUNT([DBP3].[AppSeqIDAssignedCount]) AS [DatabasesMultipleAppSeqIDsCount]
FROM [dbo].[Databases] AS DB1
INNER JOIN
	(
	SELECT [DBAppID].[DatabaseUniqueId], [DBAppID].[ExtendedPropertyValue],COUNT([DBAppSeqID].[AppSeqID]) AS AppSeqIDAssignedCount
	FROM [dbo].[DatabaseExtendedProperties] AS DBAppID
	INNER JOIN 
		(
		SELECT [DatabaseUniqueId], [ExtendedPropertyValue] AS AppSeqID, COUNT(*) AS AppSeqIDCount
		FROM [dbo].[DatabaseExtendedProperties]
		WHERE [ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
		AND [ExtendedPropertyValue] IS NOT NULL
		GROUP BY [DatabaseUniqueId], [ExtendedPropertyValue]
		) AS DBAppSeqID
	ON [DBAppID].[DatabaseUniqueId] = [DBAppSeqID].[DatabaseUniqueId]
	WHERE [DBAppID].[ExtendedPropertyName] = 'ApplicationID'
	AND [DBAppID].[ExtendedPropertyValue] IS NOT NULL
	GROUP BY [DBAppID].[DatabaseUniqueId], [DBAppID].[ExtendedPropertyValue]
	HAVING COUNT([DBAppSeqID].[AppSeqID])  > 1
	) AS DBP3
ON [DB1].[DatabaseUniqueId] = [DBP3].[DatabaseUniqueId]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
GROUP BY 
[DB1].[DatabaseName]
,[DBP3].[ExtendedPropertyValue]


--Finally, return a table of records that require manual AppID assignment or other issues
SELECT 
1 AS [ChangeType]
,'PostTaskValidation' AS [ProcessStep]
,'ApplicationID' AS [DBEPName]
,'No Record in DBEP' AS [Condition]
,'Manually Add the DBEP with ApplicationID' as [CorrectiveAction]
,[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
,CAST([ExtendedPropertyValue] as int) as EPV
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
	(SELECT 
	[DatabaseURN]
	,[ExtendedPropertyValue]
	FROM [dbo].[DatabaseExtendedProperties] 
	WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
	) as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is null
UNION ALL
SELECT 
1 AS [ChangeType]
,'PostTaskValidation' AS [ProcessStep]
,'ApplicationID' AS [DBEPName]
,'Record in DBEP but NULL' AS [Condition]
,'Manually Update with ApplicationID' as [CorrectiveAction]
,[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
,CAST([ExtendedPropertyValue] as int) as EPV
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
(
SELECT 
[DatabaseURN]
,[ExtendedPropertyValue]
FROM [dbo].[DatabaseExtendedProperties] 
WHERE [ExtendedPropertyName] LIKE 'ApplicationID'
) as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is NOT null
and [DBP1].[ExtendedPropertyValue] is null
UNION ALL
SELECT 
2 AS [ChangeType]
,'PostTaskValidation' AS [ProcessStep]
,'ApplicationDatabaseSeqID' AS [DBEPName]
,'NO Record in DBEP' AS [Condition]
,'Rerun Stored Procedure should add the AppSeqID once AppID is assigned' as [CorrectiveAction]
,[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
,CAST([ExtendedPropertyValue] as int) as EPV
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
(
SELECT 
[DatabaseURN]
,[ExtendedPropertyValue]
FROM [dbo].[DatabaseExtendedProperties] 
WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
) as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is null
UNION ALL
SELECT 
2 AS [ChangeType]
,'PostTaskValidation' AS [ProcessStep]
,'ApplicationDatabaseSeqID' AS [DBEPName]
,'Record in DBEP but NULL' AS [Condition]
,'Rerun Stored Procedure should add the AppSeqID once AppID is assigned' as [CorrectiveAction]
,[DB1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DB1].[DatabaseURN]
,[DB1].[ETLProcessId]
,[DB1].[FirstReportedDate]
,[DB1].[LatestReportedDate]
,CAST([ExtendedPropertyValue] as int) as EPV
FROM [dbo].[Databases] AS DB1
LEFT OUTER JOIN 
(
SELECT 
[DatabaseURN]
,[ExtendedPropertyValue]
FROM [dbo].[DatabaseExtendedProperties] 
WHERE [ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID'
) as DBP1
ON [DB1].[DatabaseURN] = [DBP1].[DatabaseURN]
WHERE [DB1].[DatabaseName] NOT IN (SELECT [DatabaseName] FROM [dbo].[DatabaseExclusions])
AND [DBP1].[DatabaseURN] is NOT null
AND [DBP1].[ExtendedPropertyValue] is NULL

END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_DatabaseExtendedProperties_ins] 
(@servername varchar(128),
@instancename varchar(128),
@applicationname varchar(128),
@databasename varchar(128),
@extendedpropertyname NVARCHAR(128))
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @applicationid int;
	DECLARE @serverinstanceid int;
	DECLARE @appdatabaseid INT;
	DECLARE @databaseuniqueid INT;
	
	--DECLARE error handling variables
	DECLARE @msg VARCHAR(2048)
	DECLARE @currObject VARCHAR(128)
	DECLARE @currprod VARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	--First determine if this is a production service account or a non-production service account
	IF (@servername IS NULL) OR (@instancename IS NULL)
	BEGIN
		SET @currObject = '@servername and/or @instancename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	SELECT @serverinstanceid = ServerInstanceId FROM [dbo].[ServerInstances] AS [SI1] INNER JOIN [dbo].[Servers] AS [S1] ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
	WHERE [SI1].[InstanceName] LIKE @instancename AND [S1].[HostName] LIKE @servername;
	IF (@instancename IS NULL)
		BEGIN
		SET @currObject = '@instancename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - invalid value was passed to the input parameter--no Server instance by the name input found for the server'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	IF (@applicationname IS NULL) OR ((SELECT COUNT(*) FROM [dbo].[Applications] WHERE [ApplicationName] LIKE @applicationname) <> 1)
	BEGIN
		SET @currObject = '@applicationname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	ELSE
	BEGIN
		SELECT @appdatabaseid = [ApplicationID] FROM [dbo].[Applications] WHERE [ApplicationName] LIKE @applicationname
	END
	
	--Next determine if for a server or desktop
	IF NOT EXISTS (SELECT * FROM [dbo].[Databases] AS [DB1] WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename) 
	BEGIN
		SET @currObject = '@databasename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	ELSE
	BEGIN
		SELECT @databaseuniqueid = [databaseuniqueid] FROM [dbo].[Databases] AS [DB1] WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename
	END
	

	--A Unique Index exists on the Extended Properties table made of the databaseuniqueID and ExtendedPropertiesName to prevent the duplication of entries 
	IF NOT EXISTS (SELECT * FROM [dbo].[DatabaseExtendedProperties] AS [DBEP1] WHERE [DBEP1].[DatabaseUniqueId] = @databaseuniqueid AND [DBEP1].[ExtendedPropertyName] = @extendedpropertyname)
	BEGIN
	--Next determine if for a server or desktop
		BEGIN TRANSACTION
			INSERT INTO [dbo].[DatabaseExtendedProperties]
			([DatabaseUniqueId]
			,[DatabaseURN]
			,[ExtendedPropertyName]
			,[ExtendedPropertyValue]
			,[ExtendedPropertyLength]
			,[IsCustomExtendedProperty]
			,[ETLProcessId]
			,[FirstReportedDate]
			,[LatestReportedDate])
			SELECT [DatabaseUniqueId]
			,[DatabaseURN]
			,@extendedpropertyname
			,CAST(@appdatabaseid as nvarchar(10)) 
			,LEN(CAST(@appdatabaseid as nvarchar(10)))
			,1
			,[ETLProcessId]
			,[FirstReportedDate]
			,[LatestReportedDate]
			FROM [dbo].[Databases]
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION
			UPDATE [dbo].[DatabaseExtendedProperties]
			SET [ExtendedPropertyValue] = @appdatabaseid
			WHERE [DatabaseUniqueId] = @databaseuniqueid
			AND [ExtendedPropertyName] = @extendedpropertyname
		COMMIT TRANSACTION
	END

	-- Begin Return Select <- do not remove
	SELECT 
	[DBEP2].[DatabaseExtendedPropertyID]
	,[DBEP2].[DatabaseUniqueId]
	,[DBEP2].[DatabaseURN]
	,[DBEP2].[ExtendedPropertyName]
	,[DBEP2].[ExtendedPropertyValue]
	,[DBEP2].[ExtendedPropertyLength]
	,[DBEP2].[IsCustomExtendedProperty]
	,[DBEP2].[ETLProcessId]
	,[DBEP2].[FirstReportedDate]
	,[DBEP2].[LatestReportedDate]
	FROM [dbo].[DatabaseExtendedProperties] AS [DBEP2]
	WHERE [DatabaseUniqueId] IN
	(SELECT [DB1].[DatabaseUniqueId] 
	FROM [dbo].[Databases] AS [DB1] 
	WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename)
	AND [DBEP2].[ExtendedPropertyName] = @extendedpropertyname
	AND [DBEP2].DatabaseUniqueId = @databaseuniqueid
	-- End Return Select <- do not remove
	
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_ReassignApplicationID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_DatabaseExtendedProperties_ReassignApplicationID]
(
@dbtochange varchar(128)
,@oldapplicationname varchar(128)
,@newapplicationname varchar(128)
)
AS
BEGIN
DECLARE @oldapplicationid INT
DECLARE @newapplicationid INT

--DECLARE error handling variables
DECLARE @msg VARCHAR(2048)
DECLARE @currObject VARCHAR(128)
DECLARE @currprod VARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)

IF EXISTS (SELECT TOP 1 * FROM [dbo].[Applications] WHERE [ApplicationName] = @oldapplicationname)
BEGIN
	SELECT @oldapplicationid = [ApplicationID] FROM [dbo].[Applications] WHERE [ApplicationName] = @oldapplicationname
END
ELSE
BEGIN
	SET @currObject = '@oldapplicationid'
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	THROW 60000 , @msg, 1 
END

IF EXISTS (SELECT TOP 1 * FROM [dbo].[Applications] WHERE [ApplicationName] = @oldapplicationname)
BEGIN
	SELECT @newapplicationid = [ApplicationID] FROM [dbo].[Applications] WHERE [ApplicationName] = @newapplicationname
END
ELSE
BEGIN
	SET @currObject = '@newapplicationid'
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
	THROW 60000 , @msg, 1 
END
;

--ApplicationDatabaseSeqIDs include deleted/retired databases so cannot use database inventory view as basis
SELECT 
[DB1].[DatabaseUniqueId]
,[DB1].[ServerInstanceID]
,[S1].[ServerSystemID]
,[S1].[HostName]
,[DB1].[DatabaseName]
,[DBEP1].[ApplicationId]
,[DBEP2].[ApplicationDatabaseSeqID]
,[DBEP1].[ApplicationName] 
FROM [dbo].[Databases] AS DB1
INNER JOIN [dbo].[ServerInstances] AS SI1
ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
INNER JOIN [dbo].[Servers] AS S1
ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
INNER JOIN (
SELECT [DatabaseUniqueId]
,[ExtendedPropertyValue] AS [ApplicationID]
,[IAPPS1].[ApplicationName]
FROM [dbo].[DatabaseExtendedProperties] AS IDBEP1
LEFT OUTER JOIN [dbo].[Applications] AS IAPPS1
ON [IDBEP1].[ExtendedPropertyValue] = CAST([IAPPS1].[ApplicationId] AS VARCHAR(4000))
WHERE [ExtendedPropertyName] = 'ApplicationID'
AND [ExtendedPropertyValue] = @oldapplicationid
) AS DBEP1
ON [DB1].[DatabaseUniqueId] = [DBEP1].[DatabaseUniqueId]
INNER JOIN (
SELECT [DatabaseUniqueId]
,[ExtendedPropertyValue] AS [ApplicationDatabaseSeqID]
FROM [dbo].[DatabaseExtendedProperties]
WHERE [ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
) AS DBEP2
ON [DB1].[DatabaseUniqueId] = [DBEP2].[DatabaseUniqueId]
ORDER BY 
[DBEP1].[ApplicationId]
,CAST([DBEP2].[ApplicationDatabaseSeqID] AS INT)
,[DB1].[DatabaseName]
,[S1].[HostName]


BEGIN TRY

BEGIN TRANSACTION AppIDChange
UPDATE [dbo].[DatabaseExtendedProperties]
SET [ExtendedPropertyValue] = @newapplicationid
from dbo.DatabaseExtendedProperties AS DBEP1
inner join [dbo].[databases] as DB1
on [DB1].[DatabaseUniqueId] = [DBEP1].[DatabaseUniqueId]
WHERE [DBEP1].[ExtendedPropertyName] = 'ApplicationID'
AND cast([DBEP1].[ExtendedPropertyValue] as int) = @oldapplicationid
AND [DB1].[DatabaseName] = @dbtochange

	
	UPDATE [dbo].[DatabaseExtendedProperties]
	SET [ExtendedPropertyValue] = NULL
	from dbo.DatabaseExtendedProperties AS DBEP1
	inner join [dbo].[databases] as DB1
	on [DB1].[DatabaseUniqueId] = [DBEP1].[DatabaseUniqueId]
	WHERE [DBEP1].[ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
	AND [DB1].[DatabaseName] = @dbtochange

COMMIT TRANSACTION AppIDChange

BEGIN TRANSACTION AppSeqIDReassign
	EXECUTE [dbo].[usp_DatabaseExtendedProperties_AssignAppSeqIDs] 
COMMIT TRANSACTION AppSeqIDReassign


SELECT 
[DB1].[DatabaseUniqueId]
,[DB1].[ServerInstanceID]
,[S1].[ServerSystemID]
,[S1].[HostName]
,[DB1].[DatabaseName]
,[DBEP1].[ApplicationId]
,[DBEP2].[ApplicationDatabaseSeqID]
,[DBEP1].[ApplicationName] 
FROM [dbo].[Databases] AS DB1
INNER JOIN [dbo].[ServerInstances] AS SI1
ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
INNER JOIN [dbo].[Servers] AS S1
ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
INNER JOIN (
SELECT [DatabaseUniqueId]
,[ExtendedPropertyValue] AS [ApplicationID]
,[IAPPS1].[ApplicationName]
FROM [dbo].[DatabaseExtendedProperties] AS IDBEP1
LEFT OUTER JOIN [dbo].[Applications] AS IAPPS1
ON [IDBEP1].[ExtendedPropertyValue] = CAST([IAPPS1].[ApplicationId] AS VARCHAR(4000))
WHERE [ExtendedPropertyName] = 'ApplicationID'
AND [ExtendedPropertyValue] = @newapplicationid
) AS DBEP1
ON [DB1].[DatabaseUniqueId] = [DBEP1].[DatabaseUniqueId]
INNER JOIN (
SELECT [DatabaseUniqueId]
,[ExtendedPropertyValue] AS [ApplicationDatabaseSeqID]
FROM [dbo].[DatabaseExtendedProperties]
WHERE [ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
) AS DBEP2
ON [DB1].[DatabaseUniqueId] = [DBEP2].[DatabaseUniqueId]
ORDER BY 
[DBEP1].[ApplicationId]
,CAST([DBEP2].[ApplicationDatabaseSeqID] AS INT)
,[DB1].[DatabaseName]
,[S1].[HostName]


END TRY


BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseExtendedProperties_upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_DatabaseExtendedProperties_upd] 
(@servername varchar(128),
@instancename varchar(128),
@applicationname varchar(128),
@databasename varchar(128),
@extendedpropertyname NVARCHAR(128))
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @applicationid int;
	DECLARE @serverinstanceid int;
	DECLARE @appdatabaseid INT;
	DECLARE @databaseuniqueid INT;
	
	--DECLARE error handling variables
	DECLARE @msg VARCHAR(2048)
	DECLARE @currObject VARCHAR(128)
	DECLARE @currprod VARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	--First determine if this is a production service account or a non-production service account
	IF (@servername IS NULL) OR (@instancename IS NULL)
	BEGIN
		SET @currObject = '@servername and/or @instancename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	SELECT @serverinstanceid = ServerInstanceId FROM [dbo].[ServerInstances] AS [SI1] INNER JOIN [dbo].[Servers] AS [S1] ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
	WHERE [SI1].[InstanceName] LIKE @instancename AND [S1].[HostName] LIKE @servername;
	IF (@instancename IS NULL)
		BEGIN
		SET @currObject = '@instancename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - invalid value was passed to the input parameter--no Server instance by the name input found for the server'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	IF (@applicationname IS NULL) OR ((SELECT COUNT(*) FROM [dbo].[Applications] WHERE [ApplicationName] LIKE @applicationname) <> 1)
	BEGIN
		SET @currObject = '@applicationname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	ELSE
	BEGIN
		SELECT @appdatabaseid = [ApplicationID] FROM [dbo].[Applications] WHERE [ApplicationName] LIKE @applicationname
	END
	
	--Next determine if for a server or desktop
	IF NOT EXISTS (SELECT * FROM [dbo].[Databases] AS [DB1] WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename) 
	BEGIN
		SET @currObject = '@databasename'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	ELSE
	BEGIN
		SELECT @databaseuniqueid = [databaseuniqueid] FROM [dbo].[Databases] AS [DB1] WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename
	END
	

	--A Unique Index exists on the Extended Properties table made of the databaseuniqueID and ExtendedPropertiesName to prevent the duplication of entries 
	IF NOT EXISTS (SELECT * FROM [dbo].[DatabaseExtendedProperties] AS [DBEP1] WHERE [DBEP1].[DatabaseUniqueId] = @databaseuniqueid AND [DBEP1].[ExtendedPropertyName] = @extendedpropertyname)
	BEGIN
	--Next determine if for a server or desktop
		BEGIN TRANSACTION
			INSERT INTO [dbo].[DatabaseExtendedProperties]
			([DatabaseUniqueId]
			,[DatabaseURN]
			,[ExtendedPropertyName]
			,[ExtendedPropertyValue]
			,[ExtendedPropertyLength]
			,[IsCustomExtendedProperty]
			,[ETLProcessId]
			,[FirstReportedDate]
			,[LatestReportedDate])
			SELECT [DatabaseUniqueId]
			,[DatabaseURN]
			,@extendedpropertyname
			,CAST(@appdatabaseid as nvarchar(10)) 
			,LEN(CAST(@appdatabaseid as nvarchar(10)))
			,1
			,[ETLProcessId]
			,[FirstReportedDate]
			,[LatestReportedDate]
			FROM [dbo].[Databases]
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION
			UPDATE [dbo].[DatabaseExtendedProperties]
			SET [ExtendedPropertyValue] = @appdatabaseid
			WHERE [DatabaseUniqueId] = @databaseuniqueid
			AND [ExtendedPropertyName] = @extendedpropertyname
		COMMIT TRANSACTION
	END

	-- Begin Return Select <- do not remove
	SELECT 
	[DBEP2].[DatabaseExtendedPropertyID]
	,[DBEP2].[DatabaseUniqueId]
	,[DBEP2].[DatabaseURN]
	,[DBEP2].[ExtendedPropertyName]
	,[DBEP2].[ExtendedPropertyValue]
	,[DBEP2].[ExtendedPropertyLength]
	,[DBEP2].[IsCustomExtendedProperty]
	,[DBEP2].[ETLProcessId]
	,[DBEP2].[FirstReportedDate]
	,[DBEP2].[LatestReportedDate]
	FROM [dbo].[DatabaseExtendedProperties] AS [DBEP2]
	WHERE [DatabaseUniqueId] IN
	(SELECT [DB1].[DatabaseUniqueId] 
	FROM [dbo].[Databases] AS [DB1] 
	WHERE [DB1].[ServerInstanceId] = @serverinstanceid AND [DatabaseName] LIKE @databasename)
	AND [DBEP2].[ExtendedPropertyName] = @extendedpropertyname
	AND [DBEP2].DatabaseUniqueId = @databaseuniqueid
	-- End Return Select <- do not remove
	
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseFiles_AverageGrowthByDateRange]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_DatabaseFiles_AverageGrowthByDateRange]
(@pfirstdate DATE
,@pcalendarbasis NVARCHAR(10)
,@pincludesystemdbs BIT = 0
,@pDatabaseName NVARCHAR(4000)
)
/*
-- description: query to return the changes in disk history by server and disk over time.  
want to allow user to input how they want the history 
There are three aspects on displaying history
--the date range -- default values -- from today to 90 days prior
--the date part to segment history into (days, weeks, months)--default values days
--the date part of each segment for the reporting period--default value (day of the week, day of the month)
--user should be able to put in a historical date (or number of days to look back) to limit the history
--user should be able to input values to define how the history is compared by most granular to least granular(each day) day of the week (can put it in for every friday or every monday),  day of the month

-- inputs

*/

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
DECLARE @datevalmetric INT
DECLARE @ddef TABLE (datevalmetric int, datestring NVARCHAR(10))
INSERT INTO @ddef
values (1,'day')
INSERT INTO @ddef
values (7,'week')
INSERT INTO @ddef
values(30,'month')
INSERT INTO @ddef
values(360,'year');
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
SET @currObject = '@pcalendarbasis'
IF NOT EXISTS (SELECT * FROM @ddef WHERE datestring = @pcalendarbasis)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pcalendarbasis);
		THROW 60000 , @msg, 1 
	END;

SET @currObject = '@pfirstdate'
IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;
	
SET @currObject = '@pDatabaseName'
IF (@pDatabaseName IS NULL OR LEN(@pDatabaseName) < 1)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. A valid database name is required.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

SELECT @datevalmetric = datevalmetric 
FROM @ddef
WHERE datestring = @pcalendarbasis

IF @pcalendarbasis = 'month'
BEGIN
PRINT 'Using EOMONTH system function'
END

IF @pcalendarbasis = 'week'
BEGIN
PRINT 'Using DatePart is where condition'
END

IF @pcalendarbasis = 'year'
BEGIN
PRINT 'Using get annual report'
END

	DECLARE @DatabaseUniqueIDs TABLE (pDatabaseUniqueID INT)
	BEGIN
		INSERT INTO @DatabaseUniqueIDs
		SELECT DISTINCT [DatabaseUniqueID]
		FROM [dbo].[vw_Databases]
		WHERE [DatabaseName] LIKE @pDatabaseName
	END

	IF (SELECT COUNT(*) FROM @DatabaseUniqueIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No database names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tDatabaseFilesGrowth' AND [type] = 'U')
BEGIN
--DROP TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]
TRUNCATE TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]
END
ELSE
BEGIN
CREATE TABLE [tempdb].[dbo].[tDatabaseFilesGrowth] (
[File_Rank] INT NOT NULL,
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[LatestReportedDate] [DATE] NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[SizeDiff] [float] NULL
)
END

INSERT INTO [tempdb].[dbo].[tDatabaseFilesGrowth]
           ([File_Rank]
           ,[ServerInstanceId]
           ,[DatabaseName]
           ,[DatabaseFileID]
           ,[FileID]
           ,[FileType]
           ,[DriveLetter]
           ,[db_File_Name]
           ,[db_File_Path]
           ,[LatestReportedDate]
           ,[IsPrimaryFileInd]
           ,[Size]
           ,[SizeDiff])
EXEC	[dbo].[usp_DatabaseFiles_GrowthByDateRange] @pfirstdate,@pcalendarbasis,@pincludesystemdbs,@pDatabaseName;

--for the average, the latest file will not have any difference and the 'difference' column values will be 0.
--including these values in the calcuations for average may skew the results downward.
WITH CurrentDBFileLocs ([ServerInstanceId],[DriveLetter],[ETLProcessID],[db_file_name])
AS
(SELECT
[DB1].[ServerInstanceId]
,SUBSTRING([DBF1].[FileFullName],1,1) AS DriveLetter
,[DBF1].[ETLProcessID]
,[T2].db_file_name
FROM [dbo].[vw_DatabaseFiles] as DBF1
inner join [dbo].[vw_Databases] as DB1
ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueID]
CROSS APPLY [dbo].[ufn_ParseSQLFileName]([DBF1].[FileFullName]) AS T2
INNER JOIN @DatabaseUniqueIDs AS pDBIDS
ON [DB1].DatabaseUniqueId = pDBIDS.pDatabaseUniqueID
INNER JOIN 
(
SELECT 
[DatabaseUniqueID]
,MAX(ETLProcessID) AS MRETLID
FROM [dbo].[vw_DatabaseFiles]
GROUP BY [DatabaseUniqueID]
) AS T5
ON [DBF1].[DatabaseUniqueID] = [T5].[DatabaseUniqueID]
AND [DBF1].[ETLProcessID] = [T5].[MRETLID]
)

SELECT 
[T1].[ServerInstanceId]
,[T1].[DatabaseName]
,[T1].[FileType]
,[T1].[db_File_Name]
,[T6].DriveLetter
,COUNT([T1].[File_Rank]) AS FilesUsedInCount
,MAX([T1].[SizeDiff]) AS MaxChangeInSize
,MIN([T1].[SizeDiff]) AS MinChangeInSize
,CAST(ROUND(AVG([T1].[SizeDiff]),0) AS bigint) AS AvgChangeInSize
FROM [tempdb].[dbo].[tDatabaseFilesGrowth] AS T1
LEFT OUTER JOIN
(SELECT
[ServerInstanceId]
,[DatabaseName]
,[FileType]
,[db_File_Name]
,MAX([File_Rank]) AS [HighestFileRank]
FROM [tempdb].[dbo].[tDatabaseFilesGrowth]
GROUP BY
[ServerInstanceId]
,[DatabaseName]
,[FileType]
,[db_File_Name]) AS T2
ON 
[T1].[File_Rank] = [T2].[HighestFileRank]
AND [T1].[ServerInstanceId] = [T2].[ServerInstanceId]
AND [T1].[DatabaseName] = [T2].[DatabaseName]
AND [T1].[FileType] = [T2].[FileType]
AND [T1].[db_File_Name] = [T2].[db_File_Name]
LEFT OUTER JOIN CurrentDBFileLocs AS T6
ON [T1].[ServerInstanceId] = [T6].ServerInstanceId
AND [T1].db_File_Name = [T6].db_file_name
WHERE [T2].[HighestFileRank] IS NULL
GROUP BY 
[T1].[ServerInstanceId]
,[T1].[DatabaseName]
,[T1].[FileType]
,[T1].[db_File_Name]
,[T6].[DriveLetter]
ORDER BY [T6].[DriveLetter],[T1].[db_File_Name]

--DROP TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]

END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseFiles_CurrentFiles]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_DatabaseFiles_CurrentFiles]
(@pDiskMetric VARCHAR(5)
,@pServerHostName NVARCHAR(128)
,@pInstanceName NVARCHAR(128)
,@pDatabaseName NVARCHAR(4000)
)
/*
-- description: query to return current database files
-- inputs
@pDiskMetric -- to display file sizes in different metrics -- the values for database files (size, used space)
are stored in KB.  the appropriate divisor of 1024 raised to the corresponding POWER is used to display the requested metric
*/

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	DECLARE @diskvalmetric INT
	DECLARE @ddef TABLE (diskvaldivisor int, DiskMetric VARCHAR(5))
	INSERT INTO @ddef
	values (-1,'BYTES')
	INSERT INTO @ddef
	values (0,'KB')
	INSERT INTO @ddef
	values (1,'MB')
	INSERT INTO @ddef
	values(2,'GB')

	SET @currObject = '@pDiskMetric'
	IF NOT EXISTS (SELECT * FROM @ddef WHERE DiskMetric = @pDiskMetric)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either BYTES, KB, MB or GB'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDiskMetric);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @diskvaldivisor DECIMAL(18,3)
	SELECT @diskvaldivisor = POWER(1024,diskvaldivisor) FROM @ddef
	WHERE DiskMetric = @pDiskMetric

	PRINT (N'Disk space shown in ' + @pDiskMetric + CAST(@diskvaldivisor AS VARCHAR(19)))
	
	IF @pServerHostName IS NULL
	BEGIN
		SET @pServerHostName = '%'
	END
	
	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	INSERT INTO @ServerSystemIDs
	SELECT DISTINCT [ServerSystemID]
	FROM [dbo].[vw_Servers]
	WHERE [HostName] LIKE @pServerHostName
	
	IF (SELECT COUNT(*) FROM @ServerSystemIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No host names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pServerHostName);
		THROW 60000 , @msg, 1 
	END;

	IF @pInstanceName IS NULL
	BEGIN
		SET @pInstanceName = '%'
	END
	
	DECLARE @ServerInstanceIDs TABLE (pServerInstanceIDs INT)
	INSERT INTO @ServerInstanceIDs 
	SELECT DISTINCT [ServerInstanceID] 
	FROM [dbo].[vw_ServerInstances] AS T1
	INNER JOIN @ServerSystemIDs AS T2
	ON [T1].[ServerSystemID] = [t2].[pServerSystemID]
	WHERE [T1].[InstanceName] LIKE @pInstanceName
		
	IF (SELECT COUNT(*) FROM @ServerInstanceIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No host names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pInstanceName);
		THROW 60000 , @msg, 1 
	END;
	

	IF @pDatabaseName IS NULL
	BEGIN
		SET @pDatabaseName = '%'
	END

	DECLARE @DatabaseUniqueIDs TABLE (pDatabaseUniqueID INT,pServerInstanceID INT)
	BEGIN
		INSERT INTO @DatabaseUniqueIDs
		SELECT DISTINCT [DatabaseUniqueID],[ServerinstanceID]
		FROM [dbo].[vw_Databases] AS T1
		INNER JOIN @ServerInstanceIDs AS T2
		ON [T1].[ServerInstanceId] = [T2].[pServerInstanceIDs]
		WHERE [DatabaseName] LIKE @pDatabaseName
	END

	IF (SELECT COUNT(*) FROM @DatabaseUniqueIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No database names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;
	
	SELECT 
	[S1].[HostName]
	,[SI1].[InstanceName]
	,[DB1].[DatabaseName]
	,[DBF1].[DatabaseFileID]
	,[DBF1].[DatabaseUniqueID]
	,[DBF1].[FileID]
	,[DBF1].[FileGroupName]
	,[DBF1].[FileType]
	,SUBSTRING([DBF1].[FileFullName],1,2) AS [DiskID]
	,[DBF1].[FileFullName]
	,[DBF1].[FileLogicalName]
	,[DBF1].[Growth]
	,[DBF1].[GrowthType]
	,[DBF1].[IsPrimaryFileInd]
	,[DBF1].[LatestReportedDate]
	,CAST(CAST([DBF1].[Size] AS decimal(18,2))/@diskvaldivisor AS DECIMAL(18,2)) AS DiskSize
	,CAST(CAST(([DBF1].[Size] - [DBF1].[UsedSpace]) AS decimal(18,2))/@diskvaldivisor AS DECIMAL(18,2)) AS FreeSpace
	,CAST(CAST([DBF1].[UsedSpace] AS decimal(18,2)) /@diskvaldivisor AS DECIMAL(18,2)) AS UsedSpace
	FROM [dbo].[DatabaseFiles] AS [DBF1]
	INNER JOIN [dbo].[Databases] AS [DB1]
	ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueId]
	INNER JOIN [dbo].[ServerInstances] AS [SI1]
	ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
	INNER JOIN [dbo].[Servers] AS [S1]
	ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
	INNER JOIN @DatabaseUniqueIDs AS tDBID
	ON [DBF1].[DatabaseUniqueID] = [tDBID].[pDatabaseUniqueID]
	WHERE [DBF1].[ETLProcessId] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses])
	ORDER BY 
	[S1].[HostName]
	,[SI1].[InstanceName]
	,[DB1].[DatabaseName];


END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseFiles_GrowthByDateRange]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_DatabaseFiles_GrowthByDateRange]
(@pfirstdate DATE
,@pcalendarbasis NVARCHAR(10)
,@pincludesystemdbs BIT = 0
,@pDatabaseName NVARCHAR(4000)
)
/*
-- description: query to return the changes in disk history by server and disk over time.  
want to allow user to input how they want the history 
There are three aspects on displaying history
--the date range -- default values -- from today to 90 days prior
--the date part to segment history into (days, weeks, months)--default values days
--the date part of each segment for the reporting period--default value (day of the week, day of the month)
--user should be able to put in a historical date (or number of days to look back) to limit the history
--user should be able to input values to define how the history is compared by most granular to least granular(each day) day of the week (can put it in for every friday or every monday),  day of the month

-- inputs

*/

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
DECLARE @datevalmetric INT
DECLARE @ddef TABLE (datevalmetric int, datestring NVARCHAR(10))
INSERT INTO @ddef
values (1,'day')
INSERT INTO @ddef
values (7,'week')
INSERT INTO @ddef
values(30,'month')
INSERT INTO @ddef
values(360,'year');
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
SET @currObject = '@pcalendarbasis'
IF NOT EXISTS (SELECT * FROM @ddef WHERE datestring = @pcalendarbasis)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either day, week, month or year'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pcalendarbasis);
		THROW 60000 , @msg, 1 
	END;

SET @currObject = '@pfirstdate'
IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;
	
SET @currObject = '@pDatabaseName'
IF (@pDatabaseName IS NULL OR LEN(@pDatabaseName) < 1)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. A valid database name is required.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

SELECT @datevalmetric = datevalmetric 
FROM @ddef
WHERE datestring = @pcalendarbasis

IF @pcalendarbasis = 'month'
BEGIN
PRINT 'Using EOMONTH system function'
END

IF @pcalendarbasis = 'week'
BEGIN
PRINT 'Using DatePart is where condition'
END

IF @pcalendarbasis = 'year'
BEGIN
PRINT 'Using get annual report'
END

	DECLARE @DatabaseUniqueIDs TABLE (pDatabaseUniqueID INT)
	BEGIN
		INSERT INTO @DatabaseUniqueIDs
		SELECT DISTINCT [DatabaseUniqueID]
		FROM [dbo].[vw_Databases]
		WHERE [DatabaseName] LIKE @pDatabaseName
	END

	IF (SELECT COUNT(*) FROM @DatabaseUniqueIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No database names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tDatabaseFiles' AND [type] = 'U')
BEGIN
--TRUNCATE TABLE [tempdb].[dbo].[tDatabaseFiles]
DROP TABLE [tempdb].[dbo].[tDatabaseFiles]
END
--ELSE
--BEGIN
CREATE TABLE [tempdb].[dbo].[tDatabaseFiles](
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[ETLProcessID] [int] NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[LatestReportedDate] [date] NOT NULL,
[IncludeInRankTableInd] BIT NULL,
[DateValMetric] INT NULL)

CREATE NONCLUSTERED INDEX [IX_tDatabaseFiles_01] ON [tempdb].[dbo].[tDatabaseFiles]
(
	[ServerInstanceId] ASC,
	[DatabaseName] ASC,
	[db_File_Name] ASC
)
INCLUDE ( 	[LatestReportedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--END
INSERT INTO [tempdb].[dbo].[tDatabaseFiles] ([ServerInstanceId],[DatabaseName],[DatabaseFileID],[ETLProcessID],[FileID],[FileType],[DriveLetter],[db_File_Name],[db_File_Path],
[IsPrimaryFileInd],[Size],[LatestReportedDate],[IncludeInRankTableInd],[DateValMetric])
(
SELECT
[DB1].[ServerInstanceId]
,[DB1].[DatabaseName],
[DBF1].[DatabaseFileID],
[DBF1].[ETLProcessID]
,[DBF1].[FileID]
,[DBF1].[FileType]
,SUBSTRING([DBF1].[FileFullName],1,1) AS DriveLetter
,[T2].db_file_name
,[T2].db_file_path
,[DBF1].[IsPrimaryFileInd]
,[DBF1].[Size]
,[DBF1].[LatestReportedDate]
,CASE @datevalmetric 
WHEN 1 THEN 1
WHEN 7 THEN 
	CASE WHEN DATEPART(WEEKDAY,[DBF1].[LatestReportedDate]) = DATEPART(WEEKDAY,GETDATE()) THEN 1 ELSE 0 END  --gets file space on a week basis
WHEN 30 THEN 
	CASE WHEN DATEDIFF(DAY,[DBF1].[LatestReportedDate],GETDATE()) = 0 THEN 1 ELSE  [dbo].[ufn_IsEOMonthInd]([DBF1].[LatestReportedDate]) END
WHEN 360 THEN 
	CASE WHEN DATEDIFF(DAY,[DBF1].[LatestReportedDate],GETDATE()) = 0 THEN 1 ELSE [dbo].[ufn_IsAnnualMonthInd]([DBF1].[LatestReportedDate]) END
ELSE 0 END
,@datevalmetric
FROM [dbo].[vw_Databases] as DB1
inner join 
	(SELECT 
	[DatabaseUniqueID] 
	,[DatabaseFileID]
	,[ETLProcessID]
	,[FileID]
	,[FileType]
	,[FileFullName]
	,[IsPrimaryFileInd]
	,[Size]
	,[LatestReportedDate]
	FROM [dbo].[vw_DatabaseFiles]
	WHERE LEN(filefullname) > 0) AS [DBF1]
ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueID]
CROSS APPLY [dbo].[ufn_ParseSQLFileName]([DBF1].[FileFullName]) AS T2
INNER JOIN @DatabaseUniqueIDs AS pDBIDS
ON [DB1].DatabaseUniqueId = pDBIDS.pDatabaseUniqueID
WHERE [DB1].[SystemObjectInd] <= @pincludesystemdbs
AND [DBF1].[LatestReportedDate] >= @pfirstdate
)

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tRankedDatabaseFiles' AND [type] = 'U')
BEGIN
--TRUNCATE TABLE [tempdb].[dbo].[tRankedDatabaseFiles]
DROP TABLE [tempdb].[dbo].[tRankedDatabaseFiles]
END
--ELSE
--BEGIN
CREATE TABLE [tempdb].[dbo].[tRankedDatabaseFiles] (
[File_Rank] INT NOT NULL,
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[ETLProcessID] [int] NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[LatestReportedDate] [date] NOT NULL)
--END

--Add an index to assist in ranking comparison
CREATE NONCLUSTERED INDEX [IX_tRankedDatabaseFiles_01] ON [tempdb].[dbo].[tRankedDatabaseFiles]
(
	[ServerInstanceId] ASC,
	[DatabaseName] ASC,
	[db_File_Name] ASC,
	[File_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


INSERT INTO [tempdb].[dbo].[tRankedDatabaseFiles] ([File_Rank], [ServerInstanceId], [DatabaseName], [DatabaseFileID], [ETLProcessID], [FileID], [FileType], [DriveLetter], [db_File_Name], [db_File_Path], [IsPrimaryFileInd], [Size], [LatestReportedDate])
(
SELECT
RANK () OVER (PARTITION BY [TT1].[ServerInstanceId],[TT1].[DatabaseName],[TT1].[db_file_name] ORDER BY [TT1].[LatestReportedDate] DESC) AS file_rank,
[TT1].[ServerInstanceId]
,[TT1].[DatabaseName]
,[TT1].[DatabaseFileID]
,[TT1].[ETLProcessID]
,[TT1].[FileID]
,[TT1].[FileType]
,[TT1].[DriveLetter]
,[TT1].[db_file_name]
,[TT1].[db_file_path]
,[TT1].[IsPrimaryFileInd]
,[TT1].[Size]
,[TT1].[LatestReportedDate]
FROM [tempdb].[dbo].[tDatabaseFiles] as [TT1]
WHERE [TT1].[IncludeInRankTableInd] = 1
)

SELECT
[LT1].[File_Rank]
,[LT1].[ServerInstanceId]
,[LT1].[DatabaseName]
,[LT1].[DatabaseFileID]
,[LT1].[FileID]
,[LT1].[FileType]
,[LT1].[DriveLetter]
,[LT1].[db_file_name]
,[LT1].[db_file_path]
,[LT1].[LatestReportedDate]
,[LT1].[IsPrimaryFileInd]
,[LT1].[Size] AS [Size]
,[LT1].[Size] - COALESCE([RT1].[Size],[LT1].[Size]) as SizeChange
from [tempdb].[dbo].[tRankedDatabaseFiles]  as LT1
LEFT OUTER JOIN [tempdb].[dbo].[tRankedDatabaseFiles]  as RT1
ON [LT1].[ServerInstanceId] = [RT1].[ServerInstanceId]
AND [LT1].[DatabaseName] = [RT1].[DatabaseName]
AND [LT1].[db_file_name] = [RT1].[db_file_name]
AND [LT1].[file_rank] + 1 = [RT1].[file_rank]
order by 
[LT1].[ServerInstanceId]
,[LT1].[DatabaseName]
,[LT1].[db_file_name]
,[LT1].[file_rank] desc;


DROP TABLE [tempdb].[dbo].[tDatabaseFiles] 
DROP TABLE [tempdb].[dbo].[tRankedDatabaseFiles] 
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseFiles_GrowthByDateRangeKB]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_DatabaseFiles_GrowthByDateRangeKB]
(@pfirstdate DATE
,@pcalendarbasis NVARCHAR(10)
,@pincludesystemdbs BIT = 0
,@pHostName NVARCHAR(128)
,@pDatabaseName NVARCHAR(4000)
,@pShowFilesByRanking BIT = 1
)
/*
-- description: query to return the changes in disk history by server and disk over time.  
want to allow user to input how they want the history 
There are three aspects on displaying history
--the date range -- default values -- from today to 90 days prior
--the date part to segment history into (days, weeks, months)--default values days
--the date part of each segment for the reporting period--default value (day of the week, day of the month)
--user should be able to put in a historical date (or number of days to look back) to limit the history
--user should be able to input values to define how the history is compared by most granular to least granular(each day) day of the week (can put it in for every friday or every monday),  day of the month

-- inputs

*/

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
DECLARE @datevalmetric INT
DECLARE @ddef TABLE (datevalmetric int, datestring NVARCHAR(10))
INSERT INTO @ddef
values (1,'day')
INSERT INTO @ddef
values (7,'week')
INSERT INTO @ddef
values(30,'month')
INSERT INTO @ddef
values(360,'year');
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
SET @currObject = '@pcalendarbasis'
IF NOT EXISTS (SELECT * FROM @ddef WHERE datestring = @pcalendarbasis)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either day, week, month or year'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pcalendarbasis);
		THROW 60000 , @msg, 1 
	END;

SET @currObject = '@pfirstdate'
IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;
	
SET @currObject = '@pDatabaseName'
IF (@pDatabaseName IS NULL OR LEN(@pDatabaseName) < 1)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. A valid database name is required.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

SELECT @datevalmetric = datevalmetric 
FROM @ddef
WHERE datestring = @pcalendarbasis

IF @pcalendarbasis = 'month'
BEGIN
PRINT 'Using EOMONTH system function'
END

IF @pcalendarbasis = 'week'
BEGIN
PRINT 'Using DatePart is where condition'
END

IF @pcalendarbasis = 'year'
BEGIN
PRINT 'Using get annual report'
END

	DECLARE @DatabaseUniqueIDs TABLE (pDatabaseUniqueID INT,pDatabaseName nvarchar(128))
	BEGIN
		INSERT INTO @DatabaseUniqueIDs
		SELECT DISTINCT [DatabaseUniqueID],[Databasename]
		FROM [dbo].[vw_Databases] AS [DB1]
		INNER JOIN [dbo].[vw_ServerInstances] AS [SI1]
		ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceID]
		INNER JOIN [dbo].[vw_Servers] AS [S1]
		ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
		WHERE [DatabaseName] LIKE @pDatabaseName
		AND [S1].[HostName] LIKE @pHostName
	END

	IF (SELECT COUNT(*) FROM @DatabaseUniqueIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No database names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tDatabaseFiles' AND [type] = 'U')
BEGIN
	DROP TABLE [tempdb].[dbo].[tDatabaseFiles]
END

CREATE TABLE [tempdb].[dbo].[tDatabaseFiles](
[ServerInstanceId] [int] NOT NULL,
[DatabaseUniqueId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[ETLProcessID] [int] NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[LatestReportedDate] [date] NOT NULL,
[IncludeInRankTableInd] BIT NULL,
[DateValMetric] INT NULL)

CREATE NONCLUSTERED INDEX [IX_tDatabaseFiles_01] ON [tempdb].[dbo].[tDatabaseFiles]
(
	[ServerInstanceId] ASC,
	[DatabaseName] ASC,
	[db_File_Name] ASC
)
INCLUDE ( 	[LatestReportedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

INSERT INTO [tempdb].[dbo].[tDatabaseFiles] ([ServerInstanceId],[DatabaseUniqueId],[DatabaseName],[DatabaseFileID],[ETLProcessID],[FileID],[FileType],[DriveLetter],[db_File_Name],[db_File_Path],
[IsPrimaryFileInd],[Size],[LatestReportedDate],[IncludeInRankTableInd],[DateValMetric])
(
SELECT
[DB1].[ServerInstanceId]
,[db1].[DatabaseUniqueId]
,[DB1].[DatabaseName]
,[DBF1].[DatabaseFileID]
,[DBF1].[ETLProcessID]
,[DBF1].[FileID]
,[DBF1].[FileType]
,SUBSTRING([DBF1].[FileFullName],1,1) AS DriveLetter
,[T2].db_file_name
,[T2].db_file_path
,[DBF1].[IsPrimaryFileInd]
,[DBF1].[Size]
,[DBF1].[LatestReportedDate]
,CASE @datevalmetric 
WHEN 1 THEN 1
WHEN 7 THEN 
	CASE WHEN DATEPART(WEEKDAY,[DBF1].[LatestReportedDate]) = DATEPART(WEEKDAY,GETDATE()) THEN 1 ELSE 0 END  --gets file space on a week basis
WHEN 30 THEN 
	CASE WHEN DATEDIFF(DAY,[DBF1].[LatestReportedDate],GETDATE()) = 0 THEN 1 ELSE  [dbo].[ufn_IsEOMonthInd]([DBF1].[LatestReportedDate]) END
WHEN 360 THEN 
	CASE WHEN DATEDIFF(DAY,[DBF1].[LatestReportedDate],GETDATE()) = 0 THEN 1 ELSE [dbo].[ufn_IsAnnualMonthInd]([DBF1].[LatestReportedDate]) END
ELSE 0 END
,@datevalmetric
FROM [dbo].[vw_Databases] as DB1
inner join 
	(
	SELECT 
	[DatabaseUniqueID] 
	,[DatabaseFileID]
	,[ETLProcessID]
	,[FileID]
	,[FileType]
	,[FileFullName]
	,[IsPrimaryFileInd]
	,[Size]
	,[LatestReportedDate]
	FROM [dbo].[vw_DatabaseFiles]
	WHERE LEN(filefullname) > 0
	) AS [DBF1]
ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueID]
CROSS APPLY [dbo].[ufn_ParseSQLFileName]([DBF1].[FileFullName]) AS T2
INNER JOIN @DatabaseUniqueIDs AS pDBIDS
ON [DB1].DatabaseUniqueId = pDBIDS.pDatabaseUniqueID
WHERE [DB1].[SystemObjectInd] <= @pincludesystemdbs
AND [DBF1].[LatestReportedDate] >= @pfirstdate
)

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tRankedDatabaseFiles' AND [type] = 'U')
BEGIN
	DROP TABLE [tempdb].[dbo].[tRankedDatabaseFiles]
END

CREATE TABLE [tempdb].[dbo].[tRankedDatabaseFiles] (
[File_Rank] INT NOT NULL,
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[ETLProcessID] [int] NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[LatestReportedDate] [date] NOT NULL)

--Add an index to assist in ranking comparison
CREATE NONCLUSTERED INDEX [IX_tRankedDatabaseFiles_01] ON [tempdb].[dbo].[tRankedDatabaseFiles]
(
	[ServerInstanceId] ASC,
	[DatabaseName] ASC,
	[db_File_Name] ASC,
	[File_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


INSERT INTO [tempdb].[dbo].[tRankedDatabaseFiles] ([File_Rank], [ServerInstanceId], [DatabaseName], [DatabaseFileID], [ETLProcessID], [FileID], [FileType], [DriveLetter], [db_File_Name], [db_File_Path], [IsPrimaryFileInd], [Size], [LatestReportedDate])
(
SELECT
RANK () OVER (PARTITION BY [TT1].[ServerInstanceId],[TT1].[DatabaseName],[TT1].[db_file_name] ORDER BY [TT1].[LatestReportedDate] DESC) AS file_rank,
[TT1].[ServerInstanceId]
,[TT1].[DatabaseName]
,[TT1].[DatabaseFileID]
,[TT1].[ETLProcessID]
,[TT1].[FileID]
,[TT1].[FileType]
,[TT1].[DriveLetter]
,[TT1].[db_file_name]
,[TT1].[db_file_path]
,[TT1].[IsPrimaryFileInd]
,[TT1].[Size]
,[TT1].[LatestReportedDate]
FROM [tempdb].[dbo].[tDatabaseFiles] as [TT1]
WHERE [TT1].[IncludeInRankTableInd] = 1
)

IF @pShowFilesByRanking = 1
BEGIN
	SELECT
	'Ranked Files'
	,[LT1].[File_Rank]
	,[LT1].[ServerInstanceId]
	,[LT1].[DatabaseName]
	,[LT1].[DatabaseFileID]
	,[LT1].[FileID]
	,[LT1].[FileType]
	,[LT1].[DriveLetter]
	,[LT1].[db_file_name]
	,[LT1].[db_file_path]
	,[LT1].[LatestReportedDate]
	,[LT1].[IsPrimaryFileInd]
	,[LT1].[Size] AS [Size]
	,[LT1].[Size] - COALESCE([RT1].[Size],[LT1].[Size]) as SizeChange
	from [tempdb].[dbo].[tRankedDatabaseFiles]  as LT1
	LEFT OUTER JOIN [tempdb].[dbo].[tRankedDatabaseFiles]  as RT1
	ON [LT1].[ServerInstanceId] = [RT1].[ServerInstanceId]
	AND [LT1].[DatabaseName] = [RT1].[DatabaseName]
	AND [LT1].[db_file_name] = [RT1].[db_file_name]
	AND [LT1].[file_rank] + 1 = [RT1].[file_rank]
	order by 
	[LT1].[ServerInstanceId]
	,[LT1].[DatabaseName]
	,[LT1].[db_file_name]
	,[LT1].[file_rank] desc;
END
ELSE
BEGIN
	SELECT 
	'Raw File Data'
	,[ServerInstanceId]
	,[DatabaseUniqueId]
	,[DatabaseName]
	,[DatabaseFileID]
	,[ETLProcessID]
	,[FileID]
	,[FileType]
	,[DriveLetter]
	,[db_File_Name]
	,[db_File_Path]
	,[IsPrimaryFileInd]
	,[Size]
	,[LatestReportedDate]
	,[IncludeInRankTableInd]
	,[DateValMetric]
	FROM [tempdb].[dbo].[tDatabaseFiles]
END



DROP TABLE [tempdb].[dbo].[tDatabaseFiles] 
DROP TABLE [tempdb].[dbo].[tRankedDatabaseFiles] 
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseFiles_GrowthChangesByDateRange]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_DatabaseFiles_GrowthChangesByDateRange]
(@pfirstdate DATE
,@pcalendarbasis NVARCHAR(10)
,@pincludesystemdbs BIT = 0
,@pDatabaseName NVARCHAR(4000)
,@pspaceunits NVARCHAR(2)
)
/*
-- description: query to return the changes in disk history by server and disk over time.  
want to allow user to input how they want the history 
There are three aspects on displaying history
--the date range -- default values -- from today to 90 days prior
--the date part to segment history into (days, weeks, months)--default values days
--the date part of each segment for the reporting period--default value (day of the week, day of the month)
--user should be able to put in a historical date (or number of days to look back) to limit the history
--user should be able to input values to define how the history is compared by most granular to least granular(each day) day of the week (can put it in for every friday or every monday),  day of the month

-- inputs

*/

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

DECLARE @datevalmetric INT
DECLARE @ddef TABLE (datevalmetric int, datestring NVARCHAR(10))
INSERT INTO @ddef
values (1,'day')
INSERT INTO @ddef
values (7,'week')
INSERT INTO @ddef
values(30,'month')
INSERT INTO @ddef
values(360,'year');

DECLARE @sudef TABLE (spacevalmetric int, spacestring NVARCHAR(2))
INSERT INTO @sudef
values (0,'kb')
INSERT INTO @sudef
values (1,'mb')
INSERT INTO @sudef
values (2,'gb')
INSERT INTO @sudef
values (3,'tb'); 
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
SET @currObject = '@pcalendarbasis'
IF NOT EXISTS (SELECT * FROM @ddef WHERE datestring = @pcalendarbasis)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either day, week, month or year'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pcalendarbasis);
		THROW 60000 , @msg, 1 
	END;

SET @currObject = '@pspaceunits'
IF NOT EXISTS (SELECT * FROM @sudef WHERE spacestring = @pspaceunits)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either KB, MB, GB or TB to return values in either kilobytes, megabytes, gigabytes or terrabytes respectively'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pspaceunits);
		THROW 60000 , @msg, 1 
	END;

SET @currObject = '@pfirstdate'
IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;
	
SET @currObject = '@pDatabaseName'
IF (@pDatabaseName IS NULL OR LEN(@pDatabaseName) < 1)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. A valid database name is required.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

SELECT @datevalmetric = datevalmetric 
FROM @ddef
WHERE datestring = @pcalendarbasis

IF @pcalendarbasis = 'month'
BEGIN
PRINT 'Using EOMONTH system function'
END

IF @pcalendarbasis = 'week'
BEGIN
PRINT 'Using DatePart is where condition'
END

IF @pcalendarbasis = 'year'
BEGIN
PRINT 'Using get annual report'
END

	DECLARE @DatabaseUniqueIDs TABLE (pDatabaseUniqueID INT)
	BEGIN
		INSERT INTO @DatabaseUniqueIDs
		SELECT DISTINCT [DatabaseUniqueID]
		FROM [dbo].[vw_Databases]
		WHERE [DatabaseName] LIKE @pDatabaseName
	END

	IF (SELECT COUNT(*) FROM @DatabaseUniqueIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No database names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDatabaseName);
		THROW 60000 , @msg, 1 
	END;

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tDatabaseFilesGrowth' AND [type] = 'U')
BEGIN
DROP TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]
--TRUNCATE TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]
END
--ELSE
--BEGIN
CREATE TABLE [tempdb].[dbo].[tDatabaseFilesGrowth] (
[File_Rank] INT NOT NULL,
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[LatestReportedDate] [DATE] NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[SizeChange] [float] NULL)
--END
DECLARE @spacevalmetric INT 
DECLARE @spacevalmetricbytes BIGINT

SELECT @spacevalmetric = POWER(1024,spacevalmetric)
,@spacevalmetricbytes = POWER(1024,(spacevalmetric+1))
FROM @sudef
WHERE spacestring = @pspaceunits

print cast(@spacevalmetric as varchar(30)) 
print @pspaceunits

INSERT INTO [tempdb].[dbo].[tDatabaseFilesGrowth]
           ([File_Rank]
           ,[ServerInstanceId]
           ,[DatabaseName]
           ,[DatabaseFileID]
           ,[FileID]
           ,[FileType]
           ,[DriveLetter]
           ,[db_File_Name]
           ,[db_File_Path]
           ,[LatestReportedDate]
           ,[IsPrimaryFileInd]
           ,[Size]
           ,[SizeChange])
EXEC	[dbo].[usp_DatabaseFiles_GrowthByDateRange] @pfirstdate,@pcalendarbasis,@pincludesystemdbs,@pDatabaseName;

IF EXISTS (SELECT * FROM [tempdb].[sys].[objects] WHERE [name] = 'tServerPhysicalDisks' AND [type] = 'U')
BEGIN
DROP TABLE [tempdb].[dbo].[tServerPhysicalDisks]
--TRUNCATE TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]
END
--ELSE
--BEGIN
CREATE TABLE [tempdb].[dbo].[tServerPhysicalDisks] (
[ServerSystemID] INT NOT NULL
,[HostName] NVARCHAR(128) NOT NULL
,[DiskID] NVARCHAR(1) NOT NULL
,[FreeSpace] BIGINT NOT NULL
,[DiskSize] BIGINT NOT NULL
,[ETLProcessID] INT NOT NULL
,[LatestReportedDate] DATE NOT NULL
);
--for the average, the latest file will not have any difference and the 'difference' column values will be 0.
--including these values in the calcuations for average may skew the results downward.

WITH CurrentDBFileLocs ([ServerSystemID],[ServerInstanceId],[DriveLetter],[ETLProcessID],[db_file_name],[CurrentSize],[CurrentUsedSpace])
AS
(SELECT
[SI1].[ServerSystemID]
,[DB1].[ServerInstanceId]
,SUBSTRING([DBF1].[FileFullName],1,1) AS DriveLetter
,[DBF1].[ETLProcessID]
,[T2].db_file_name
,[DBF1].[Size]
,[DBF1].[UsedSpace]
FROM [dbo].[vw_DatabaseFiles] as DBF1
inner join [dbo].[vw_Databases] as DB1
ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueID]
CROSS APPLY [dbo].[ufn_ParseSQLFileName]([DBF1].[FileFullName]) AS T2
INNER JOIN @DatabaseUniqueIDs AS pDBIDS
ON [DB1].DatabaseUniqueId = pDBIDS.pDatabaseUniqueID
INNER JOIN 
	(SELECT 
	[DatabaseUniqueID]
	,MAX(ETLProcessID) AS MRETLID
	FROM [dbo].[vw_DatabaseFiles]
	GROUP BY [DatabaseUniqueID]
	) AS T5
	ON [DBF1].[DatabaseUniqueID] = [T5].[DatabaseUniqueID]
	AND [DBF1].[ETLProcessID] = [T5].[MRETLID]
INNER JOIN [dbo].[vw_ServerInstances] AS SI1
ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceID]
),
DatabaseSpaceMetrics (
[CalendarBasis],[SpacePresentedIn],[ServerSystemID],[ServerInstanceId],[DatabaseName],[FileType],[db_File_Name],[DriveLetter],[FileCurrentSize],	[FileCurrentSpaceUsed],	[NumberOfDateMetricsUsed],[MaxChangeInSize],[MinChangeInSize],[AvgChangeInSize])
AS
(
SELECT 
@pcalendarbasis as CalendarBasis
,@pspaceunits as SpacePresentedIn
,[T6].[ServerSystemID]
,[T1].[ServerInstanceId]
,[T1].[DatabaseName]
,[T1].[FileType]
,[T1].[db_File_Name]
,[T6].DriveLetter
,CAST(ROUND(([T6].[CurrentSize]/@spacevalmetric),0) AS bigint) AS FileCurrentSize
,CAST(ROUND(([T6].[CurrentUsedSpace]/@spacevalmetric),0) AS bigint) AS FileCurrentSpaceUsed
,COUNT([T1].[File_Rank]) AS NumberOfDateMetricsUsed
,CAST(ROUND(MAX([T1].[SizeChange]/@spacevalmetric),0) AS bigint) AS MaxChangeInSize
,CAST(ROUND(MIN([T1].[SizeChange]/@spacevalmetric),0) AS bigint) AS MinChangeInSize
,CAST(ROUND(AVG([T1].[SizeChange]/@spacevalmetric),0) AS bigint) AS AvgChangeInSize
  FROM [tempdb].[dbo].[tDatabaseFilesGrowth] AS T1
LEFT OUTER JOIN
(SELECT
[ServerInstanceId]
,[DatabaseName]
,[FileType]
,[db_File_Name]
,MAX([File_Rank]) AS [HighestFileRank]
FROM [tempdb].[dbo].[tDatabaseFilesGrowth]
GROUP BY
[ServerInstanceId]
,[DatabaseName]
,[FileType]
,[db_File_Name]) AS T2
ON 
[T1].[File_Rank] = [T2].[HighestFileRank]
AND [T1].[ServerInstanceId] = [T2].[ServerInstanceId]
AND [T1].[DatabaseName] = [T2].[DatabaseName]
AND [T1].[FileType] = [T2].[FileType]
AND [T1].[db_File_Name] = [T2].[db_File_Name]
LEFT OUTER JOIN CurrentDBFileLocs AS T6
ON [T1].[ServerInstanceId] = [T6].ServerInstanceId
AND [T1].db_File_Name = [T6].db_file_name
WHERE [T2].[HighestFileRank] IS NULL
GROUP BY 
[T6].[ServerSystemID]
,[T1].[ServerInstanceId]
,[T1].[DatabaseName]
,[T1].[FileType]
,[T1].[db_File_Name]
,[T6].[DriveLetter]
,[T6].[CurrentSize]
,[T6].[CurrentUsedSpace]
)

SELECT
[T8].[HostName],
[T8].[ETLProcessId],
[T8].[LatestReportedDate],
[T7].[CalendarBasis],
[T7].[SpacePresentedIn],
[T7].[ServerSystemID],
[T7].[ServerInstanceId],
[T7].[DatabaseName],
[T7].[NumberOfDateMetricsUsed],
[T7].[FileType],
[T7].[db_File_Name],
[T7].[DriveLetter],
[T7].[FileCurrentSize] AS [DBFile_CurrentSize],
[T7].[FileCurrentSpaceUsed] AS [DBFile_CurrentSpaceUsed],
[T7].[MaxChangeInSize] AS [DBFile_LargestSizeChange],
[T7].[MinChangeInSize] AS [DBFile_SmallestSizeChange],
[T7].[AvgChangeInSize] AS [DBFile_AvgSizeChange],
CAST(ROUND([T8].[DiskSize]/@spacevalmetricbytes,0) AS bigint) AS [LatestDiskSize],
CAST(ROUND([T8].[FreeSpace]/@spacevalmetricbytes,0) AS bigint) AS [LatestFreeSpace]
FROM DatabaseSpaceMetrics AS T7
INNER JOIN
(
SELECT
[ServerSystemID]
,[HostName]
,SUBSTRING([DiskID],1,1) AS DiskID
,[FreeSpace]
,[DiskSize]
,[ETLProcessId]
,[LatestReportedDate]
FROM [dbo].[vw_ServerPhysicalDisks] AS T2
INNER JOIN 
(SELECT MAX(ETLProcessID) as MRETLID
FROM [dbo].[vw_ETLProcesses]) AS T1
ON [T1].[MRETLID] = [T2].[ETLProcessId]
) AS T8
ON [T7].[ServerSystemID] = [T8].[ServerSystemID]
AND [T7].[DriveLetter] = [T8].[DiskID]
ORDER BY [T7].[DriveLetter],[T7].[db_File_Name]
--DROP TABLE [tempdb].[dbo].[tDatabaseFilesGrowth]

END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DatabaseObjects_DeleteHistory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: Procedure deletes historical database object properties records older than a stated time in discrete batches via WHILE BREAK CONTINUE loops.
Batches are used to prevent filling of the database log.
While this procedure could be parameterized, it is not by design.
Since deletion is a significant event, retention values are static to prevent inadvertent purging shorter than desired times.
Changes in retention policy are significant enought to warrant a change in the procedure
*/
CREATE PROCEDURE [dbo].[usp_DatabaseObjects_DeleteHistory]
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @DBPropsRetentionMonths INT
	DECLARE @DBFilesRetentionMonths INT
	SET @DBPropsRetentionMonths = 6
	SET @DBFilesRetentionMonths = 24
	DECLARE @DBPT TABLE ([DatabasePropertyID] INT)
	DECLARE @ROWCNT BIGINT
	DECLARE @ITER INT = 0
	SELECT 'DatabaseProperties Count before Purge Date',CAST(DATEADD(month,-@DBPropsRetentionMonths,getdate()) AS DATE) as [CutoffDate], COUNT(*) as [RecordCount] FROM [dbo].[DatabaseProperties]
	WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
		
	SELECT @ROWCNT = COUNT(*) FROM [dbo].[DatabaseProperties] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
	PRINT 'ITERATION: ' + CAST(@ITER AS VARCHAR(7)) + '--TOTAL ROW COUNT: ' + CAST(@ROWCNT AS VARCHAR(50))

	WHILE  (SELECT COUNT(*) FROM [dbo].[DatabaseProperties] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())) > 0
	
	BEGIN
		SET @ITER = @ITER + 1
		PRINT 'ITERATION: ' + CAST(@ITER AS VARCHAR(7)) + '--TOTAL ROW COUNT: ' + CAST(@ROWCNT AS VARCHAR(50))

		INSERT INTO @DBPT
		SELECT TOP 100000 [DatabasePropertyID]
		FROM [dbo].[DatabaseProperties]
		WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
		BEGIN TRANSACTION DeletingDatabaseProperties
		DELETE FROM [dbo].[DatabaseProperties]
		WHERE [DatabasePropertyID] in (select [DatabasePropertyID] from @DBPT)
		COMMIT TRANSACTION DeletingDatabaseProperties
		delete from @DBPT
		PRINT 'DELETED 100000 ROWS'
		IF (SELECT COUNT(*) FROM [dbo].[DatabaseProperties] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())) <= 0
		BREAK
		ELSE CONTINUE

	END

	DELETE FROM @DBPT

	SET @ITER = 0
	SELECT 'DatabaseFiles Count before Purge Date',CAST(DATEADD(month,-@DBPropsRetentionMonths,getdate()) AS DATE) as [CutoffDate], COUNT(*) as [RecordCount] FROM [dbo].[DatabaseFiles]
	WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
	
	SELECT @ROWCNT = COUNT(*) FROM [dbo].[DatabaseFiles] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
	PRINT 'ITERATION: ' + CAST(@ITER AS VARCHAR(7)) + '--TOTAL ROW COUNT: ' + CAST(@ROWCNT AS VARCHAR(50))

	WHILE  (SELECT COUNT(*) FROM [dbo].[DatabaseFiles] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())) > 0
	
	BEGIN
	SET @ITER = @ITER + 1
		PRINT 'ITERATION: ' + CAST(@ITER AS VARCHAR(7)) + '--TOTAL ROW COUNT: ' + CAST(@ROWCNT AS VARCHAR(50))

		INSERT INTO @DBPT
		SELECT TOP 10000 [DatabaseFileID]
		FROM [dbo].[DatabaseFiles] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())
		PRINT 'ITERATION: ' + CAST(@ITER AS VARCHAR(7)) + '--TOTAL ROW COUNT: ' + CAST(@ROWCNT AS VARCHAR(50))
		BEGIN TRANSACTION DeletingDatabaseFiles
		DELETE FROM [dbo].[DatabaseFiles]
		WHERE [DatabaseFileID] in (select [DatabasePropertyID] from @DBPT)
		COMMIT TRANSACTION DeletingDatabaseFiles
		delete from @DBPT
		PRINT 'DELETED 10000 ROWS'
		IF (SELECT COUNT(*) FROM [dbo].[DatabaseProperties] WHERE [LatestReportedDate] < DATEADD(month,-@DBPropsRetentionMonths,getdate())) <= 0
		BREAK
		ELSE CONTINUE
	END
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_databaseproperties_multiplevalues]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[usp_databaseproperties_multiplevalues]
as
begin
SELECT 
[DBP1].[DatabaseUniqueId]
,[dbs1].[DatabaseName]
,[DBP1].[DatabasePropertyName]
,max([DatabasePropertyID])
,count([DatabasePropertyValue])
FROM [dbo].[DatabaseProperties] as dbp1
inner join [dbo].[vw_Databases] as dbs1
on dbp1.DatabaseUniqueId = dbs1.DatabaseUniqueId
left outer join [dbo].[DatabaseExclusions] as dbe1
on dbs1.DatabaseName = dbe1.DatabaseName
where dbe1.DatabaseName is null
group by 
[DBP1].[DatabaseUniqueId]
,[dbs1].[DatabaseName]
,[DBP1].[DatabasePropertyName]
having count([DatabasePropertyValue]) > 1
end
GO
/****** Object:  StoredProcedure [dbo].[usp_Databases_ChangeNameInAllTables]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_Databases_ChangeNameInAllTables]
(@HostName VARCHAR(128),
@CurrentDBName VARCHAR(128),
@RenamedDBName VARCHAR(128))
AS
BEGIN
DECLARE @DatabaseUniqueID INT
DECLARE @DatabaseURN NVARCHAR(256)
DECLARE @NewDatabaseURN NVARCHAR(256)
DECLARE @assigneddatabase VARCHAR(128)
DECLARE @currObject VARCHAR(128)
DECLARE @msg VARCHAR(2048)



IF (@HostName IS NULL) OR (@CurrentDBName IS NULL) OR (@RenamedDBName IS NULL)
BEGIN
	SET @currObject = 'Required Parameter'
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'Invalid connection or usage: A value is require for HostName, CurrentDBName and RenamedDBName'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000);
	THROW 60000 , @msg, 1 
END

--Throw an error if the new/renamed database already matches a database
IF EXISTS (
	SELECT * FROM [dbo].[Databases] AS DB1
	INNER JOIN [dbo].[ServerInstances] AS SI1
	ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
	INNER JOIN [dbo].[Servers] AS S1
	ON [S1].[ServerSystemID] = [SI1].[ServerSystemID]
	WHERE [DB1].[DatabaseName] = @RenamedDBName
	AND [S1].[HostName] = @HostName
	AND [S1].[RetiredInd] = 0 AND [SI1].[RetiredInd] = 0
)
BEGIN
	SET @currObject = '@RenamedDBName'
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'Invalid connection or usage: The new name to use - %s - already matches an existing database name - %s on %s'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @RenamedDBName,@CurrentDBName,@HostName);
	THROW 60000 , @msg, 1 

END
ELSE
BEGIN
	DECLARE @DatabaseRenameTable TABLE ([HostName] VARCHAR(128), [InstanceName] VARCHAR(128), [DatabaseUniqueId] INT, [ServerInstanceId] INT, 
	[DatabaseURN] NVARCHAR(256), [CurrentDBName] VARCHAR(128), [NewDBName] VARCHAR(128), [NewDatabaseURN] NVARCHAR(256), [DatabaseIsProcessed] BIT)
	INSERT INTO @DatabaseRenameTable ([HostName], [InstanceName], [DatabaseUniqueId], [ServerInstanceId], [DatabaseURN], [CurrentDBName], [NewDBName], [NewDatabaseURN], [DatabaseIsProcessed])
	SELECT DISTINCT
	[S1].[HostName]
	,[SI1].[InstanceName]
	,[DB1].[DatabaseUniqueId]
	,[DB1].[ServerInstanceId]
	,[DB1].[DatabaseURN]
	,[DB1].[DatabaseName]
	,@RenamedDBName
	,REPLACE([DB1].[DatabaseURN],@CurrentDBName,@RenamedDBName)
	,(cast(0 as bit))
	FROM [dbo].[Databases] AS DB1
	INNER JOIN [dbo].[ServerInstances] AS SI1
	ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceId]
	INNER JOIN [dbo].[Servers] AS S1
	ON [S1].[ServerSystemID] = [SI1].[ServerSystemID]
	WHERE [DB1].[DatabaseName] = @CurrentDBName
	AND [S1].[HostName] = @HostName
	AND [S1].[RetiredInd] = 0 AND [SI1].[RetiredInd] = 0


	SELECT * FROM @DatabaseRenameTable
	WHILE (SELECT COUNT(*) FROM @DatabaseRenameTable WHERE [DatabaseIsProcessed] = 0) > 0
	BEGIN
	SELECT TOP 1 @DatabaseUniqueID = [DatabaseUniqueId], @DatabaseURN = [DatabaseURN], @NewDatabaseURN = [NewDatabaseURN]FROM @DatabaseRenameTable WHERE [DatabaseIsProcessed] = 0
	BEGIN TRY
		BEGIN TRANSACTION OtherTables
			UPDATE [dbo].[DatabaseExtendedProperties]
			SET [DatabaseURN] = @NewDatabaseURN
			WHERE [DatabaseUniqueId] = @DatabaseUniqueID
			AND [DatabaseURN] = @DatabaseURN 

			UPDATE [dbo].[DatabaseProperties]
			SET [DatabaseURN] = @NewDatabaseURN
			WHERE [DatabaseUniqueId] = @DatabaseUniqueID
			AND [DatabaseURN] = @DatabaseURN 

			DECLARE @CurrentDBFileURN NVARCHAR(256) 
			DECLARE @NewDBFileURN NVARCHAR(256) 
			SET @CurrentDBFileURN = 'Database[@Name=' + char(39) + @CurrentDBName + char(39) + ']'
			SET @NewDBFileURN = 'Database[@Name=' + char(39) + @RenamedDBName + char(39) + ']'

			UPDATE [dbo].[DatabaseFiles]
			SET [DatabaseURN] = @NewDatabaseURN
			,[DatabaseFileURN] = REPLACE([DatabaseFileURN],@CurrentDBFileURN,@NewDBFileURN)
			WHERE [DatabaseUniqueID] = @DatabaseUniqueID
			AND [DatabaseURN] = @DatabaseURN 

			UPDATE [dbo].[ServerPrincipalsLogins]
			SET [AssignedDatabaseName] = @RenamedDBName
			WHERE [ServerNameId] = @HostName
			AND [AssignedDatabaseName] = @CurrentDBName
			AND [UserRetiredInd] = 0
		COMMIT TRANSACTION OtherTables

		BEGIN TRANSACTION BaseTable
			UPDATE [dbo].[Databases]
			SET [DatabaseURN] = @NewDatabaseURN
			,[DatabaseName] = @RenamedDBName
			WHERE [DatabaseUniqueId] = @DatabaseUniqueID
			AND [DatabaseName] = @CurrentDBName
		COMMIT TRANSACTION BaseTable
	END TRY
	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH

	SELECT * FROM [dbo].[DatabaseExtendedProperties] WHERE [DatabaseUniqueId] = @DatabaseUniqueID
	SELECT * FROM [dbo].[DatabaseProperties] WHERE [DatabaseUniqueId] = @DatabaseUniqueID
	SELECT * FROM [dbo].[DatabaseFiles] WHERE [DatabaseUniqueId] = @DatabaseUniqueID
	SELECT * FROM [dbo].[Databases] WHERE [DatabaseUniqueId] = @DatabaseUniqueID
	SELECT * FROM [dbo].[ServerPrincipalsLogins] WHERE [AssignedDatabaseName] = @RenamedDBName
	
	UPDATE @DatabaseRenameTable
	SET [DatabaseIsProcessed] = 1
	WHERE [DatabaseUniqueId] = @DatabaseUniqueID

	END
	

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_ErrorHandling_SystemErrors_Get]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized TSQL error processing.
This procedure is called by other stored procedures in TRY...CATCH blocks in catching and returning errors during insert, update, select and delete processes
See ER model for revision information
***************************************************/
--Create procedure to retrieve error information.
CREATE PROCEDURE [dbo].[usp_ErrorHandling_SystemErrors_Get]
AS
SELECT
ERROR_NUMBER() AS ErrorNumber
,ERROR_SEVERITY() AS ErrorSeverity
,ERROR_STATE() AS ErrorState
,ERROR_PROCEDURE() AS ErrorProcedure
,ERROR_LINE() AS ErrorLine
,ERROR_MESSAGE() AS ErrorMessage;
PRINT N'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N', Error Severity:' + CAST(ERROR_SEVERITY() AS NVARCHAR(10)) + N', Error State:' + CAST(ERROR_STATE() AS NVARCHAR(10)) + N', Error Procedure:' + CAST(ERROR_PROCEDURE() AS NVARCHAR(128)) + N', Error Line:' + CAST(ERROR_LINE() AS NVARCHAR(10)) + char(13) + char(10) +  N'Error Message:' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000))
GO
/****** Object:  StoredProcedure [dbo].[usp_ETLProcesses_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ETLProcesses table.  Also sets the current record flag on the previous ETL process for this process group as not being current
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_ETLProcesses_Ins] (
@ETLProcessGroupID int,
@InitiatingJobName  NVARCHAR(128),
@ProcessFailedInd bit 

)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
BEGIN TRY
	BEGIN TRANSACTION COMPLETETRAN
	BEGIN TRANSACTION T1
		DECLARE @ProcessDt DATE
		SET @ProcessDt = CAST(GETDATE() AS DATE)

		DECLARE @PriorRecordInd INT
		DECLARE @PriorProcessDt DATE
		SELECT @PriorRecordInd = ISNULL(MAX(ETLProcessId) ,0)
		,@PriorProcessDt = ISNULL(MAX([ProcessDt]),CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))
		FROM [dbo].[ETLProcesses] 
		WHERE [ETLProcessGroupID] = @ETLProcessGroupID
			
		DECLARE @RecordInd bit
		SET @RecordInd = 0
		UPDATE [dbo].[ETLProcesses] 
		SET [CurrentRecordsInd] = @RecordInd
		WHERE [ETLProcessGroupID] = @ETLProcessGroupID
		and [ETLProcessId] = @PriorRecordInd
		COMMIT TRANSACTION T1

		SET @RecordInd = 1
	BEGIN TRANSACTION T2
		INSERT INTO [dbo].[ETLProcesses]
		([ETLProcessGroupID]
		,[InitiatingJobName]
		,[ProcessDt]
		,[CurrentRecordsInd]
		,[ProcessFailedInd])
		VALUES
		(@ETLProcessGroupID
		,@InitiatingJobName
		,@ProcessDt
		,@RecordInd
		,cast(0 as bit))
	
		-- Begin Return Select <- do not remove

		SELECT [ETLProcessId]
		,[ETLProcessGroupID]
		,[InitiatingJobName]
		,[ProcessDt]
		,[CurrentRecordsInd]
		,[ProcessFailedInd]
		,@PriorProcessDt
		FROM [dbo].[ETLProcesses]
		WHERE  [ETLProcessId] = SCOPE_IDENTITY()
		COMMIT TRANSACTION T2
	COMMIT TRANSACTION COMPLETETRAN

END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_IndexDefragmenation_DEL_PurgeHistoryOlderThanRetentionDays]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_IndexDefragmenation_DEL_PurgeHistoryOlderThanRetentionDays]
	@pDatabaseName VARCHAR(128), 
	@pRetentionDays int = 180
AS
BEGIN
-- =============================================
-- Author:		Danny Howell
-- Description:	Deletes history from the Index Defragmentation History tables based upon a number of days retention
-- =============================================

SET NOCOUNT ON 
SET XACT_ABORT ON
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

BEGIN TRY
	SELECT @pRetentionDays = COALESCE(@pRetentionDays,180),@pDatabaseName = COALESCE(@pDatabaseName,'%')
	DECLARE @DetailCount INT
	DECLARE @SummaryCount INT
	DECLARE @CutoffDate DATETIME
	SET @CutoffDate = DATEADD(DAY,-@pRetentionDays,GETDATE())

	BEGIN TRANSACTION 
		SELECT @DetailCount = COUNT([defragmentation_job_id])
		FROM [dbo].[Index_Defragmentation_History_Detail]
		WHERE [defragmentation_job_id] IN
		(SELECT [defragmentation_job_id]
		FROM [dbo].[Index_Defragmentation_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		AND [last_update_date] < @CutoffDate)

		SELECT @SummaryCount = COUNT([defragmentation_job_id])
		FROM [dbo].[Index_Defragmentation_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		AND [last_update_date] < @CutoffDate

		print 'Deleting history prior to ' + cast(@cutoffdate as varchar(20))
		PRINT 'Count of detail records to purge:' + cast(@DetailCount as varchar(10))
		PRINT 'Count of summary records to purge:' + cast(@SummaryCount as varchar(10))
		
		DELETE FROM [dbo].[Index_Defragmentation_History_Detail]
		WHERE [defragmentation_job_id] IN
		(SELECT [defragmentation_job_id]
		FROM [dbo].[Index_Defragmentation_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		AND [last_update_date] < @CutoffDate)
		
		DELETE FROM [dbo].[Index_Defragmentation_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		AND [last_update_date] < @CutoffDate
	

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		EXEC dbo.usp_ErrorHandling_SystemErrors_Get
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
	
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerInstances_Upd_RetireSQLInstance]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Danny Howell
-- Create date:	03/12/2012
-- Description:	Procedure used to set flag on dbo.ServerInstances table for SQL instances permanently shutdown and deleted by changing the IsDecommissionedInd field = true(1)
--				and other management indicator flags to False (0).  This will remove the input host name and all its SQL instances from processing by the SSIS packages used for KFB SQL management
-- =============================================
CREATE PROCEDURE [dbo].[usp_ServerInstances_Upd_RetireSQLInstance]
@pServerInstanceId INT
	
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
		DECLARE @LatestReportedDate DATE
		DECLARE @msg NVARCHAR(2048)
		DECLARE @currprod NVARCHAR(128)
		SELECT @currprod = OBJECT_NAME(@@PROCID)
		SET @LatestReportedDate = CAST(GETDATE() as DATE)
		IF @pServerInstanceId IS NULL
		BEGIN
			EXEC sys.sp_addmessage
			@msgnum   = 60000
			,@severity = 10
			,@msgtext  = N'A NULL entry was passed to the ServerInstanceId input parameter in the procedure %s.  Please provide a valid Server Instance ID value.'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg = FORMATMESSAGE(60000,@currprod); 
			THROW 60000 , @msg, 1; 
		END

		IF NOT EXISTS (SELECT * FROM [dbo].[ServerInstances] WHERE ServerInstanceId = @pServerInstanceId)	
		BEGIN
			EXEC sys.sp_addmessage
			@msgnum   = 60002
			,@severity = 10
			,@msgtext  = N'Invalid input parameters passed to the procedure %s: Server Instance ID %d does not exist.  Please provide a valid SQL Instance ID.'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg  = FORMATMESSAGE(60002,@currprod, @pServerInstanceId); 
			THROW 60002 , @msg, 1; 
		END
	--If parameters are valid, retire the indicated SQL instance
		BEGIN TRANSACTION DBDEL
				UPDATE [dbo].[Databases]
				SET 
				[LatestReportedDate] = @LatestReportedDate
				,[DeletedInd] = 1
				WHERE [ServerInstanceId] = @pServerInstanceID
					BEGIN TRANSACTION SIRETIRE
						UPDATE [dbo].[ServerInstances]
						SET RetiredInd = 1, 
						WinAuthUserCanConnectToSystemInd = 0,
						SQLAuthUserCanConnectToSystemInd = 0
						WHERE [ServerInstanceId] = @pServerInstanceID
					COMMIT TRANSACTION SIRETIRE
		COMMIT TRANSACTION DBDEL
	
		SELECT 
		[SI1].[ServerInstanceID]
		,[SI1].[ServerSystemID]
		,[SI1].[InstanceName]
		,[SI1].[WinAuthUserCanConnectToSystemInd]
		,[SI1].[SQLAuthUserCanConnectToSystemInd]
		,[SI1].[LatestReportedDate]
		,[SI1].[RetiredInd]
		,[DB1].[DatabaseUniqueId]
		,[DB1].[SystemDBID]
		,[DB1].[DatabaseName]
		,[DB1].[SystemObjectInd]
		,[DB1].[LatestReportedDate]
		FROM [dbo].[vw_ServerInstances] AS SI1
		LEFT OUTER JOIN [dbo].[vw_Databases] as DB1
		ON [SI1].[ServerInstanceID] = [DB1].[ServerInstanceId]
		WHERE [SI1].[ServerInstanceID] = @pServerInstanceId
 		
		END TRY
		
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
				EXEC dbo.usp_ErrorHandling_SystemErrors_Get
			END
		END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerObjects_DeleteHistory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: Procedure deletes historical server object properties records older than a stated time
While this procedure could be parameterized, it is not by design.
Since deletion is a significant event, retention values are static to prevent inadvertent purging shorter than desired times.
Changes in retention policy are significant enought to warrant a change in the procedure
*/
CREATE PROCEDURE [dbo].[usp_ServerObjects_DeleteHistory]
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @ServerPropsRetentionMonths INT
	DECLARE @CutoffDate DATE
	SET @ServerPropsRetentionMonths = 6
	SET @CutoffDate = DATEADD(month,-@ServerPropsRetentionMonths,getdate())
	SELECT 'ServerProperties Count before Purge Date'
	,@CutoffDate as [CutoffDate] 
	,COUNT(*) as [RecordCount] 
	FROM [dbo].[ServerProperties]
	WHERE [LatestReportedDate] <= @CutoffDate

	BEGIN TRANSACTION 
		DELETE FROM [dbo].[ServerProperties]
		WHERE [LatestReportedDate] <= @CutoffDate
	COMMIT TRANSACTION

	DECLARE @ServerDiskRetentionMonths INT
	SET @ServerDiskRetentionMonths = 24
	SET @CutoffDate = CAST(DATEADD(month,-@ServerDiskRetentionMonths,getdate()) AS DATE)
	SELECT 'ServerPhysicalDisk Count before Purge Date'
	, @CutoffDate as [CutoffDate]
	, COUNT(*) as [RecordCount] 
	FROM [dbo].[ServerPhysicalDisks]
	WHERE [LatestReportedDate] <= @CutoffDate

	BEGIN TRANSACTION
		DELETE FROM [dbo].[ServerPhysicalDisks]
		WHERE [LatestReportedDate] <= @CutoffDate
	COMMIT TRANSACTION
	
	DECLARE @DatabaseFileRetentionMonths INT
	SET @DatabaseFileRetentionMonths = 12
	SET @CutoffDate = CAST(DATEADD(month,-@DatabaseFileRetentionMonths,getdate()) AS DATE)
	SELECT 'DatabaseFiles Count before Purge Date'
	, @CutoffDate as [CutoffDate]
	, COUNT(*) as [RecordCount] 
	FROM [dbo].[DatabaseFiles]
	WHERE [LatestReportedDate] <= @CutoffDate

	BEGIN TRANSACTION
		DELETE FROM [dbo].[DatabaseFiles]
		WHERE [LatestReportedDate] <= @CutoffDate
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPhysicalDisks_ActiveDiskHistory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: query to return the current disk space information by server and disk.  
*/

CREATE PROCEDURE [dbo].[usp_ServerPhysicalDisks_ActiveDiskHistory]
(@pfirstdate DATE
,@pDiskMetric VARCHAR(5)
,@pServerHostName NVARCHAR(128)
)

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	DECLARE @diskvalmetric INT
	DECLARE @ddef TABLE (diskvaldivisor int, DiskMetric VARCHAR(5))
	INSERT INTO @ddef
	values (0,'BYTES')
	INSERT INTO @ddef
	values (1,'KB')
	INSERT INTO @ddef
	values (2,'MB')
	INSERT INTO @ddef
	values(3,'GB')

	SET @currObject = '@pDiskMetric'
	IF NOT EXISTS (SELECT * FROM @ddef WHERE DiskMetric = @pDiskMetric)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either BYTES, KB, MB or GB'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDiskMetric);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @diskvaldivisor DECIMAL(18,3)
	SELECT @diskvaldivisor = POWER(1024,diskvaldivisor) FROM @ddef
	WHERE DiskMetric = @pDiskMetric

	PRINT (N'Disk space shown in ' + @pDiskMetric + CAST(@diskvaldivisor AS VARCHAR(19)))

	SET @currObject = '@pfirstdate'
	IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;


	IF @pServerHostName IS NULL
	BEGIN
		SET @pServerHostName = '%'
	END
	
	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	INSERT INTO @ServerSystemIDs
	SELECT DISTINCT [ServerSystemID]
	FROM [dbo].[vw_Servers]
	WHERE [HostName] LIKE @pServerHostName
	
	IF (SELECT COUNT(*) FROM @ServerSystemIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No host names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pServerHostName);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @ServerPhysicalDisks TABLE ([ServerSystemID] INT,[DiskID] NVARCHAR(3))
	INSERT INTO @ServerPhysicalDisks
	SELECT DISTINCT 
	[T1].[ServerSystemID]
	,[T1].[DiskID]
	FROM [dbo].[ServerPhysicalDisks] AS [T1]
	INNER JOIN @ServerSystemIDs AS [T2]
	ON [T1].[ServerSystemID] = [T2].[pServerSystemID]
	WHERE [ETLProcessId] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses]);

	SELECT
	RANK () OVER (PARTITION BY [S1].[HostName],[SPD1].[DiskID] ORDER BY [SPD1].[LatestReportedDate] DESC) AS DISKDATERANK
	,[S1].[ServerSystemID]
	,[S1].[HostName]
	,[SPD1].[ETLProcessId]
	,[S1].[ProductionInd]
	,[SPD1].[DiskID]
	,[SPD1].[LatestReportedDate] 
	,@pDiskMetric AS DiskSpaceMetric
	,CAST(CAST([SPD1].[DiskSize] AS decimal(18,3))/@diskvaldivisor AS DECIMAL(18,3)) AS DiskSize
	,CAST(CAST([SPD1].[FreeSpace] AS decimal(18,3))/@diskvaldivisor AS DECIMAL(18,3)) AS FreeSpace
	,CAST(CAST(([SPD1].[DiskSize] - [SPD1].[FreeSpace]) AS decimal(18,3)) /@diskvaldivisor AS DECIMAL(18,3)) AS UsedSpace
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN CAST((cast([SPD1].[FreeSpace] as numeric(18,3))/cast([SPD1].[DiskSize] as numeric(18,3))) AS DECIMAL(7,3)) * 100 ELSE 0 END AS PercentFree
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN (1- CAST((cast([SPD1].[FreeSpace] as numeric(18,3))/cast([SPD1].[DiskSize] as numeric(18,3))) AS DECIMAL(7,3))) * 100 ELSE 0 END AS PercentUsed
	FROM [dbo].[vw_Servers] AS S1
	LEFT OUTER JOIN [dbo].[vw_ServerPhysicalDisks] AS SPD1
	ON [S1].[ServerSystemID] = [SPD1].[ServerSystemID]
	INNER JOIN @ServerPhysicalDisks AS pS1
	ON [SPD1].[ServerSystemID]  = [pS1].[ServerSystemID]
	AND [SPD1].[DiskID] = [pS1].[DiskID]
	WHERE [S1].[RetiredInd] = 0
	AND [SPD1].[LatestReportedDate] >= @pfirstdate
	ORDER BY 
	[S1].[ServerSystemID]
	,[SPD1].[DiskID]
	,[SPD1].[LatestReportedDate] DESC


	
	
	
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPhysicalDisks_ActiveDisks]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
Author: Danny Howell
Description: query to return the current disk space information by server and disk.  
*/

CREATE PROCEDURE [dbo].[usp_ServerPhysicalDisks_ActiveDisks]
(@pDiskMetric VARCHAR(5)
,@pServerHostName NVARCHAR(128)
)

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	DECLARE @diskvalmetric INT
	DECLARE @ddef TABLE (diskvaldivisor int, DiskMetric VARCHAR(5))
	INSERT INTO @ddef
	values (0,'BYTES')
	INSERT INTO @ddef
	values (1,'KB')
	INSERT INTO @ddef
	values (2,'MB')
	INSERT INTO @ddef
	values(3,'GB')

	SET @currObject = '@pDiskMetric'
	IF NOT EXISTS (SELECT * FROM @ddef WHERE DiskMetric = @pDiskMetric)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either BYTES, KB, MB or GB'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDiskMetric);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @diskvaldivisor DECIMAL(18,3)
	SELECT @diskvaldivisor = POWER(1024,diskvaldivisor) FROM @ddef
	WHERE DiskMetric = @pDiskMetric

	PRINT (N'Disk space shown in ' + @pDiskMetric + CAST(@diskvaldivisor AS VARCHAR(19)))

	IF @pServerHostName IS NULL
	BEGIN
		SET @pServerHostName = '%'
	END
	
	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	INSERT INTO @ServerSystemIDs
	SELECT DISTINCT [ServerSystemID]
	FROM [dbo].[vw_Servers]
	WHERE [HostName] LIKE @pServerHostName
	
	IF (SELECT COUNT(*) FROM @ServerSystemIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No host names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pServerHostName);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @ServerPhysicalDisks TABLE ([ServerSystemID] INT,[DiskID] NVARCHAR(3), [ServerPhysicalDiskID] BIGINT)
	INSERT INTO @ServerPhysicalDisks
	SELECT DISTINCT 
	[T1].[ServerSystemID]
	,[T1].[DiskID]
	,[T1].[ServerPhysicalDiskID]
	FROM [dbo].[ServerPhysicalDisks] AS [T1]
	INNER JOIN @ServerSystemIDs AS [T2]
	ON [T1].[ServerSystemID] = [T2].[pServerSystemID]
	WHERE [ETLProcessId] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses]);

	SELECT
	RANK () OVER (PARTITION BY [S1].[HostName],[SPD1].[DiskID] ORDER BY [SPD1].[LatestReportedDate] DESC) AS DISKDATERANK
	,[S1].[ServerSystemID]
	,[S1].[HostName]
	,[SPD1].[ETLProcessId]
	,[S1].[ProductionInd]
	,[SPD1].[DiskID]
	,[SPD1].[LatestReportedDate] 
	,@pDiskMetric AS DiskSpaceMetric
	,CAST(CAST([SPD1].[DiskSize] AS decimal(18,2))/@diskvaldivisor AS DECIMAL(18,2)) AS DiskSize
	,CAST(CAST([SPD1].[FreeSpace] AS decimal(18,2))/@diskvaldivisor AS DECIMAL(18,2)) AS FreeSpace
	,CAST(CAST(([SPD1].[DiskSize] - [SPD1].[FreeSpace]) AS decimal(18,2)) /@diskvaldivisor AS DECIMAL(18,2)) AS UsedSpace
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN CAST((cast([SPD1].[FreeSpace] as numeric(18,2))/cast([SPD1].[DiskSize] as numeric(18,2))) AS DECIMAL(7,2)) * 100 ELSE 0 END AS PercentFree
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN (1- CAST((cast([SPD1].[FreeSpace] as numeric(18,2))/cast([SPD1].[DiskSize] as numeric(18,2))) AS DECIMAL(7,2))) * 100 ELSE 0 END AS PercentUsed
	FROM [dbo].[vw_Servers] AS S1
	LEFT OUTER JOIN [dbo].[vw_ServerPhysicalDisks] AS SPD1
	ON [S1].[ServerSystemID] = [SPD1].[ServerSystemID]
	INNER JOIN @ServerPhysicalDisks AS pS1
	ON [SPD1].[ServerSystemID]  = [pS1].[ServerSystemID]
	AND [SPD1].[DiskID] = [pS1].[DiskID]
	AND [SPD1].[ServerPhysicalDiskID] = [pS1].[ServerPhysicalDiskID]
	WHERE [S1].[RetiredInd] = 0
	ORDER BY 
	[S1].[ServerSystemID]
	,[SPD1].[DiskID]
	,[SPD1].[LatestReportedDate] DESC


	
	
	
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPhysicalDisks_ActiveDisksGrowthHistory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: query to return the current disk space information by server and disk.  
*/
CREATE PROCEDURE [dbo].[usp_ServerPhysicalDisks_ActiveDisksGrowthHistory]
(
@pfirstdate DATE
,@pDiskMetric VARCHAR(5)
,@pServerHostName NVARCHAR(128)
)

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON; 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON;  

BEGIN TRY
		
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)

	DECLARE @lfirstdate DATE,@lDiskMetric VARCHAR(5),@lServerHostName NVARCHAR(128)
	SELECT @lfirstdate =@pfirstdate,@lDiskMetric = @pDiskMetric,@lServerHostName = @pServerHostName

	DECLARE @diskvalmetric INT
	DECLARE @ddef TABLE (diskvaldivisor int, DiskMetric VARCHAR(5))
	INSERT INTO @ddef
	values (0,'BYTES')
	INSERT INTO @ddef
	values (1,'KB')
	INSERT INTO @ddef
	values (2,'MB')
	INSERT INTO @ddef
	values(3,'GB')

	SET @currObject = '@pDiskMetric'
	IF NOT EXISTS (SELECT * FROM @ddef WHERE DiskMetric = @pDiskMetric)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either BYTES, KB, MB or GB'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDiskMetric);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @diskvaldivisor DECIMAL(18,3)
	SELECT @diskvaldivisor = POWER(1024,diskvaldivisor) FROM @ddef
	WHERE DiskMetric = @pDiskMetric

	PRINT (N'Disk space shown in ' + @pDiskMetric + CAST(@diskvaldivisor AS VARCHAR(19)))
	

	SET @currObject = '@pfirstdate'
	IF @pfirstdate >= CAST(GETDATE() AS DATE)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Beginning date must be less than the current date'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,CAST(@pfirstdate AS NVARCHAR(12)));
		THROW 60000 , @msg, 1 
	END;
	
	IF @pServerHostName IS NULL
	BEGIN
		SET @pServerHostName = '%'
	END
	
	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	INSERT INTO @ServerSystemIDs
	SELECT DISTINCT [ServerSystemID]
	FROM [dbo].[vw_Servers]
	WHERE [HostName] LIKE @pServerHostName
	
	IF (SELECT COUNT(*) FROM @ServerSystemIDs) < 1
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No host names could be found for the input value (%s).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pServerHostName);
		THROW 60000 , @msg, 1 
	END;
		
	--First, get only the current disks--some disks may have been used files have since been moved
	--get physical disks of the server to a table variable by diskid (driveletter)
	--set the reporting period like in database file growth
	DECLARE @ServerPhysicalDisks TABLE ([ServerSystemID] INT,[DiskID] NVARCHAR(3))
	INSERT INTO @ServerPhysicalDisks
	SELECT DISTINCT 
	[T1].[ServerSystemID]
	,[T1].[DiskID]
	FROM [dbo].[ServerPhysicalDisks] AS [T1]
	INNER JOIN @ServerSystemIDs AS [T2]
	ON [T1].[ServerSystemID] = [T2].[pServerSystemID]
	WHERE [ETLProcessId] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses]);

	--Create a CTE to hold ranked disks according to date descending
	--This CTE is then outer joined to itself to provide the space changed in total space, free space and used space (which is the difference between total and free space)
	-- use the disk history stored procedure to populate a table variable

	DECLARE @TT TABLE (
	DiskDateRank int
	,ServerSystemID int
	,HostName varchar(128)
	,ETLProcessId int
	,ProductionInd bit
	,DiskID char(4)
	,LatestReportedDate date
	,DiskSpaceMetric varchar(10)
	,DiskSize numeric(18,3)
	,FreeSpace numeric(18,3)
	,UsedSpace numeric(18,3)
	,PercentFree decimal(7,3)
	,PercentUsed decimal(7,3))
	
	
	insert into @TT
	EXEC	 [dbo].[usp_ServerPhysicalDisks_ActiveDiskHistory]
	@pfirstdate = @lfirstdate  
	,@pDiskMetric = @lDiskMetric
	,@pServerHostName = @lServerHostName


	SELECT
	[T1].[DiskDateRank]
	,[T1].[ServerSystemID]
	,[T1].[HostName]
	,[T1].[ETLProcessId]
	,[T1].[ProductionInd]
	,[T1].[DiskID]
	,[T1].[LatestReportedDate] 
	,[T1].[DiskSpaceMetric]
	,[T1].[DiskSize]
	,[T1].[FreeSpace]
	,[T1].[UsedSpace]
	,[T1].[PercentFree]
	,[T1].[PercentUsed]
	,[T1].[DiskSize] - COALESCE([T2].[DiskSize],[T1].[DiskSize]) AS DiskSizeChange
	,[T1].[FreeSpace] - COALESCE([T2].[FreeSpace],[T1].[FreeSpace]) AS FreeSpaceChange
	,[T1].[UsedSpace] - COALESCE([T2].[UsedSpace],[T1].[UsedSpace]) AS UsedSpaceChange
	FROM @TT AS T1
	LEFT OUTER JOIN @TT AS T2
	ON [T1].[ServerSystemID] = [T2].[ServerSystemID]
	AND [T1].[DiskID] = [T2].[DiskID]
	AND [T1].[DiskDateRank] = [T2].[DiskDateRank] - 1
	ORDER BY 
	[T1].[ServerSystemID] 
	,[T1].[DiskID]
	,[T1].[LatestReportedDate] DESC

	
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPhysicalDisks_DatabaseFileCount]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
Author: Danny Howell
Description: query to return the current disk space information by server and disk over an input percentage.  
*/
CREATE PROCEDURE [dbo].[usp_ServerPhysicalDisks_DatabaseFileCount]
(@pIncludeNonProdInd BIT)
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @SCDCurrentRecordIndLow INT = 1
	DECLARE @SCDCurrentRecordIndHigh INT = 1
	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow

	IF @pIncludeNonProdInd = 1
	BEGIN
		SET @ProductionIndLow = 0
	END

	
	DECLARE @DiskUsage TABLE ([HostName] VARCHAR(128),[InstanceName] VARCHAR(128),[ProductionBitInd] BIT, [ProductionInd] VARCHAR(3) ,[LocalHostDescription] VARCHAR(128),[DriveLetter] VARCHAR(1),  [DiskSize] BIGINT, [FreeSpace] BIGINT, [UsedSpace] BIGINT, [PercentFree] NUMERIC(7,4), [PercentUsed] NUMERIC(7,4))

	DECLARE @Disks TABLE (ServerSystemID INT, ServerPhysicalDiskID BIGINT,  HostName	VARCHAR(128), [FreeSpace] BIGINT, [DiskSize] BIGINT,
	LatestReportedDate DATE, DriveLetter VARCHAR(3))

	INSERT INTO @Disks(ServerSystemID, ServerPhysicalDiskID,  HostName, [FreeSpace], [DiskSize], LatestReportedDate, DriveLetter)
	SELECT  
		MSPD1.ServerSystemID
		,SPD1.ServerPhysicalDiskID
		,SPD1.HostName	
		,SPD1.FreeSpace
		,SPD1.DiskSize
		,SPD1.LatestReportedDate
		,MSPD1.DriveLetter
		FROM	[dbo].[vw_ServerPhysicalDisks] AS SPD1
		INNER JOIN (
			SELECT
			[ServerSystemID]
			,SUBSTRING([DiskID],1,1) AS DriveLetter
			,MAX(ServerPhysicalDiskID) AS LatestSPDID
			FROM [dbo].[vw_ServerPhysicalDisks]
			GROUP BY 
			[ServerSystemID]
			,SUBSTRING([DiskID],1,1)
			) AS MSPD1
		ON [SPD1].[ServerPhysicalDiskID] = [MSPD1].[LatestSPDID]


	--INSERT INTO @DiskUsage ([HostName],[InstanceName],[ProductionBitInd],[ProductionInd],[LocalHostDescription],[DriveLetter], [DiskSize], [FreeSpace], [UsedSpace], [PercentFree], [PercentUsed])
	SELECT
	UPPER([SI1].[HostName]) as VM
	,[SI1].[ServerInstanceID]
	,[SI1].[ProductionBitInd]
	,[SI1].[ProductionInd]
	,[SI1].[LocalHostDescription]
	,ISNULL([DBD1].[CountofDatabaseFilesOnDisk],0) AS CountofDatabaseFilesOnDisk
	,ISNULL([DBD1].CountOfDatabasesOnDisk,0) AS CountOfDatabasesOnDisk
	,[D1].[DriveLetter]
	,[D1].[DiskSize]
	,[D1].[FreeSpace]
	,[D1].[DiskSize]-[D1].[FreeSpace] as [UsedSpace]
	,CASE WHEN [D1].[DiskSize] > 0 THEN CAST((cast([D1].[FreeSpace] as numeric(25,3))/cast([D1].[DiskSize] as numeric(25,3))) AS DECIMAL(8,4)) * 100 ELSE 0 END AS [PercentFree]
	,CASE WHEN [D1].[DiskSize] > 0 THEN (1- CAST((cast([D1].[FreeSpace] as numeric(25,3))/cast([D1].[DiskSize] as numeric(25,3))) AS DECIMAL(8,4))) * 100 ELSE 0 END AS [PercentUsed]
	FROM dbo.vw_ServerInstances_InventoryDiagram as SI1
	LEFT OUTER JOIN
	(
		SELECT 
		[SI1].[ServerSystemID]
		,[DB1].[ServerInstanceID]
		,SUBSTRING([DBF1].[FileFullName],1,1) as DriveLetter
		,COUNT([DB1].[DatabaseName]) as CountOfDatabasesOnDisk
		,COUNT(SUBSTRING(dbf1.FileFullName,1,1)) as CountofDatabaseFilesOnDisk
		FROM [dbo].[vw_DatabaseFiles] as DBF1
		INNER JOIN [dbo].[vw_Databases] as DB1
		ON [DBF1].[DatabaseUniqueID] = [DB1].[DatabaseUniqueId]
		INNER JOIN [dbo].[vw_ServerInstances] AS SI1
		ON [DB1].[ServerInstanceId] = [SI1].[ServerInstanceID]
		WHERE
		[DBF1].[ETLProcessID] = (select MAX([etlprocessid]) FROM [dbo].[ETLProcesses])
		GROUP BY [SI1].[ServerSystemID],[DB1].[ServerInstanceID],SUBSTRING([DBF1].[FileFullName],1,1)
		) AS DBD1
	ON [SI1].[ServerSystemID] = [DBD1].[ServerSystemID]
	AND [SI1].[ServerInstanceID] = [DBD1].[ServerInstanceId]
	LEFT OUTER JOIN @Disks AS D1
	ON [DBD1].[ServerSystemID] = [D1].[ServerSystemID]
	AND [DBD1].[DriveLetter] = [D1].[DriveLetter] 
	WHERE [SI1].[ProductionBitInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
	order by 
	UPPER([SI1].[HostName])
	,d1.DriveLetter

	
	

	
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPhysicalDisks_UsedSpaceAbovePercent]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
Author: Danny Howell
Description: query to return the current disk space information by server and disk over an input percentage.  
*/
CREATE PROCEDURE [dbo].[usp_ServerPhysicalDisks_UsedSpaceAbovePercent]
(@pPercentageUsed INT
,@pDiskMetric VARCHAR(5)
,@pIncludeNonProdInd BIT)
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @SCDCurrentRecordIndLow INT = 1
	DECLARE @SCDCurrentRecordIndHigh INT = 1
	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow

	IF @pIncludeNonProdInd = 1
	BEGIN
		SET @ProductionIndLow = 0
	END

	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	INSERT INTO @ServerSystemIDs
	SELECT DISTINCT [ServerSystemID]
	FROM [dbo].[vw_Servers]
	WHERE [ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
	
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	--First determine if this is a production service account or a non-production service account
	IF (@pPercentageUsed <= 0) OR (@pPercentageUsed IS NULL)
	BEGIN
		SET @currObject = '@pPercentageFull'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;
	
	DECLARE @ddef TABLE (diskvaldivisor int, DiskMetric VARCHAR(5))
	INSERT INTO @ddef
	values (0,'BYTES')
	INSERT INTO @ddef
	values (1,'KB')
	INSERT INTO @ddef
	values (2,'MB')
	INSERT INTO @ddef
	values(3,'GB')

	SET @currObject = '@pDiskMetric'
	IF NOT EXISTS (SELECT * FROM @ddef WHERE DiskMetric = @pDiskMetric)
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or INVALID value (%s) was passed to the input parameter. Value must be one of either BYTES, KB, MB or GB'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pDiskMetric);
		THROW 60000 , @msg, 1 
	END;

	DECLARE @diskvaldivisor DECIMAL(18,3)
	SELECT @diskvaldivisor = POWER(1024,diskvaldivisor) FROM @ddef
	WHERE DiskMetric = @pDiskMetric

	PRINT (N'Disk space shown in ' + @pDiskMetric + CAST(@diskvaldivisor AS VARCHAR(19)))

	DECLARE @ServerPhysicalDisks TABLE ([ServerSystemID] INT,[DiskID] NVARCHAR(3),[ServerPhysicalDiskID] BIGINT)
	INSERT INTO @ServerPhysicalDisks
	SELECT DISTINCT 
	[T1].[ServerSystemID]
	,[T1].[DiskID]
	,[T1].[ServerPhysicalDiskID]
	FROM [dbo].[ServerPhysicalDisks] AS [T1]
	INNER JOIN @ServerSystemIDs AS [T2]
	ON [T1].[ServerSystemID] = [T2].[pServerSystemID]
	WHERE [ETLProcessId] = (SELECT MAX([ETLProcessId]) FROM [dbo].[ETLProcesses]);


	DECLARE @TT TABLE (
	ServerSystemID INT
	,HostName VARCHAR(128)
	,ETLProcessId INT
	,ProductionInd BIT
	,DiskID CHAR(4)
	,LatestReportedDate DATE
	,DiskSpaceMetric VARCHAR(10)
	,DiskSize NUMERIC(18,3)
	,FreeSpace NUMERIC(18,3)
	,UsedSpace NUMERIC(18,3)
	,PercentFree DECIMAL(7,3)
	,PercentUsed DECIMAL(7,3))

	INSERT INTO @TT (ServerSystemID,HostName,ETLProcessId,ProductionInd,DiskID,LatestReportedDate,DiskSpaceMetric,DiskSize,FreeSpace,UsedSpace,PercentFree,PercentUsed)
	SELECT
	[S1].[ServerSystemID]
	,[S1].[HostName]
	,[SPD1].[ETLProcessId]
	,[S1].[ProductionInd]
	,[SPD1].[DiskID]
	,[SPD1].[LatestReportedDate] 
	,@pDiskMetric AS DiskSpaceMetric
	,CAST(CAST([SPD1].[DiskSize] AS decimal(18,3))/@diskvaldivisor AS DECIMAL(18,3)) AS DiskSize
	,CAST(CAST([SPD1].[FreeSpace] AS decimal(18,3))/@diskvaldivisor AS DECIMAL(18,3)) AS FreeSpace
	,CAST(CAST(([SPD1].[DiskSize] - [SPD1].[FreeSpace]) AS decimal(18,3)) /@diskvaldivisor AS DECIMAL(18,3)) AS UsedSpace
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN CAST((cast([SPD1].[FreeSpace] as numeric(18,3))/cast([SPD1].[DiskSize] as numeric(18,3))) AS DECIMAL(7,3)) * 100 ELSE 0 END AS [PercentFree]
	,CASE WHEN [SPD1].[DiskSize] > 0 THEN (1- CAST((cast([SPD1].[FreeSpace] as numeric(18,3))/cast([SPD1].[DiskSize] as numeric(18,3))) AS DECIMAL(7,3))) * 100 ELSE 0 END AS [PercentUsed]
	FROM [dbo].[vw_Servers] AS S1
	LEFT OUTER JOIN [dbo].[vw_ServerPhysicalDisks] AS SPD1
	ON [S1].[ServerSystemID] = [SPD1].[ServerSystemID]
	INNER JOIN @ServerPhysicalDisks AS pS1
	ON [SPD1].[ServerSystemID]  = [pS1].[ServerSystemID]
	AND [SPD1].[DiskID] = [pS1].[DiskID]
	AND [SPD1].[ServerPhysicalDiskID] = [pS1].[ServerPhysicalDiskID]

	SELECT
	[ServerSystemID]
	,[HostName]
	,[ETLProcessId]
	,[ProductionInd]
	,[DiskID]
	,[LatestReportedDate]
	,[DiskSpaceMetric]
	,[DiskSize]
	,[FreeSpace]
	,[UsedSpace]
	,[PercentFree]
	,[PercentUsed]
	FROM @TT
	WHERE [PercentUsed] >= @pPercentageUsed
	
END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalLogins_CreatePWSafeImport]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_ServerPrincipalLogins_CreatePWSafeImport]
(@ApplicationName VARCHAR(50)
,@PWPrimaryFolder VARCHAR(50)
,@SpecificUserID VARCHAR(128)
,@IsForDesktopBasedApplications BIT)
AS

/*
Exporting the ServerPrincipalLogins for import into PWSafe requires a very specific format and text encoding.  The only required fields are Group/Title,Username and Password but the below query includes the Created Time and Notes fields.  If the import fails when these two fields are included, comment them out of the query and retry.

To create a file which can be imported to PWSafe Vault, you must follow these exact steps:
1) Update the @PWPrimaryFolder to the 'root' folder in the vault under which the service accounts are stored.
2) Update the @ApplicationName to the Application name for which exporting to the vault.  The application name must be one of the application names in the dbo.applications table
3) Confirm that your Tools > Options > Query Results > SQL Server > Results to Text are set with Output format=Tab Delimited and the "Include column headers in the result set" option is checked.  You may need to close and reopen this file if you change these settings.
4) Direct the query to file.  The file can have any file extension
5) After the results file is created, open the results with NotePad++.  
--Change the file encoding--You must open with NotePad++ to change the Encoding to "Encode to UTF-8".  SQL results files may save the results as "Encode to UTF-8-BOM" but this format is not compatible with the PWSafe importer
--Delete any extra lines after the last record--SQL output tends to pad extra lines after the last record.  While those are usually skipped during the import, it is best to delete them prior to importing the file.
6) Run the File > Import > Plain Text process in the PWSafe vault.  If steps 1-5 are followed, the file should be importable without making any import setting changes

This same query can be used to UPDATE existing passwords but to update, you must check the "Import to Change passwords of existing entries ONLY" box in the Import Text Settings

REMEMBER TO DELETE THE EXPORT FILE ONCE THE IMPORT TO PWSAFE IS FINISHED.
THE PASSWORDS ARE IN PLAIN TEXT AND THE FILE MUST BE DELETED OTHERWISE PASSWORDS ARE EXPOSED.

*/
BEGIN
SET NOCOUNT ON
--DECLARE error handling variables
BEGIN TRY
DECLARE @PWSafeContainer VARCHAR(50);
DECLARE @PWSafeApplication VARCHAR(50);
DECLARE @PWSGroup nvarchar(50);
DECLARE @PWSEntityName nvarchar(50);
declare @username nvarchar(128);
declare @password nvarchar(128);
DECLARE @PlatformString varchar(15);
DECLARE @PlatformDesc varchar(60);


DECLARE @msg VARCHAR(2048)
DECLARE @currObject VARCHAR(128)
DECLARE @currprod VARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)
IF NOT EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @ApplicationName)
	BEGIN
		SET @currObject = '@applicationcreatedforname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - An application by this name does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;

IF @IsForDesktopBasedApplications = 1
BEGIN
	SET @PlatformString = '[A-E][N-P]D%'
	SET @PlatformDesc = '--For Apps running on Desktops'
END
ELSE
BEGIN
	SET @PlatformString = '[A-E][N-P]S%'
	SET @PlatformDesc = '--For Apps running on Servers'
END

DECLARE @AppID CHAR(3)
SELECT @AppID = CAST([FormattedApplicationID] AS CHAR(3)) FROM [dbo].[vw_Applications]
WHERE [ApplicationName] = @ApplicationName


SELECT @SpecificUserID = COALESCE(@SpecificUserID,'%')


SELECT 
@username = [SPL1].[UserId]
,@password = [SPL1].[CurrentPassword]
,@PWSEntityName = [DAR1].[RoleName]
,@PWSafeApplication= [APP1].[ApplicationName]
FROM [dbo].[ServerPrincipalsLogins] AS SPL1
LEFT OUTER JOIN [dbo].[vw_DataAccessRoles] AS DAR1
ON CAST(SUBSTRING([SPL1].[UserID],9,2) AS VARCHAR(2)) = [DAR1].[FormattedCustomRoleID]
LEFT OUTER JOIN [dbo].[vw_Applications] AS APP1
ON [SPL1].[PrimaryApplicationID] = [APP1].[ApplicationId]
WHERE [ApplicationCreatedForName] like @ApplicationName
AND [SPL1].[UserId] LIKE @PlatformString
;

SELECT DISTINCT
CONCAT(@PWPrimaryFolder,'.',CASE WHEN [DAR1].[environmentscope] LIKE 'P' THEN 'Production' ELSE 'Dev' END,'.',[APP1].[ApplicationName],'.',[RoleName],' - ',ISNULL(APPDB1.[DatabaseName],'ALL')) AS [Group/Title]
,[SPL1].[UserId] AS [Username]
,[SPL1].[CurrentPassword] AS [Password]
,CONCAT(CONVERT(VARCHAR(11),GETDATE(),111),' ', CONVERT(VARCHAR(8),GETDATE(),108)) AS [Created Time]
,CONCAT('"',[SPL1].[Description] + ' (' + ISNULL(APPDB1.[DatabaseName],'ALL') + ' database(s))' +   @PlatformDesc,'"') as [Notes]
FROM [dbo].[ServerPrincipalsLogins] AS SPL1
LEFT OUTER JOIN [dbo].[vw_DataAccessRoles] AS DAR1
ON CAST(SUBSTRING([SPL1].[UserID],9,2) AS VARCHAR(2)) = [DAR1].[FormattedCustomRoleID]
LEFT OUTER JOIN [dbo].[vw_Applications] AS APP1
ON [SPL1].[PrimaryApplicationID] = [APP1].[ApplicationId]
LEFT OUTER JOIN 
	(
	SELECT [ApplicationName]
      ,[FormattedApplicationID]
      ,[DatabaseUniqueId]
      ,[DatabaseName]
      ,[ApplicationID]
      ,[ApplicationDatabaseSeqID]
	FROM [dbo].[vw_Applications_Databases]
	) AS APPDB1
ON cast(SUBSTRING([SPL1].[UserId],7,2) as int) = [APPDB1].[ApplicationDatabaseSeqID]
AND cast(SUBSTRING([SPL1].[UserId],4,3) as int) = [APPDB1].[ApplicationID]
where cast(SUBSTRING([SPL1].[UserId],4,3) as CHAR(3)) = @AppID
and [DAR1].[RoleName] is not null
AND [SPL1].[UserId] like @SpecificUserID
AND [SPL1].[UserRetiredInd] = 0
AND [SPL1].[UserId] LIKE @PlatformString
ORDER BY [SPL1].[UserId] 
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF

END;
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_ins_ETLAccounts]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROC [dbo].[usp_ServerPrincipalsLogins_ins_ETLAccounts] 
(@servernameid varchar(128),
@applicationcreatedforname varchar(128),
@dataaccessrole varchar(128),
@currentpassword varchar(128),
@isdesktoptier bit,
@isproductionuser bit,
@isforspecificdatabase bit,
@databasename varchar(128),
@userrequestedby varchar(50),
@approvedby varchar(50))
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @createdate DATE = CAST(GETDATE() AS DATE);
	DECLARE @creator VARCHAR(128) = SYSTEM_USER;
	DECLARE @createuserTSQL VARCHAR(1000);
	DECLARE @appdatabaseidstring VARCHAR(2);
	DECLARE @appdatabaseid INT;
	DECLARE @userdefaultdatabasename VARCHAR(128)
	SET @createuserTSQL = 'CREATE LOGIN [<uname>]  WITH PASSWORD=N<upassword>, DEFAULT_DATABASE=[<udefaultdatabase>], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF; GRANT VIEW ANY DEFINITION TO [<uname>]; GRANT VIEW SERVER STATE TO [<uname>]; USE [TEMPDB]; CREATE USER [<uname>] FOR LOGIN [<uname>]; ALTER ROLE [db_owner] ADD MEMBER [<uname>];'
	
	DECLARE @applicationid int
	DECLARE @environmentusedin varchar(1)
	DECLARE @formattedroleid varchar(3)
	DECLARE @isrestricteduser bit;
	DECLARE @formattedapplicationid varchar(3);
	DECLARE @systemtier varchar(1);
	DECLARE @passworditeration tinyint = 1;
	DECLARE @userid VARCHAR(128);
	DECLARE @description VARCHAR(300);
	
	--Set default values for new records
	DECLARE @userretiredind BIT = 0;
	DECLARE @usertype VARCHAR(15) = 'SQL';
	DECLARE @userplatform VARCHAR(15) = 'Windows';
	DECLARE @LastModifiedDate DATE = @createdate;
	DECLARE @PreviousPassword VARCHAR(128) = NULL;
	--DECLARE error handling variables
	DECLARE @msg VARCHAR(2048)
	DECLARE @currObject VARCHAR(128)
	DECLARE @currprod VARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)

	-- Certain fields cannot be null, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	--First determine if this is a production service account or a non-production service account
	IF (@isproductionuser IS NOT NULL) AND (@isproductionuser BETWEEN 0 AND 1)
	BEGIN
		IF (@isproductionuser = 1 ) 
		BEGIN
		SET @environmentusedin = 'P'
		END
		ELSE
		BEGIN
		SET @environmentusedin = 'N'
		END;
	END;
	ELSE
	BEGIN
		SET @currObject = '@isproductionuser'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;

	--Next determine if for a server or desktop
	IF (@isdesktoptier IS NOT NULL) AND (@isdesktoptier BETWEEN 0 AND 1)
	BEGIN
		IF @isdesktoptier = 0
		BEGIN
		SET @systemtier = 'S'
		END
		ELSE
		BEGIN
		SET @systemtier = 'D'
		END; 
	END
	ELSE
	BEGIN
		SET @currObject = '@isdesktoptier'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	--Next determine if for a server or desktop
	IF (@databasename IS NOT NULL)
	BEGIN
		IF EXISTS (SELECT * FROM [dbo].[Databases] WHERE [databasename] = @databasename)
		BEGIN
		SELECT TOP 1 @appdatabaseid = [ExtendedPropertyValue] FROM [dbo].[vw_DatabaseExtendedProperties] AS [DBA1]
		INNER JOIN [dbo].[vw_Databases] AS [DBS1]
		ON [DBA1].[DatabaseUniqueId] = [DBS1].[DatabaseUniqueId]
		WHERE [DBA1].[ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
		AND [DBS1].[DatabaseName] = @databasename;

		SET @appdatabaseidstring = RIGHT(CONCAT('00',CAST(@appdatabaseid AS VARCHAR(2))),2);
		SET @userdefaultdatabasename = @databasename
		SET @createuserTSQL = CONCAT(@createuserTSQL,' USE [<udefaultdatabase>]; CREATE USER [<uname>] FOR LOGIN [<uname>];')
		END
		ELSE
		BEGIN
		SET @currObject = '@isforspecificdatabase'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter.  SQL Logins for ETL purpose must specify a specific database, but no database found in KFBSQLMgmt database by the name provided.  Please input correct database name'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
		END; 
	END
	ELSE
	BEGIN
		IF ISNULL(@isforspecificdatabase,0) = 0
		BEGIN
			SET @appdatabaseidstring = '00'
		END
		ELSE
		BEGIN
			EXEC sys.sp_addmessage
			@msgnum   = 60000
			,@severity = 10
			,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter.  SQL Logins for ETL purpose must specify a specific database, but a NULL value was provided for the database name.  Please input correct database name'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
			THROW 60000 , @msg, 1 
		END
	END
			
	-- Confirm the named role exists for this environment, if it does not, throw an error
	IF EXISTS (SELECT * FROM [dbo].[vw_DataAccessRoles] WHERE [RoleName] = @dataaccessrole AND [IsProductionRoleInd] = @isproductionuser)
	BEGIN
	SELECT 
		@formattedroleid = [FormattedCustomRoleID]
		,@description = [RoleName]
		,@isrestricteduser = [HighlyPrivilegedRoleInd]
		FROM [dbo].[vw_DataAccessRoles] 
		WHERE [RoleName] = @dataaccessrole AND [IsProductionRoleInd] = @isproductionuser
	END
	ELSE
	BEGIN
		SET @currObject = '@dataaccessrole'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - A data access role for the indicated production or non-production environment does not exist.  Correct the role name or the environment'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;
	
	-- Confirm the named Application exists.  If it does not
	IF EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @applicationcreatedforname)
	BEGIN
		SELECT @formattedapplicationid = RIGHT(CONCAT('000',[ApplicationID]),3) 
		,@description = CONCAT(@description,' for the ',[ApplicationName])
		,@applicationid = ApplicationId
		FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @applicationcreatedforname
	END
	ELSE
	BEGIN
		SET @currObject = '@applicationcreatedforname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - An application by this name does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;

	SET @userid = CONCAT('E',@environmentusedin,@systemtier,@formattedapplicationid,@appdatabaseidstring,@formattedroleid,cast(@passworditeration as varchar(1)))
	IF EXISTS (SELECT * FROM [dbo].[vw_ServerPrincipalsLogins] where [Userid] like @userid AND [ServerNameId] LIKE @servernameid)
	BEGIN
		DECLARE @seconduserid VARCHAR(128);
		SET @passworditeration = 2
		SET @seconduserid = CONCAT('E',@environmentusedin,@systemtier,@formattedapplicationid,@appdatabaseidstring,@formattedroleid,cast(@passworditeration as varchar(1)))

		IF EXISTS (SELECT * FROM [dbo].[vw_ServerPrincipalsLogins] where [Userid] like @seconduserid AND [ServerNameId] LIKE @servernameid)
		BEGIN
			SET @currObject = 'User ID'
			EXEC sys.sp_addmessage
			@msgnum   = 60000
			,@severity = 10
			,@msgtext  = N'Primary key violation %s: %s - Both iterations of the User ID already exist.  Please review all input parameters for correct values or use the current active account.'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
			THROW 60000 , @msg, 1 
		END
		ELSE
		BEGIN
		UPDATE [dbo].[ServerPrincipalsLogins]
		SET [UserRetiredInd] = 1
		WHERE [UserID] = @userid
		SET @userid = @seconduserid
		END
	END
	
		BEGIN TRANSACTION
		INSERT INTO [dbo].[ServerPrincipalsLogins]
		([UserId]
		,[ServerNameId]
		,[ApplicationDatabaseSeqID]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[AssignedDatabaseName]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd])
		VALUES
		(@UserId
		,@ServerNameId
		,@appdatabaseid
		,@IsRestrictedUser
		,@CurrentPassword
		,@databasename
		,@UserPlatform
		,@UserType
		,@applicationid
		,@ApplicationCreatedForName
		,@UserRequestedBy
		,@ApprovedBy
		,@CreateDate
		,@LastModifiedDate
		,@Description
		,@Creator
		,@EnvironmentUsedIn
		,@PreviousPassword
		,@UserRetiredInd)
			
		-- Begin Return Select <- do not remove
		SELECT 
		[UserId]
		,[ServerNameId]
		,[ApplicationDatabaseSeqID]
		,[AssignedDatabaseName]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE  [servernameid] = @servernameid AND [userid] = @userid
		-- End Return Select <- do not remove

		--Build and return statement to create the SQL Login
		SET @currentpassword = QUOTENAME(@currentpassword,'''')
		IF (@databasename IS NULL)
		BEGIN
			SET @createuserTSQL = REPLACE(@createuserTSQL,'DEFAULT_DATABASE=[<udefaultdatabase>],','')
			SET @createuserTSQL = REPLACE(@createuserTSQL,'USE [<udefaultdatabase>]; CREATE USER [<uname>] FOR LOGIN [<uname>];','')
		END
		ELSE
		BEGIN
			SET @createuserTSQL = REPLACE(@createuserTSQL,'<udefaultdatabase>',@userdefaultdatabasename)
		END
		SET @createuserTSQL = REPLACE(@createuserTSQL,'<uname>',@userid)
		SET @createuserTSQL = REPLACE(@createuserTSQL,'<upassword>',@currentpassword)
		
		--Execute this statement on the target server
		PRINT @createuserTSQL

		SELECT 'SELECT ' + CHAR(39) + [UserId] + CHAR(39) + ',' + CHAR(39) + [CurrentPassword] + CHAR(39) + ',' + CHAR(39) + isnull([AssignedDatabaseName],'ALLDATABASES') + CHAR(39) + ',0 UNION' 
		,[servernameid],[ApplicationCreatedForName]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE
		userid like @userid
		and ServerNameId = @servernameid
		order by servernameid, UserId
		
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_ins_OtherTypes]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_ServerPrincipalsLogins_ins_OtherTypes] 
    @servernameid VARCHAR(128),
    @userid VARCHAR(128),
    @isrestricteduser bit,
    @currentpassword VARCHAR(128),
    @userplatform VARCHAR(50),
    @usertype VARCHAR(50),
    @applicationcreatedforname VARCHAR(128),
    @userrequestedby VARCHAR(50),
   	@approvedby VARCHAR(50),
    @createdate date,
    @lastmodifieddate date,
    @description VARCHAR(300),
    @creator VARCHAR(128),
    @environmentusedin VARCHAR(50),
    @previouspassword VARCHAR(128),
    @userretiredind bit
AS 
	SET NOCOUNT ON 
	  
	
	BEGIN TRAN

	INSERT INTO [dbo].[ServerPrincipalsLogins]
	([UserId]
	,[ServerNameId]
	,[IsRestrictedUser]
	,[CurrentPassword]
	,[UserPlatform]
	,[UserType]
	,[ApplicationCreatedForName]
	,[UserRequestedBy]
	,[ApprovedBy]
	,[CreateDate]
	,[LastModifiedDate]
	,[Description]
	,[Creator]
	,[EnvironmentUsedIn]
	,[PreviousPassword]
	,[UserRetiredInd])
	VALUES 
	(@UserId
	,@ServerNameId
	,@IsRestrictedUser
	,@CurrentPassword
	,@UserPlatform
	,@UserType
	,@ApplicationCreatedForName
	,@UserRequestedBy
	,@ApprovedBy
	,@CreateDate
	,@LastModifiedDate
	,@Description
	,@Creator
	,@EnvironmentUsedIn
	,@PreviousPassword
	,@UserRetiredInd)
	
	-- Begin Return Select <- do not remove
	SELECT [UserId]
      ,[ServerNameId]
      ,[IsRestrictedUser]
      ,[CurrentPassword]
      ,[UserPlatform]
      ,[UserType]
      ,[ApplicationCreatedForName]
      ,[UserRequestedBy]
      ,[ApprovedBy]
      ,[CreateDate]
      ,[LastModifiedDate]
      ,[Description]
      ,[Creator]
      ,[EnvironmentUsedIn]
      ,[PreviousPassword]
      ,[UserRetiredInd]
	FROM [dbo].[ServerPrincipalsLogins]
	WHERE  [servernameid] = @servernameid AND [userid] = @userid
	-- End Return Select <- do not remove
               
	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_ins_RecordCopiedLogin]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_ServerPrincipalsLogins_ins_RecordCopiedLogin]
@SourceServerName VARCHAR(128) , 
@SQLLoginCopied VARCHAR(128) ,
@TargetServerName VARCHAR(128),
@SQLLoginNameonTargetServer VARCHAR(128)
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
BEGIN TRY
	-- If copying to a different server and the name is unchanged, leave the @SQLLoginNameonTargetServer null
	SELECT @SQLLoginNameonTargetServer = COALESCE(@SQLLoginNameonTargetServer,@SQLLoginCopied)
	BEGIN TRANSACTION
	INSERT INTO [dbo].[ServerPrincipalsLogins]
           ([UserId]
           ,[ServerNameId]
           ,[ApplicationDatabaseSeqID]
           ,[IsRestrictedUser]
           ,[CurrentPassword]
           ,[AssignedDatabaseName]
           ,[UserPlatform]
           ,[UserType]
           ,[PrimaryApplicationID]
           ,[ApplicationCreatedForName]
           ,[UserRequestedBy]
           ,[ApprovedBy]
           ,[CreateDate]
           ,[LastModifiedDate]
           ,[Description]
           ,[Creator]
           ,[EnvironmentUsedIn]
           ,[PreviousPassword]
           ,[UserRetiredInd])
     SELECT 
		@SQLLoginNameonTargetServer
		,@TargetServerName
		,[ApplicationDatabaseSeqID]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[AssignedDatabaseName]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE ServerNameId = @SourceServerName
		AND UserId = @SQLLoginCopied
	COMMIT TRANSACTION

	SELECT [UserId]
	,[ServerNameId]
	,[ApplicationDatabaseSeqID]
	,[IsRestrictedUser]
	,[CurrentPassword]
	,[AssignedDatabaseName]
	,[UserPlatform]
	,[UserType]
	,[PrimaryApplicationID]
	,[ApplicationCreatedForName]
	,[UserRequestedBy]
	,[ApprovedBy]
	,[CreateDate]
	,[LastModifiedDate]
	,[Description]
	,[Creator]
	,[EnvironmentUsedIn]
	,[PreviousPassword]
	,[UserRetiredInd]
	FROM [dbo].[ServerPrincipalsLogins]
	WHERE UserId = @SQLLoginNameonTargetServer
	AND ServerNameId = @TargetServerName

END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_ins_SQLServiceAccounts]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROC [dbo].[usp_ServerPrincipalsLogins_ins_SQLServiceAccounts] 
(@servernameid varchar(128),
@applicationcreatedforname varchar(128),
@dataaccessrole varchar(128),
@currentpassword varchar(128),
@isdesktoptier bit,
@isproductionuser bit,
@isforspecificdatabase bit,
@databasename varchar(128),
@userrequestedby varchar(50),
@approvedby varchar(50))
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	DECLARE @createdate DATE = CAST(GETDATE() AS DATE);
	DECLARE @creator VARCHAR(128) = SYSTEM_USER;
	DECLARE @createuserTSQL VARCHAR(1000);
	DECLARE @appdatabaseidstring VARCHAR(2);
	DECLARE @appdatabaseid INT;
	DECLARE @userdefaultdatabasename VARCHAR(128)
	SET @createuserTSQL = 'CREATE LOGIN [<uname>]  WITH PASSWORD=N<upassword>, DEFAULT_DATABASE=[<udefaultdatabase>], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF; GRANT VIEW ANY DEFINITION TO [<uname>]; GRANT VIEW SERVER STATE TO [<uname>]; USE [TEMPDB]; CREATE USER [<uname>] FOR LOGIN [<uname>]; ALTER ROLE [db_owner] ADD MEMBER [<uname>];'

	DECLARE @applicationid int
	DECLARE @environmentusedin varchar(1)
	DECLARE @formattedroleid varchar(3)
	DECLARE @isrestricteduser bit;
	DECLARE @formattedapplicationid varchar(3);
	DECLARE @systemtier varchar(1);
	DECLARE @passworditeration tinyint = 1;
	DECLARE @userid VARCHAR(128);
	DECLARE @description VARCHAR(300);
	
	--Set default values for new records
	DECLARE @userretiredind BIT = 0;
	DECLARE @usertype VARCHAR(15) = 'SQL';
	DECLARE @userplatform VARCHAR(15) = 'Windows';
	DECLARE @LastModifiedDate DATE = @createdate;
	DECLARE @PreviousPassword VARCHAR(128) = NULL;
	--DECLARE error handling variables
	DECLARE @msg VARCHAR(2048)
	DECLARE @currObject VARCHAR(128)
	DECLARE @currprod VARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	--First determine if this is a production service account or a non-production service account
	IF (@isproductionuser IS NOT NULL) AND (@isproductionuser BETWEEN 0 AND 1)
	BEGIN
		IF (@isproductionuser = 1 ) 
		BEGIN
		SET @environmentusedin = 'P'
		END
		ELSE
		BEGIN
		SET @environmentusedin = 'N'
		END;
	END;
	ELSE
	BEGIN
		SET @currObject = '@isproductionuser'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;

	--Next determine if for a server or desktop
	IF (@isdesktoptier IS NOT NULL) AND (@isdesktoptier BETWEEN 0 AND 1)
	BEGIN
		IF @isdesktoptier = 0
		BEGIN
		SET @systemtier = 'S'
		END
		ELSE
		BEGIN
		SET @systemtier = 'D'
		END; 
	END
	ELSE
	BEGIN
		SET @currObject = '@isdesktoptier'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	--Next determine if for a server or desktop
	IF (@isforspecificdatabase IS NOT NULL) AND (@isforspecificdatabase = 1)
	BEGIN
		IF EXISTS (SELECT * FROM [dbo].[Databases] WHERE [databasename] = @databasename)
		BEGIN
		SELECT TOP 1 @appdatabaseid = [ExtendedPropertyValue] FROM [dbo].[vw_DatabaseExtendedProperties] AS [DBA1]
		INNER JOIN [dbo].[vw_Databases] AS [DBS1]
		ON [DBA1].[DatabaseUniqueId] = [DBS1].[DatabaseUniqueId]
		WHERE [DBA1].[ExtendedPropertyName] = 'ApplicationDatabaseSeqID'
		AND [DBS1].[DatabaseName] = @databasename;

		SET @appdatabaseidstring = RIGHT(CONCAT('00',CAST(@appdatabaseid AS VARCHAR(2))),2);
		SET @userdefaultdatabasename = @databasename
		SET @createuserTSQL = CONCAT(@createuserTSQL,' USE [<udefaultdatabase>]; CREATE USER [<uname>] FOR LOGIN [<uname>];')
		END
		ELSE
		BEGIN
		SET @currObject = '@isforspecificdatabase'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL or invalid value was passed to the input parameter.  Boolean value indicates user is for a specific database, yet no database found in KFBSQLMgmt database by the name provided.  Please input correct database name'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
		END; 
	END
	ELSE
	BEGIN
	SET @appdatabaseidstring = '00';
	SET @appdatabaseid = 0;
	SET @userdefaultdatabasename = 'TEMPDB'
	SET @databasename = NULL;
	END
			
	-- Confirm the named role exists for this environment, if it does not, throw an error
	IF EXISTS (SELECT * FROM [dbo].[vw_DataAccessRoles] WHERE [RoleName] = @dataaccessrole AND [IsProductionRoleInd] = @isproductionuser AND [RoleAuthorityIsLDAP] = 0)
	BEGIN
	SELECT 
		@formattedroleid = [FormattedCustomRoleID]
		,@description = [RoleName]
		,@isrestricteduser = [HighlyPrivilegedRoleInd]
		FROM [dbo].[vw_DataAccessRoles] 
		WHERE [RoleName] = @dataaccessrole AND [IsProductionRoleInd] = @isproductionuser
		
	END
	ELSE
	BEGIN
		SET @currObject = '@dataaccessrole'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - A data access role for the indicated production or non-production environment does not exist.  Correct the role name or the environment'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;
	
	-- Confirm the named Application exists.  If it does not
	IF EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @applicationcreatedforname)
	BEGIN
		SELECT @formattedapplicationid = RIGHT(CONCAT('000',[ApplicationID]),3) 
		,@description = CONCAT(@description,' for the ',[ApplicationName])
		,@applicationid = ApplicationId
		FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @applicationcreatedforname
	END
	ELSE
	BEGIN
		SET @currObject = '@applicationcreatedforname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - An application by this name does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;

	SET @userid = CONCAT('A',@environmentusedin,@systemtier,@formattedapplicationid,@appdatabaseidstring,@formattedroleid,cast(@passworditeration as varchar(1)))
	IF EXISTS (SELECT * FROM [dbo].[vw_ServerPrincipalsLogins] where [Userid] like @userid AND [ServerNameId] LIKE @servernameid)
	BEGIN
		DECLARE @seconduserid VARCHAR(128);
		SET @passworditeration = 2
		SET @seconduserid = CONCAT('A',@environmentusedin,@systemtier,@formattedapplicationid,@appdatabaseidstring,@formattedroleid,cast(@passworditeration as varchar(1)))

		IF EXISTS (SELECT * FROM [dbo].[vw_ServerPrincipalsLogins] where [Userid] like @seconduserid AND [ServerNameId] LIKE @servernameid)
		BEGIN
			SET @currObject = 'User ID'
			EXEC sys.sp_addmessage
			@msgnum   = 60000
			,@severity = 10
			,@msgtext  = N'Primary key violation %s: %s - Both iterations of the User ID already exist.  Please review all input parameters for correct values or use the current active account.'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
			THROW 60000 , @msg, 1 
		END
		ELSE
		BEGIN
		UPDATE [dbo].[ServerPrincipalsLogins]
		SET [UserRetiredInd] = 1
		WHERE [UserID] = @userid
		SET @userid = @seconduserid
		END
	END
	
		BEGIN TRANSACTION
		INSERT INTO [dbo].[ServerPrincipalsLogins]
		([UserId]
		,[ServerNameId]
		,[ApplicationDatabaseSeqID]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[AssignedDatabaseName]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd])
		VALUES
		(@UserId
		,@ServerNameId
		,@appdatabaseid
		,@IsRestrictedUser
		,@CurrentPassword
		,@databasename
		,@UserPlatform
		,@UserType
		,@applicationid
		,@ApplicationCreatedForName
		,@UserRequestedBy
		,@ApprovedBy
		,@CreateDate
		,@LastModifiedDate
		,@Description
		,@Creator
		,@EnvironmentUsedIn
		,@PreviousPassword
		,@UserRetiredInd)
			
		-- Begin Return Select <- do not remove
		SELECT 
		[UserId]
		,[ServerNameId]
		,[ApplicationDatabaseSeqID]
		,[AssignedDatabaseName]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE  [servernameid] = @servernameid AND [userid] = @userid
		-- End Return Select <- do not remove

		--Build and return statement to create the SQL Login
		SET @currentpassword = QUOTENAME(@currentpassword,'''')
		SET @createuserTSQL = REPLACE(@createuserTSQL,'<uname>',@userid)
		SET @createuserTSQL = REPLACE(@createuserTSQL,'<upassword>',@currentpassword)
		SET @createuserTSQL = REPLACE(@createuserTSQL,'<udefaultdatabase>',@userdefaultdatabasename)
		
		--Execute this statement on the target server
		PRINT @createuserTSQL
		
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_sel]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_ServerPrincipalsLogins_sel] 
    @servernameid NVARCHAR(128),
    @userid NVARCHAR(128)
AS 
	SET NOCOUNT ON 
	
	BEGIN TRAN

	SELECT 
	[UserId]
	,[ServerNameId]
	,[IsRestrictedUser]
	,[CurrentPassword]
	,[UserPlatform]
	,[UserType]
	,[ApplicationCreatedForName]
	,[UserRequestedBy]
	,[ApprovedBy]
	,[CreateDate]
	,[LastModifiedDate]
	,[Description]
	,[Creator]
	,[EnvironmentUsedIn]
	,[PreviousPassword]
	,[UserRetiredInd]
	FROM [dbo].[ServerPrincipalsLogins]
	WHERE  ([servernameid] = @servernameid OR @servernameid IS NULL) 
	AND ([userid] = @userid OR @userid IS NULL) 

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_sel_ServiceAccountsByApplication]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_ServerPrincipalsLogins_sel_ServiceAccountsByApplication] 
(@applicationcreatedforname varchar(128),
@ServerNameId varchar(128),
@dataaccessrole varchar(128))
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
	BEGIN TRY
	
	--DECLARE error handling variables
	DECLARE @msg VARCHAR(2048)
	DECLARE @currObject VARCHAR(128)
	DECLARE @currprod VARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)

	SELECT @ServerNameId = ISNULL(@ServerNameId,'%')
	SELECT @dataaccessrole = ISNULL(@dataaccessrole,'%')

	IF NOT EXISTS (SELECT * FROM [dbo].[vw_Applications] WHERE [ApplicationName] = @applicationcreatedforname)
	BEGIN
		SET @currObject = '@applicationcreatedforname'
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - An application by this name does not exist in the Applications table.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END;
	
	
	-- Confirm the named Application exists.  If it does not
	
		BEGIN TRANSACTION
		DECLARE @ApplicationID int
		SELECT @ApplicationID = RIGHT(('000' + ApplicationID),3) FROM [dbo].[Applications]
		WHERE [ApplicationName] LIKE @applicationcreatedforname	
		COMMIT TRANSACTION
		-- Begin Return Select <- do not remove
		
		SELECT 
		[UserId]
		,[ServerNameId]
		,[ApplicationDatabaseSeqID]
		,[AssignedDatabaseName]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[UserPlatform]
		,[UserType]
		,[PrimaryApplicationID]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE  ([userid] LIKE '[A,E][N,P][D,S]%'
		AND isnumeric(SUBSTRING([userid],4,3)) > 0)
		AND SUBSTRING([userid],4,3) = @ApplicationID
		AND [ServerNameId] LIKE @ServerNameId
		ORDER BY 
		[UserId]
		,[ServerNameId]

		-- End Return Select <- do not remove

		
	

END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_upd_Password]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_ServerPrincipalsLogins_upd_Password] 
    @userid varchar(128),
    @servernameid varchar(128),
    @newpassword varchar(128)
AS 
	SET NOCOUNT ON 
	
	BEGIN TRAN
	UPDATE [dbo].[ServerPrincipalsLogins]
	SET [LastModifiedDate] = CAST(GETDATE() AS DATE)
	,[PreviousPassword] = [CurrentPassword]
	WHERE [UserId] = @userid
	AND [ServerNameId] = @ServerNameId
	
	UPDATE [dbo].[ServerPrincipalsLogins]
	SET [CurrentPassword] = @newpassword
	WHERE [UserId] = @userid
	AND [ServerNameId] = @ServerNameId

	-- Begin Return Select <- do not remove
	SELECT 
	[UserId]
	,[ServerNameId]
	,[IsRestrictedUser]
	,[CurrentPassword]
	,[UserPlatform]
	,[UserType]
	,[ApplicationCreatedForName]
	,[UserRequestedBy]
	,[ApprovedBy]
	,[CreateDate]
	,[LastModifiedDate]
	,[Description]
	,[Creator]
	,[EnvironmentUsedIn]
	,[PreviousPassword]
	,[UserRetiredInd]
	FROM   [dbo].[vw_ServerPrincipalsLogins]
	WHERE  [userid] = @userid AND [servernameid] = @servernameid
	-- End Return Select <- do not remove

	COMMIT
GO
/****** Object:  StoredProcedure [dbo].[usp_ServerPrincipalsLogins_upd_RetireUser]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[usp_ServerPrincipalsLogins_upd_RetireUser] 
(@UserId varchar(128)
,@ServerNameId varchar(128)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE [dbo].[ServerPrincipalsLogins]
			SET [UserRetiredInd] = CAST(1 AS BIT)
			WHERE [UserId] = @UserId AND [ServerNameId] = @ServerNameId
		COMMIT TRANSACTION
		SELECT 
		[UserId]
		,[ServerNameId]
		,[IsRestrictedUser]
		,[CurrentPassword]
		,[UserPlatform]
		,[UserType]
		,[ApplicationCreatedForName]
		,[UserRequestedBy]
		,[ApprovedBy]
		,[CreateDate]
		,[LastModifiedDate]
		,[Description]
		,[Creator]
		,[EnvironmentUsedIn]
		,[PreviousPassword]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE [UserId] = @UserId AND [ServerNameId] = @ServerNameId
	END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Servers_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on Servers table.
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_Servers_Ins] (
@pHostName NVARCHAR(128),
@pInKFBDOM1Domain BIT,
@pRetiredInd BIT,
@pReplacedByHost NVARCHAR(255),
@pProductionInd BIT,
@pBusinessCategoryID INT,
@pPrimaryApplicationUsedFor NVARCHAR(100),
@pLocalHostDescription NVARCHAR(256),
@pManagedBySQLDBAsInd BIT,
@pMonitoredbySQLToolsInd BIT,
@pExcludeFromETLProcessesInd BIT,
@pExcludeFromWMIDataLoadInd BIT,
@pExcludeFromServiceRestartInd BIT,
@pUsedByAppSyncInd BIT,
@pUsageScope VARCHAR(50),
@pPrimaryDataProcessModelType VARCHAR(25),
@pOSManufacturer NVARCHAR(30),
@pOSName NVARCHAR(20),
@pOSVersion INT,
@pOSEdition NVARCHAR(30),
@pOSRelease NVARCHAR(10),
@pOSCaption NVARCHAR(128)
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
DECLARE @DateAdded DATE
DECLARE @LatestReportedDate DATE
DECLARE @OSFullVersion NVARCHAR(128)
DECLARE @OSProductType INT
DECLARE @OSType INT
DECLARE @CSDVersion NVARCHAR(128)
DECLARE @OSBuildNumber NVARCHAR(20)
DECLARE @OSLanguage INT
DECLARE @OSSKUId INT
DECLARE @OSVersionID NVARCHAR(15)
DECLARE @ServicePackMajorVersion NVARCHAR(15)
DECLARE @ServicePackMinorVersion NVARCHAR(15)
DECLARE @WindowsDirectory NVARCHAR(256)

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null for new Servers, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	SET @currObject = 'Host Name'
	IF @pHostName IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	IF EXISTS (SELECT * FROM [dbo].[vw_Servers] WHERE HostName  = @pHostName)	
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60001
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - %s does already exists.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg  = FORMATMESSAGE(60001, @currprod,@currObject, @pHostName);
		THROW 60001 , @msg, 1; 
	END
	BEGIN TRAN
	--Certain fields, if NULL values are passed, can be set to default values (logical defaults set here in the procedure, not database defined defaults)
		SET @LatestReportedDate = CAST(GETDATE() AS DATE)
		SET @DateAdded = CAST(GETDATE() AS DATE)
		SET @pInKFBDOM1Domain = ISNULL(@pInKFBDOM1Domain,1)
		SET @pRetiredInd = ISNULL(@pRetiredInd,0)
		SET @pReplacedByHost = @pReplacedByHost
		SET @pProductionInd = ISNULL(@pProductionInd,0)
		SET @pUsageScope = ISNULL(@pUsageScope,'Not Assigned')
		SET @pPrimaryDataProcessModelType = ISNULL(@pPrimaryDataProcessModelType,'Unknown')
		SET @pBusinessCategoryID = ISNULL(@pBusinessCategoryID,1)
		SET @pPrimaryApplicationUsedFor = @pPrimaryApplicationUsedFor
		SET @pLocalHostDescription = @pLocalHostDescription
		SET @pManagedBySQLDBAsInd = ISNULL(@pManagedBySQLDBAsInd,1)
		SET @pMonitoredbySQLToolsInd = ISNULL(@pMonitoredbySQLToolsInd,0)
		SET @pExcludeFromETLProcessesInd = ISNULL(@pExcludeFromETLProcessesInd,0)
		SET @pExcludeFromWMIDataLoadInd = ISNULL(@pExcludeFromWMIDataLoadInd,0)
		SET @pExcludeFromServiceRestartInd = CAST(ISNULL(@PExcludeFromServiceRestartInd,0) AS BIT)
		SET @pUsedByAppSyncInd = CAST(ISNULL(@pUsedByAppSyncInd,0) AS BIT)
		SET @pOSManufacturer = ISNULL(@pOSManufacturer,'Microsoft Corporation')
		SET @pOSName = ISNULL(@pOSName,'Windows Server')
		SET @pOSVersion = ISNULL(@pOSVersion,0)
		SET @pOSEdition = ISNULL(@pOSEdition,'Standard')
		SET @pOSRelease = ISNULL(@pOSRelease,0)
		SET @pOSCaption = ISNULL(@pOSCaption,0)
		--The following fields will be updated by the ETL load process and are allow to set to NULL for initial insert of Servers
		SET @OSFullVersion  = NULL
		SET @OSProductType  = NULL
		SET @OSType  = NULL
		SET @CSDVersion  = NULL
		SET @OSBuildNumber  = NULL
		SET @OSLanguage  = NULL
		SET @OSSKUId  = NULL
		SET @OSVersionID  = NULL
		SET @ServicePackMajorVersion  = NULL
		SET @ServicePackMinorVersion  = NULL
		SET @WindowsDirectory  = NULL

		INSERT INTO [dbo].[Servers]
		(
			[HostName],
			[LatestReportedDate],
			[DateAdded],
			[InKFBDOM1Domain],
			[RetiredInd],
			[ReplacedByHost],
			[ProductionInd],
			[BusinessCategoryID],
			[PrimaryApplicationUsedFor],
			[LocalHostDescription],
			[ManagedBySQLDBAsInd],
			[MonitoredbySQLToolsInd],
			[ExcludeFromETLProcessesInd],
			[ExcludeFromWMIDataLoadInd],
			[ExcludeFromServiceRestartInd],
			[UsedByAppSyncInd],
			[OSManufacturer],
			[OSName],
			[OSVersion],
			[OSEdition],
			[OSRelease],
			[OSCaption],
			[OSFullVersion],
			[OSProductType],
			[OSType],
			[CSDVersion],
			[OSBuildNumber],
			[OSLanguage],
			[OSSKUId],
			[OSVersionID],
			[ServicePackMajorVersion],
			[ServicePackMinorVersion],
			[WindowsDirectory],
			[UsageScope],
	        [PrimaryDataProcessModelType]
		)
		SELECT
			@pHostName,
			@LatestReportedDate,
			@DateAdded,
			@pInKFBDOM1Domain,
			@pRetiredInd,
			@pReplacedByHost,
			@pProductionInd,
			@pBusinessCategoryID,
			@pPrimaryApplicationUsedFor,
			@pLocalHostDescription,
			@pManagedBySQLDBAsInd,
			@pMonitoredbySQLToolsInd,
			@pExcludeFromETLProcessesInd,
			@pExcludeFromWMIDataLoadInd,
			@PExcludeFromServiceRestartInd,
			@pUsedByAppSyncInd,
			@pOSManufacturer,
			@pOSName,
			@pOSVersion,
			@pOSEdition,
			@pOSRelease,
			@pOSCaption,
			@OSFullVersion,
			@OSProductType,
			@OSType,
			@CSDVersion,
			@OSBuildNumber,
			@OSLanguage,
			@OSSKUId,
			@OSVersionID,
			@ServicePackMajorVersion,
			@ServicePackMinorVersion,
			@WindowsDirectory,
			@pUsageScope,
			@pPrimaryDataProcessModelType 


		-- Begin Return Select of record just added
		SELECT 
			[SHS].[ServerSystemID],
			[SHS].[HostName],
			CONVERT(NVARCHAR(15),[SHS].[LatestReportedDate],101) AS LatestReportedDate,
			CONVERT(NVARCHAR(15),[SHS].[DateAdded],101) AS DateAdded,
			[SHS].[InKFBDOM1Domain],
			[SHS].[RetiredInd],
			[SHS].[ReplacedByHost],
			[SHS].[ProductionInd],
			[SHS].[BusinessCategoryID],
			[SHS].[UsageScope],
	        [SHS].[PrimaryDataProcessModelType],
			[SBC].[BusinessCategoryDesc],
			[SHS].[PrimaryApplicationUsedFor],
			[SHS].[LocalHostDescription],
			[SHS].[ManagedBySQLDBAsInd],
			[SHS].[MonitoredbySQLToolsInd],
			[SHS].[ExcludeFromETLProcessesInd],
			[SHS].[ExcludeFromWMIDataLoadInd],
			[SHS].[ExcludeFromServiceRestartInd],
			[SHS].[UsedByAppSyncInd],
			[SHS].[OSManufacturer],
			[SHS].[OSName],
			[SHS].[OSVersion],
			[SHS].[OSEdition],
			[SHS].[OSRelease],
			[SHS].[OSCaption]
		FROM [dbo].[vw_Servers] AS SHS
		LEFT OUTER JOIN [dbo].vw_BusinessCategories as SBC
		ON [SHS].[BusinessCategoryID] = [SBC].[BusinessCategoryID]
		WHERE  [ServerSystemID] = SCOPE_IDENTITY();
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Servers_Upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on Servers table.
Procedure standardizes operation for inserting records to the table.
DateAdded is not included here as this will only be set during insert operations
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [dbo].[usp_Servers_Upd] (
@ServerSystemID INT,
@HostName NVARCHAR(128),
@InKFBDOM1Domain BIT,
@RetiredInd BIT,
@ReplacedByHost NVARCHAR(255),
@ProductionInd BIT,
@BusinessCategoryID INT,
@PrimaryApplicationUsedFor NVARCHAR(100),
@UsageScope VARCHAR(50),
@PrimaryDataProcessModelType VARCHAR(25),
@LocalHostDescription NVARCHAR(256),
@ManagedBySQLDBAsInd BIT,
@MonitoredbySQLToolsInd BIT,
@ExcludeFromETLProcessesInd BIT,
@ExcludeFromWMIDataLoadInd BIT,
@ExcludeFromServiceRestartInd BIT,
@UsedByAppSyncInd BIT,
@OSManufacturer NVARCHAR(30),
@OSName NVARCHAR(20),
@OSVersion INT,
@OSEdition NVARCHAR(30),
@OSRelease NVARCHAR(10),
@OSCaption NVARCHAR(128)
--As the following columns are updated via ETL processes and to conform to the SP list structure, they are commented out/not used in updates via SP
--the current value in the table is retrieved and reapplied back to the table
--a secondary update stored procedure exists where the values can be updated--used only for updating servers for which WMI connections fail
--@OSFullVersion NVARCHAR(128),
--@OSProductType INT,
--@OSType INT,
--@CSDVersion NVARCHAR(128),
--@OSBuildNumber NVARCHAR(20),
--@OSLanguage INT,
--@OSSKUId INT,
--@OSVersionID NVARCHAR(15),
--@ServicePackMajorVersion NVARCHAR(15),
--@ServicePackMinorVersion NVARCHAR(15),
--@WindowsDirectory NVARCHAR(256),
)
AS 
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON  
--Set default and non-null values
BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	IF @ServerSystemID IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A NULL entry was passed to the ServerSystemID input parameter in the procedure %s.  Please provide a valid Server Host System ID value.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod); 
		THROW 60000 , @msg, 1; 
	END
	BEGIN TRAN
		DECLARE @LatestReportedDate DATE	
		--Set any NULL values passed in the procedure parameters equal to the value currently in the table to prevent NULL errors and prevent overwriting current values with incorrect nulls.
		SELECT
			@HostName = ISNULL(@HostName,HostName),
			@LatestReportedDate = CAST(GETDATE() AS DATE),
			@InKFBDOM1Domain = ISNULL(@InKFBDOM1Domain,InKFBDOM1Domain),
			@RetiredInd = ISNULL(@RetiredInd,RetiredInd),
			@ReplacedByHost = ISNULL(@ReplacedByHost,ReplacedByHost),
			@ProductionInd = ISNULL(@ProductionInd,ProductionInd),
			@BusinessCategoryID = ISNULL(@BusinessCategoryID,BusinessCategoryID),
			@PrimaryApplicationUsedFor = ISNULL(@PrimaryApplicationUsedFor,PrimaryApplicationUsedFor),
			@UsageScope = ISNULL(@UsageScope,UsageScope),
			@PrimaryDataProcessModelType = ISNULL(@PrimaryDataProcessModelType,PrimaryDataProcessModelType),
			@LocalHostDescription = ISNULL(@LocalHostDescription,LocalHostDescription),
			@ManagedBySQLDBAsInd = ISNULL(@ManagedBySQLDBAsInd,ManagedBySQLDBAsInd),
			@MonitoredbySQLToolsInd = ISNULL(@MonitoredbySQLToolsInd,MonitoredbySQLToolsInd),
			@ExcludeFromETLProcessesInd = ISNULL(@ExcludeFromETLProcessesInd,ExcludeFromETLProcessesInd),
			@ExcludeFromWMIDataLoadInd = ISNULL(@ExcludeFromWMIDataLoadInd,ExcludeFromWMIDataLoadInd),
			@ExcludeFromServiceRestartInd = ISNULL(@ExcludeFromServiceRestartInd,ExcludeFromServiceRestartInd),
			@UsedByAppSyncInd = ISNULL(@UsedByAppSyncInd,UsedByAppSyncInd),
			@OSManufacturer = ISNULL(@OSManufacturer,OSManufacturer),
			@OSName = ISNULL(@OSName,OSName),
			@OSVersion = ISNULL(@OSVersion,OSVersion),
			@OSEdition = ISNULL(@OSEdition,OSEdition),
			@OSRelease = ISNULL(@OSRelease,OSRelease),
			@OSCaption = ISNULL(@OSCaption,OSCaption)
		FROM [dbo].[vw_Servers]
		WHERE @ServerSystemID = [ServerSystemID]
		
		UPDATE [dbo].[Servers]
		SET 
			[HostName] = @HostName,
			[LatestReportedDate] = @LatestReportedDate,
			[InKFBDOM1Domain] = @InKFBDOM1Domain,
			[RetiredInd] = @RetiredInd,
			[ReplacedByHost] = @ReplacedByHost,
			[ProductionInd] = @ProductionInd,
		    [BusinessCategoryID] = @BusinessCategoryID,
			[PrimaryApplicationUsedFor] = @PrimaryApplicationUsedFor,
			[UsageScope] = @UsageScope,
			[PrimaryDataProcessModelType] = @PrimaryDataProcessModelType,
			[LocalHostDescription] = @LocalHostDescription,
			[ManagedBySQLDBAsInd] = @ManagedBySQLDBAsInd,
			[MonitoredbySQLToolsInd] = @MonitoredbySQLToolsInd,
			[ExcludeFromETLProcessesInd] = @ExcludeFromETLProcessesInd,
			[ExcludeFromWMIDataLoadInd] = @ExcludeFromWMIDataLoadInd,
			[ExcludeFromServiceRestartInd] = @ExcludeFromServiceRestartInd,
			[UsedByAppSyncInd] = @UsedByAppSyncInd,
			[OSManufacturer] = @OSManufacturer,
			[OSName] = @OSName,
			[OSVersion] = @OSVersion,
			[OSEdition] = @OSEdition,
			[OSRelease] = @OSRelease,
			[OSCaption] = @OSCaption
		WHERE @ServerSystemID = [ServerSystemID]

		--If the update includes retiring the HostSystem, then execute the stored procedure which sets all SQL instances (ServerInstances) as retired also
		IF @RetiredInd = 1
		BEGIN
			EXECUTE [dbo].[usp_Servers_Upd_Retire] @ServerSystemID
		END
	COMMIT TRANSACTION
	-- Begin Return Select of record just added
		SELECT 
			[SHS].[ServerSystemID],
			[SHS].[HostName],
			CONVERT(NVARCHAR(15),[SHS].[LatestReportedDate],101) AS LatestReportedDate,
			CONVERT(NVARCHAR(15),[SHS].[DateAdded],101) AS DateAdded,
			[SHS].[InKFBDOM1Domain],
			[SHS].[RetiredInd],
			[SHS].[ReplacedByHost],
			[SHS].[ProductionInd],
			[SHS].[BusinessCategoryID],
			[SBC].[BusinessCategoryDesc],
			[SHS].[PrimaryApplicationUsedFor],
			[SHS].[UsageScope],
			[SHS].[PrimaryDataProcessModelType],
			[SHS].[LocalHostDescription],
			[SHS].[ManagedBySQLDBAsInd],
			[SHS].[MonitoredbySQLToolsInd],
			[SHS].[ExcludeFromETLProcessesInd],
			[SHS].[ExcludeFromWMIDataLoadInd],
			[SHS].[UsedByAppSyncInd],
			[SHS].[OSManufacturer],
			[SHS].[OSName],
			[SHS].[OSVersion],
			[SHS].[OSEdition],
			[SHS].[OSRelease],
			[SHS].[OSCaption]
			--the following columns are part of the table but are not displayed in the SP list
			--the information in them is gathered as part of the ETL load and is provided to users via reporting tools
			--[SHS].[OSFullVersion],
			--[SHS].[OSProductType],
			--[SHS].[OSType],
			--[SHS].[CSDVersion],
			--[SHS].[OSBuildNumber],
			--[SHS].[OSLanguage],
			--[SHS].[OSSKUId],
			--[SHS].[OSVersionID],
			--[SHS].[ServicePackMajorVersion],
			--[SHS].[ServicePackMinorVersion],
			--[SHS].[WindowsDirectory]
		FROM [dbo].[vw_Servers] AS SHS
		LEFT OUTER JOIN [dbo].vw_BusinessCategories as SBC
		ON [SHS].[BusinessCategoryID] = [SBC].[BusinessCategoryID]
		WHERE [SHS].[ServerSystemID] = @ServerSystemID
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Servers_Upd_Retire]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Danny Howell
-- Create date:	03/12/2012
-- Description:	Procedure used to set flag on dbo.Servers table for systems permanently shutdown and deleted by changing the IsDecommissionedInd field = true(1)
--				and other management indicator flags to False (0).  This will remove the input host name and all its SQL instances from processing by the SSIS packages used for KFB SQL management
-- =============================================
CREATE PROCEDURE [dbo].[usp_Servers_Upd_Retire]
	--HostName
	@pServerSystemID INT
AS
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

BEGIN TRY
	DECLARE @ServerInstanceID INT
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'Server System ID'
	IF @pServerSystemID IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	IF NOT EXISTS (SELECT * FROM [dbo].[vw_Servers] WHERE ServerSystemID = @pServerSystemID)	
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60001
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - %d does not exist.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg  = FORMATMESSAGE(60001, @currprod,@currObject, @pServerSystemID);
		THROW 60001 , @msg, 1; 
	END
	
	BEGIN TRANSACTION
		UPDATE [dbo].[Servers]
		SET [RetiredInd] = 1
		,[LatestReportedDate] = cast(getdate() as date)
		,[ExcludeFromETLProcessesInd] = CAST(1 AS BIT)
		,[ExcludeFromWMIDataLoadInd] = CAST(1 AS BIT)
		,[ExcludeFromServiceRestartInd] = CAST(1 AS BIT)
		WHERE [ServerSystemID] = @pServerSystemID
		
		DECLARE SICUR CURSOR FOR
		SELECT [ServerInstanceID]
		FROM [dbo].[vw_ServerInstances]
		WHERE [ServerSystemID] = @pServerSystemID

		OPEN SICUR
		FETCH NEXT FROM SICUR
		INTO @ServerInstanceID

			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC [dbo].[usp_ServerInstances_Upd_RetireSQLInstance] @pServerInstanceID = @ServerInstanceID
			FETCH NEXT FROM SICUR
			INTO @ServerInstanceID
			END
		CLOSE SICUR
		DEALLOCATE SICUR
		

	COMMIT TRANSACTION

		SELECT [ServerSystemID]
		,[HostName]
		,[LocalHostDescription]
		,[RetiredInd]
		,[ReplacedByHost]
		,[ProductionInd]
		,[DateAdded]
		,[LatestReportedDate]
		,[ExcludeFromETLProcessesInd]
		,[ExcludeFromWMIDataLoadInd]
		,[ExcludeFromServiceRestartInd]
		FROM [dbo].[vw_Servers] AS [S1]
		WHERE [ServerSystemID] = @pServerSystemID

	BEGIN TRANSACTION
	-- Flag all users for this server as 'retired' since the server no longer exists
		UPDATE [dbo].[ServerPrincipalsLogins]
		SET [UserRetiredInd] = 1
		,[LastModifiedDate] = CAST(GETDATE() AS date) 
		WHERE [ServerNameId] =  (SELECT [HostName] FROM [dbo].[vw_Servers] WHERE [ServerSystemID] = @pServerSystemID)

	COMMIT TRANSACTION
		SELECT 
		[UserId]
		,[ServerNameId]
		,[CurrentPassword]
		,[AssignedDatabaseName]
		,[ApplicationCreatedForName]
		,[LastModifiedDate]
		,[Description]
		,[UserRetiredInd]
		FROM [dbo].[ServerPrincipalsLogins]
		WHERE [ServerNameId] =  (SELECT [HostName] FROM [dbo].[vw_Servers] WHERE [ServerSystemID] = @pServerSystemID)
	END TRY

	BEGIN CATCH
		EXEC dbo.usp_ErrorHandling_SystemErrors_Get
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
	
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_ApplicationPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_ApplicationPrincipals] 
(@pIncludeVendorsInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	BEGIN TRAN
		SELECT @pIncludeVendorsInd = ISNULL(@pIncludeVendorsInd,0)

		DECLARE @tBAP1 TABLE ([ApplicationRoleID] INT)
		INSERT INTO @tBAP1 (ApplicationRoleID)
		SELECT [ApplicationRoleID]
        FROM [dbo].[vw_ApplicationRoles]
		WHERE [ApplicationRoleName] NOT LIKE '%vendor%'
		
		IF @pIncludeVendorsInd = 1
		BEGIN
			INSERT INTO @tBAP1 (ApplicationRoleID)
			SELECT [ApplicationRoleID]
			FROM [dbo].[vw_ApplicationRoles]
			WHERE [ApplicationRoleName] LIKE '%vendor%'
		END


		-- Begin Return Select of record
		SELECT DISTINCT
		[vBAP1].[ApplicationPrincipalID]
		,[vBAP1].[PrincipalLocalName]
		FROM [dbo].[vw_ApplicationPrincipals] AS vBAP1
		INNER JOIN [dbo].[ApplicationRolePrincipals] AS BARP1
		ON [vBAP1].[ApplicationPrincipalID] = [BARP1].[ApplicationPrincipalID]
		INNER JOIN @tBAP1 AS BAR1
		ON [BARP1].[ApplicationRoleID] = [BAR1].[ApplicationRoleID]
		ORDER BY [PrincipalLocalName]

	
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Applications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report dataset values used in tables and matrices.
The procedural logic allows for this to be used in a multiple value parameter box.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
Additionally, the procedure reflects the relational nature of the table.  As the  Applications table is a child table to other parent tables, the procedure structure allows for its use as either a standalone parameter (one in which the parent table values are not provided or used to filter the dataset) or a dependent parameter (one in which parent table values are provided to filter the dataset returned).  Each usage could return 1 to N number of  Application primary keys.
There are no conditions in which both a list of applicationids and a list of businesscategoryids will be sent to the procedure.  It is designed to provide a dataset of applications based upon a list of businesscategories OR a list of applicationids (mutually exclusive)
As this procedure is custom written for use in reporting only.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Applications]
(@pApplicationIDs VARCHAR(4000)
,@pBusinessCategoryIDs VARCHAR(4000)
,@pShowRetiredApplications BIT
)
AS
BEGIN
DECLARE @BusinessCatgoryIDs TABLE (pBusCatID INT)
DECLARE @ApplicationsIDs TABLE (pAppID INT)

--if a dependent parameter, then the  Application IDs returned will be based upon the parent table value
--parse the parent table values and return the Application records matching that criteria
--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value
IF @pBusinessCategoryIDs IS NULL OR Len(@pBusinessCategoryIDs) = 0
	BEGIN
		INSERT INTO @BusinessCatgoryIDs
		SELECT DISTINCT
		[BusinessCategoryID]
		FROM [dbo].[vw_BusinessCategories]
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @BusinessCatgoryIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pBusinessCategoryIDs,',')
	END

--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value. As the BusinessCategory parameter is null, the table variable will contain ALL business categories, therefore only test upon the applicationids string
IF @pApplicationIDs IS NULL OR Len(@pApplicationIDs) = 0
	BEGIN
		INSERT INTO @ApplicationsIDs
		SELECT DISTINCT
		[ApplicationId]
        FROM [dbo].[vw_Applications]
		WHERE [BusinessCategoryID] IN (SELECT pBusCatID FROM @BusinessCatgoryIDs)
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationsIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
	END

SELECT @pShowRetiredApplications = ISNULL(@pShowRetiredApplications,0)

SELECT 
[BC].[BusinessCategoryDesc]
,[BC].[BusinessCategoryLongDesc]
,[BA].[ApplicationId]
,CASE [BA].[RetiredInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [RetiredInd]
,CASE [BA].[SQLDBBasedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [SQLDBBasedAppInd]
,[BA].[ApplicationName]
,[BA].[BusinessCategoryID]
,[BA].[ApplicationCommonName]
,[BA].[PrimaryBusinessPurposeDesc]
,[BA].[KFBMFApplicationCode]
,[BA].[FinanciallySignificantAppInd]
,[BA].[KFBDistributedAbbreviations]
,CASE [BA].[VendorSuppliedDBInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [VendorSuppliedDBInd]
,CASE [BA].[InternallyDevelopedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [InternallyDevelopedAppInd]
,[BA].[AppDBERModelName]
,[BAS1].[ApplicationRoleID]
,[BAS1].[ApplicationPrincipalID]
,[BAS1].[ApplicationRoleDesc]
,[BAS1].[ApplicationRoleName] as ApplicationRoleName
,ISNULL([BAS1].[ApplicationRoleCommonName],'No Application Roles Assigned') as ApplicationRoleCommonName
,[BAS1].[ApplicationRoleType]
,[BAS1].[ApplicationManagementRoleID]
,ISNULL([BAS1].[PrincipalLocalName],'No one assigned this roles') as PrincipalLocalName
,CONVERT(VARCHAR(15),[BAS1].[RolePrincipalLastUpdateDt],101) AS LastUpdateDt
FROM [dbo].[vw_Applications] AS BA
LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC
ON [BA].[BusinessCategoryID] = [BC].BusinessCategoryID
LEFT OUTER JOIN [dbo].[vw_Applications_Staffing] AS BAS1
ON [BA].[ApplicationID] = [BAS1].[ApplicationID]
WHERE [BA].[ApplicationId] IN (SELECT pAppID FROM  @ApplicationsIDs)
AND [BA].[RetiredInd] <= @pShowRetiredApplications 
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Applications_by_IDs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report dataset values used in tables and matrices.
this procedure is custom written for use in reporting only.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Applications_by_IDs]
(@pApplicationID VARCHAR(3)
)
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	-- Certain fields cannot be null for new Servers, although the system would throw errors if NULL values passed and data integrity violated, throw custom errors for these fields
	IF @pApplicationID IS NULL 
	BEGIN
		DECLARE @ApplicationsIDs TABLE (pAppID INT)
		INSERT INTO @ApplicationsIDs
		SELECT DISTINCT
		[ApplicationId]
		FROM [dbo].[vw_Applications]
	END
	ELSE
	BEGIN
		SET @currObject = 'ApplicationRoleName'
		IF TRY_CONVERT(int,@pApplicationID) IS NULL
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
		END
		ELSE
		BEGIN
		INSERT INTO @ApplicationsIDs
		SELECT DISTINCT
		[ApplicationId]
		FROM [dbo].[vw_Applications]
		WHERE [ApplicationId] = CAST(@pApplicationID AS INT)
		END
	END

--if a dependent parameter, then the  Application IDs returned will be based upon the parent table value
--parse the parent table values and return the Application records matching that criteria
--if an independent parameter, then the procedure parameter @pCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value. As the BusinessCategory parameter is null, the table variable will contain ALL business categories, therefore only test upon the applicationids string

SELECT 
[BC].[BusinessCategoryDesc]
,[BC].[BusinessCategoryLongDesc]
,RIGHT('000' + CAST([BA].[ApplicationId] AS VARCHAR(3)),3) AS [ApplicationId]
,CASE [BA].[RetiredInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [RetiredInd]
,CASE [BA].[SQLDBBasedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [SQLDBBasedAppInd]
,[BA].[ApplicationName]
,[BA].[BusinessCategoryID]
,[BA].[ApplicationCommonName]
,[BA].[PrimaryBusinessPurposeDesc]
,[BA].[KFBMFApplicationCode]
,[BA].[FinanciallySignificantAppInd]
,[BA].[KFBDistributedAbbreviations]
,CASE [BA].[VendorSuppliedDBInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [VendorSuppliedDBInd]
,CASE [BA].[InternallyDevelopedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [InternallyDevelopedAppInd]
,[BA].[AppDBERModelName]
FROM [dbo].[vw_Applications] AS BA
LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC
ON [BA].[BusinessCategoryID] = [BC].BusinessCategoryID
WHERE [BA].[ApplicationId] IN (SELECT pAppID FROM @ApplicationsIDs)
AND [BA].[RetiredInd] = 0
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Applications_by_Name]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report dataset values used in tables and matrices.
The procedural logic allows for this to be used in a multiple value parameter box.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
Additionally, the procedure reflects the relational nature of the table.  As the  Applications table is a child table to other parent tables, the procedure structure allows for its use as either a standalone parameter (one in which the parent table values are not provided or used to filter the dataset) or a dependent parameter (one in which parent table values are provided to filter the dataset returned).  Each usage could return 1 to N number of  Application primary keys.
There are no conditions in which both a list of applicationids and a list of businesscategoryids will be sent to the procedure.  It is designed to provide a dataset of applications based upon a list of businesscategories OR a list of applicationids (mutually exclusive)
As this procedure is custom written for use in reporting only.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Applications_by_Name]
(@pApplicationName VARCHAR(100)
)
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

DECLARE @ApplicationsIDs TABLE (pAppID INT)
INSERT INTO @ApplicationsIDs
SELECT DISTINCT
[ApplicationId]
FROM [dbo].[vw_Applications]
WHERE [ApplicationName] LIKE @pApplicationName
OR [ApplicationCommonName] LIKE @pApplicationName
--if a dependent parameter, then the  Application IDs returned will be based upon the parent table value
--parse the parent table values and return the Application records matching that criteria
--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value. As the BusinessCategory parameter is null, the table variable will contain ALL business categories, therefore only test upon the applicationids string

SELECT 
[BC].[BusinessCategoryDesc]
,[BC].[BusinessCategoryLongDesc]
,RIGHT('000' + CAST([BA].[ApplicationId] AS VARCHAR(3)),3) AS [ApplicationId]
,CASE [BA].[RetiredInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [RetiredInd]
,CASE [BA].[SQLDBBasedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [SQLDBBasedAppInd]
,[BA].[ApplicationName]
,[BA].[BusinessCategoryID]
,[BA].[ApplicationCommonName]
,[BA].[PrimaryBusinessPurposeDesc]
,[BA].[KFBMFApplicationCode]
,[BA].[FinanciallySignificantAppInd]
,[BA].[KFBDistributedAbbreviations]
,CASE [BA].[VendorSuppliedDBInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [VendorSuppliedDBInd]
,CASE [BA].[InternallyDevelopedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [InternallyDevelopedAppInd]
,[BA].[AppDBERModelName]
FROM [dbo].[vw_Applications] AS BA
LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC
ON [BA].[BusinessCategoryID] = [BC].BusinessCategoryID
WHERE [BA].[ApplicationId] IN (SELECT pAppID FROM  @ApplicationsIDs)
AND [BA].[RetiredInd] = 0
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Applications_By_Principal]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Applications_By_Principal] 
(@pApplicationPrincipalIDs VARCHAR(8000)
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
	DECLARE @ApplicationPrincipalIDs TABLE (pBAPrincipalID INT)
	IF @pApplicationPrincipalIDs IS NULL OR CHARINDEX('-1',@pApplicationPrincipalIDs,0) > 0
	BEGIN
		INSERT INTO @ApplicationPrincipalIDs
		SELECT DISTINCT [ApplicationPrincipalID]
		FROM [dbo].[ApplicationPrincipals]
		
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationPrincipalIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationPrincipalIDs,',')
	END

	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
		[vBAS1].[ApplicationId]
		,[vBAS1].[RetiredInd]
		,[vBAS1].[SQLDBBasedAppInd]
		,[vBAS1].[ApplicationName]
		,[vBAS1].[ApplicationCommonName]
		,[vBAS1].[ApplicationRoleID]
		,[vBAS1].[ApplicationPrincipalID]
		,[vBAS1].[RolePrincipalLastUpdateDt]
		,[vBAS1].[ApplicationRoleDesc]
		,[vBAS1].[ApplicationRoleName]
		,[vBAS1].[ApplicationRoleType]
		,[BAP1].[PrincipalADsamAccountName]
		,[vBAS1].[PrincipalLocalName]
		,[vBAS1].[ApplicationRoleCommonName]
		FROM [dbo].[vw_Applications_Staffing] AS vBAS1
		INNER JOIN [dbo].[ApplicationPrincipals] AS BAP1
		ON [vBAS1].[ApplicationPrincipalID] = [BAP1].[ApplicationPrincipalID]
		INNER JOIN @ApplicationPrincipalIDs AS tBAPIDs
		ON [vBAS1].[ApplicationPrincipalID] = [tBAPIDs].[pBAPrincipalID]
		WHERE [vBAS1].[RetiredInd] = 0
	
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_ApplicationSupport_by_ApplicationID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report dataset values used in tables and matrices.
The procedural logic allows for this to be used in a multiple value parameter box.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
Additionally, the procedure reflects the relational nature of the table.  As the  Applications table is a child table to other parent tables, the procedure structure allows for its use as either a standalone parameter (one in which the parent table values are not provided or used to filter the dataset) or a dependent parameter (one in which parent table values are provided to filter the dataset returned).  Each usage could return 1 to N number of  Application primary keys.
There are no conditions in which both a list of applicationids and a list of businesscategoryids will be sent to the procedure.  It is designed to provide a dataset of applications based upon a list of businesscategories OR a list of applicationids (mutually exclusive)
As this procedure is custom written for use in reporting only.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_ApplicationSupport_by_ApplicationID]
(@pApplicationIDs VARCHAR(4000)
,@pShowRetiredApplications BIT
)
AS
BEGIN

DECLARE @ApplicationsIDs TABLE (pAppID INT)

--if a dependent parameter, then the  Application IDs returned will be based upon the parent table value
--parse the parent table values and return the Application records matching that criteria
--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value. As the BusinessCategory parameter is null, the table variable will contain ALL business categories, therefore only test upon the applicationids string
IF @pApplicationIDs IS NULL OR Len(@pApplicationIDs) = 0
	BEGIN
		INSERT INTO @ApplicationsIDs
		SELECT DISTINCT
		[ApplicationId]
        FROM [dbo].[vw_Applications]
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationsIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
	END

SELECT @pShowRetiredApplications = ISNULL(@pShowRetiredApplications,0)

SELECT 
[BA].[ApplicationId]
,CASE [BA].[RetiredInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [RetiredInd]
,CASE [BA].[SQLDBBasedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [SQLDBBasedAppInd]
,[BA].[ApplicationName]
,[BA].[ApplicationCommonName]
,[BA].[PrimaryBusinessPurposeDesc]
,[BA].[KFBMFApplicationCode]
,[BA].[FinanciallySignificantAppInd]
,[BA].[KFBDistributedAbbreviations]
,CASE WHEN ISNULL([BA].[VendorSuppliedDBInd],0) = 0 THEN 
	CASE WHEN ISNULL([BA].[InternallyDevelopedAppInd],0) = 0 THEN 'UNKNOWN' ELSE 'KFB' END
	ELSE
	'Vendor' END AS [KFBorVendor]
,CASE [BA].[InternallyDevelopedAppInd] WHEN 1 THEN 'Yes' ELSE 'No' END AS [InternallyDevelopedAppInd]
,[BAS1].[ApplicationRoleName] as ApplicationRoleName
,ISNULL([BAS1].[ApplicationRoleCommonName],'No Application Roles Assigned') as ApplicationRoleCommonName
,dense_rank () OVER (PARTITION BY [BAS1].[ApplicationId], [BAS1].[ApplicationRoleCommonName] ORDER BY [BAS1].[PrincipalLocalName]) AS ROLESEQ
,ISNULL([BAS1].[PrincipalLocalName],'No one assigned this roles') as PrincipalLocalName
FROM [dbo].[vw_Applications] AS BA
LEFT OUTER JOIN [dbo].[vw_Applications_Staffing] AS BAS1
ON [BA].[ApplicationID] = [BAS1].[ApplicationID]
WHERE [BA].[ApplicationId] IN (SELECT pAppID FROM  @ApplicationsIDs)
AND [BA].[RetiredInd] <= @pShowRetiredApplications 

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_BusinessCategories]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report dataset values used in tables and matrices.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
As this procedure is custom written for use in reporting only and should only be used for providing a source for report parameters.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_BusinessCategories]
(@pBusinessCategoryIDs VARCHAR(4000)
)
AS
BEGIN
DECLARE @BusinessCatgoryIDs TABLE (pAppID INT)
IF @pBusinessCategoryIDs IS NULL OR @pBusinessCategoryIDs = -1
	BEGIN
		INSERT INTO @BusinessCatgoryIDs
		SELECT DISTINCT
		[BusinessCategoryID]
		FROM [dbo].[vw_BusinessCategories]
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @BusinessCatgoryIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pBusinessCategoryIDs,',')
	END

SELECT DISTINCT
[BusinessCategoryID]
,[BusinessCategoryDesc]
,[BusinessCategoryLongDesc]
FROM [dbo].[vw_BusinessCategories]
WHERE [BusinessCategoryID] IN (SELECT pAppID FROM @BusinessCatgoryIDs)
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DataAccessRoles_by_Application]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_DataAccessRoles_by_Application] 
(@pApplicationIDs VARCHAR(4000)  --app id
,@pEnvironmentScope INT -- -1 or NULL indicates both, 0 = non-production only, 1 indicates production only
,@pRoleAuthorities INT -- -1 or NULL indicates both, 0 = SQL Server only, 1 indicates ActiveDirectory only
,@pShowETLIDs INT -- -1 or NULL indicates both, 0 = Applications only, 1 = ETL Only
)
AS 
BEGIN
	--Setting NOCOUNT ON removes the row count as output
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  

	BEGIN TRY
		--if null value is passed then default to all  applications
		DECLARE @ProductionIndLow BIT
		DECLARE @ProductionIndHigh BIT
		DECLARE @RoleAuthorityLow BIT
		DECLARE @RoleAuthorityHigh BIT

		IF ISNULL(@pEnvironmentScope,-1) = -1
		BEGIN
			SET @ProductionIndLow = 0
			SET @ProductionIndHigh = 1
		END
		ELSE
		BEGIN
			SET @ProductionIndLow = @pEnvironmentScope
			SET @ProductionIndHigh = @ProductionIndLow
		END

		IF ISNULL(@pRoleAuthorities,-1) = -1
		BEGIN
			SET @RoleAuthorityLow = 0
			SET @RoleAuthorityHigh = 1
		END
		ELSE
		BEGIN
			SET @RoleAuthorityLow = @pRoleAuthorities
			SET @RoleAuthorityHigh = @RoleAuthorityLow
		END
	
		DECLARE @ApplicationIDs TABLE (pAppID INT)
		IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
		BEGIN
			INSERT INTO @ApplicationIDs
			SELECT DISTINCT [ApplicationId]
			FROM [dbo].[vw_Applications]
		END
		ELSE
		BEGIN
		--use custom function to split input string into a table of integers
			INSERT INTO @ApplicationIDs
			SELECT item
			FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
		END
		BEGIN TRAN

			DECLARE @SysPrefix varchar(1)

			DECLARE @AccountTable2 TABLE (
			[AccountClass] VARCHAR(25)
			,[PlatformSegment] VARCHAR(1)
			,[EnvironmentSegment] VARCHAR(1)
			,[SystemClassSegment] VARCHAR(1)
			,[ApplicationSegment] VARCHAR(3)
			,[DatabaseSegment] VARCHAR(2)
			,[RoleSegment] VARCHAR(2)
			,[ApplicationSegmentNumeric] INT
			,[DatabaseSegmentNumeric] INT
			,[RoleSegmentNumeric] INT		
			,[ApplicationName] VARCHAR(128)
			,[ServiceAccountOrGroupName] VARCHAR(128)
			,[RoleScopeLabel] VARCHAR(20)
			,[RoleAuthority] VARCHAR(15)
			,[RoleAuthorityIsLDAP] BIT
			,[RoleName] VARCHAR(25)
			,[EnvironmentScope] VARCHAR(1)
			,[EnvironmentScopeName] VARCHAR(30)
			,[GrantDescription] VARCHAR(1000)
			,[PurposeDescription] VARCHAR(1000) )


			IF (@ProductionIndLow = 0)
			BEGIN
				SET @SysPrefix = 'D'
				--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
				--Will be returing all the roles with their definitions for the given components

				INSERT INTO @AccountTable2
				(
				[AccountClass]
				,[PlatformSegment]
				,[EnvironmentSegment]
				,[SystemClassSegment]
				,[ApplicationSegment]
				,[DatabaseSegment]
				,[RoleSegment]
				,[ApplicationSegmentNumeric]
				,[DatabaseSegmentNumeric]
				,[RoleSegmentNumeric]
				,[ApplicationName]
				,[ServiceAccountOrGroupName]
				,[RoleScopeLabel]
				,[RoleAuthority]
				,[RoleAuthorityIsLDAP]
				,[RoleName]
				,[EnvironmentScope]
				,[EnvironmentScopeName]
				,[GrantDescription]
				,[PurposeDescription]
				)
				SELECT 
				'ServiceAcounts'
				,'A'
				,'N'
				,@SysPrefix
				,[T1].[FormattedApplicationID]
				,'00'
				,[T2].[FormattedCustomRoleID]				
				,[T1].[ApplicationId]
				,0
				,[T2].[CustomRoleID]
				,[T1].[ApplicationName]
				,NULL
				,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
				,[T2].[RoleAuthority]
				,[T2].[RoleAuthorityIsLDAP]
				,[T2].[RoleName]
				,[T2].[EnvironmentScope]
				,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
				,[T2].[GrantDescription]
				,[T2].[PurposeDescription]
				from [dbo].[vw_Applications] AS T1
				cross join 
				(
					SELECT 
					[IT1].[CustomRoleID]
					,[IT1].[FormattedCustomRoleID]
					,[IT1].[RoleScope]
					,[IT1].[RoleAuthority]
					,[IT1].[RoleAuthorityIsLDAP]
					,[IT1].[RoleName]
					,[IT1].[EnvironmentScope]
					,[IT1].[GrantDescription]
					,[IT1].[PurposeDescription]
					,[IT1].[IsProductionRoleInd]  
					FROM [dbo].[vw_DataAccessRoles] AS IT1
					WHERE [RoleAuthorityISLDAP] = 0
					AND [RoleAuthority] = 'SQLServer'
					AND [IT1].[IsProductionRoleInd] = 0
					AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
					) AS [T2]
				WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			
			SET @SysPrefix = 'S'
			--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
			--Will be returing all the roles with their definitions for the given components
			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'ServiceAcounts'
			,'A'
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,@SysPrefix
			,[T1].[FormattedApplicationID]
			,'00'
			,[T2].[FormattedCustomRoleID]				
			,[T1].[ApplicationId]
			,0
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,NULL
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)

			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'ETL Acounts'
			,'E'
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,@SysPrefix
			,[T1].[FormattedApplicationID]
			,'##'
			,[T2].[FormattedCustomRoleID]				
			,[T1].[ApplicationId]
			,0
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,NULL
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)


			
			IF (@RoleAuthorityHigh = 1)
			BEGIN
			--Instead of doing a cross join, do a left outer join to a cross join for applications that have an AD Group value assigned
			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'Active Directory Groups'
			,NULL
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,'S'
			,[T1].[FormattedApplicationID]
			,'##'
			,[T2].[FormattedCustomRoleID]
			,0
			,[T1].[ApplicationId]
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,CASE WHEN [T1].[ActiveDirectoryGroupTag] IS NOT NULL THEN CONCAT('SQL_',[T1].[ActiveDirectoryGroupTag],'_',[T2].[RoleName]) ELSE 'NONE' END as ServiceAccountOrGroupName
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END AS [RoleScopeLabel]
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END as [EnvironmentScopeName]
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			LEFT OUTER JOIN
			(
				SELECT 
				[IT2].[ApplicationId]
				,[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_Applications] AS IT2
				CROSS JOIN	[dbo].[vw_DataAccessRoles] AS IT1
				WHERE [IT1].[RoleAuthorityISLDAP] = 1
				AND [IT1].[RoleScope] = 'DB'
				AND [IT2].[ActiveDirectoryGroupTag] IS NOT NULL
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			ON [T1].[ApplicationId] = [T2].[ApplicationId]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			--Create a Temp Table of the ServerPrincipalsLogins table to join with the Accounts table
			DECLARE @FormattedSPLTable TABLE ([UserID] VARCHAR(128), [PlatformSegment] VARCHAR(1), [EnvironmentSegment] VARCHAR(1), [SystemClassSegment] VARCHAR(1),
			[ApplicationSegmentNumeric] INT, [DatabaseSegment] INT, [RoleSegment] INT, [ServerName] VARCHAR(128),
			[DatabaseName] VARCHAR(128), [ApplicationDatabaseSeqID] INT )
			INSERT INTO @FormattedSPLTable
			([UserID], [PlatformSegment], [EnvironmentSegment] , [SystemClassSegment],[ApplicationSegmentNumeric], [DatabaseSegment], [RoleSegment] 
			,[ServerName],[DatabaseName],[ApplicationDatabaseSeqID] )
			SELECT [UserId]
			,SUBSTRING([UserID],1,1) AS [PlatformSegment]
			,SUBSTRING([UserID],2,1) AS [EnvironmentSegment]
			,SUBSTRING([UserID],3,1) AS [SystemClassSegment]
			,CAST([PrimaryApplicationID] AS INT) AS [ApplicationSegmentNumeric]
			,CAST(SUBSTRING([UserID],7,2) AS INT) AS [DatabaseSegment]
			,CAST(SUBSTRING([UserID],9,2) AS INT) AS [RoleSegment]
			,[DBEP3].[HostName]
			,[DBEP3].[DatabaseName]
			,[DBEP3].[ExtendedPropertyValue]
			FROM [dbo].[ServerPrincipalsLogins] AS [SPL1]
			LEFT OUTER JOIN 
				(SELECT 
				[DB1].[ApplicationId]
				,[DB1].[HostName]
				,[DB1].[DatabaseName]
				,[DBEP2].[ExtendedPropertyValue]
				FROM [dbo].[vw_Databases_Inventory] AS DB1
				LEFT OUTER JOIN [dbo].[vw_DatabaseExtendedProperties_CurrentValues] as DBEP2
				ON [DB1].[DatabaseUniqueId] = [DBEP2].DatabaseUniqueId
				WHERE [DBEP2].[ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') AS DBEP3
			ON CAST([SPL1].[PrimaryApplicationID] AS INT) = [DBEP3].[ApplicationId]
			AND CAST(SUBSTRING([UserID],7,2) AS INT) = [DBEP3].[ExtendedPropertyValue]
			WHERE USERID LIKE '[A,E][N,P][D,S][0-1]%'
			AND [UserRetiredInd] = 0
			
			--Return a data set formatted for reporting
			SELECT
			[T1].[ApplicationName]
			,[T1].[AccountClass]
			,CASE WHEN [T1].[SystemClassSegment] = 'S' THEN 'Server' ELSE 'Desktop' END AS SystemTier
			,[T1].[RoleAuthority]
			,CASE WHEN [T1].[PlatformSegment] IS NOT NULL THEN 
				CONCAT([T1].[PlatformSegment],[T1].[EnvironmentSegment],[T1].[SystemClassSegment],[T1].[ApplicationSegment],[T1].[DatabaseSegment],[T1].[RoleSegment])
				ELSE [T1].[ServiceAccountOrGroupName] END AS [ServiceAccountOrGroupName]
			,[T1].[RoleName]
			,[T1].[RoleScopeLabel]
			,CASE WHEN [ADG1].[samAccountName] IS NOT NULL THEN 'Yes-Group Exists' ELSE  
				CASE WHEN [T3].[UserID] IS NOT NULL THEN CONCAT([T3].[UserId], ' Database: ',ISNULL([t3].[DatabaseName],'All'),
					CASE WHEN [t3].[DatabaseName] IS NOT NULL THEN CONCAT(' Server: ', [T3].[ServerName]) ELSE NULL END
				) ELSE NULL END
				END AS ServiceAccountExists
			,[T1].[GrantDescription]
			,[T1].[PurposeDescription]
			,[T1].[ApplicationSegmentNumeric]
			,[T1].[DatabaseSegmentNumeric]
			,[T1].[RoleSegmentNumeric]
			,[T1].[RoleAuthorityIsLDAP]	
			,[T1].[EnvironmentScope]
			,[T1].[EnvironmentScopeName]
			from @AccountTable2 AS T1
			LEFT OUTER JOIN [sec].[vw_ADGroups] AS ADG1
			ON [t1].[ServiceAccountOrGroupName] = [ADG1].[samAccountName]
			LEFT OUTER JOIN
			(
				SELECT
				[UserID], [PlatformSegment], [EnvironmentSegment],[SystemClassSegment],[ApplicationSegmentNumeric], [DatabaseSegment], [RoleSegment] 
				,[ServerName],[DatabaseName],[ApplicationDatabaseSeqID]
				FROM @FormattedSPLTable
			) AS T3
			ON [T1].[PlatformSegment] = [T3].[PlatformSegment]
			AND [T1].[EnvironmentSegment] = [T3].[EnvironmentSegment]
			AND [T1].[SystemClassSegment] = [T3].[SystemClassSegment]
			AND [T1].[ApplicationSegmentNumeric] = [T3].ApplicationSegmentNumeric
			AND [T1].[RoleSegmentNumeric] = [T3].[RoleSegment]
			
						
		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DataAccessRoles_by_Application2]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_DataAccessRoles_by_Application2] 
(@pApplicationIDs VARCHAR(4000)  --app id
,@pEnvironmentScope INT -- -1 or NULL indicates both, 0 = non-production only, 1 indicates production only
,@pRoleAuthorities INT -- -1 or NULL indicates both, 0 = SQL Server only, 1 indicates ActiveDirectory only
,@pShowETLIDs INT -- -1 or NULL indicates both, 0 = Applications only, 1 = ETL Only
)
AS 
BEGIN
	--Setting NOCOUNT ON removes the row count as output
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  

	BEGIN TRY
		--if null value is passed then default to all  applications
		DECLARE @ProductionIndLow BIT
		DECLARE @ProductionIndHigh BIT
		DECLARE @RoleAuthorityLow BIT
		DECLARE @RoleAuthorityHigh BIT

		IF ISNULL(@pEnvironmentScope,-1) = -1
		BEGIN
			SET @ProductionIndLow = 0
			SET @ProductionIndHigh = 1
		END
		ELSE
		BEGIN
			SET @ProductionIndLow = @pEnvironmentScope
			SET @ProductionIndHigh = @ProductionIndLow
		END

		IF ISNULL(@pRoleAuthorities,-1) = -1
		BEGIN
			SET @RoleAuthorityLow = 0
			SET @RoleAuthorityHigh = 1
		END
		ELSE
		BEGIN
			SET @RoleAuthorityLow = @pRoleAuthorities
			SET @RoleAuthorityHigh = @RoleAuthorityLow
		END
	
		DECLARE @ApplicationIDs TABLE (pAppID INT)
		IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
		BEGIN
			INSERT INTO @ApplicationIDs
			SELECT DISTINCT [ApplicationId]
			FROM [dbo].[vw_Applications]
		END
		ELSE
		BEGIN
		--use custom function to split input string into a table of integers
			INSERT INTO @ApplicationIDs
			SELECT item
			FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
		END
		BEGIN TRAN

			DECLARE @SysPrefix varchar(1)

			DECLARE @AccountTable2 TABLE (
			[AccountClass] VARCHAR(25)
			,[PlatformSegment] VARCHAR(1)
			,[EnvironmentSegment] VARCHAR(1)
			,[SystemClassSegment] VARCHAR(1)
			,[ApplicationSegment] VARCHAR(3)
			,[DatabaseSegment] VARCHAR(2)
			,[RoleSegment] VARCHAR(2)
			,[ApplicationSegmentNumeric] INT
			,[DatabaseSegmentNumeric] INT
			,[RoleSegmentNumeric] INT		
			,[ApplicationName] VARCHAR(128)
			,[ServiceAccountOrGroupName] VARCHAR(128)
			,[RoleScopeLabel] VARCHAR(20)
			,[RoleAuthority] VARCHAR(15)
			,[RoleAuthorityIsLDAP] BIT
			,[RoleName] VARCHAR(25)
			,[EnvironmentScope] VARCHAR(1)
			,[EnvironmentScopeName] VARCHAR(30)
			,[GrantDescription] VARCHAR(1000)
			,[PurposeDescription] VARCHAR(1000) )


			IF (@ProductionIndLow = 0)
			BEGIN
				SET @SysPrefix = 'D'
				--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
				--Will be returing all the roles with their definitions for the given components

				INSERT INTO @AccountTable2
				(
				[AccountClass]
				,[PlatformSegment]
				,[EnvironmentSegment]
				,[SystemClassSegment]
				,[ApplicationSegment]
				,[DatabaseSegment]
				,[RoleSegment]
				,[ApplicationSegmentNumeric]
				,[DatabaseSegmentNumeric]
				,[RoleSegmentNumeric]
				,[ApplicationName]
				,[ServiceAccountOrGroupName]
				,[RoleScopeLabel]
				,[RoleAuthority]
				,[RoleAuthorityIsLDAP]
				,[RoleName]
				,[EnvironmentScope]
				,[EnvironmentScopeName]
				,[GrantDescription]
				,[PurposeDescription]
				)
				SELECT 
				'ServiceAcounts'
				,'A'
				,'N'
				,@SysPrefix
				,[T1].[FormattedApplicationID]
				,'00'
				,[T2].[FormattedCustomRoleID]				
				,[T1].[ApplicationId]
				,0
				,[T2].[CustomRoleID]
				,[T1].[ApplicationName]
				,NULL
				,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
				,[T2].[RoleAuthority]
				,[T2].[RoleAuthorityIsLDAP]
				,[T2].[RoleName]
				,[T2].[EnvironmentScope]
				,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
				,[T2].[GrantDescription]
				,[T2].[PurposeDescription]
				from [dbo].[vw_Applications] AS T1
				cross join 
				(
					SELECT 
					[IT1].[CustomRoleID]
					,[IT1].[FormattedCustomRoleID]
					,[IT1].[RoleScope]
					,[IT1].[RoleAuthority]
					,[IT1].[RoleAuthorityIsLDAP]
					,[IT1].[RoleName]
					,[IT1].[EnvironmentScope]
					,[IT1].[GrantDescription]
					,[IT1].[PurposeDescription]
					,[IT1].[IsProductionRoleInd]  
					FROM [dbo].[vw_DataAccessRoles] AS IT1
					WHERE [RoleAuthorityISLDAP] = 0
					AND [RoleAuthority] = 'SQLServer'
					AND [IT1].[IsProductionRoleInd] = 0
					AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
					) AS [T2]
				WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			
			SET @SysPrefix = 'S'
			--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
			--Will be returing all the roles with their definitions for the given components
			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'ServiceAcounts'
			,'A'
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,@SysPrefix
			,[T1].[FormattedApplicationID]
			,'00'
			,[T2].[FormattedCustomRoleID]				
			,[T1].[ApplicationId]
			,0
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,NULL
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)

			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'ETL Acounts'
			,'E'
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,@SysPrefix
			,[T1].[FormattedApplicationID]
			,'##'
			,[T2].[FormattedCustomRoleID]				
			,[T1].[ApplicationId]
			,0
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,NULL
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)


			
			IF (@RoleAuthorityHigh = 1)
			BEGIN
			--Instead of doing a cross join, do a left outer join to a cross join for applications that have an AD Group value assigned
			INSERT INTO @AccountTable2
			(
			[AccountClass]
			,[PlatformSegment]
			,[EnvironmentSegment]
			,[SystemClassSegment]
			,[ApplicationSegment]
			,[DatabaseSegment]
			,[RoleSegment]
			,[ApplicationSegmentNumeric]
			,[DatabaseSegmentNumeric]
			,[RoleSegmentNumeric]
			,[ApplicationName]
			,[ServiceAccountOrGroupName]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription]
			)
			SELECT 
			'Active Directory Groups'
			,NULL
			,CASE WHEN [T2].[IsProductionRoleInd] = 0 THEN 'N' ELSE 'P' END
			,'S'
			,[T1].[FormattedApplicationID]
			,'##'
			,[T2].[FormattedCustomRoleID]
			,0
			,[T1].[ApplicationId]
			,[T2].[CustomRoleID]
			,[T1].[ApplicationName]
			,CASE WHEN [T1].[ActiveDirectoryGroupTag] IS NOT NULL THEN CONCAT('SQL_',[T1].[ActiveDirectoryGroupTag],'_',[T2].[RoleName]) ELSE 'NONE' END as ServiceAccountOrGroupName
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END AS [RoleScopeLabel]
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END as [EnvironmentScopeName]
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			LEFT OUTER JOIN
			(
				SELECT 
				[IT2].[ApplicationId]
				,[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_Applications] AS IT2
				CROSS JOIN	[dbo].[vw_DataAccessRoles] AS IT1
				WHERE [IT1].[RoleAuthorityISLDAP] = 1
				AND [IT1].[RoleScope] = 'DB'
				AND [IT2].[ActiveDirectoryGroupTag] IS NOT NULL
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			ON [T1].[ApplicationId] = [T2].[ApplicationId]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			--Create a Temp Table of the ServerPrincipalsLogins table to join with the Accounts table
			DECLARE @FormattedSPLTable TABLE ([UserID] VARCHAR(128), [PlatformSegment] VARCHAR(1), [EnvironmentSegment] VARCHAR(1), [SystemClassSegment] VARCHAR(1),
			[ApplicationSegmentNumeric] INT, [DatabaseSegment] INT, [RoleSegment] INT, [ServerName] VARCHAR(128),
			[DatabaseName] VARCHAR(128), [ApplicationDatabaseSeqID] INT )
			INSERT INTO @FormattedSPLTable
			([UserID], [PlatformSegment], [EnvironmentSegment] , [SystemClassSegment],[ApplicationSegmentNumeric], [DatabaseSegment], [RoleSegment] 
			,[ServerName],[DatabaseName],[ApplicationDatabaseSeqID] )
			SELECT [UserId]
			,SUBSTRING([UserID],1,1) AS [PlatformSegment]
			,SUBSTRING([UserID],2,1) AS [EnvironmentSegment]
			,SUBSTRING([UserID],3,1) AS [SystemClassSegment]
			,CAST([PrimaryApplicationID] AS INT) AS [ApplicationSegmentNumeric]
			,CAST(SUBSTRING([UserID],7,2) AS INT) AS [DatabaseSegment]
			,CAST(SUBSTRING([UserID],9,2) AS INT) AS [RoleSegment]
			,[DBEP3].[HostName]
			,[DBEP3].[DatabaseName]
			,[DBEP3].[ExtendedPropertyValue]
			FROM [dbo].[ServerPrincipalsLogins] AS [SPL1]
			LEFT OUTER JOIN 
				(SELECT 
				[DB1].[ApplicationId]
				,[DB1].[HostName]
				,[DB1].[DatabaseName]
				,[DBEP2].[ExtendedPropertyValue]
				FROM [dbo].[vw_Databases_Inventory] AS DB1
				LEFT OUTER JOIN [dbo].[vw_DatabaseExtendedProperties_CurrentValues] as DBEP2
				ON [DB1].[DatabaseUniqueId] = [DBEP2].DatabaseUniqueId
				WHERE [DBEP2].[ExtendedPropertyName] LIKE 'ApplicationDatabaseSeqID') AS DBEP3
			ON CAST([SPL1].[PrimaryApplicationID] AS INT) = [DBEP3].[ApplicationId]
			AND CAST(SUBSTRING([UserID],7,2) AS INT) = [DBEP3].[ExtendedPropertyValue]
			WHERE USERID LIKE '[A,E][N,P][D,S][0-1]%'
			AND [UserRetiredInd] = 0
			
			select
			[T1].[AccountClass]
			,[T1].[ApplicationSegmentNumeric]
			,[T1].[DatabaseSegmentNumeric]
			,[T1].[RoleSegmentNumeric]
			,[T1].[ApplicationName]
			,CASE WHEN [T1].[PlatformSegment] IS NOT NULL THEN 
				CONCAT([T1].[PlatformSegment],[T1].[EnvironmentSegment],[T1].[SystemClassSegment],[T1].[ApplicationSegment],[T1].[DatabaseSegment],[T1].[RoleSegment])
				ELSE [T1].[ServiceAccountOrGroupName] END AS [ServiceAccountOrGroupName]
			,CASE WHEN [ADG1].[samAccountName] IS NOT NULL THEN 'Yes-Group Exists' ELSE  
				CASE WHEN [T3].[UserID] IS NOT NULL THEN CONCAT([T3].[UserId], ' Database: ',ISNULL([t3].[DatabaseName],'All'),
					CASE WHEN [t3].[DatabaseName] IS NOT NULL THEN CONCAT(' Server: ', [T3].[ServerName]) ELSE NULL END
				) ELSE NULL END
				END AS ServiceAccountExists
			,[T1].[RoleScopeLabel]
			,[T1].[RoleAuthority]
			,[T1].[RoleAuthorityIsLDAP]	
			,[T1].[RoleName]
			,[T1].[EnvironmentScope]
			,[T1].[EnvironmentScopeName]
			,[T1].[GrantDescription]
			,[T1].[PurposeDescription]
			from @AccountTable2 AS T1
			LEFT OUTER JOIN [sec].[vw_ADGroups] AS ADG1
			ON [t1].[ServiceAccountOrGroupName] = [ADG1].[samAccountName]
			LEFT OUTER JOIN
			(
				SELECT
				[UserID], [PlatformSegment], [EnvironmentSegment],[SystemClassSegment],[ApplicationSegmentNumeric], [DatabaseSegment], [RoleSegment] 
				,[ServerName],[DatabaseName],[ApplicationDatabaseSeqID]
				FROM @FormattedSPLTable
			) AS T3
			ON [T1].[PlatformSegment] = [T3].[PlatformSegment]
			AND [T1].[EnvironmentSegment] = [T3].[EnvironmentSegment]
			AND [T1].[SystemClassSegment] = [T3].[SystemClassSegment]
			AND [T1].[ApplicationSegmentNumeric] = [T3].ApplicationSegmentNumeric
			AND [T1].[RoleSegmentNumeric] = [T3].[RoleSegment]
			
						
		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DataAccessRoles_by_ETL]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_DataAccessRoles_by_ETL] 
(@pApplicationIDs VARCHAR(4000)  --app id
,@pEnvironmentScope INT -- -1 or NULL indicates both, 0 = non-production only, 1 indicates production only
,@pRoleAuthorities INT -- -1 or NULL indicates both, 0 = SQL Server only, 1 indicates ActiveDirectory only
)
AS 
BEGIN
	--Setting NOCOUNT ON removes the row count as output
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  

	BEGIN TRY
		--if null value is passed then default to all  applications
		DECLARE @ProductionIndLow BIT
		DECLARE @ProductionIndHigh BIT
		DECLARE @RoleAuthorityLow BIT
		DECLARE @RoleAuthorityHigh BIT

		IF ISNULL(@pEnvironmentScope,-1) = -1
		BEGIN
			SET @ProductionIndLow = 0
			SET @ProductionIndHigh = 1
		END
		ELSE
		BEGIN
			SET @ProductionIndLow = @pEnvironmentScope
			SET @ProductionIndHigh = @ProductionIndLow
		END

		IF ISNULL(@pRoleAuthorities,-1) = -1
		BEGIN
			SET @RoleAuthorityLow = 0
			SET @RoleAuthorityHigh = 1
		END
		ELSE
		BEGIN
			SET @RoleAuthorityLow = @pRoleAuthorities
			SET @RoleAuthorityHigh = @RoleAuthorityLow
		END
	
		DECLARE @ApplicationIDs TABLE (pAppID INT)
		IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
		BEGIN
			INSERT INTO @ApplicationIDs
			SELECT DISTINCT [ApplicationId]
			FROM [dbo].[vw_Applications]
		END
		ELSE
		BEGIN
		--use custom function to split input string into a table of integers
			INSERT INTO @ApplicationIDs
			SELECT item
			FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
		END
		BEGIN TRAN

			DECLARE @SysPrefix varchar(1)
			DECLARE @AccountTable TABLE ([AccountClass] VARCHAR(25), [FormattedApplicationID] CHAR(3),[ApplicationName] VARCHAR(128), [CustomRoleID] BIGINT, [SystemTier] VARCHAR(15),[ServiceAccountOrGroupName] VARCHAR(128), [ServiceAccountRoot] VARCHAR(128), [RoleScope] CHAR(2), [RoleScopeLabel] VARCHAR(20), [RoleAuthority] VARCHAR(15),[RoleAuthorityIsLDAP] BIT, [RoleName] VARCHAR(25), 
			[EnvironmentScope] VARCHAR(1), [EnvironmentScopeName] VARCHAR(30), [GrantDescription] VARCHAR(1000), [PurposeDescription] VARCHAR(1000) )
			IF (@ProductionIndLow = 0)
			BEGIN
				SET @SysPrefix = 'D'
				--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
				--Will be returing all the roles with their definitions for the given components
				INSERT INTO @AccountTable
				([AccountClass] 
				,[FormattedApplicationID]
				,[ApplicationName]
				,[CustomRoleID]
				,[SystemTier] 
				,[ServiceAccountOrGroupName]
				,[ServiceAccountRoot]
				,[RoleScope]
				,[RoleScopeLabel]
				,[RoleAuthority]
				,[RoleAuthorityIsLDAP]
				,[RoleName]
				,[EnvironmentScope]
				,[EnvironmentScopeName]
				,[GrantDescription]
				,[PurposeDescription])
				SELECT 
				'ServiceAcounts',
				[T1].[FormattedApplicationID]
				,[T1].[ApplicationName]
				,[T2].[CustomRoleID]
				,'Desktop'
				,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID],'##')
				,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
				,[T2].[RoleScope]
				,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
				,[T2].[RoleAuthority]
				,[T2].[RoleAuthorityIsLDAP]
				,[T2].[RoleName]
				,[T2].[EnvironmentScope]
				,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END 
				,[T2].[GrantDescription]
				,[T2].[PurposeDescription]
				from [dbo].[vw_Applications] AS T1
				cross join 
				(
					SELECT 
					[IT1].[CustomRoleID]
					,[IT1].[FormattedCustomRoleID]
					,[IT1].[RoleScope]
					,[IT1].[RoleAuthority]
					,[IT1].[RoleAuthorityIsLDAP]
					,[IT1].[RoleName]
					,[IT1].[EnvironmentScope]
					,[IT1].[GrantDescription]
					,[IT1].[PurposeDescription]
					,[IT1].[IsProductionRoleInd]  
					FROM [dbo].[vw_DataAccessRoles] AS IT1
					WHERE [RoleAuthorityISLDAP] = 0
					AND [RoleAuthority] = 'SQLServer'
					AND [IT1].[IsProductionRoleInd] = 0
					AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
					) AS [T2]
				WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			SET @SysPrefix = 'S'
			--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
			--Will be returing all the roles with their definitions for the given components
			INSERT INTO @AccountTable
			([AccountClass] 
			,[FormattedApplicationID]
			,[ApplicationName]
			,[CustomRoleID]
			,[SystemTier] 
			,[ServiceAccountOrGroupName]
			,[ServiceAccountRoot]
			,[RoleScope]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription])
			SELECT 
			'ServiceAcounts',
			[T1].[FormattedApplicationID]
			,[T1].[ApplicationName]
			,[T2].[CustomRoleID]
			,'Server'
			,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID],'##')
			,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
			,[T2].[RoleScope]
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END 
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)

			IF (@RoleAuthorityHigh = 1)
			BEGIN
			--Instead of doing a cross join, do a left outer join to a cross join for applications that have an AD Group value assigned
			INSERT INTO @AccountTable
			([AccountClass] 
			,[FormattedApplicationID]
			,[ApplicationName]
			,[CustomRoleID]
			,[SystemTier] 
			,[ServiceAccountOrGroupName]
			,[ServiceAccountRoot]
			,[RoleScope]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleAuthorityIsLDAP]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription])
			SELECT 
			'ADGroups',
			[T1].[FormattedApplicationID]
			,[T1].[ApplicationName]
			,[T2].[CustomRoleID]
			,'Server'
			,CASE WHEN [T1].[ActiveDirectoryGroupTag] IS NOT NULL THEN CONCAT('SQL_',[T1].[ActiveDirectoryGroupTag],'_',[T2].[RoleName]) ELSE 'NONE' END as ServiceAccountOrGroupName
			,NULL
			,[T2].[RoleScope]
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END AS [RoleScopeLabel]
			,[T2].[RoleAuthority]
			,[T2].[RoleAuthorityIsLDAP]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END as [EnvironmentScopeName]
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			LEFT OUTER JOIN
			(
				SELECT 
				[IT2].[ApplicationId]
				,[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_Applications] AS IT2
				CROSS JOIN	[dbo].[vw_DataAccessRoles] AS IT1
				WHERE [IT1].[RoleAuthorityISLDAP] = 1
				AND [IT2].[ActiveDirectoryGroupTag] IS NOT NULL
				AND [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
				AND [IT1].[RoleAuthorityIsLDAP] BETWEEN @RoleAuthorityLow AND @RoleAuthorityHigh
				) AS [T2]
			ON [T1].[ApplicationId] = [T2].[ApplicationId]
			WHERE [T1].[ApplicationId] IN (SELECT pAppID FROM @ApplicationIDs)
			END

			SELECT
			[AT1].[ApplicationName]
			,[AT1].[AccountClass]
			,[AT1].[EnvironmentScopeName]
			,[AT1].[FormattedApplicationID]
			,[AT1].[SystemTier] 
			,RIGHT(CONCAT('000',[AT1].[CustomRoleID]),3) AS [CustomRoleID]
			,[AT1].[ServiceAccountRoot]
			,[AT1].[RoleScopeLabel]
			,CASE WHEN [AT1].[RoleAuthorityIsLDAP] = 0 THEN 
				CASE WHEN [SPL1].[FormattedUSERID] IS NULL THEN 'N - Account not generated yet' ELSE CONCAT('Y - ',[SPL1].[UserId]) END 
			 ELSE NULL END AS [CurrentAccountInUse]
			,[AT1].[ServiceAccountOrGroupName]
			,[AT1].[RoleAuthority]
			,[AT1].[RoleName]
			,[AT1].[EnvironmentScope]
			,[AT1].[RoleScope]
			,[AT1].[GrantDescription]
			,[AT1].[PurposeDescription] 
			FROM @AccountTable AS [AT1]
			LEFT OUTER JOIN 
				(
				SELECT DISTINCT 
				[USERID]
				,REVERSE(SUBSTRING(REVERSE([USERID]),2,LEN([USERID]))) AS FormattedUSERID 
				FROM [dbo].[vw_ServerPrincipalsLogins] 
				WHERE [UserRetiredInd] = 0) AS SPL1
			ON [AT1].[ServiceAccountRoot] = [SPL1].[FormattedUSERID]

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DataAccessRoles_by_Type]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_DataAccessRoles_by_Type] 
(@pEnvironmentScope INT -- -1 or NULL indicates both, 0 = non-production only, 1 indicates production only
,@pRoleAuthority VARCHAR(15)
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
	DECLARE @ProductionIndLow BIT
	DECLARE @ProductionIndHigh BIT
	DECLARE @RoleAuthorityLow BIT
	DECLARE @RoleAuthorityHigh BIT

	IF ISNULL(@pEnvironmentScope,-1) = -1
	BEGIN
		SET @ProductionIndLow = 0
		SET @ProductionIndHigh = 1
	END
	ELSE
	BEGIN
		SET @ProductionIndLow = @pEnvironmentScope
		SET @ProductionIndHigh = @ProductionIndLow
	END

	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
		[IT1].[CustomRoleID]
		,[IT1].[FormattedCustomRoleID]
		,[IT1].[RoleScope]
		,[IT1].[RoleAuthority]
		,[IT1].[RoleName]
		,CASE [IT1].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END as [EnvironmentScopeName]
		,[IT1].[EnvironmentScope]
		,[IT1].[GrantDescription]
		,[IT1].[PurposeDescription]
		,[IT1].[Abbreviation]
		,[IT1].[LastUpdateDt]
		FROM [dbo].[vw_DataAccessRoles] AS [IT1]
		WHERE [IT1].[IsProductionRoleInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
		AND [IT1].[RoleAuthority] LIKE @pRoleAuthority
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DataAccessRoles_Search_AccountName]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_DataAccessRoles_Search_AccountName] 
(@pSearchString VARCHAR(20)  -- text string including wildcard searches
)

AS 
BEGIN
	--Setting NOCOUNT ON removes the row count as output
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  

	BEGIN TRY
			DECLARE @SysPrefix varchar(1)
			DECLARE @AccountTable TABLE ([AccountClass] VARCHAR(25), [FormattedApplicationID] CHAR(3),[ApplicationName] VARCHAR(128), [CustomRoleID] BIGINT, [SystemTier] VARCHAR(15),[ServiceAccountOrGroupName] VARCHAR(128), [ServiceAccountRoot] VARCHAR(128), [RoleScope] CHAR(2), [RoleScopeLabel] VARCHAR(20), [RoleAuthority] VARCHAR(15), [RoleName] VARCHAR(25), 
			[EnvironmentScope] VARCHAR(1), [EnvironmentScopeName] VARCHAR(30), [GrantDescription] VARCHAR(1000), [PurposeDescription] VARCHAR(1000) )
			
			BEGIN
				SET @SysPrefix = 'D'
				--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
				--Will be returing all the roles with their definitions for the given components
				INSERT INTO @AccountTable
				([AccountClass] 
				,[FormattedApplicationID]
				,[ApplicationName]
				,[CustomRoleID]
				,[SystemTier] 
				,[ServiceAccountOrGroupName]
				,[ServiceAccountRoot]
				,[RoleScope]
				,[RoleScopeLabel]
				,[RoleAuthority]
				,[RoleName]
				,[EnvironmentScope]
				,[EnvironmentScopeName]
				,[GrantDescription]
				,[PurposeDescription])
				SELECT 
				'ServiceAcounts',
				[T1].[FormattedApplicationID]
				,[T1].[ApplicationName]
				,[T2].[CustomRoleID]
				,'Desktop'
				,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
				,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
				,[T2].[RoleScope]
				,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
				,[T2].[RoleAuthority]
				,[T2].[RoleName]
				,[T2].[EnvironmentScope]
				,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END
				,[T2].[GrantDescription]
				,[T2].[PurposeDescription]
				from [dbo].[vw_Applications] AS T1
				cross join 
				(
					SELECT 
					[IT1].[CustomRoleID]
					,[IT1].[FormattedCustomRoleID]
					,[IT1].[RoleScope]
					,[IT1].[RoleAuthority]
					,[IT1].[RoleAuthorityIsLDAP]
					,[IT1].[RoleName]
					,[IT1].[EnvironmentScope]
					,[IT1].[GrantDescription]
					,[IT1].[PurposeDescription]
					,[IT1].[IsProductionRoleInd]  
					FROM [dbo].[vw_DataAccessRoles] AS IT1
					WHERE [RoleAuthorityISLDAP] = 0
					AND [RoleAuthority] = 'SQLServer'
					AND [IT1].[IsProductionRoleInd] = 0
					) AS [T2]
			END

			SET @SysPrefix = 'S'
			--As as SQL Service Account, the information needed is related to A-application, environment (P or N), system tier (S or D), the application, and the roles
			--Will be returing all the roles with their definitions for the given components
			INSERT INTO @AccountTable
			([AccountClass] 
			,[FormattedApplicationID]
			,[ApplicationName]
			,[CustomRoleID]
			,[SystemTier] 
			,[ServiceAccountOrGroupName]
			,[ServiceAccountRoot]
			,[RoleScope]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription])
			SELECT 
			'ServiceAcounts',
			[T1].[FormattedApplicationID]
			,[T1].[ApplicationName]
			,[T2].[CustomRoleID]
			,'Server'
			,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
			,CONCAT('A', [T2].[EnvironmentScope],@SysPrefix,[T1].[FormattedApplicationID],'00',[T2].[FormattedCustomRoleID])
			,[T2].[RoleScope]
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END
			,[T2].[RoleAuthority]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			cross join 
				(
				SELECT 
				[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_DataAccessRoles] AS IT1
				WHERE [RoleAuthorityISLDAP] = 0
				AND [RoleAuthority] = 'SQLServer'
				) AS [T2]

			--Instead of doing a cross join, do a left outer join to a cross join for applications that have an AD Group value assigned
			INSERT INTO @AccountTable
			([AccountClass] 
			,[FormattedApplicationID]
			,[ApplicationName]
			,[CustomRoleID]
			,[SystemTier] 
			,[ServiceAccountOrGroupName]
			,[ServiceAccountRoot]
			,[RoleScope]
			,[RoleScopeLabel]
			,[RoleAuthority]
			,[RoleName]
			,[EnvironmentScope]
			,[EnvironmentScopeName]
			,[GrantDescription]
			,[PurposeDescription])
			SELECT 
			'ADGroups',
			[T1].[FormattedApplicationID]
			,[T1].[ApplicationName]
			,[T2].[CustomRoleID]
			,'Server'
			,CASE WHEN [T1].[ActiveDirectoryGroupTag] IS NOT NULL THEN CONCAT('SQL_',[T1].[ActiveDirectoryGroupTag],'_',[T2].[RoleName]) ELSE 'NONE' END as ServiceAccountOrGroupName
			,NULL
			,[T2].[RoleScope]
			,CASE WHEN PATINDEX('SI',[T2].[RoleScope]) > 0 THEN 'Server Level' ELSE 'Database Level' END AS [RoleScopeLabel]
			,[T2].[RoleAuthority]
			,[T2].[RoleName]
			,[T2].[EnvironmentScope]
			,CASE [T2].[IsProductionRoleInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END as [EnvironmentScopeName]
			,[T2].[GrantDescription]
			,[T2].[PurposeDescription]
			from [dbo].[vw_Applications] AS T1
			LEFT OUTER JOIN
			(
				SELECT 
				[IT2].[ApplicationId]
				,[IT1].[CustomRoleID]
				,[IT1].[FormattedCustomRoleID]
				,[IT1].[RoleScope]
				,[IT1].[RoleAuthority]
				,[IT1].[RoleAuthorityIsLDAP]
				,[IT1].[RoleName]
				,[IT1].[EnvironmentScope]
				,[IT1].[GrantDescription]
				,[IT1].[PurposeDescription]
				,[IT1].[IsProductionRoleInd]  
				FROM [dbo].[vw_Applications] AS IT2
				CROSS JOIN	[dbo].[vw_DataAccessRoles] AS IT1
				WHERE [IT1].[RoleAuthorityISLDAP] = 1
				AND [IT2].[ActiveDirectoryGroupTag] IS NOT NULL
				) AS [T2]
			ON [T1].[ApplicationId] = [T2].[ApplicationId]

			SELECT
			[AT1].[ApplicationName]
			,[AT1].[AccountClass]
			,[AT1].[EnvironmentScopeName]
			,[AT1].[FormattedApplicationID]
			,[AT1].[SystemTier] 
			,RIGHT(CONCAT('000',[AT1].[CustomRoleID]),3) AS [CustomRoleID]
			,[AT1].[ServiceAccountRoot]
			,[AT1].[RoleScopeLabel]
			,CASE WHEN [SPL1].[FormattedUSERID] IS NULL THEN 'N - Account not generated yet' ELSE CONCAT('Y - ',[SPL1].[FormattedUSERID]) END AS [CurrentAccountInUse]
			,[AT1].[ServiceAccountOrGroupName]
			,[AT1].[RoleAuthority]
			,[AT1].[RoleName]
			,[AT1].[EnvironmentScope]
			,[AT1].[RoleScope]
			,[AT1].[GrantDescription]
			,[AT1].[PurposeDescription] 
			FROM @AccountTable AS [AT1]
			LEFT OUTER JOIN 
				(SELECT DISTINCT 
				[USERID]
				,REVERSE(SUBSTRING(REVERSE([USERID]),3,LEN([USERID]))) AS FormattedUSERID FROM [dbo].[vw_ServerPrincipalsLogins] WHERE [UserRetiredInd] = 0) AS SPL1
			ON [AT1].[ServiceAccountRoot] = [SPL1].[FormattedUSERID]
			WHERE [AT1].[ServiceAccountOrGroupName] LIKE @pSearchString

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DatabaseFiles_GrowthHistory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_DatabaseFiles_GrowthHistory]
(@pfirstdate date
,@pcalendarbasis nvarchar(10)
,@pincludesystemdbs bit
,@pDatabaseName VARCHAR(128))
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
BEGIN TRY
DECLARE @tAvgGrowth TABLE (
[ServerInstanceId] [int] NOT NULL,
[DatabaseName] [NVARCHAR] (128) NOT NULL,
[DatabaseFileID] [int]  NOT NULL,
[FileRank] [int] NOT NULL,
[FileID] [int] NULL,
[FileType] [nvarchar](15) NULL,
[DriveLetter] [NVARCHAR] (1) NOT NULL,
[db_File_Name] [NVARCHAR] (128) NOT NULL,
[db_File_Path] [NVARCHAR] (128) NOT NULL,
[LastReportedDate] [date] NOT NULL,
[IsPrimaryFileInd] [bit] NOT NULL,
[Size] [float] NULL,
[UsedSpace] [float] NULL,
[VolumeFreeSpace] [bigint] NULL,
[SizeChange] [float] NULL,
[UsedSpaceChange] [float] NULL,
[VolumeFreeSpaceChange] [bigint] NULL)

INSERT INTO @tAvgGrowth (
[FileRank],
[ServerInstanceId],
[DatabaseName],
[DatabaseFileID],
[FileID],
[FileType],
[DriveLetter],
[db_File_Name],
[db_File_Path],
[LastReportedDate],
[IsPrimaryFileInd],
[Size],
[UsedSpace],
[VolumeFreeSpace],
[SizeChange],
[UsedSpaceChange],
[VolumeFreeSpaceChange])
EXECUTE [dbousp_DatabaseFiles_GrowthByDateRangeKBnge] 
   @pfirstdate
  ,@pcalendarbasis
  ,@pincludesystemdbs
  ,@pDatabaseName

SELECT
[ServerInstanceId]
,[DatabaseName]
,[db_File_Name]
,COUNT([LastReportedDate]) AS numberofperiods
,CAST(AVG([Size]) AS BIGINT) AS AverageFileSize
,CAST(AVG([UsedSpace]) AS BIGINT) AS AverageSpaceUsed
,CAST(AVG([SizeChange]) AS INT) as AverageFileSizeChange
,CAST(AVG([UsedSpaceChange]) AS INT) as AverageSpaceUsedChange
,CAST(AVG([VolumeFreeSpace]) AS BIGINT) AS AverageVolumeFreeSpace
,CAST(AVG([VolumeFreeSpaceChange]) AS INT) as AverageVolumeFreeSpaceChange
FROM @tAvgGrowth
GROUP BY
[ServerInstanceId]
,[DatabaseName]
,[db_File_Name]
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DatabaseFiles_HistoricalMetrics]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_DatabaseFiles_HistoricalMetrics]
(@pfirstdate date
,@pcalendarbasis nvarchar(10)
,@pincludesystemdbs bit
,@pDatabaseName VARCHAR(128))
AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
BEGIN TRY
	DECLARE @tAvgChange TABLE (
	[ServerInstanceId] [int] NOT NULL,
	[DatabaseName] [NVARCHAR] (128) NOT NULL,
	[DatabaseFileID] [int]  NOT NULL,
	[FileRank] INT NOT NULL,
	[FileID] [int] NULL,
	[FileType] [nvarchar](15) NULL,
	[DriveLetter] [NVARCHAR] (1) NOT NULL,
	[db_File_Name] [NVARCHAR] (128) NOT NULL,
	[db_File_Path] [NVARCHAR] (128) NOT NULL,
	[LastReportedDate] [date] NOT NULL,
	[IsPrimaryFileInd] [bit] NOT NULL,
	[Size] [float] NULL,
	[UsedSpace] [float] NULL,
	[VolumeFreeSpace] [bigint] NULL,
	[SizeChange] [float] NULL,
	[UsedSpaceChange] [float] NULL,
	[VolumeFreeSpaceChange] [bigint] NULL)

	INSERT INTO @tAvgChange (
	[FileRank],
	[ServerInstanceId],
	[DatabaseName],
	[DatabaseFileID],
	[FileID],
	[FileType],
	[DriveLetter],
	[db_File_Name],
	[db_File_Path],
	[LastReportedDate],
	[IsPrimaryFileInd],
	[Size],
	[UsedSpace],
	[VolumeFreeSpace],
	[SizeChange],
	[UsedSpaceChange],
	[VolumeFreeSpaceChange])
	EXECUTE [dbousp_DatabaseFiles_GrowthByDateRangeKBnge] 
	   @pfirstdate
	  ,@pcalendarbasis
	  ,@pincludesystemdbs
	  ,@pDatabaseName


	SELECT
	[DBFM1].[ServerInstanceId]
	,[DBFM1].[DatabaseName]
	,[DBFM1].[db_File_Name]
	,COUNT([DBFM1].[LastReportedDate]) AS numberofperiods
	,CAST(MAX([DBFM1].[Size]) AS BIGINT) AS MaxFileSize
	,CAST(MIN([DBFM1].[Size]) AS BIGINT) AS MinFileSize
	,CAST(AVG([DBFM1].[Size]) AS BIGINT) AS AverageFileSize
	,CAST(MAX([DBFM1].[UsedSpace]) AS BIGINT) AS MaxSpaceUsed
	,CAST(MIN([DBFM1].[UsedSpace]) AS BIGINT) AS MinSpaceUsed
	,CAST(AVG([DBFM1].[UsedSpace]) AS BIGINT) AS AverageSpaceUsed
	,CAST(MAX([DBFM1].[SizeChange]) AS INT) as MaxFileSizeChange
	,CAST(MIN([DBFM1].[SizeChange]) AS INT) as MinFileSizeChange
	,CAST(AVG([DBFM1].[SizeChange]) AS INT) as AverageFileSizeChange
	,CAST(MAX([DBFM1].[UsedSpaceChange]) AS INT) as MaxSpaceUsedChange
	,CAST(MIN([DBFM1].[UsedSpaceChange]) AS INT) as MinSpaceUsedChange
	,CAST(AVG([DBFM1].[UsedSpaceChange]) AS INT) as AverageSpaceUsedChange
	,CAST(MAX([DBFM1].[VolumeFreeSpace]) AS BIGINT) AS MaxVolumeFreeSpace
	,CAST(MIN([DBFM1].[VolumeFreeSpace]) AS BIGINT) AS MinVolumeFreeSpace
	,CAST(AVG([DBFM1].[VolumeFreeSpace]) AS BIGINT) AS AverageVolumeFreeSpace
	,CAST(MAX([DBFM1].[VolumeFreeSpaceChange]) AS INT) as MaxVolumeFreeSpaceChange
	,CAST(MIN([DBFM1].[VolumeFreeSpaceChange]) AS INT) as MinVolumeFreeSpaceChange
	,CAST(AVG([DBFM1].[VolumeFreeSpaceChange]) AS INT) as AverageVolumeFreeSpaceChange
	FROM @tAvgChange AS DBFM1
	GROUP BY
	[DBFM1].[ServerInstanceId]
	,[DBFM1].[DatabaseName]
	,[DBFM1].[db_File_Name]
END TRY
BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_DatabaseMaintenance_DuplicateItems]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_DatabaseMaintenance_DuplicateItems]
AS
BEGIN
/*
Author: Danny Howell
Description: The procedure should return no rows.  If there are any rows, then there is a logical error in the SSIS package performing processing
Dataset returns databases for which statistics are updated twice per the same statistics update job.
This provides a validation of package logical processing.  There should be no tables where the same stat is updated more than once within the same package execution. Package testing indicated the logic determining which stats were subject to updating may have incorrectly evaluated history and performed invalid joins resulting in a statistic being updated multiple times.  This extended the maintenance beyond the acceptable window and duplication of stats updates is an error.


*/
;with maintenancesum ([maintenance_job_class], [maintenance_job_id],[maintenance_job_date],[database_name],[schema_name],[table_name],[statistic_name],[dupl_stat_count])
AS
(
SELECT 
'Statistics_Update'
,[MT1].[statssummary_job_id]
,[MT2].[statsupdate_job_date]
,[MT2].[database_name]
,[MT1].[schema_name]
,[MT1].[table_name]
,[MT1].[statistic_name]
,COUNT(*)
FROM [dbo].[Statistics_Update_History_Detail] AS [MT1]
INNER JOIN [dbo].[Statistics_Update_History_Summary] AS [MT2]
ON [MT1].[statssummary_job_id] = [MT2].[statssummary_job_id]
GROUP BY
[MT1].[statssummary_job_id]
,[MT2].[statsupdate_job_date]
,[MT2].[database_name]
,[MT1].[schema_name]
,[MT1].[table_name]
,[MT1].[statistic_name]
HAVING COUNT(*) > 1
UNION ALL
SELECT 
'Index_Defragmentation'
,[MT3].[defragmentation_job_id]
,[MT3].[last_user_update]
,[MT4].[database_name]
,[MT3].[schema_name]
,[MT3].[table_name]
,[MT3].[index_name]
,COUNT(*)
FROM [dbo].[Index_Defragmentation_History_Detail] AS [MT3]
INNER JOIN [dbo].[Index_Defragmentation_History_Summary] AS [MT4]
ON [MT3].[defragmentation_job_id] = [MT4].[defragmentation_job_id]
GROUP BY
[MT3].[defragmentation_job_id]
,[MT3].[last_user_update]
,[MT4].[database_name]
,[MT3].[schema_name]
,[MT3].[table_name]
,[MT3].[index_name]
HAVING COUNT(*) > 1

)

SELECT
[maintenance_job_class]
,[maintenance_job_id]
,[maintenance_job_date]
,[database_name]
,[schema_name]
,[table_name]
,[statistic_name]
,[dupl_stat_count]
FROM maintenancesum as [T1]
ORDER BY 
[database_name]
,[maintenance_job_class]


END

/*
Stats summary IDs by ExecutionID--to get duration and max/min IDs for each time the AB job was run
*/
/*
SELECT
'First & Last stats job by executionGUID--will need for report--LOJ to job date by GUID',
[[T2]].[executioninstanceGUID]
,[T3].[JobStartDate]
,min([[T2]].[statssummary_job_id]) as firststatssumaryid
,max([[T2]].[statssummary_job_id]) as laststatssumaryid
,t3.duration
--,[t3].JobStartTime,[t3].JobEndTime
 FROM [dbo].[Statistics_Update_History_Summary] as [T2]
 LEFT OUTER JOIN
	(
	SELECT [executioninstanceGUID]
	,MIN([STATSUPDATE_JOB_date]) as [JobStartDate]
	,min([statsupdate_job_starttime]) as [JobStartTime]
	,max([statsupdate_job_endtime]) as [JobEndTime]
	,datediff(minute,min([statsupdate_job_starttime]),max([statsupdate_job_endtime])) as duration
	FROM [dbo].[Statistics_Update_History_Summary] 
	GROUP BY [executioninstanceGUID]) AS t3
ON [[T2]].[executioninstanceGUID] = [T3].[executioninstanceGUID]
 group by 
 [[T2]].[executioninstanceGUID]
 ,[T3].[JobStartDate]
 ,t3.duration
 ORDER BY [T3].[JobStartDate] DESC
 */


/*
Stats job by Stats summary IDs--gets the per database information on the maintenance job--used in reporting
*/
/*
SELECT 
'Current job status',
[[T2]].[statssummary_job_id]
,[[T2]].[statsupdate_job_date]
,[[T2]].[statsupdate_process_completed_ind]
,datediff(minute,[[T2]].[statsupdate_job_starttime],ISNULL([[T2]].[statsupdate_job_endtime],GETDATE())) AS TimeToProcessDBStats
,[t3].[statsupdatedcount]
,[[T2]].[executioninstanceGUID]
,[[T2]].[database_id]
,[[T2]].[database_name]
,[[T2]].[statsupdate_comments]
FROM [dbo].[Statistics_Update_History_Summary] as [T2]
LEFT OUTER JOIN 
	(SELECT [statssummary_job_id]
	,[database_id]
	,count([statistic_name]) as statsupdatedcount
	FROM [dbo].[Statistics_Update_History_Detail]
	group by 
	[statssummary_job_id]
	,[database_id]
	) AS T3
ON [[T2]].[statssummary_job_id] = [T3].[statssummary_job_id]
order by [T2].statssummary_job_id desc
*/

/*
use pc_prod
go
declare @currdbid int
--set @currdbid = db_id()
SELECT 
	@currdbid = MAX([statssummary_job_id])
	FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Summary] 
	WHERE [database_id] = db_id()


select 
OBJECT_NAME(s1.object_id),
s1.auto_created
,s1.user_created
,[CSJ1].[table_row_count]
,[CSJ1].[statsupdate_completed_ind]
,[CSJ1].[statsupdate_performed_ind]
,[CSJ1].[statsupdate_failed_ind]
,[CSJ1].[statsupdate_fromindexdefrag]
,[CSJ1].[statsupdate_scan_type_performed]
,'need to provide text of scantypeperformeID'
,datediff(minute,[csj1].[statsupdate_task_starttime],[csj1].[statsupdate_task_endtime]) as statsupdatetime
,[CSJ1].[statsupdate_task_starttime]
,[CSJ1].[statsupdate_task_endtime]
,[CSJ1].[system_last_updated]
,[CSJ1].[rows_sampled]
,[CSJ1].[statistic_specific_comments]
from sys.stats as s1
left outer join 
(SELECT [SD1].[statssummary_job_id]
      ,[SD1].[schema_name]
      ,[SD1].[table_id]
      ,[SD1].[table_name]
      ,[SD1].[statistic_id]
      ,[SD1].[statistic_name]
      ,[SD1].[table_row_count]
      ,[SD1].[statsupdate_completed_ind]
      ,[SD1].[statsupdate_performed_ind]
      ,[SD1].[statsupdate_failed_ind]
      ,[SD1].[statsupdate_fromindexdefrag]
      ,[SD1].[statsupdate_scan_type_performed]
	  ,[SD1].[statsupdate_task_starttime]
      ,[SD1].[statsupdate_task_endtime]
      ,[SD1].[auto_created]
      ,[SD1].[user_created]
      ,[SD1].[system_last_updated]
      ,[SD1].[rows_sampled]
      ,[SD1].[statistic_specific_comments]
  FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Detail]  AS SD1 
  WHERE [SD1].[statssummary_job_id] = @currdbid
  ) as csj1
  on s1.object_id = csj1.table_id
  and s1.stats_id = csj1.statistic_id
where OBJECT_SCHEMA_NAME(object_id) not like 'sys'
--and csj1.table_name is null

*/
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_By_Application]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_By_Application] 
(@pApplicationIDs VARCHAR(8000)
,@pIncludeNonProdInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	--if null value is passed then default to all  applications
	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
	DECLARE @ApplicationIDs TABLE (pAppID INT)
	IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
	BEGIN
		INSERT INTO @ApplicationIDs
		SELECT DISTINCT [ApplicationId]
		FROM [dbo].[vw_Applications]
		
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
	END

	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	
	If @pIncludeNonProdInd = 1
	BEGIN
		SET @ProductionIndLow = 0
	END

	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
		[DB1].[DatabaseUniqueId]
		,[SHS1].[ServerSystemID]
		,[SHS1].[HostName]
		,[SHS1].[ProductionInd]
		,[S1].[InstanceName]
		,[SIVP1].[SQLVersionDescription]
		,[DB1].[ServerInstanceID]
		,CAST(CASE WHEN [S1].[RetiredInd] = 1 THEN 1 ELSE
		CASE WHEN [S1].[RetiredInd] = 0 THEN [SHS1].[RetiredInd] ELSE 0 END
		END AS BIT) AS OnRetiredInstance
		,[DB1].[DatabaseName]
		,[DBCL1].[DatabaseCompatibilityLevel]
		,[DBApp1].[ApplicationId]
		,[DBApp1].[ApplicationName]
		,[DBApp1].[BusinessCategoryDesc]
		FROM [dbo].[vw_Databases_Inventory] AS DB1
		INNER JOIN [dbo].[vw_DatabaseApplications] AS DBApp1
		ON DB1.DatabaseUniqueId = DBApp1.DatabaseUniqueId
		LEFT OUTER JOIN [dbo].[vw_ServerInstances] AS S1
		ON [DB1].[ServerInstanceID] = [S1].[ServerInstanceID]
		INNER JOIN [dbo].[vw_Servers] AS SHS1
		ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
		INNER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
		ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
		LEFT OUTER JOIN
		(SELECT DISTINCT 
		DatabaseUniqueId
		, DatabasePropertyName
		, CAST(RTRIM(LTRIM(REPLACE(DatabasePropertyValue, 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
		FROM [dbo].[vw_DatabaseProperties] AS DBP1
		WHERE
		(DatabasePropertyName LIKE 'CompatibilityLevel') 
		OR (DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')) AS DBCL1
		ON [DB1].DatabaseUniqueId = DBCL1.DatabaseUniqueId
		WHERE 
		CAST([DBApp1].[ApplicationId] AS NVARCHAR(4000)) IN (SELECT CAST(pAppID AS NVARCHAR(4000)) FROM @ApplicationIDs)
		AND [SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_By_Application2]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_By_Application2] 
(@pApplicationIDs VARCHAR(8000) 
,@pIncludeDatabaseNoLongerUsedInd BIT
,@pIncludeDeletedCopiesOfCurrentDBsInd BIT
)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	--if parameters for include deleted databases and include databases no longer used are null, then set to FALSE (do not include)
	IF @pIncludeDatabaseNoLongerUsedInd IS NULL 
	BEGIN
	SET @pIncludeDatabaseNoLongerUsedInd = 0
	END

	IF @pIncludeDeletedCopiesOfCurrentDBsInd IS NULL 
	BEGIN
		SET @pIncludeDeletedCopiesOfCurrentDBsInd = 0
	END


	DECLARE @ApplicationIDs TABLE (pAppID INT)
	IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
	BEGIN
		INSERT INTO @ApplicationIDs
		SELECT DISTINCT [ApplicationId]
		FROM [dbo].[vw_Applications]
	END
	ELSE
	BEGIN
		--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
	END


	DECLARE @T1 TABLE 
	([DatabaseURN] NVARCHAR(256)
	,[DatabaseCount] INT
	)
	
	--It is assumed that reports always include current, non-deleted databases
	INSERT INTO @T1 ([DatabaseURN],[DatabaseCount])
	SELECT  [DatabaseURN]
	,COUNT([DatabaseUniqueId]) 
	FROM [dbo].[vw_Databases]
	WHERE LatestReportedDate IS NULL
	AND DeletedInd = 0	
	group by [DatabaseURN]

	IF @pIncludeDatabaseNoLongerUsedInd = 1
	BEGIN
	INSERT INTO @T1 ([DatabaseURN],[DatabaseCount])
	SELECT [DeletedDBs].[DatabaseURN]
	,0
	FROM [dbo].[vw_Databases] AS DeletedDBs
	LEFT OUTER JOIN @T1 AS DBT2
	ON [DeletedDBs].[DatabaseURN] = [DBT2].[DatabaseURN]
	WHERE [DBT2].[DatabaseURN] IS NULL
	GROUP BY [DeletedDBs].[DatabaseURN]
	END

	--If the flag to include deleted databases, get the DatabaseURN of the databases
	IF @pIncludeDeletedCopiesOfCurrentDBsInd = 1
	BEGIN
		UPDATE @T1
		SET [DatabaseCount] = [DBT1].[DatabaseCount] + [DBV1].[DelDBCount]
		FROM @T1 AS DBT1
		INNER JOIN 
		(
		SELECT [DatabaseURN]
		,COUNT([DatabaseUniqueId]) AS DelDBCount
		FROM [dbo].[vw_Databases]
		WHERE DeletedInd = 1
		GROUP BY [DatabaseURN]) AS DBV1
		ON DBV1.DatabaseURN = DBT1.DatabaseURN
			
	END

	
	SELECT 
	[UDB1].[ServerInstanceId]
	,[TT1].[DatabaseURN]
	,COALESCE([DBCL1].[ExtendedPropertyValue],0) AS ExtendedPropertyValue
	,[DBC1].DBCount
	FROM @T1 AS TT1
	LEFT OUTER JOIN
	(
	SELECT DISTINCT 
	[DatabaseURN]
	, [ExtendedPropertyName]
	, [ExtendedPropertyValue]
	FROM [dbo].[vw_DatabaseExtendedProperties] AS DBP1
	WHERE
	[ExtendedPropertyName] LIKE 'ApplicationID' 
	) AS DBCL1
	ON [TT1].[DatabaseURN] = [DBCL1].[DatabaseURN]
	LEFT OUTER JOIN
	(SELECT [DatabaseURN]
	,CASE @pIncludeDeletedCopiesOfCurrentDBsInd WHEN 1 THEN COUNT(*) ELSE 1 END AS DBCount
	FROM [dbo].[vw_Databases] 
	GROUP BY [DatabaseURN]) AS DBC1
	ON [TT1].[DatabaseURN] = [DBC1].[DatabaseURN]
	INNER JOIN 
	(SELECT DISTINCT
	[ServerInstanceID]
	,[DatabaseURN]
	from [dbo].[vw_Databases]) AS UDB1
	ON [TT1].DatabaseURN = [UDB1].DatabaseURN
	AND [DBCL1].[ExtendedPropertyValue] IN (SELECT cast(pAppID as varchar(4000)) FROM @ApplicationIDs)		
	ORDER BY 	[UDB1].[ServerInstanceId]
	,[TT1].[DatabaseURN]

END TRY

BEGIN CATCH
EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_By_ApplicationRecoveryPlan]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_By_ApplicationRecoveryPlan] 
(@pApplicationIDs VARCHAR(8000)
,@pIncludeNonProdInd BIT
,@pIncludeDeletedInd BIT
,@pIncludeRetiredInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	--if null value is passed then default to all  applications
	DECLARE @SCDCurrentRecordIndLow INT = 1
	DECLARE @SCDCurrentRecordIndHigh INT = 1
	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
	DECLARE @ApplicationIDs TABLE (pAppID INT)
	IF @pApplicationIDs IS NULL OR CHARINDEX('-1',@pApplicationIDs,0) > 0
	BEGIN
		INSERT INTO @ApplicationIDs
		SELECT DISTINCT [ApplicationId]
		FROM [dbo].[vw_Applications]
		
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ApplicationIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pApplicationIDs,',')
	END

	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	IF @pIncludeDeletedInd = 1
	BEGIN
		SET @SCDCurrentRecordIndLow = 0
	END

	If @pIncludeNonProdInd = 1
	BEGIN
		SET @ProductionIndLow = 0
	END

	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
		[DB1].[DatabaseUniqueId]
		,[SHS1].[ServerSystemID]
		,[SHS1].[HostName]
		,[SHS1].[ProductionInd]
		,[S1].[InstanceName]
		,[SIVP1].[SQLVersionDescription]
		,[DB1].[ServerInstanceID]
		,CAST(CASE WHEN [S1].[RetiredInd] = 1 THEN 1 ELSE
		CASE WHEN [S1].[RetiredInd] = 0 THEN [SHS1].[RetiredInd] ELSE 0 END
		END AS BIT) AS OnRetiredInstance
		,CONVERT(NVARCHAR(15),[DB1].[LatestReportedDate],101) AS LatestReportedDate
		--,[DB1].[DatabaseId]
		,[DB1].[DatabaseName]
		,CONVERT(NVARCHAR(15),[DB1].[CreateDt],101) AS CreateDt
		,[DB1].[AccessibleInd]
		,[DB1].[SystemObjectInd]
		,[DB1].[DeletedInd] AS [DatabaseDeletedInd]
		,[DB1].[CurrentState]
		,[DB1].[ReadOnlyInd]
		,[DBCL1].[DatabaseCompatibilityLevel]
		,[DBApp1].[ApplicationId]
		,[DBApp1].[ApplicationName]
		,[DBApp1].[BusinessCategoryDesc]
		,[ARPP1].*
		FROM [dbo].[vw_Databases] AS DB1
		INNER JOIN [dbo].[vw_DatabaseApplications] AS DBApp1
		ON DB1.DatabaseUniqueId = DBApp1.DatabaseUniqueId
		LEFT OUTER JOIN [dbo].[vw_ServerInstances] AS S1
		ON [DB1].[ServerInstanceID] = [S1].[ServerInstanceID]
		INNER JOIN [dbo].[vw_Servers] AS SHS1
		ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
		INNER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
		ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
		LEFT OUTER JOIN [dbo].[vw_ApplicationRecoveryPlanProperties] AS ARPP1
		ON [DBApp1].[ApplicationId] = [ARPP1].[ApplicationId]
		LEFT OUTER JOIN
		(SELECT DISTINCT 
		DatabaseUniqueId
		, DatabasePropertyName
		, CAST(RTRIM(LTRIM(REPLACE(DatabasePropertyValue, 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
		FROM [dbo].[vw_DatabaseProperties] AS DBP1
		WHERE
		(DatabasePropertyName LIKE 'CompatibilityLevel') 
		OR (DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')) AS DBCL1
		ON [DB1].DatabaseUniqueId = DBCL1.DatabaseUniqueId
		WHERE 
		CAST([DBApp1].[ApplicationId] AS NVARCHAR(4000)) IN (SELECT CAST(pAppID AS NVARCHAR(4000)) FROM @ApplicationIDs)
		--AND [DB1].[SCDCurrentRecordInd] BETWEEN @SCDCurrentRecordIndLow AND @SCDCurrentRecordIndHigh
		AND [DB1].[DeletedInd] <= @pIncludeDeletedInd
		AND [SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
		--AND ([S1].[RetiredInd] <= @pIncludeRetiredInd)
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_By_Name]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_By_Name] 
(@pDatabaseName VARCHAR(128)
,@pIncludeNonProdInd BIT
,@pIncludeDeletedInd BIT
,@pIncludeRetiredInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @MAXETLDATE DATE
	SELECT @MAXETLDATE = MAX(ProcessDt) FROM [dbo].[ETLProcesses]
	DECLARE @DeletedIndLow INT = 0
	DECLARE @DeletedIndHigh INT = 0

	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow
	
	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	IF @pIncludeDeletedInd = 1
	BEGIN
	SET @DeletedIndHigh = 1
	END

	If @pIncludeNonProdInd = 1
	BEGIN
	SET @ProductionIndLow = 0
	END


	BEGIN TRAN
		-- Begin Return Select of record
	SELECT 
[SHS1].[ServerSystemID]
, [DB1].[DatabaseUniqueId]
, [DB1].[DatabaseName]
, CONVERT(NVARCHAR(15), COALESCE([DB1].[LatestReportedDate],@MAXETLDATE), 101) AS LatestReportedDate
, [SHS1].[ProductionInd]
, [DB1].[CreateDt]
, [DB1].[AccessibleInd]
, [DB1].[SystemObjectInd]
, [DB1].[DeletedInd]
, [DB1].[CurrentState]
, [DB1].[ReadOnlyInd]
, [SHS1].[HostName]
, [S1].[InstanceName]
, [DB1].[ServerInstanceId]
, CASE WHEN [DBCL1].[DatabaseCompatibilityLevel] IS NULL THEN 
		ISNULL([SQLV2].[SQLVersionDescription],'Unknown/Not Captured')
		ELSE CASE when [DB1].[SystemObjectInd] = 0 then [sqlv1].[SQLVersionDescription] else [SIVP1].[SQLVersionDescription] end
	END AS DatabaseCompatibilityLevel
, CASE WHEN [DBCL1].[DatabaseCompatibilityLevel] IS NULL THEN 
		ISNULL([SQLV2].[DatabaseCompatibilityLevel],0)
		ELSE CASE when [DB1].[SystemObjectInd] = 0 then [sqlv1].[DatabaseCompatibilityLevel] else [SIVP1].[DatabaseCompatibilityLevel] end
	END AS DatabaseCompatibilityLevelValue
, [SIVP1].[SQLVersionDescription] as ServerLevelVersionDescription
, [SIVP1].[DatabaseCompatibilityLevel] AS ServerVersionCompatibilityLevel
, [DBApp1].[ExtendedPropertyValue] AS [ApplicationID]
, [DBApp1].[ApplicationName]
, [DBApp1].[BusinessCategoryDesc]
FROM [dbo].[vw_Databases] AS DB1
LEFT OUTER JOIN
(SELECT DISTINCT 
	DatabaseUniqueId
	, DatabasePropertyName
	, CAST(RTRIM(LTRIM(REPLACE([DatabasePropertyValue], 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
	FROM [dbo].[vw_DatabaseProperties] AS DBP1
	WHERE
	(DatabasePropertyName LIKE 'CompatibilityLevel') 
	OR (DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')) AS DBCL1
ON [DB1].[DatabaseUniqueId] = [DBCL1].[DatabaseUniqueId]
LEFT OUTER JOIN 
	(
	SELECT min([SQLVersionDescription]) as SQLVersionDescription
      ,[DatabaseCompatibilityLevel]
		FROM [dbo].[vw_SQLServerVersions]  
		GROUP BY [DatabaseCompatibilityLevel]) AS SQLV1
ON [DBCL1].[DatabaseCompatibilityLevel] = [sqlv1].[DatabaseCompatibilityLevel]
LEFT OUTER JOIN
(SELECT
	DB2.ServerInstanceId
	, DB2.DatabaseName
	, MAX(DBCL2.DatabaseCompatibilityLevel) AS DatabaseCompatibilityLevel
	FROM
	vw_Databases AS DB2 
	LEFT OUTER JOIN
		(SELECT DISTINCT 
		DatabaseUniqueId
		, DatabasePropertyName
		, CAST(RTRIM(LTRIM(REPLACE(DatabasePropertyValue, 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
		FROM DatabaseProperties AS DatabaseProperties_1
		WHERE (DatabasePropertyName LIKE 'CompatibilityLevel') OR
		(DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')
		) AS DBCL2
	ON DB2.DatabaseUniqueId = DBCL2.DatabaseUniqueId
	GROUP BY DB2.ServerInstanceId
	, DB2.DatabaseName) AS DBCL2
ON [DB1].[ServerInstanceId] = [DBCL2].[ServerInstanceId]
AND [DB1].[DatabaseName] = [DBCL2].[DatabaseName]
LEFT OUTER JOIN 
	(
	SELECT min([SQLVersionDescription]) as SQLVersionDescription
      ,[DatabaseCompatibilityLevel]
		FROM [dbo].[vw_SQLServerVersions]  
		GROUP BY [DatabaseCompatibilityLevel]) AS SQLV2
ON DBCL2.DatabaseCompatibilityLevel = sqlv2.DatabaseCompatibilityLevel
LEFT OUTER JOIN vw_ServerInstances AS S1 
ON [DB1].[ServerInstanceId] = [S1].[ServerInstanceID]
INNER JOIN vw_Servers AS SHS1 
ON S1.ServerSystemID = SHS1.ServerSystemID 
LEFT OUTER JOIN vw_ServerInstance_VersionProperties AS SIVP1 
ON S1.ServerInstanceID = SIVP1.ServerInstanceID 
INNER JOIN
	(SELECT        
	DBEP1.DatabaseUniqueId, DBEP1.ExtendedPropertyValue,[App1].[ApplicationName], BC1.BusinessCategoryDesc
	FROM            
	vw_DatabaseExtendedProperties AS DBEP1 
	LEFT OUTER JOIN vw_Applications AS App1 
	ON DBEP1.ExtendedPropertyValue = App1.ApplicationId 
	LEFT OUTER JOIN vw_BusinessCategories AS BC1 
	ON App1.BusinessCategoryID = BC1.BusinessCategoryID
	WHERE        
	(DBEP1.ExtendedPropertyName = 'ApplicationId')) AS DBApp1 
ON [DB1].[DatabaseUniqueId] = DBApp1.DatabaseUniqueId 
WHERE
(DB1.DatabaseName LIKE @pDatabaseName) 
AND (DB1.DeletedInd BETWEEN @DeletedIndLow AND @DeletedIndHigh)
AND ([SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh)

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_By_ServerSystemID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_By_ServerSystemID] 
(@pServerSystemIDs VARCHAR(8000)
,@pIncludeNonProdInd BIT
,@pIncludeDeletedInd BIT
,@pIncludeRetiredInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @DeletedIndLow INT = 0
	DECLARE @DeletedIndHigh INT = 0

	DECLARE @ProductionIndLow BIT = 1
	DECLARE @ProductionIndHigh BIT = @ProductionIndLow
	
	--If the parameter to include deleted databases is set to 1 (TRUE), then the query WHERE condition of choosing the most current record indicator has to be overridden. Previously deleted databases would not necessarily have their SCDCurrentRecordInd set to 1 (TRUE)
	IF @pIncludeDeletedInd = 1
	BEGIN
	SET @DeletedIndHigh = 1
	END

	If @pIncludeNonProdInd = 1
	BEGIN
	SET @ProductionIndLow = 0
	END
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
	DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
	IF @pServerSystemIDs IS NULL OR CHARINDEX('-1',@pServerSystemIDs,0) > 0
	BEGIN
		INSERT INTO @ServerSystemIDs
		SELECT DISTINCT
		[ServerInstanceID]
		FROM [dbo].[vw_ServerInstances]
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ServerSystemIDs
		SELECT DISTINCT
		[ServerInstanceID]
		FROM [dbo].[vw_ServerInstances]
		WHERE [ServerSystemID] IN
		(SELECT item 
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pServerSystemIDs,','))
	END
	BEGIN TRAN
		-- Begin Return Select of record
		
	SELECT 
[DB1].ServerInstanceId
, [SHS1].HostName
, [S1].InstanceName
, [DB1].[DatabaseUniqueId]
, [DB1].DatabaseName
, CONVERT(NVARCHAR(15), [DB1].LatestReportedDate, 101) AS LatestReportedDate
, [SHS1].ProductionInd
, [DB1].CreateDt
, [DB1].AccessibleInd
, [DB1].SystemObjectInd
, [DB1].DeletedInd
, [DB1].CurrentState
, [DB1].ReadOnlyInd
, CASE WHEN [DBCL1].[DatabaseCompatibilityLevel] IS NULL THEN 
		ISNULL([SQLV2].SQLVersionDescription,'Unknown/Not Captured')
		ELSE CASE when [DB1].SystemObjectInd = 0 then sqlv1.SQLVersionDescription else [SIVP1].[SQLVersionDescription] end
	END AS DatabaseCompatibilityLevel
, CASE WHEN [DBCL1].[DatabaseCompatibilityLevel] IS NULL THEN 
		ISNULL([SQLV2].DatabaseCompatibilityLevel,0)
		ELSE CASE when [DB1].SystemObjectInd = 0 then sqlv1.DatabaseCompatibilityLevel else [SIVP1].[DatabaseCompatibilityLevel] end
	END AS DatabaseCompatibilityLevelValue
, [SIVP1].SQLVersionDescription as ServerLevelVersionDescription
, [SIVP1].DatabaseCompatibilityLevel AS ServerVersionCompatibilityLevel
, [DBApp1].ApplicationID
, [DBApp1].ApplicationName
, [DBApp1].BusinessCategoryDesc
FROM [dbo].[vw_Databases] AS DB1
LEFT OUTER JOIN
(SELECT DISTINCT 
	DatabaseUniqueId
	, DatabasePropertyName
	, CAST(RTRIM(LTRIM(REPLACE(DatabasePropertyValue, 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
	FROM [dbo].[vw_DatabaseProperties] AS DBP1
	WHERE
	(DatabasePropertyName LIKE 'CompatibilityLevel') 
	OR (DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')) AS DBCL1
ON [DB1].DatabaseUniqueId = DBCL1.DatabaseUniqueId
LEFT OUTER JOIN 
	(
	SELECT min([SQLVersionDescription]) as SQLVersionDescription
      ,[DatabaseCompatibilityLevel]
		FROM [dbo].[vw_SQLServerVersions]  
		GROUP BY [DatabaseCompatibilityLevel]) AS SQLV1
ON DBCL1.DatabaseCompatibilityLevel = sqlv1.DatabaseCompatibilityLevel
LEFT OUTER JOIN
(SELECT
	DB2.ServerInstanceId
	, DB2.DatabaseName
	, MAX(DBCL2.DatabaseCompatibilityLevel) AS DatabaseCompatibilityLevel
	FROM
	vw_Databases AS DB2 
	LEFT OUTER JOIN
		(SELECT DISTINCT 
		DatabaseUniqueId
		, DatabasePropertyName
		, CAST(RTRIM(LTRIM(REPLACE(DatabasePropertyValue, 'Version', ''))) AS int) AS DatabaseCompatibilityLevel
		FROM DatabaseProperties AS DatabaseProperties_1
		WHERE (DatabasePropertyName LIKE 'CompatibilityLevel') OR
		(DatabasePropertyDataType LIKE 'Microsoft.SqlServer.Management.Smo.CompatibilityLevel')
		) AS DBCL2
	ON DB2.DatabaseUniqueId = DBCL2.DatabaseUniqueId
	GROUP BY DB2.ServerInstanceId
	, DB2.DatabaseName) AS DBCL2
ON [DB1].ServerInstanceId = [DBCL2].ServerInstanceId
AND [DB1].DatabaseName = [DBCL2].DatabaseName
LEFT OUTER JOIN 
	(
	SELECT min([SQLVersionDescription]) as SQLVersionDescription
      ,[DatabaseCompatibilityLevel]
		FROM [dbo].[vw_SQLServerVersions]  
		GROUP BY [DatabaseCompatibilityLevel]) AS SQLV2
ON DBCL2.DatabaseCompatibilityLevel = sqlv2.DatabaseCompatibilityLevel
LEFT OUTER JOIN vw_ServerInstances AS S1 
ON [DB1].ServerInstanceId = S1.ServerInstanceID 
INNER JOIN vw_Servers AS SHS1 
ON S1.ServerSystemID = SHS1.ServerSystemID 
LEFT OUTER JOIN vw_ServerInstance_VersionProperties AS SIVP1 
ON S1.ServerInstanceID = SIVP1.ServerInstanceID 
INNER JOIN
	(SELECT        
	DBEP1.DatabaseUniqueId
	,DBEP1.ExtendedPropertyValue AS ApplicationID
	,[App1].ApplicationName, BC1.BusinessCategoryDesc
	FROM            
	vw_DatabaseExtendedProperties AS DBEP1 
	LEFT OUTER JOIN vw_Applications AS App1 
	ON DBEP1.ExtendedPropertyValue = App1.ApplicationId 
	LEFT OUTER JOIN vw_BusinessCategories AS BC1 
	ON App1.BusinessCategoryID = BC1.BusinessCategoryID
	WHERE        
	(DBEP1.ExtendedPropertyName = 'ApplicationId')) AS DBApp1 
ON [DB1].DatabaseUniqueId = DBApp1.DatabaseUniqueId 
WHERE
	(DB1.ServerInstanceId IN (SELECT pServerSystemID FROM @ServerSystemIDs))
	AND 
	(DB1.DeletedInd BETWEEN @DeletedIndLow AND @DeletedIndHigh)
	AND ([SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh)
	AND (DB1.SystemObjectInd = 0)

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Databases_UnknownApplicationIDs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Databases_UnknownApplicationIDs] 
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

	BEGIN TRY
		BEGIN TRANSACTION
			--Goal is to provide a list of records in 
			DECLARE @T2 TABLE 
			([DatabaseURN] NVARCHAR(256)
			,[ExtendedPropertyName] NVARCHAR(128)
			,[ApplicationID] VARCHAR(4000))

			INSERT INTO @T2
			SELECT DISTINCT 
			UPPER([DBP1].[DatabaseURN])
			,[DBP1].[ExtendedPropertyName]
			,[DBP1].[ExtendedPropertyValue]
			FROM [dbo].[vw_DatabaseExtendedProperties] AS DBP1
			WHERE ([ExtendedPropertyName] LIKE 'ApplicationID') 
			
			SELECT 
			[DB1].[DatabaseName]
			,[DBP2].[DatabaseExtendedPropertyID]
			,[DBP2].[ExtendedPropertyValue] AS CurrentApplicationID
			,[BA1].[ApplicationName]
			,[SHS1].[HostName]
			,[S1].[InstanceName]
			,[DB1].[DatabaseUniqueId]
			,[DB1].[ServerInstanceId]
			,[DB1].[SystemDBID]
		
			,[DB1].[SystemObjectInd]
			,[DB1].[DeletedInd]
			,CONVERT(VARCHAR(15),[DB1].[CreateDt],101) AS CreateDt
			,CONVERT(VARCHAR(15), [DB1].[LatestReportedDate], 101) AS LatestReportedDate
			,[T2].[AppIDCount]
			FROM [dbo].[vw_Databases] AS DB1
			INNER JOIN 
			(SELECT 
			[DatabaseURN]
			,COUNT([ApplicationID]) AS AppIDCount
			FROM @T2
			GROUP BY [DatabaseURN]) AS T2
			ON [DB1].[DatabaseURN] = [T2].[DatabaseURN]
			INNER JOIN 
			(SELECT 
			[DatabaseExtendedPropertyID]
			,[DatabaseUniqueId]
			,[ExtendedPropertyName]
			,[ExtendedPropertyValue]
			FROM [dbo].[vw_DatabaseExtendedProperties] AS DBP1
			WHERE [ExtendedPropertyName] LIKE 'ApplicationID') AS DBP2
			ON [DB1].[DatabaseUniqueId] = [DBP2].[DatabaseUniqueId]
			LEFT OUTER JOIN [dbo].[vw_Applications] AS BA1
			ON [DBP2].[ExtendedPropertyValue] = CAST([BA1].[ApplicationId] AS NVARCHAR(4000))
			INNER JOIN [dbo].[vw_ServerInstances] AS S1
			ON [S1].[ServerInstanceID] = [DB1].[ServerInstanceId]
			INNER JOIN [dbo].[vw_Servers] AS SHS1
			ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
			WHERE [BA1].[ApplicationId] = 0
			ORDER BY [DB1].[DatabaseName],[SHS1].[hostname],[ExtendedPropertyValue]
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_ETLProcess_CustomErrors]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_ETLProcess_CustomErrors]
(@pStartDate DATE
,@pEndDate DATE
,@pIncludeWarnings BIT
,@pIncludeInformational BIT

)
AS
BEGIN
/*  ETL processes errors are heirarchial and are classified according to three levels of 'severity' as indicated by increasing numbers.  The higher the number, the more severe the error.  
These are:
0 = Informational--do not indicate a problem with the object; the state of the object is acceptable yet abnormal
1 = Warnings--indicates a potential problem with the object; the state of the object is abnormal and may not be acceptable in its current state
2 = Fatal Error --indicates an actual problem with the object causing/preventing ETL processes from occuring or continuing; the state of the object is abnormal and is not acceptable in its current state
The report dataset assumes that all level 2 errors are included.  However, parameters exist for the inclusion of non-error level information

*/
--SELECT @ErrorSeverityLevelLow = CASE WHEN @
--By default the dataset includes all 'fatal/severe/failure' level errors
DECLARE @ErrorSeverityLevels TABLE (ErrorLevel INT)
--Fatal errors are always reported
INSERT INTO @ErrorSeverityLevels (ErrorLevel) VALUES (2)

--If null values passed for the optional error levels, set them to false
SELECT @pIncludeWarnings = COALESCE(@pIncludeWarnings,0), @pIncludeInformational = COALESCE(@pIncludeInformational,0)

IF @pIncludeInformational = 1
BEGIN
INSERT INTO @ErrorSeverityLevels (ErrorLevel) VALUES (0)
END
IF @pIncludeWarnings = 1
BEGIN
INSERT INTO @ErrorSeverityLevels (ErrorLevel) VALUES (1)
END


SELECT @pStartDate = COALESCE(@pStartDate, MIN(ProcessDt)) 
FROM [dbo].[ETLProcesses]
SELECT @pEndDate = COALESCE(@pEndDate, MAX(ProcessDt)) 
FROM [dbo].[ETLProcesses]

SELECT 
[T2].[HostName]
,[T1].[ServerSystemID]
,[T1].[ErrorSeverityLevel]
,CASE [T1].[ErrorSeverityLevel] 
	WHEN 0 THEN 'Informational' 
	WHEN 1 THEN 'Warning'
	WHEN 2 THEN 'Error'
	ELSE 'Unknown' END AS [ErrorSeverityDescription]
,[T1].[ETLCustomErrorID]
,[T1].[ETLProcessId]
,CONVERT(VARCHAR(12),[T3].[ProcessDt], 101) AS [LastUpdateDt]
,[T1].[PackageName]
,[T1].[PackageTaskName]
,[T1].[CustomErrorText]
,[T1].[SSISSystemErrorCode]
,[T1].[SSISSystemErrorColumn]
,[T1].[IssueResolvedInd]
,[T1].[ResolutionDescription]
FROM [dbo].[ETLProcessCustomErrors] AS T1
INNER JOIN [dbo].[ETLProcesses] AS T3
ON [T3].[ETLProcessId] = [T1].[ETLProcessId]
INNER JOIN [dbo].[Servers] AS T2
ON [T1].[ServerSystemID] = [T2].[ServerSystemID]
INNER JOIN @ErrorSeverityLevels AS T4
ON [T1].[ErrorSeverityLevel] = [T4].[ErrorLevel]
WHERE [T3].[ProcessDt] BETWEEN @pStartDate AND @pEndDate
AND [T2].[RetiredInd] = 0
ORDER BY [T2].[HostName],[T1].[ErrorSeverityLevel]

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_Errors_DuplicateProcessing]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_Errors_DuplicateProcessing]
AS
BEGIN
/*
Author: Danny Howell
Description: The procedure should return no rows.  If there are any rows, then there is a logical error in the SSIS package performing processing
Dataset returns databases for which statistics are updated twice per the same statistics update job.
This provides a validation of package logical processing.  There should be no tables where the same stat is updated more than once within the same package execution. Package testing indicated the logic determining which stats were subject to updating may have incorrectly evaluated history and performed invalid joins resulting in a statistic being updated multiple times.  This extended the maintenance beyond the acceptable window and duplication of stats updates is an error.


*/
;with maintenancesum ([maintenance_job_class], [maintenance_job_id],[maintenance_job_date],[database_name],[schema_name],[table_name],[statistic_name],[dupl_stat_count])
AS
(
SELECT 
'Statistics_Update'
,[MT1].[statssummary_job_id]
,[MT2].[statsupdate_job_date]
,[MT2].[database_name]
,[MT1].[schema_name]
,[MT1].[table_name]
,[MT1].[statistic_name]
,COUNT(*)
FROM [dbo].[vw_Statistics_Update_History_Detail] AS [MT1]
INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS [MT2]
ON [MT1].[statssummary_job_id] = [MT2].[statssummary_job_id]
GROUP BY
[MT1].[statssummary_job_id]
,[MT2].[statsupdate_job_date]
,[MT2].[database_name]
,[MT1].[schema_name]
,[MT1].[table_name]
,[MT1].[statistic_name]
HAVING COUNT(*) > 1
UNION ALL
SELECT 
'Index_Defragmentation'
,[MT3].[defragmentation_job_id]
,[MT3].[last_user_update]
,[MT4].[database_name]
,[MT3].[schema_name]
,[MT3].[table_name]
,[MT3].[index_name]
,COUNT(*)
FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS [MT3]
INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS [MT4]
ON [MT3].[defragmentation_job_id] = [MT4].[defragmentation_job_id]
GROUP BY
[MT3].[defragmentation_job_id]
,[MT3].[last_user_update]
,[MT4].[database_name]
,[MT3].[schema_name]
,[MT3].[table_name]
,[MT3].[index_name]
HAVING COUNT(*) > 1

)

SELECT
[maintenance_job_class]
,[maintenance_job_id]
,[maintenance_job_date]
,[database_name]
,[schema_name]
,[table_name]
,[statistic_name]
,[dupl_stat_count]
FROM maintenancesum as [T1]
ORDER BY 
[database_name]
,[maintenance_job_class]


END

/*
Stats summary IDs by ExecutionID--to get duration and max/min IDs for each time the AB job was run
*/
/*
SELECT
'First & Last stats job by executionGUID--will need for report--LOJ to job date by GUID',
[[T2]].[executioninstanceGUID]
,[T3].[JobStartDate]
,min([[T2]].[statssummary_job_id]) as firststatssumaryid
,max([[T2]].[statssummary_job_id]) as laststatssumaryid
,t3.duration
--,[t3].JobStartTime,[t3].JobEndTime
 FROM [dbo].[Statistics_Update_History_Summary] as [T2]
 LEFT OUTER JOIN
	(
	SELECT [executioninstanceGUID]
	,MIN([STATSUPDATE_JOB_date]) as [JobStartDate]
	,min([statsupdate_job_starttime]) as [JobStartTime]
	,max([statsupdate_job_endtime]) as [JobEndTime]
	,datediff(minute,min([statsupdate_job_starttime]),max([statsupdate_job_endtime])) as duration
	FROM [dbo].[Statistics_Update_History_Summary] 
	GROUP BY [executioninstanceGUID]) AS t3
ON [[T2]].[executioninstanceGUID] = [T3].[executioninstanceGUID]
 group by 
 [[T2]].[executioninstanceGUID]
 ,[T3].[JobStartDate]
 ,t3.duration
 ORDER BY [T3].[JobStartDate] DESC
 */


/*
Stats job by Stats summary IDs--gets the per database information on the maintenance job--used in reporting
*/
/*
SELECT 
'Current job status',
[[T2]].[statssummary_job_id]
,[[T2]].[statsupdate_job_date]
,[[T2]].[statsupdate_process_completed_ind]
,datediff(minute,[[T2]].[statsupdate_job_starttime],ISNULL([[T2]].[statsupdate_job_endtime],GETDATE())) AS TimeToProcessDBStats
,[t3].[statsupdatedcount]
,[[T2]].[executioninstanceGUID]
,[[T2]].[database_id]
,[[T2]].[database_name]
,[[T2]].[statsupdate_comments]
FROM [dbo].[Statistics_Update_History_Summary] as [T2]
LEFT OUTER JOIN 
	(SELECT [statssummary_job_id]
	,[database_id]
	,count([statistic_name]) as statsupdatedcount
	FROM [dbo].[Statistics_Update_History_Detail]
	group by 
	[statssummary_job_id]
	,[database_id]
	) AS T3
ON [[T2]].[statssummary_job_id] = [T3].[statssummary_job_id]
order by [T2].statssummary_job_id desc
*/

/*
use pc_prod
go
declare @currdbid int
--set @currdbid = db_id()
SELECT 
	@currdbid = MAX([statssummary_job_id])
	FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Summary] 
	WHERE [database_id] = db_id()


select 
OBJECT_NAME(s1.object_id),
s1.auto_created
,s1.user_created
,[CSJ1].[table_row_count]
,[CSJ1].[statsupdate_completed_ind]
,[CSJ1].[statsupdate_performed_ind]
,[CSJ1].[statsupdate_failed_ind]
,[CSJ1].[statsupdate_fromindexdefrag]
,[CSJ1].[statsupdate_scan_type_performed]
,'need to provide text of scantypeperformeID'
,datediff(minute,[csj1].[statsupdate_task_starttime],[csj1].[statsupdate_task_endtime]) as statsupdatetime
,[CSJ1].[statsupdate_task_starttime]
,[CSJ1].[statsupdate_task_endtime]
,[CSJ1].[system_last_updated]
,[CSJ1].[rows_sampled]
,[CSJ1].[statistic_specific_comments]
from sys.stats as s1
left outer join 
(SELECT [SD1].[statssummary_job_id]
      ,[SD1].[schema_name]
      ,[SD1].[table_id]
      ,[SD1].[table_name]
      ,[SD1].[statistic_id]
      ,[SD1].[statistic_name]
      ,[SD1].[table_row_count]
      ,[SD1].[statsupdate_completed_ind]
      ,[SD1].[statsupdate_performed_ind]
      ,[SD1].[statsupdate_failed_ind]
      ,[SD1].[statsupdate_fromindexdefrag]
      ,[SD1].[statsupdate_scan_type_performed]
	  ,[SD1].[statsupdate_task_starttime]
      ,[SD1].[statsupdate_task_endtime]
      ,[SD1].[auto_created]
      ,[SD1].[user_created]
      ,[SD1].[system_last_updated]
      ,[SD1].[rows_sampled]
      ,[SD1].[statistic_specific_comments]
  FROM [KFBSQLMgmt].[dbo].[Statistics_Update_History_Detail]  AS SD1 
  WHERE [SD1].[statssummary_job_id] = @currdbid
  ) as csj1
  on s1.object_id = csj1.table_id
  and s1.stats_id = csj1.statistic_id
where OBJECT_SCHEMA_NAME(object_id) not like 'sys'
--and csj1.table_name is null

*/
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_Detail_ForDefragJobID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_Detail_ForDefragJobID] 
@pDefragJobID INT
,@pShowIndexesNoMaint BIT

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
/*
Author: Danny Howell
Description: Provides detailed Index Defragmentation (I/D) maintenance job history for tables in the selected databases for the selected defragmentation job ID. 
Data results provide the type of I/D performed and % fragmentation change for each index and table processed by the maintenance job.
The default option excludes tables and indexes for which no maintenance was performed.  The @pShowIndexesNoMaint parameter
report option includes tables which were not processed as they did not meet the maintenance threshold parameters.
Viewing unprocessed tables provides a "snapshot" of the index fragmentation at the time of the maintenance.
*/
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowIndexesNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
	BEGIN TRANSACTION
	DECLARE @tIDDetail TABLE (
	[defragmentation_job_id] [int] NOT NULL,
	[table_id] [bigint] NOT NULL,
	[index_id] [bigint] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[index_name] [varchar](128) NOT NULL,
	[table_row_count] [int] NOT NULL,
	[Type_performed] VARCHAR(25) NULL,
	[defragmentation_failed_ind] [bit] NOT NULL,
	[defragmentation_performed_on_Index] [bit] NOT NULL,
	[maintenance_duration_minutes] INT NULL,
	[defragmentation_task_starttime] [datetime] NULL,
	[fragmentationlevel_prerun] [numeric](6,1) NULL,
	[fragmentationlevel_postrun] [numeric](6,1) NULL,
	[fragmentationlevel_change] [numeric](6,1) NULL,
	[index_specific_comments] [varchar](1000) NULL
	) 
	IF NOT EXISTS (SELECT * FROM [dbo].[vw_Index_Defragmentation_History_Summary] WHERE [defragmentation_job_id] = @pDefragJobID)
	BEGIN
	INSERT INTO @tIDDetail
	(
	[defragmentation_job_id],
	[table_id],
	[index_id],
	[schema_name],
	[table_name],
	[index_name],
	[table_row_count],
	[Type_performed],
	[defragmentation_failed_ind],
	[defragmentation_performed_on_Index],
	[maintenance_duration_minutes],
	[defragmentation_task_starttime],
	[fragmentationlevel_prerun],
	[fragmentationlevel_postrun],
	[fragmentationlevel_change],
	[index_specific_comments]
	)
	SELECT 
	0
	,0
	,0
	,'No schema'
	,'No tables'
	,'No Indexes'
	,0
	,'None' as Type_performed
	,0
	,0
	,0
	,0
	,NULL
	,0
	,0
	,'No maintenance performed on this database or a database with this name does not exist on this server'
	END
	ELSE
	BEGIN
		INSERT INTO @tIDDetail
		(
		[defragmentation_job_id],
		[table_id],
		[index_id],
		[schema_name],
		[table_name],
		[index_name],
		[table_row_count],
		[Type_performed],
		[defragmentation_failed_ind],
		[defragmentation_performed_on_Index],
		[maintenance_duration_minutes],
		[defragmentation_task_starttime],
		[fragmentationlevel_prerun],
		[fragmentationlevel_postrun],
		[fragmentationlevel_change],
		[index_specific_comments]
		)
		SELECT [defragmentation_job_id]
		,[table_id]
		,[index_id]
		,[schema_name]
		,[table_name]
		,[index_name]
		,[table_row_count]
		,case [index_rebuild_performed_ind] when 1 then 'Rebuild' 
		else 
		case [index_reorg_performed_ind] when 1 then 'Reorg' else '-' end
		end
		as Type_performed
		,[defragmentation_failed_ind]
		,[defragmentation_performed_on_Index]
		,datediff(minute,[defragmentation_task_starttime],[defragmentation_task_endtime]) as maintenance_duration_minutes
		,[defragmentation_task_starttime]
		,cast([fragmentationlevel_prerun] as numeric(6,1)) as fragmentationlevel_prerun
		,cast([fragmentationlevel_postrun] as numeric(6,1)) as fragmentationlevel_postrun
		,cast([fragmentationlevel_prerun] as numeric(6,1)) - cast([fragmentationlevel_postrun] as numeric(6,3)) as fragmentationlevel_change
		,[index_specific_comments]
		FROM [dbo].[vw_Index_Defragmentation_History_Detail]
		WHERE [defragmentation_job_id] = @pDefragJobID
		AND [defragmentation_performed_on_Index] BETWEEN @ShowAllIndLow AND @ShowAllIndHigh
	END

	SELECT 
	[defragmentation_job_id],
	[table_id],
	[index_id],
	[schema_name],
	[table_name],
	[index_name],
	[table_row_count],
	[Type_performed],
	cast([defragmentation_failed_ind] as bit) as [defragmentation_failed_ind],
	cast([defragmentation_performed_on_Index] as bit) as [defragmentation_performed_on_Index],
	[maintenance_duration_minutes],
	CONVERT(VARCHAR(20),[defragmentation_task_starttime],100) as [defragmentation_task_starttime],
	[fragmentationlevel_prerun],
	[fragmentationlevel_postrun],
	[fragmentationlevel_change],
	[index_specific_comments]
	FROM @tIDDetail 

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF




	END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_Detail_ForTable]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_Detail_ForTable] 
@pDatabaseName VARCHAR(128)
,@pTableName VARCHAR(128)
,@pShowIndexesNoMaint BIT

AS
BEGIN
/*
Author: Danny Howell
Description:  Procedures provides detailed Index Defragmentation (I/D) maintenance job history for tables in the selected databases. 
Results data provides a view type of I/D performed and % fragmentation change for each index and table processed by the maintenance job. 
The default option excludes tables and indexes for which no maintenance was performed.
Changing the @pShowIndexesNoMaint parameter includes tables not processed. 
Viewing unprocessed tables provides a "snapshot" of the index fragmentation at the time of the maintenance.
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowIndexesNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
	BEGIN TRANSACTION
	DECLARE @tIDDetail TABLE (
	[defragmentation_job_id] [int] NOT NULL,
	[table_id] [bigint] NOT NULL,
	[index_id] [bigint] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[index_name] [varchar](128) NOT NULL,
	[table_row_count] [int] NOT NULL,
	[Type_performed] VARCHAR(25) NULL,
	[defragmentation_failed_ind] [bit] NOT NULL,
	[defragmentation_performed_on_Index] [bit] NOT NULL,
	[maintenance_duration_minutes] INT NULL,
	[defragmentation_task_starttime] [datetime] NULL,
	[fragmentationlevel_prerun] [numeric](6,1) NULL,
	[fragmentationlevel_postrun] [numeric](6,1) NULL,
	[fragmentationlevel_change] [numeric](6,1) NULL,
	[index_specific_comments] [varchar](1000) NULL
	) 
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDS1
		ON [IDD1].[defragmentation_job_id] = [IDS1].[defragmentation_job_id]
		WHERE [database_name] = @pDatabaseName AND [IDD1].[table_name] LIKE @pTableName)
	BEGIN
	INSERT INTO @tIDDetail
	(
	[defragmentation_job_id],
	[table_id],
	[index_id],
	[schema_name],
	[table_name],
	[index_name],
	[table_row_count],
	[Type_performed],
	[defragmentation_failed_ind],
	[defragmentation_performed_on_Index],
	[maintenance_duration_minutes],
	[defragmentation_task_starttime],
	[fragmentationlevel_prerun],
	[fragmentationlevel_postrun],
	[fragmentationlevel_change],
	[index_specific_comments]
	)
	SELECT 
	0
	,0
	,0
	,'No schema'
	,'No table'
	,'No Index'
	,0
	,'None' as Type_performed
	,0
	,0
	,0
	,0
	,NULL
	,0
	,0
	,'No maintenance performed on this table or a table with this name does not exist in the database ' + @pDatabaseName + ' on this server'
	END
	ELSE
	BEGIN
		INSERT INTO @tIDDetail
		(
		[defragmentation_job_id],
		[table_id],
		[index_id],
		[schema_name],
		[table_name],
		[index_name],
		[table_row_count],
		[Type_performed],
		[defragmentation_failed_ind],
		[defragmentation_performed_on_Index],
		[maintenance_duration_minutes],
		[defragmentation_task_starttime],
		[fragmentationlevel_prerun],
		[fragmentationlevel_postrun],
		[fragmentationlevel_change],
		[index_specific_comments]
		)
		SELECT 
		[IDD1].[defragmentation_job_id]
		,[IDD1].[table_id]
		,[IDD1].[index_id]
		,[IDD1].[schema_name]
		,[IDD1].[table_name]
		,[IDD1].[index_name]
		,[IDD1].[table_row_count]
		,case [IDD1].[index_rebuild_performed_ind] when 1 then 'Rebuild' 
		else 
		case [IDD1].[index_reorg_performed_ind] when 1 then 'Reorg' else 'None' end
		end
		as Type_performed
		,[IDD1].[defragmentation_failed_ind]
		,[IDD1].[defragmentation_performed_on_Index]
		,datediff(minute,[IDD1].[defragmentation_task_starttime],[IDD1].[defragmentation_task_endtime]) as maintenance_duration_minutes
		,[IDD1].[defragmentation_task_starttime]
		,cast([IDD1].[fragmentationlevel_prerun] as numeric(6,1)) as fragmentationlevel_prerun
		,cast([IDD1].[fragmentationlevel_postrun] as numeric(6,1)) as fragmentationlevel_postrun
		,cast([IDD1].[fragmentationlevel_prerun] as numeric(6,1)) - cast([IDD1].[fragmentationlevel_postrun] as numeric(6,3)) as fragmentationlevel_change
		,[IDD1].[index_specific_comments]
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDS1
		ON [IDD1].[defragmentation_job_id] = [IDS1].[defragmentation_job_id]
		WHERE [IDS1].[database_name] = @pDatabaseName
		AND [IDD1].[table_name] LIKE @pTableName
		AND [defragmentation_performed_on_Index] BETWEEN @ShowAllIndLow AND @ShowAllIndHigh
	END

	SELECT 
	[defragmentation_job_id],
	[table_id],
	[index_id],
	[schema_name],
	[table_name],
	[index_name],
	[table_row_count],
	[Type_performed],
	cast([defragmentation_failed_ind] as bit) as [defragmentation_failed_ind],
	cast([defragmentation_performed_on_Index] as bit) as [defragmentation_performed_on_Index],
	[maintenance_duration_minutes],
	CONVERT(VARCHAR(20),[defragmentation_task_starttime],100) as [defragmentation_task_starttime],
	[fragmentationlevel_prerun],
	[fragmentationlevel_postrun],
	[fragmentationlevel_change],
	[index_specific_comments]
	FROM @tIDDetail 

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_JobStats_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_JobStats_ForDatabase] 
@pDatabaseName VARCHAR(128)
,@pTableName VARCHAR(128)
,@pEarliestDate DATETIME
,@pLatestDate DATETIME
AS
BEGIN

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
/*
Author: Danny Howell
Description:  Procedures provides summary statistics for Index Defragmentation (I/D) maintenance job history for tables in the selected databases.
The date parameters permit restriction of the history range--this allows for narrowing the maintenance history to more recent jobs.
Results data provides a view of average times and counts of tables and indexes for the database to identify objects requiring more frequent and resource intensive maintenance tasks. 
By separating tables and indexes by those performed and not performed, summary statistics are not skewed by jobs for which no maintenance is performed.
*/

BEGIN TRY
/* Table index work--when done--impact when maintenance was done, times when maintenance was not done and the average condition at that time */
		BEGIN TRANSACTION

		DECLARE @tIDIndexCount TABLE (
		[defragmentation_job_id] [INT] NOT NULL,
		[defragmentation_performed_ind] [bit] NOT NULL,
		[database_name] [varchar](128) NULL,
		[schema_name] [varchar](128) NULL,
		[table_name] [varchar](128) NULL,
		[index_count] [int] NOT NULL)
		
		INSERT INTO @tIDIndexCount(
		[defragmentation_job_id],
		[defragmentation_performed_ind],
		[database_name],
		[schema_name],
		[table_name],
		[index_count])
	SELECT
		[IDHD2].[defragmentation_job_id],
		[IDHD2].[defragmentation_performed_on_Index],
		IDHS2.[database_name],
		IDHD2.[schema_name],
		IDHD2.[table_name],
		SUM(CAST(1 AS INT))
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS [IDHD2]
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDHS2
		ON [IDHD2].[defragmentation_job_id] = [IDHS2].[defragmentation_job_id]
		WHERE [IDHS2].[database_name] LIKE @pDatabaseName
		AND [IDHD2].[table_name] LIKE @pTableName
		AND [IDHS2].[last_update_date] BETWEEN @pEarliestDate and @pLatestDate
		GROUP BY 
		[IDHD2].[defragmentation_job_id],
		[defragmentation_performed_on_Index],
		IDHS2.[database_name],
		IDHD2.[schema_name],
		IDHD2.[table_name]
							
		DECLARE @tIDTableSummary TABLE (
		[defragmentation_job_id] [int] NOT NULL,
		[defragmentation_performed_ind] [bit] NOT NULL,
		[server_name] [varchar](128) NULL,
		[database_name] [varchar](128) NULL,
		[schema_name] [varchar](128) NULL,
		[table_name] [varchar](128) NULL,
		[avg_row_count] [bigint] NOT NULL,
		[index_rebuilds_count] [int] NOT NULL,
		[index_reorgs_count] [int] NOT NULL,
		[defragmentation_failed_count] [int] NULL,
		[defragmentation_performed_count] [int] NULL,
		[avg_index_maintenance_duration] [numeric] (15,2) NULL,
		[avg_prerun_fragmentation] [numeric] (7,3) NULL,
		[avg_postrun_fragmentation] [numeric] (7,3) NULL)

		INSERT INTO @tIDTableSummary(
		[defragmentation_job_id],
		[defragmentation_performed_ind],
		[server_name],
		[database_name],
		[schema_name],
		[table_name],
		[avg_row_count],
		[index_rebuilds_count],
		[index_reorgs_count],
		[defragmentation_failed_count],
		[defragmentation_performed_count],
		[avg_index_maintenance_duration],
		[avg_prerun_fragmentation],
		[avg_postrun_fragmentation])
		SELECT 
		[IDHD1].[defragmentation_job_id]
		,[IDHD1].[defragmentation_performed_on_Index] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		,cast(avg(cast([IDHD1].[table_row_count] as bigint)) as bigint)
		,sum(CAST([IDHD1].[index_rebuild_performed_ind] AS INT))
		,sum(CAST([IDHD1].[index_reorg_performed_ind] AS INT))
		,sum(CAST([IDHD1].[defragmentation_failed_ind] AS INT))
		,sum(CAST([IDHD1].[defragmentation_performed_on_Index] AS INT))
		,avg(datediff(second,[IDHD1].[defragmentation_task_starttime],[IDHD1].[defragmentation_task_endtime]))
		,avg(case when [IDHD1].[fragmentationlevel_prerun] > [IDHD1].[fragmentationlevel_postrun] then [IDHD1].[fragmentationlevel_prerun] else [IDHD1].[fragmentationlevel_postrun] end)
		,avg(case when [IDHD1].[fragmentationlevel_prerun] > [IDHD1].[fragmentationlevel_postrun] then [IDHD1].[fragmentationlevel_postrun] else [IDHD1].[fragmentationlevel_prerun] end )
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDHD1
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDHS1
		ON [IDHD1].[defragmentation_job_id] = [IDHS1].[defragmentation_job_id]
		WHERE [IDHS1].[database_name] LIKE @pDatabaseName
		AND [IDHD1].[table_name] LIKE @pTableName
		AND [IDHS1].[last_update_date] BETWEEN @pEarliestDate and @pLatestDate
		AND [IDHD1].[defragmentation_performed_on_Index] = 1
		GROUP BY 
		[IDHD1].[defragmentation_job_id]
		,[IDHD1].[defragmentation_performed_on_Index] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		UNION ALL		
		SELECT 
		[IDHD1].[defragmentation_job_id]
		,[IDHD1].[defragmentation_performed_on_Index] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		,cast(avg(cast([IDHD1].[table_row_count] as bigint)) as bigint)
		,sum(CAST([IDHD1].[index_rebuild_performed_ind] AS INT))
		,sum(CAST([IDHD1].[index_reorg_performed_ind] AS INT))
		,sum(CAST([IDHD1].[defragmentation_failed_ind] AS INT))
		,sum(CAST([IDHD1].[defragmentation_performed_on_Index] AS INT))
		,avg(datediff(second,[IDHD1].[defragmentation_task_starttime],[IDHD1].[defragmentation_task_endtime]))
		,avg(case when [IDHD1].[fragmentationlevel_prerun] > [IDHD1].[fragmentationlevel_postrun] then [IDHD1].[fragmentationlevel_prerun] else [IDHD1].[fragmentationlevel_postrun] end)
		,avg(case when [IDHD1].[fragmentationlevel_prerun] > [IDHD1].[fragmentationlevel_postrun] then [IDHD1].[fragmentationlevel_postrun] else [IDHD1].[fragmentationlevel_prerun] end )
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDHD1
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDHS1
		ON [IDHD1].[defragmentation_job_id] = [IDHS1].[defragmentation_job_id]
		WHERE [IDHS1].[database_name] LIKE @pDatabaseName
		AND [IDHD1].[table_name] LIKE @pTableName
		AND [IDHS1].[last_update_date] BETWEEN @pEarliestDate and @pLatestDate
		AND [IDHD1].[defragmentation_performed_on_Index] = 0
		GROUP BY 
		[IDHD1].[defragmentation_job_id]
		,[IDHD1].[defragmentation_performed_on_Index] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]

		SELECT
		[IDS1].[defragmentation_job_id],
		convert(varchar(20), [IDS2].[last_update_date], 101) as defragmentation_maintenance_job_date,
		[IDS1].[defragmentation_performed_ind],
		[IDS1].[server_name],
		[IDS1].[database_name],
		[IDS1].[schema_name],
		[IDS1].[table_name],
		[IDDH3].[index_count],  -- want the count of indexes either not defragmented or defragmented per table per job
		[IDS1].[avg_row_count], -- want the row count of the table at the time the job ran
		[IDS1].[index_rebuilds_count],  -- want the count of indexes rebuilt which assumes that the maintenance was done per table per job
		[IDS1].[index_reorgs_count],  -- want the count of indexes reorged which assumes that the maintenance was done per table per job
		[IDS1].[defragmentation_failed_count], -- want the count of indexes which failed per table per job
		[IDS1].[defragmentation_performed_count],  -- want the count of indexes which maintenance was performed per table per job
		[IDS1].[avg_index_maintenance_duration], -- want the average time to perform maintenance FOR JUST THE ones for which maintenance was performed to remove 0 duration times when the maintenance was NOT performed per table per job--it is the average of all indexes of a table
		[IDS1].[avg_prerun_fragmentation], -- want the average pre-run fragmentation separated by maint performed ind--it is the average of all indexes of a table by whether fragmentation was performed or not
		[IDS1].[avg_postrun_fragmentation]  -- want the average post-run fragmentation separated by maint performed ind--it is the average of all indexes of a table by whether fragmentation was performed or not
		FROM @tIDTableSummary AS [IDS1]
		LEFT OUTER JOIN 
			(SELECT 
			[defragmentation_performed_ind],
			[database_name],
			[schema_name],
			[table_name],
			AVG([index_count]) as Index_count
			FROM @tIDIndexCount
			GROUP BY
			[defragmentation_performed_ind],
			[database_name],
			[schema_name],
			[table_name]) AS [IDDH3]
		ON [IDS1].[schema_name] = [IDDH3].[schema_name]
		AND [IDS1].[table_name] = [IDDH3].[table_name]
		AND [IDS1].[defragmentation_performed_ind] = [IDDH3].[defragmentation_performed_ind]
		and [IDS1].[database_name] = [IDDH3].[database_name]
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS [IDS2]
		ON [IDS1].[defragmentation_job_id] = [IDS2].[defragmentation_job_id]
		ORDER BY 
		[server_name],
		[database_name],
		[schema_name],
		[table_name],
		[defragmentation_performed_ind]

		COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_JobStats_ForServer]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_JobStats_ForServer] 
@pLatestDate DATETIME
,@pEarliestDate DATETIME
AS
BEGIN
/*
Author: Danny Howell
Description:  Procedures provides summary statistics for Index Defragmentation (I/D) maintenance job history for all databases on the server.
The date parameters permit restriction of the history range--this allows for narrowing the maintenance history to more recent jobs.
Results data provides a view of average times and counts of tables and indexes for the databases to identify objects requiring more frequent and resource intensive maintenance tasks. 
*/

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
/* Table index work--when done--impact when maintenance was done, times when maintenance was not done and the average condition at that time */
		BEGIN TRANSACTION
	
		DECLARE @tIDSummary TABLE (
		[server_name] [varchar](128) NULL,
		[database_name] [varchar](128) NULL,
		[total_defragmentation_job_count] [int] NULL,
		[database_not_accessible_count] [int] NULL,
		[database_accessible_count] [int] NULL,
		[defragmentation_performed_count] [int] NULL,
		[defragmentation_notperformed_count] [int] NULL,
		[max_update_date] [datetime] NULL,
		[min_update_date] [datetime] NULL,
		[defragmentation_job_average_duration] [int] NULL,
		[defragmentation_job_longest_duration] [int] NULL,
		[defragmentation_job_shortest_duration] [int] NULL,
		[average_table_count] [int] NULL,
		[average_index_count] [int] NULL,
		[average_defragmented_Indexes_TotalCount] [int] NULL,
		[average_defragmenting_errors_count] [int] NULL,
		[max_defragmented_Indexes_TotalCount] [int] NULL,
		[max_defragmenting_errors_count] [int] NULL)

		INSERT INTO @tIDSummary
		([server_name]
		,[database_name]
		,[total_defragmentation_job_count]
		,[database_not_accessible_count]
		,[database_accessible_count]
		,[defragmentation_performed_count]
		,[defragmentation_notperformed_count]
		,[max_update_date]
		,[min_update_date]
		,[defragmentation_job_average_duration]
		,[defragmentation_job_longest_duration]
		,[defragmentation_job_shortest_duration]
		,[average_table_count]
		,[average_index_count]
		,[average_defragmented_Indexes_TotalCount]
		,[average_defragmenting_errors_count]
		,[max_defragmented_Indexes_TotalCount]
		,[max_defragmenting_errors_count])
		SELECT 
		[server_name]
		,[database_name]
		,count([defragmentation_job_id])
		,sum(case [database_accessible_ind] when CAST(0 AS INT) then CAST(1 AS INT) else 0 end) as not_accessible_counter
		,sum(case [database_accessible_ind] when 1 then CAST(1 AS INT) else CAST(0 AS INT) end) as accessible_counter
		,sum(CAST([defragmentation_performed_ind] AS INT))
		,(count([defragmentation_job_id]) - sum(cast([defragmentation_performed_ind] as int))) as not_performed
		,max([last_update_date])
		,min([last_update_date])
		,avg(datediff(minute,[defragmentation_job_starttime],[defragmentation_job_endtime]))
		,max(datediff(minute,[defragmentation_job_starttime],[defragmentation_job_endtime]))
		,min(datediff(minute,[defragmentation_job_starttime],[defragmentation_job_endtime]))
		,avg([table_count])
		,avg([index_count])
		,avg([defragmented_Indexes_TotalCount])
		,avg([defragmenting_errors_count])
		,max([defragmented_Indexes_TotalCount])
		,max([defragmenting_errors_count])
		FROM [dbo].[vw_Index_Defragmentation_History_Summary]
		WHERE [last_update_date] BETWEEN @pEarliestDate and @pLatestDate 
		GROUP BY
		[server_name]
		,[database_name]
		
		SELECT
		 [server_name]
		,[database_name]
		,[total_defragmentation_job_count]
		,[database_not_accessible_count]
		,[database_accessible_count]
		,[defragmentation_performed_count]
		,[defragmentation_notperformed_count]
		,[max_update_date]
		,[min_update_date]
		,[defragmentation_job_average_duration]
		,[defragmentation_job_longest_duration]
		,[defragmentation_job_shortest_duration]
		,[average_table_count]
		,[average_index_count]
		,[average_defragmented_Indexes_TotalCount]
		,[average_defragmenting_errors_count]
		,[max_defragmented_Indexes_TotalCount]
		,[max_defragmenting_errors_count]
		FROM @tIDSummary
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_LongestAvgDuration_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_LongestAvgDuration_ForDatabase] 
@pDatabaseName VARCHAR(128)
,@pEarliestDate DATETIME
,@pLatestDate DATETIME
AS
BEGIN

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
/* 
Author: Danny Howell
Description: Procedure provides summary statistic ranking tables by the most time to perform maintenance.  The summary and rankings is the accumulation of average times time spent
per table.  As the I/D detail table records each index for each table, a table can appear multiple times per I/D job id because each table can have 1 to N number of indexes.
This requires first accumulating statistics by table BY defragmentation job (which provides averages/sums by table across time).  Without performing this step first, counts are skewed up and averages are skewed down which
results in inaccurate indicators. 
*/
		
		BEGIN TRANSACTION;

		DECLARE @RankedIDDuration TABLE ([server_name] VARCHAR(128), [database_name] VARCHAR(128), [schema_name] varchar(128), [table_name] VARCHAR(128), [defragmentation_job_id] INT,[indexes_defragmented_count] INT, [avg_duration_seconds] BIGINT, [max_defragment_endtime] datetime, [avg_table_row_count] BIGINT)
		INSERT INTO @RankedIDDuration (
		[server_name]
		,[database_name]
		,[schema_name]
		,[table_name]
		,[defragmentation_job_id]
		,[indexes_defragmented_count]
		,[avg_duration_seconds]
		,[max_defragment_endtime]
		,[avg_table_row_count])
		SELECT 
		[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		,[IDHS1].[defragmentation_job_id]
		,count([IDHS1].[defragmentation_job_id])
		,SUM(datediff(second,[IDHD1].[defragmentation_task_starttime],[IDHD1].[defragmentation_task_endtime]))
		,MAX([IDHD1].[defragmentation_task_endtime])
		,round(avg(cast([table_row_count] as bigint)),0)
		FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDHD1
		INNER JOIN [dbo].[vw_Index_Defragmentation_History_Summary] AS IDHS1
		ON [IDHD1].[defragmentation_job_id] = [IDHS1].[defragmentation_job_id]
		WHERE [IDHS1].[database_name] LIKE @pDatabaseName
		AND [IDHS1].[last_update_date] BETWEEN @pEarliestDate and @pLatestDate
		AND [IDHD1].[defragmentation_performed_on_Index] = 1
		GROUP BY 
		[IDHS1].[defragmentation_job_id]
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]		
			
		;WITH CTE_RunningTotals 
		AS
		(		
		SELECT
		DENSE_RANK () OVER (ORDER BY avg([TT1].[avg_duration_seconds]) DESC) as [duration_ranking]
		,DENSE_RANK () OVER (ORDER BY Count([TT1].[defragmentation_job_id]) * avg(cast([TT1].[indexes_defragmented_count] as numeric(5,1))) DESC) AS [factored_index_count_ranking]
		,[TT1].[server_name]
		,[TT1].[database_name]
		,[TT1].[schema_name]
		,[TT1].[table_name]
		,datediff(day,max([TT1].[max_defragment_endtime]),getdate()) as [days_since_last_maintenance]
		,avg([TT1].[avg_duration_seconds]) as [avg_total_duration_table]
		,max([IDHD3].[MRRowCount]) as [max_row_count]
		,Count([TT1].defragmentation_job_id) as [number_of_defrag_jobs]
		,cast(avg(cast([TT1].[indexes_defragmented_count] as numeric(5,1))) as numeric(5,1)) as [avg_number_of_indexes_defragmented]
		from @RankedIDDuration AS TT1
		LEFT OUTER JOIN
			(
			SELECT 
			[IDHS2].[server_name]
			,[IDHS2].[database_name]
			,[IDHD2].[schema_name]
			,[IDHD2].[table_name]
			,MAX([IDHD2].[table_row_count]) AS MRRowCount
			FROM [dbo].[vw_Index_Defragmentation_History_Detail] AS IDHD2
			INNER JOIN (SELECT 
						[server_name]
						,[database_name]
						,MAX([defragmentation_job_id]) as MRIDJobID
						FROM [dbo].[vw_Index_Defragmentation_History_Summary] 
						GROUP BY 
						[server_name]
						,[database_name]) AS IDHS2
			ON [IDHD2].[defragmentation_job_id] = [IDHS2].[MRIDJobID]
			GROUP BY 
			[IDHS2].[server_name]
			,[IDHS2].[database_name]
			,[IDHD2].[schema_name]
			,[IDHD2].[table_name]
			) AS IDHD3
		ON TT1.[server_name] = IDHD3.[server_name]
		AND [TT1].[database_name] = [IDHD3].[database_name]
		AND [TT1].[schema_name] = [IDHD3].[schema_name]
		AND [TT1].[table_name] = [IDHD3].[table_name]
		group by 
		[TT1].[server_name]
		,[TT1].[database_name]
		,[TT1].[schema_name]
		,[TT1].[table_name]
		)

		select 
		[T1].[duration_ranking]
		,[T1].[factored_index_count_ranking]
		,[T1].[server_name]
		,[T1].[database_name]
		,[T1].[schema_name]
		,[T1].[table_name]
		,[T1].[days_since_last_maintenance]
		,[T1].[avg_total_duration_table]
		,[T1].[max_row_count]
		,[T1].[number_of_defrag_jobs]
		,[T1].[avg_number_of_indexes_defragmented]
		,cast((t1.avg_total_duration_table/cast(rt2.runningtotal as numeric(15,2))) as numeric(5,4)) table_percent_of_total_duration
		,rt1.runningtot as duration_running_total
		from CTE_RunningTotals as t1
		cross apply (select sum(avg_total_duration_table) as runningtot
		from CTE_RunningTotals 
		where duration_ranking <= t1.duration_ranking
		) as rt1
		cross apply (select sum(avg_total_duration_table) as runningtotal
		from CTE_RunningTotals 
		) as rt2
		ORDER BY [T1].[duration_ranking] ASC

		COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_MostRecent_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_MostRecent_ForDatabase] 
@pDatabaseName NVARCHAR(128)

AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Index Defragmentation (I/D) maintenance job history for tables in the selected databases. 
Report data used to view type of I/D performed and % fragmentation change for the most recent maintenance job.
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

	DECLARE @maxdefragmentation_job_id INT
	SELECT @maxdefragmentation_job_id = MAX(defragmentation_job_id)
	FROM [dbo].[vw_Index_Defragmentation_History_Summary]
	WHERE [database_name] LIKE @pDatabaseName

	BEGIN TRANSACTION
	DECLARE @tIDSummary TABLE (
		[defragmentation_job_id] [int] NULL,
		[executioninstanceGUID] [uniqueidentifier] NULL,
		[initiating_job_scheduler_application_name] [varchar](30) NULL,
		[initiating_job_name] [varchar](128) NULL,
		[server_name] [varchar](128) NULL,
		[database_id] [int] NULL,
		[database_name] [varchar](128) NULL,
		[database_accessible_ind] [bit] NULL,
		[defragmentation_performed_ind] [bit] NULL,
		[online_defrag_operations_override_ind] [bit] NULL,
		[last_update_date] [datetime] NULL,
		[defragmentation_job_starttime] [datetime] NULL,
		[defragmentation_job_endtime] [datetime] NULL,
		[index_defragment_agerequirement_at_job_run] [smallint] NULL,
		[index_defragment_minimum_pagecount_at_job_run] [bigint] NULL,
		[index_rebuild_minimum_fragmentation_percent] [float] NULL,
		[index_reorganize_minimum_fragmentation_percent] [float] NULL,
		[table_count] [int] NULL,
		[index_count] [int] NULL,
		[defragmented_Indexes_TotalCount] [int] NULL,
		[defragmenting_errors_count] [int] NULL,
		[defragmentation_comments] [varchar](1000) NULL)

		INSERT INTO @tIDSummary
				   ([defragmentation_job_id]
				   ,[executioninstanceGUID]
				   ,[initiating_job_scheduler_application_name]
				   ,[initiating_job_name]
				   ,[server_name]
				   ,[database_id]
				   ,[database_name]
				   ,[database_accessible_ind]
				   ,[defragmentation_performed_ind]
				   ,[online_defrag_operations_override_ind]
				   ,[last_update_date]
				   ,[defragmentation_job_starttime]
				   ,[defragmentation_job_endtime]
				   ,[index_defragment_agerequirement_at_job_run]
				   ,[index_defragment_minimum_pagecount_at_job_run]
				   ,[index_rebuild_minimum_fragmentation_percent]
				   ,[index_reorganize_minimum_fragmentation_percent]
				   ,[table_count]
				   ,[index_count]
				   ,[defragmented_Indexes_TotalCount]
				   ,[defragmenting_errors_count]
				   ,[defragmentation_comments])
			SELECT 
				[T4].[defragmentation_job_id]
				,[T4].[executioninstanceGUID]
				,[T4].[initiating_job_scheduler_application_name]
				,[T4].[initiating_job_name]
				,[T4].[server_name]
				,[t4].[database_id]
				,[T4].[database_name]
				,[T4].[database_accessible_ind]
				,[T4].[defragmentation_performed_ind]
				,[T4].[online_defrag_operations_override_ind]
				,[T4].[last_update_date]
				,[T4].[defragmentation_job_starttime]
				,[T4].[defragmentation_job_endtime]
				,[T4].[index_defragment_agerequirement_at_job_run]
				,[T4].[index_defragment_minimum_pagecount_at_job_run]
				,[T4].[index_rebuild_minimum_fragmentation_percent]
				,[T4].[index_reorganize_minimum_fragmentation_percent]
				,[T4].[table_count]
				,[T4].[index_count]
				,[T4].[defragmented_Indexes_TotalCount]
				,[T4].[defragmenting_errors_count]
				,[T4].[defragmentation_comments]
			FROM [dbo].[vw_Index_Defragmentation_History_Summary] AS T4
			WHERE [T4].[database_name] LIKE @pDatabaseName
			AND [T4].[defragmentation_job_id] = @maxdefragmentation_job_id
		
		SELECT 
		[T4].[defragmentation_job_id]
		,[T4].[executioninstanceGUID]
		,[T4].[initiating_job_scheduler_application_name]
		,[T4].[initiating_job_name]
		,[T4].[server_name]
		,[T4].[database_name]
		,cast([T4].[database_accessible_ind] as bit) as [database_accessible_ind]
		,cast([T4].[defragmentation_performed_ind] as bit) as [defragmentation_performed_ind]
		,cast([T4].[online_defrag_operations_override_ind] as bit) as [online_defrag_operations_override_ind]
		,convert(varchar(20), [T4].[last_update_date],100) as last_update_date
		,convert(varchar(20), [T4].[defragmentation_job_starttime],100) as defragmentation_job_starttime
		,convert(varchar(20), [T4].[defragmentation_job_endtime],1) as defragmentation_job_endtime
		,datediff(minute,[T4].[defragmentation_job_starttime],[T4].[defragmentation_job_endtime]) as job_duration_minutes
		,CASE WHEN [T4].[defragmenting_errors_count] > 0 THEN 1 ELSE 0 END AS job_experience_errors
		,[T4].[index_defragment_agerequirement_at_job_run]
		,[T4].[index_defragment_minimum_pagecount_at_job_run]
		,[T4].[index_rebuild_minimum_fragmentation_percent]
		,[T4].[index_reorganize_minimum_fragmentation_percent]
		,[T4].[table_count]
		,[T4].[index_count]
		,[T4].[defragmented_Indexes_TotalCount]
		,[T4].[defragmenting_errors_count]
		,[T4].[defragmentation_comments]
		FROM @tIDSummary AS T4
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_MostRecent_ForServer]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_MostRecent_ForServer] 
AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Index Defragmentation (I/D) maintenance job history for all databases on the server. 
Report data used to view type of I/D performed and summary information for the most recent maintenance job.
By utilizing the master.sys.databases table in a LEFT OUTER JOIN relationship to the I/D history tables, procedure provides 
a results set for databases for which NO maintenance has been performed as well as those for which it was done.
As such, this procedure is useful in confirming any job parameter changes in case new databases are added after the initial SSIS environment creation.
*/

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

	BEGIN TRANSACTION
		DECLARE @tIDSummary TABLE (
			[defragmentation_job_id] [int] NULL,
			[executioninstanceGUID] [uniqueidentifier] NULL,
			[initiating_job_scheduler_application_name] [varchar](30) NULL,
			[initiating_job_name] [varchar](128) NULL,
			[server_name] [varchar](128) NULL,
			[database_id] [int] NULL,
			[database_name] [varchar](128) NULL,
			[database_accessible_ind] [bit] NULL,
			[defragmentation_performed_ind] [bit] NULL,
			[online_defrag_operations_override_ind] [bit] NULL,
			[last_update_date] [datetime] NULL,
			[defragmentation_job_starttime] [datetime] NULL,
			[defragmentation_job_endtime] [datetime] NULL,
			[index_defragment_agerequirement_at_job_run] [smallint] NULL,
			[index_defragment_minimum_pagecount_at_job_run] [bigint] NULL,
			[index_rebuild_minimum_fragmentation_percent] [float] NULL,
			[index_reorganize_minimum_fragmentation_percent] [float] NULL,
			[table_count] [int] NULL,
			[index_count] [int] NULL,
			[defragmented_Indexes_TotalCount] [int] NULL,
			[defragmenting_errors_count] [int] NULL,
			[defragmentation_comments] [varchar](1000) NULL)

			INSERT INTO @tIDSummary
					   ([defragmentation_job_id]
					   ,[executioninstanceGUID]
					   ,[initiating_job_scheduler_application_name]
					   ,[initiating_job_name]
					   ,[server_name]
					   ,[database_id]
					   ,[database_name]
					   ,[database_accessible_ind]
					   ,[defragmentation_performed_ind]
					   ,[online_defrag_operations_override_ind]
					   ,[last_update_date]
					   ,[defragmentation_job_starttime]
					   ,[defragmentation_job_endtime]
					   ,[index_defragment_agerequirement_at_job_run]
					   ,[index_defragment_minimum_pagecount_at_job_run]
					   ,[index_rebuild_minimum_fragmentation_percent]
					   ,[index_reorganize_minimum_fragmentation_percent]
					   ,[table_count]
					   ,[index_count]
					   ,[defragmented_Indexes_TotalCount]
					   ,[defragmenting_errors_count]
					   ,[defragmentation_comments])
				SELECT 
					[T4].[defragmentation_job_id]
					,[T4].[executioninstanceGUID]
					,[T4].[initiating_job_scheduler_application_name]
					,[T4].[initiating_job_name]
					,[T4].[server_name]
					,[t4].[database_id]
					,[T4].[database_name]
					,[T4].[database_accessible_ind]
					,[T4].[defragmentation_performed_ind]
					,[T4].[online_defrag_operations_override_ind]
					,[T4].[last_update_date]
					,[T4].[defragmentation_job_starttime]
					,[T4].[defragmentation_job_endtime]
					,[T4].[index_defragment_agerequirement_at_job_run]
					,[T4].[index_defragment_minimum_pagecount_at_job_run]
					,[T4].[index_rebuild_minimum_fragmentation_percent]
					,[T4].[index_reorganize_minimum_fragmentation_percent]
					,[T4].[table_count]
					,[T4].[index_count]
					,[T4].[defragmented_Indexes_TotalCount]
					,[T4].[defragmenting_errors_count]
					,[T4].[defragmentation_comments]
				FROM [dbo].[vw_Index_Defragmentation_History_Summary] AS T4
				INNER JOIN 
				(SELECT
				MAX([defragmentation_job_id]) as MRJobID
				,[database_name]
				FROM [dbo].[vw_Index_Defragmentation_History_Summary]
				GROUP BY [database_name]) as T2
				ON [T4].[defragmentation_job_id] = [T2].[MRJobID]
				AND [T4].[database_name] = [T2].database_name

		SELECT 
			[T4].[defragmentation_job_id]
			,[T4].[executioninstanceGUID]
			,[T4].[initiating_job_scheduler_application_name]
			,[T4].[initiating_job_name]
			,ISNULL([T4].[server_name],cast(serverproperty('servername') as nvarchar(128))) as server_name
			,ISNULL([T4].[database_name],[t3].[name]) as database_name
			,cast(isnull([T4].[database_accessible_ind],0) as bit) as [database_accessible_ind]
			,cast(ISNULL([T4].[defragmentation_performed_ind],0) as bit) AS defragmentation_performed_ind
			,cast(isnull([T4].[online_defrag_operations_override_ind],0) as bit) as [online_defrag_operations_override_ind]
			,ISNULL(convert(varchar(20), [T4].[last_update_date],100),'No maintenance done') as last_update_date
			,ISNULL(convert(varchar(20), [T4].[defragmentation_job_starttime],100) ,'') as defragmentation_job_starttime
			,ISNULL(convert(varchar(20), [T4].[defragmentation_job_endtime],100) ,'') as defragmentation_job_endtime
			,datediff(minute,[T4].[defragmentation_job_starttime],[T4].[defragmentation_job_endtime]) as job_duration_minutes
			,CASE WHEN [T4].[defragmenting_errors_count] > 0 THEN cast(1 as bit) ELSE cast(0 as bit) END AS job_experience_errors
			,[T3].[state_desc]
			,[T3].[user_access_desc]
			,[T4].[index_defragment_agerequirement_at_job_run]
			,[T4].[index_defragment_minimum_pagecount_at_job_run]
			,[T4].[index_rebuild_minimum_fragmentation_percent]f
			,[T4].[index_reorganize_minimum_fragmentation_percent]
			,[T4].[table_count]
			,[T4].[index_count]
			,[T4].[defragmented_Indexes_TotalCount]
			,[T4].[defragmenting_errors_count]
			,ISNULL([T4].[defragmentation_comments], 'No maintenance found for this database') as defragmentation_comments
			FROM [master].[sys].[databases] AS T3
		LEFT OUTER JOIN @tIDSummary AS T4
		ON [T3].[name] = [T4].[database_name]
		WHERE [T3].[name] NOT IN ('master','model','msdb','tempdb','distribution','ReportServer','ReportServerTempDB','SSISDB')
		AND [T3].[source_database_id] IS NULL

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_MostRecentDetail_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_MostRecentDetail_ForDatabase] 
@pDatabaseName NVARCHAR(128)
,@pShowIndexesNoMaint BIT

AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Index Defragmentation (I/D) maintenance job history for tables in the selected databases. 
Report data used to view type of I/D performed and % fragmentation change for each index and table processed by the most recent maintenance job.
The default option excludes tables and indexes for which no maintenance was performed.  
The @pShowIndexesNoMaint parameter sets the option to include tables not processed. 
Viewing unprocessed tables provides a "snapshot" of the index fragmentation at the time of the maintenance.
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowIndexesNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
	BEGIN TRANSACTION
	DECLARE @tIDDetail TABLE (
	[defragmentation_job_id] [int] NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_id] [bigint] NOT NULL,
	[index_id] [bigint] NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[index_name] [varchar](128) NOT NULL,
	[table_row_count] [int] NOT NULL,
	[Type_performed] VARCHAR(25) NULL,
	[defragmentation_failed_ind] [bit] NOT NULL,
	[defragmentation_performed_on_Index] [bit] NOT NULL,
	[maintenance_duration_minutes] INT NULL,
	[defragmentation_task_starttime] [datetime] NULL,
	[fragmentationlevel_prerun] [numeric](6,1) NULL,
	[fragmentationlevel_postrun] [numeric](6,1) NULL,
	[fragmentationlevel_change] [numeric](6,1) NULL,
	[index_specific_comments] [varchar](1000) NULL
	) 
	
		DECLARE @maxdefragmentation_job_id INT
		SELECT @maxdefragmentation_job_id = MAX(defragmentation_job_id)
		FROM [dbo].[vw_Index_Defragmentation_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		
		INSERT INTO @tIDDetail
		(
		[defragmentation_job_id],
		[schema_name],
		[table_id],
		[index_id],
		[table_name],
		[index_name],
		[table_row_count],
		[Type_performed],
		[defragmentation_failed_ind],
		[defragmentation_performed_on_Index],
		[maintenance_duration_minutes],
		[defragmentation_task_starttime],
		[fragmentationlevel_prerun],
		[fragmentationlevel_postrun],
		[fragmentationlevel_change],
		[index_specific_comments]
		)
		SELECT [defragmentation_job_id]
		,[schema_name]
		,[table_id]
		,[index_id]
		,[table_name]
		,[index_name]
		,[table_row_count]
		,case [index_rebuild_performed_ind] when 1 then 'Rebuild' 
		else 
		case [index_reorg_performed_ind] when 1 then 'Reorg' else 'None' end
		end
		as Type_performed
		,[defragmentation_failed_ind]
		,[defragmentation_performed_on_Index]
		,datediff(minute,[defragmentation_task_starttime],[defragmentation_task_endtime]) as maintenance_duration_minutes
		,[defragmentation_task_starttime]
		,cast([fragmentationlevel_prerun] as numeric(6,1)) as fragmentationlevel_prerun
		,cast([fragmentationlevel_postrun] as numeric(6,1)) as fragmentationlevel_postrun
		,cast([fragmentationlevel_prerun] as numeric(6,1)) - cast([fragmentationlevel_postrun] as numeric(6,3)) as fragmentationlevel_change
		,[index_specific_comments]
		FROM [dbo].[vw_Index_Defragmentation_History_Detail]
		WHERE [defragmentation_job_id] = @maxdefragmentation_job_id 
		AND [defragmentation_performed_on_Index] BETWEEN @ShowAllIndLow AND @ShowAllIndHigh

	SELECT 
	[defragmentation_job_id],
	[schema_name],
	[table_id],
	[index_id],
	[table_name],
	[index_name],
	[table_row_count],
	[Type_performed],
	cast([defragmentation_failed_ind] as bit) as [defragmentation_failed_ind],
	cast([defragmentation_performed_on_Index] as bit) as [defragmentation_performed_on_Index],
	[maintenance_duration_minutes],
	CONVERT(VARCHAR(20),[defragmentation_task_starttime],100) as [defragmentation_task_starttime],
	[fragmentationlevel_prerun],
	[fragmentationlevel_postrun],
	[fragmentationlevel_change],
	[index_specific_comments]
	FROM @tIDDetail 

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF




	END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_ID_Summary_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_ID_Summary_ForDatabase] 
@pDatabaseName NVARCHAR(128)
,@pLatestDate DATETIME
,@pEarliestDate DATETIME
AS
BEGIN
/*
Author: Danny Howell
Description: 
Procedure provides summary Index Defragmentation (I/D) maintenance job information for the indicated database for all jobs within the selected date range. 
Report data used to view I/D job facts along with total tables and indexes processed along with error counts as well as the threshold and job parameters used for the most recent job execution.  
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @tIDSummary TABLE (
			[defragmentation_job_id] [int] NULL,
			[executioninstanceGUID] [uniqueidentifier] NULL,
			[initiating_job_scheduler_application_name] [varchar](30) NULL,
			[initiating_job_name] [varchar](128) NULL,
			[server_name] [varchar](128) NULL,
			[database_id] [int] NULL,
			[database_name] [varchar](128) NULL,
			[database_accessible_ind] [bit] NULL,
			[defragmentation_performed_ind] [bit] NULL,
			[online_defrag_operations_override_ind] [bit] NULL,
			[last_update_date] [datetime] NULL,
			[defragmentation_job_starttime] [datetime] NULL,
			[defragmentation_job_endtime] [datetime] NULL,
			[index_defragment_agerequirement_at_job_run] [smallint] NULL,
			[index_defragment_minimum_pagecount_at_job_run] [bigint] NULL,
			[index_rebuild_minimum_fragmentation_percent] [float] NULL,
			[index_reorganize_minimum_fragmentation_percent] [float] NULL,
			[table_count] [int] NULL,
			[index_count] [int] NULL,
			[defragmented_Indexes_TotalCount] [int] NULL,
			[defragmenting_errors_count] [int] NULL,
			[defragmentation_comments] [varchar](1000) NULL)

			INSERT INTO @tIDSummary
					   ([defragmentation_job_id]
					   ,[executioninstanceGUID]
					   ,[initiating_job_scheduler_application_name]
					   ,[initiating_job_name]
					   ,[server_name]
					   ,[database_id]
					   ,[database_name]
					   ,[database_accessible_ind]
					   ,[defragmentation_performed_ind]
					   ,[online_defrag_operations_override_ind]
					   ,[last_update_date]
					   ,[defragmentation_job_starttime]
					   ,[defragmentation_job_endtime]
					   ,[index_defragment_agerequirement_at_job_run]
					   ,[index_defragment_minimum_pagecount_at_job_run]
					   ,[index_rebuild_minimum_fragmentation_percent]
					   ,[index_reorganize_minimum_fragmentation_percent]
					   ,[table_count]
					   ,[index_count]
					   ,[defragmented_Indexes_TotalCount]
					   ,[defragmenting_errors_count]
					   ,[defragmentation_comments])
				SELECT 
					[T4].[defragmentation_job_id]
					,[T4].[executioninstanceGUID]
					,[T4].[initiating_job_scheduler_application_name]
					,[T4].[initiating_job_name]
					,[T4].[server_name]
					,[t4].[database_id]
					,[T4].[database_name]
					,[T4].[database_accessible_ind]
					,[T4].[defragmentation_performed_ind]
					,[T4].[online_defrag_operations_override_ind]
					,[T4].[last_update_date]
					,[T4].[defragmentation_job_starttime]
					,[T4].[defragmentation_job_endtime]
					,[T4].[index_defragment_agerequirement_at_job_run]
					,[T4].[index_defragment_minimum_pagecount_at_job_run]
					,[T4].[index_rebuild_minimum_fragmentation_percent]
					,[T4].[index_reorganize_minimum_fragmentation_percent]
					,[T4].[table_count]
					,[T4].[index_count]
					,[T4].[defragmented_Indexes_TotalCount]
					,[T4].[defragmenting_errors_count]
					,[T4].[defragmentation_comments]
				FROM [dbo].[vw_Index_Defragmentation_History_Summary] AS T4
				WHERE [T4].[database_name] LIKE @pDatabaseName
				AND [T4].[defragmentation_job_starttime] BETWEEN @pEarliestDate AND @pLatestDate
	
			SELECT 
			[T4].[defragmentation_job_id]
			,[T4].[executioninstanceGUID]
			,[T4].[initiating_job_scheduler_application_name]
			,[T4].[initiating_job_name]
			,[T4].[server_name]
			,[T4].[database_name]
			,cast([T4].[database_accessible_ind] as bit) as [database_accessible_ind]
			,cast([T4].[defragmentation_performed_ind] as bit) as [defragmentation_performed_ind]
			,cast([T4].[online_defrag_operations_override_ind] as bit) as [online_defrag_operations_override_ind]
			,convert(varchar(20), [T4].[last_update_date],100) as last_update_date
			,convert(varchar(20), [T4].[defragmentation_job_starttime],100) as defragmentation_job_starttime
			,convert(varchar(20), [T4].[defragmentation_job_endtime],100) as defragmentation_job_endtime
			,datediff(minute,[T4].[defragmentation_job_starttime],[T4].[defragmentation_job_endtime]) as job_duration_minutes
			,CASE WHEN [T4].[defragmenting_errors_count] > 0 THEN cast(1 as bit) ELSE cast(0 as bit) END AS job_experience_errors
			,[T4].[index_defragment_agerequirement_at_job_run]
			,[T4].[index_defragment_minimum_pagecount_at_job_run]
			,[T4].[index_rebuild_minimum_fragmentation_percent]
			,[T4].[index_reorganize_minimum_fragmentation_percent]
			,[T4].[table_count]
			,[T4].[index_count]
			,[T4].[defragmented_Indexes_TotalCount]
			,[T4].[defragmenting_errors_count]
			,[T4].[defragmentation_comments]
			FROM @tIDSummary AS T4

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_Detail_ForStatUpdateJobID]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_Detail_ForStatUpdateJobID] 
@pUpdateJobID INT
,@pShowStatsNoMaint BIT

AS
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
/*
Author: Danny Howell
Description: Provides detailed Statistics Update (S/U) maintenance job history for tables in the selected databases for the selected stats update job ID. 
Data results provide the type of scan performed. Percentage scans should use the parameter value set in the Summary table.
The default option excludes tables and indexes for which no maintenance was performed.  The @pShowStatsNoMaint parameter
report option includes tables which were not processed as they did not meet the maintenance threshold parameters.
Scan Type--the Database_Maintenance_UpdateStatistics_History uses the following scan types for the possible values of statistic_last_scan_type
No Scan--Value = 0, The table's statistics were not updated because the table has no rows or has no statistics to update
Default--Value = 5. Specifies that a percentage of the table or indexed view is used when collecting statistics. The actual percentage is calculated by the SQL Server engine automatically.
FullScan--Value = 3. Specifies that all rows in the table or view are read when gathering statistics. This option must be used if a view is specified and it references more than one table.
Percent--Value = 1. Specifies that a percentage of the table or indexed view is used when collecting statistics. 
This options cannot be used if a view is specified and it references more than one table. When specified, use the sampleValue argument to indicate number of rows.
Resample-- Value = 4. Specifies that the percentage ratio of the table or indexed view used when collecting statistics is inherited from existing the statistics
Rows--Value = 2. Specifies that a number of rows in the table or indexed view are used when collecting statistics. 
This option cannot be used if a view is specified and it references more than one table. When specified, use the sampleValue argument to indicate number of rows

*/
SET XACT_ABORT ON  

BEGIN TRY
	
	BEGIN TRANSACTION
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowStatsNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
		SELECT
		[statssummary_job_id]
		,[database_id]
		,[table_id]
		,[statistic_id]
		,[schema_name]
		,[table_name]
		,[statistic_name]
		,[table_row_count]
		,[rows_sampled]
		, CAST([rows_sampled] AS NUMERIC(15,3))/
		(CAST(CASE WHEN ISNULL([table_row_count],0) > 0 THEN [table_row_count] ELSE
			CASE WHEN ISNULL([rows_sampled],0) > 0 THEN [rows_sampled] ELSE 1 END 
			END AS numeric(15,2))) as [percentage_used]
		,[modification_counter] AS [modification_counter]
		,(CAST([modification_counter] AS NUMERIC(18,3)) / 
			CAST(CASE WHEN ISNULL([table_row_count],0) > 0 THEN [table_row_count] ELSE
			CASE WHEN ISNULL([modification_counter],0) > 0 THEN [modification_counter] ELSE 1 END 
			END AS numeric(15,2))) as [percentage_modified]
		,CAST([statsupdate_completed_ind] AS BIT) AS [statsupdate_completed_ind]
		,CAST([statsupdate_performed_ind] AS BIT) AS [statsupdate_performed_ind]
		,CAST([statsupdate_failed_ind] AS BIT) AS [statsupdate_failed_ind]
		,CAST([statsupdate_fromindexdefrag] AS BIT) AS [statsupdate_fromindexdefrag]
		,CASE [statsupdate_scan_type_performed] 
			WHEN 0 THEN 'None'
			WHEN 1 THEN 'Percent'
			WHEN 2 THEN 'Rows'
			WHEN 3 THEN 'Full Scan'
			WHEN 4 THEN 'Resample'
			WHEN 5 THEN 'Percent'
			ELSE 'Unknown' END as [scan_type_performed]
		,cast(cast(datediff(MILLISECOND,[statsupdate_task_starttime],[statsupdate_task_endtime]) as numeric(18,3))/1000 as numeric(10,1)) as maintenance_duration_sec
		,CONVERT(VARCHAR(20),[statsupdate_task_starttime],100) AS [statsupdate_task_starttime]
		,[statistic_specific_comments]
		FROM [dbo].[vw_Statistics_Update_History_Detail]
		WHERE [statssummary_job_id] = @pUpdateJobID
		AND [statsupdate_performed_ind] BETWEEN @ShowAllIndLow AND @ShowAllIndHigh
		
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_Detail_ForTable]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_Detail_ForTable] 
@pDatabaseName VARCHAR(128)
,@pTableName VARCHAR(128)
,@pShowStatsNoMaint BIT

AS
BEGIN
/*
Author: Danny Howell
Description:  Procedures provides detailed Index Defragmentation (I/D) maintenance job history for tables in the selected databases. 
Results data provides a view type of I/D performed and % fragmentation change for each index and table processed by the maintenance job. 
The default option excludes tables and indexes for which no maintenance was performed.
Changing the @pShowStatsNoMaint parameter includes tables not processed. 
Viewing unprocessed tables provides a "snapshot" of the index fragmentation at the time of the maintenance.
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowStatsNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
	BEGIN TRANSACTION
	DECLARE @tSUDetail TABLE (
	[statssummary_job_id] [int] NOT NULL,
	[database_id] [int] NOT NULL,
	[table_id] [bigint] NOT NULL,
	[statistic_id] [int] NOT NULL,
	[database_name] [varchar] (128) NOT NULL,
	[schema_name] [varchar](128) NOT NULL,
	[table_name] [varchar](128) NOT NULL,
	[statistic_name] [varchar](128) NOT NULL,
	[table_row_count] [bigint] NOT NULL,
	[statsupdate_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[statsupdate_failed_ind] [bit] NULL,
	[statsupdate_fromindexdefrag] [bit] NULL,
	[statsupdate_scan_type_performed] [int] NOT NULL,
	[maintenance_duration_ms] [bigint] NULL,
	[statsupdate_task_starttime] [datetime] NULL,
	[statsupdate_task_endtime] [datetime] NULL,
	[auto_created] [bit] NULL,
	[user_created] [bit] NULL,
	[system_last_updated] [datetime] NULL,
	[rows_sampled] [bigint] NULL,
	[statistic_specific_comments] [varchar](1000) NULL
	)


	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDS1
		ON [IDD1].[statssummary_job_id] = [IDS1].[statssummary_job_id]
		WHERE [database_name] = @pDatabaseName AND [IDD1].[table_name] LIKE @pTableName)
	BEGIN
		INSERT INTO @tSUDetail
		(
		[statssummary_job_id],
		[database_id],
		[table_id],
		[statistic_id],
		[database_name],
		[schema_name],
		[table_name],
		[statistic_name],
		[table_row_count],
		[statsupdate_completed_ind],
		[statsupdate_performed_ind],
		[statsupdate_failed_ind],
		[statsupdate_fromindexdefrag],
		[statsupdate_scan_type_performed],
		[maintenance_duration_ms],
		[statsupdate_task_starttime],
		[statsupdate_task_endtime],
		[auto_created],
		[user_created],
		[system_last_updated],
		[rows_sampled],
		[statistic_specific_comments]
		)
		SELECT 
		0
		,0
		,0
		,0
		,@pDatabaseName
		,'No schema'
		,'No table'
		,'No statistic'
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,GETDATE()
		,GETDATE()
		,0
		,0
		,GETDATE()
		,0
		,'No maintenance performed on this table or a table with this name does not exist in the database ' + @pDatabaseName + ' on this server'
	END
	ELSE
	BEGIN
		INSERT INTO @tSUDetail
		(
		[statssummary_job_id],
		[database_id],
		[table_id],
		[statistic_id],
		[database_name],
		[schema_name],
		[table_name],
		[statistic_name],
		[table_row_count],
		[statsupdate_completed_ind],
		[statsupdate_performed_ind],
		[statsupdate_failed_ind],
		[statsupdate_fromindexdefrag],
		[statsupdate_scan_type_performed],
		[maintenance_duration_ms],
		[statsupdate_task_starttime],
		[statsupdate_task_endtime],
		[auto_created],
		[user_created],
		[system_last_updated],
		[rows_sampled],
		[statistic_specific_comments]
		)
		SELECT 
		[IDD1].[statssummary_job_id]
		,[IDD1].[database_id]
		,[IDD1].[table_id]
		,[IDD1].[statistic_id]
		,[IDS1].[database_name]
		,[IDD1].[schema_name]
		,[IDD1].[table_name]
		,[IDD1].[statistic_name]
		,[IDD1].[table_row_count]
		,[IDD1].[statsupdate_completed_ind]
		,[IDD1].[statsupdate_performed_ind]
		,CASE WHEN [IDD1].[statsupdate_task_endtime] IS NULL THEN CAST(1 AS BIT) ELSE [IDD1].[statsupdate_failed_ind] END
		,[IDD1].[statsupdate_fromindexdefrag]
		,CASE WHEN [IDD1].[statsupdate_scan_type_performed] = 0 THEN 0 WHEN [table_row_count] = [rows_sampled] THEN 3 ELSE 1 END
		,datediff(MILLISECOND,[IDD1].[statsupdate_task_starttime],ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])) as maintenance_duration_ms
		,[IDD1].[statsupdate_task_starttime]
		,ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])
		,[IDD1].[auto_created]
		,[IDD1].[user_created]
		,[IDD1].[system_last_updated]
		,[IDD1].[rows_sampled]
		,[IDD1].[statistic_specific_comments]
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDS1
		ON [IDD1].[statssummary_job_id] = [IDS1].[statssummary_job_id]
		WHERE [IDS1].[database_name] = @pDatabaseName
		AND [IDD1].[table_name] LIKE @pTableName
		AND [IDD1].[statsupdate_performed_ind]BETWEEN @ShowAllIndLow AND @ShowAllIndHigh
	END
	
	SELECT 
	[statssummary_job_id],
	[database_id],
	[table_id],
	[statistic_id],
	[database_name],
	[schema_name],
	[table_name],
	[statistic_name],
	[table_row_count],
	CAST(CASE WHEN ISNULL([table_row_count],0) > 0 THEN [table_row_count] ELSE
			CASE WHEN ISNULL([rows_sampled],0) > 0 THEN [rows_sampled] ELSE 1 END 
			END AS numeric(15,2)) as [percentage_used],
	CAST([statsupdate_completed_ind] AS BIT) AS [statsupdate_completed_ind],
	CAST([statsupdate_performed_ind] AS BIT) AS [statsupdate_performed_ind],
	CAST([statsupdate_failed_ind] AS BIT) AS [statsupdate_failed_ind],
	CAST([statsupdate_fromindexdefrag] AS BIT) AS [statsupdate_fromindexdefrag],
	[statsupdate_scan_type_performed],
	CASE [statsupdate_scan_type_performed] 
			WHEN 0 THEN 'None'
			WHEN 1 THEN 'Percent'
			WHEN 2 THEN 'Rows'
			WHEN 3 THEN 'Full Scan'
			WHEN 4 THEN 'Resample'
			WHEN 5 THEN 'Percent'
			ELSE 'Unknown' END as [scan_type_performed],
	CAST([maintenance_duration_ms]/1000 AS NUMERIC(15,3)) AS duration_seconds,
	CONVERT(VARCHAR(20),[statsupdate_task_starttime],100) AS [statsupdate_task_starttime],
	[statistic_specific_comments]
	FROM @tSUDetail

	
	COMMIT TRANSACTION


END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_JobStats_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_JobStats_ForDatabase] 
@pDatabaseName VARCHAR(128)
,@pTableName VARCHAR(128)
,@pEarliestDate DATETIME
,@pLatestDate DATETIME
AS
BEGIN

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
/*
Author: Danny Howell
Description:  Procedures provides summary statistics for Index Defragmentation (I/D) maintenance job history for tables in the selected databases.
The date parameters permit restriction of the history range--this allows for narrowing the maintenance history to more recent jobs.
Results data provides a view of average times and counts of tables and indexes for the database to identify objects requiring more frequent and resource intensive maintenance tasks. 
By separating tables and indexes by those performed and not performed, summary statistics are not skewed by jobs for which no maintenance is performed.
*/

BEGIN TRY
/* Table index work--when done--impact when maintenance was done, times when maintenance was not done and the average condition at that time */
		BEGIN TRANSACTION

		DECLARE @tIDIndexCount TABLE (
		[statssummary_job_id] [INT] NOT NULL,
		[statsupdate_performed_ind] [bit] NOT NULL,
		[database_name] [varchar](128) NULL,
		[schema_name] [varchar](128) NULL,
		[table_name] [varchar](128) NULL,
		[statistic_count] [int] NOT NULL)
		
		INSERT INTO @tIDIndexCount(
		[statssummary_job_id],
		[statsupdate_performed_ind],
		[database_name],
		[schema_name],
		[table_name],
		[statistic_count])
	SELECT
		[IDHD2].[statssummary_job_id],
		[IDHD2].[statsupdate_performed_ind],
		IDHS2.[database_name],
		IDHD2.[schema_name],
		IDHD2.[table_name],
		SUM(CAST(1 AS INT))
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS [IDHD2]
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDHS2
		ON [IDHD2].[statssummary_job_id] = [IDHS2].[statssummary_job_id]
		WHERE [IDHS2].[database_name] LIKE @pDatabaseName
		AND [IDHD2].[table_name] LIKE @pTableName
		AND [IDHS2].[statsupdate_job_date] BETWEEN @pEarliestDate and @pLatestDate
		GROUP BY 
		[IDHD2].[statssummary_job_id],
		[IDHD2].[statsupdate_performed_ind],
		IDHS2.[database_name],
		IDHD2.[schema_name],
		IDHD2.[table_name]
							
		DECLARE @tIDTableSummary TABLE (
		[statssummary_job_id] [INT] NOT NULL,
		[statsupdate_performed_ind] [bit] NOT NULL,
		[server_name] [varchar](128) NULL,
		[database_name] [varchar](128) NULL,
		[schema_name] [varchar](128) NULL,
		[table_name] [varchar](128) NULL,
		[avg_row_count] [bigint] NOT NULL,
		[stats_update_completed_count] [int] NOT NULL,
		[stats_update_failed_count] [int] NULL,
		[stats_update_performed_count] [int] NULL,
		[avg_stats_maintenance_duration] [numeric] (15,2) NULL
		)

		INSERT INTO @tIDTableSummary(
		[statssummary_job_id],
		[statsupdate_performed_ind],
		[server_name],
		[database_name],
		[schema_name],
		[table_name],
		[avg_row_count],
		[stats_update_completed_count],
		[stats_update_failed_count],
		[stats_update_performed_count],
		[avg_stats_maintenance_duration] 
		)
		SELECT 
		[IDHD1].[statssummary_job_id]
		,[IDHD1].[statsupdate_performed_ind]
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		,cast(avg(cast([IDHD1].[table_row_count] as bigint)) as bigint)
		,sum(CAST([IDHD1].[statsupdate_completed_ind] AS INT))
		,sum(CAST([IDHD1].[statsupdate_failed_ind] AS INT))
		,sum(CAST([IDHD1].[statsupdate_performed_ind] AS INT))
		,avg(datediff(MILLISECOND,[IDHD1].[statsupdate_task_starttime],ISNULL([IDHD1].[statsupdate_task_endtime],[IDHD1].[statsupdate_task_starttime])))
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDHD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDHS1
		ON [IDHD1].[statssummary_job_id] = [IDHS1].[statssummary_job_id]
		WHERE [IDHS1].[database_name] LIKE @pDatabaseName
		AND [IDHD1].[table_name] LIKE @pTableName
		AND [IDHS1].[statsupdate_job_date] BETWEEN @pEarliestDate and @pLatestDate
		AND [IDHD1].[statsupdate_performed_ind] = 1
		GROUP BY 
		[IDHD1].[statssummary_job_id]
		,[IDHD1].[statsupdate_performed_ind] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		UNION ALL		
		SELECT
		[IDHD1].[statssummary_job_id]
		,[IDHD1].[statsupdate_performed_ind]
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]
		,cast(avg(cast([IDHD1].[table_row_count] as bigint)) as bigint)
		,sum(CAST([IDHD1].[statsupdate_completed_ind] AS INT))
		,sum(CAST([IDHD1].[statsupdate_failed_ind] AS INT))
		,sum(CAST([IDHD1].[statsupdate_performed_ind] AS INT))
		,avg(datediff(MILLISECOND,[IDHD1].[statsupdate_task_starttime],ISNULL([IDHD1].[statsupdate_task_endtime],[IDHD1].[statsupdate_task_starttime])))
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDHD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDHS1
		ON [IDHD1].[statssummary_job_id] = [IDHS1].[statssummary_job_id]
		WHERE [IDHS1].[database_name] LIKE @pDatabaseName
		AND [IDHD1].[table_name] LIKE @pTableName
		AND [IDHS1].[statsupdate_job_date] BETWEEN @pEarliestDate and @pLatestDate
		AND [IDHD1].[statsupdate_performed_ind] = 0
		GROUP BY 
		[IDHD1].[statssummary_job_id]
		,[IDHD1].[statsupdate_performed_ind] 
		,[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,[IDHD1].[schema_name]
		,[IDHD1].[table_name]

		SELECT
		[IDS1].[statssummary_job_id],
		convert(varchar(20), [IDS2].[statsupdate_job_date], 101) as statistics_maintenance_job_date,
		[IDS1].[statsupdate_performed_ind],
		[IDS1].[server_name],
		[IDS1].[database_name],
		[IDS1].[schema_name],
		[IDS1].[table_name],
		[IDDH3].[statistic_count],  -- want the count of indexes either not defragmented or defragmented per table per job
		[IDS1].[avg_row_count], -- want the row count of the table at the time the job ran
		[IDS1].[stats_update_completed_count],
		[IDS1].[stats_update_failed_count],
		[IDS1].[stats_update_performed_count],
		[IDS1].[avg_stats_maintenance_duration]  -- want the average time to perform maintenance FOR JUST THE ones for which maintenance was performed to remove 0 duration times when the maintenance was NOT performed per table per job--it is the average of all indexes of a table
		FROM @tIDTableSummary AS [IDS1]
		LEFT OUTER JOIN 
			(SELECT 
			[statsupdate_performed_ind],
			[database_name],
			[schema_name],
			[table_name],
			AVG([statistic_count]) as statistic_count
			FROM @tIDIndexCount
			GROUP BY
			[statsupdate_performed_ind],
			[database_name],
			[schema_name],
			[table_name]) AS [IDDH3]
		ON [IDS1].[schema_name] = [IDDH3].[schema_name]
		AND [IDS1].[table_name] = [IDDH3].[table_name]
		AND [IDS1].[statsupdate_performed_ind] = [IDDH3].[statsupdate_performed_ind]
		and [IDS1].[database_name] = [IDDH3].[database_name]
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS [IDS2]
		ON [IDS1].[statssummary_job_id] = [IDS2].[statssummary_job_id]
		ORDER BY 
		[server_name],
		[database_name],
		[schema_name],
		[table_name],
		[statsupdate_performed_ind]

		COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_JobStats_ForServer]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_JobStats_ForServer] 
@pLatestDate DATETIME
,@pEarliestDate DATETIME
AS
BEGIN
/*
Author: Danny Howell
Description:  Procedures provides summary statistics for Index statsupdate (I/D) maintenance job history for all databases on the server.
The date parameters permit restriction of the history range--this allows for narrowing the maintenance history to more recent jobs.
Results data provides a view of average times and counts of tables and indexes for the databases to identify objects requiring more frequent and resource intensive maintenance tasks. 
*/

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
/* Table index work--when done--impact when maintenance was done, times when maintenance was not done and the average condition at that time */
		BEGIN TRANSACTION
	
		DECLARE @tIDSummary TABLE (
		[server_name] [varchar](128) NULL,
		[database_name] [varchar](128) NULL,
		[total_statsupdate_job_count] [int] NULL,
		[database_not_accessible_count] [int] NULL,
		[database_accessible_count] [int] NULL,
		[statsupdate_performed_count] [int] NULL,
		[statsupdate_notperformed_count] [int] NULL,
		[max_update_date] [datetime] NULL,
		[min_update_date] [datetime] NULL,
		[statsupdate_job_average_duration] [int] NULL,
		[statsupdate_job_longest_duration] [int] NULL,
		[statsupdate_job_shortest_duration] [int] NULL,
		[average_table_count] [int] NULL,
		[average_stats_count] [int] NULL,
		[average_statsupdate_TotalCount] [int] NULL,
		[average_statsupdate_errors_count] [int] NULL,
		[max_statsupdate_TotalCount] [int] NULL,
		[max_statsupdate_errors_count] [int] NULL)

		INSERT INTO @tIDSummary
		([server_name]
		,[database_name]
		,[total_statsupdate_job_count]
		,[database_not_accessible_count]
		,[database_accessible_count]
		,[statsupdate_performed_count]
		,[statsupdate_notperformed_count]
		,[max_update_date]
		,[min_update_date]
		,[statsupdate_job_average_duration]
		,[statsupdate_job_longest_duration]
		,[statsupdate_job_shortest_duration]
		,[average_table_count]
		,[average_stats_count]
		,[average_statsupdate_TotalCount]
		,[average_statsupdate_errors_count]
		,[max_statsupdate_TotalCount]
		,[max_statsupdate_errors_count])
		SELECT 
		[IDHS1].[server_name]
		,[IDHS1].[database_name]
		,count([IDHS1].[statsupdate_job_date])
		,sum(case [IDHS1].[database_accessible_ind] when CAST(0 AS INT) then CAST(1 AS INT) else 0 end) as not_accessible_counter
		,sum(case [IDHS1].[database_accessible_ind] when 1 then CAST(1 AS INT) else CAST(0 AS INT) end) as accessible_counter
		,sum(CAST([IDHS1].[statsupdate_performed_ind] AS INT))
		,(count([IDHS1].[statssummary_job_id]) - sum(cast([IDHS1].[statsupdate_performed_ind] as int))) as not_performed
		,max([IDHS1].[statsupdate_job_date])
		,min([IDHS1].[statsupdate_job_date])
		,avg(datediff(minute,[IDHS1].[statsupdate_job_starttime],[IDHS1].[statsupdate_job_endtime]))
		,max(datediff(minute,[IDHS1].[statsupdate_job_starttime],[IDHS1].[statsupdate_job_endtime]))
		,min(datediff(minute,[IDHS1].[statsupdate_job_starttime],[IDHS1].[statsupdate_job_endtime]))
		,avg([IDHS1].[table_count])
		,avg([IDHS1].[statistic_count_total])
		,avg([IDHS1].[statistic_count_updated])
		,avg([IDHS1].[statsupdate_errors_count])
		,max([IDHS1].[statistic_count_total])
		,max([IDHS1].[statsupdate_errors_count])
		FROM [dbo].[vw_Statistics_Update_History_Summary] AS IDHS1
		WHERE [IDHS1].[statsupdate_job_date] BETWEEN @pEarliestDate and @pLatestDate 
		GROUP BY
		[server_name]
		,[database_name]
		
		SELECT
		 [server_name]
		,[database_name]
		,[total_statsupdate_job_count]
		,[database_not_accessible_count]
		,[database_accessible_count]
		,[statsupdate_performed_count]
		,[statsupdate_notperformed_count]
		,[max_update_date]
		,[min_update_date]
		,[statsupdate_job_average_duration]
		,[statsupdate_job_longest_duration]
		,[statsupdate_job_shortest_duration]
		,[average_table_count]
		,[average_stats_count]
		,[average_statsupdate_TotalCount]
		,[average_statsupdate_errors_count]
		,[max_statsupdate_TotalCount]
		,[max_statsupdate_errors_count]
		FROM @tIDSummary
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_LongestAvgDuration_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_LongestAvgDuration_ForDatabase] 
@pDatabaseName VARCHAR(128)
,@pEarliestDate DATETIME
,@pLatestDate DATETIME
AS
BEGIN

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
/* 
Author: Danny Howell
Description: Procedure provides summary statistic ranking tables by the most time to perform maintenance.  The summary and rankings is the accumulation of average times time spent per table.  As the S/U detail table records each statistic for each table, a table can appear multiple times per S/U job id because each table can have 1 to N number of statistics. This requires first accumulating statistics by table BY stats update job (which provides averages/sums by table across time).  Without performing this step first, counts are skewed up and averages are skewed down which results in inaccurate indicators. 
*/
		
		BEGIN TRANSACTION;

		DECLARE @RankedMaintDuration TABLE 
		(
		[server_name] VARCHAR(128)
		,[database_name] VARCHAR(128)
		,[schema_name] VARCHAR(128)
		,[table_name] VARCHAR(128)
		,[statssummary_job_id] INT
		,[stats_updated_count] INT
		,[avg_duration_seconds] BIGINT
		,[max_statupdate_endtime] datetime
		,[avg_table_row_count] BIGINT
		)

		INSERT INTO @RankedMaintDuration (
		[server_name]
		,[database_name]
		,[schema_name]
		,[table_name]
		,[statssummary_job_id]
		,[stats_updated_count]
		,[avg_duration_seconds]
		,[max_statupdate_endtime]
		,[avg_table_row_count]
		)
		SELECT 
		[IDS1].[server_name]
		,[IDS1].[database_name]
		,[IDD1].[schema_name]
		,[IDD1].[table_name]
		,[IDD1].[statssummary_job_id]
		,count([IDD1].[statistic_id])
		,SUM(datediff(MILLISECOND,[IDD1].[statsupdate_task_starttime],ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])))
		,MAX(ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime]))
		,round(avg(cast([table_row_count] as bigint)),0)
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDS1
		ON [IDD1].[statssummary_job_id] = [IDS1].[statssummary_job_id]
		WHERE [IDS1].[database_name] = @pDatabaseName
		AND [IDD1].[statsupdate_performed_ind] = 1
		AND [IDS1].[statsupdate_job_date] BETWEEN @pEarliestDate and @pLatestDate
		GROUP BY 
		[IDS1].[server_name]
		,[IDS1].[database_name]
		,[IDD1].[schema_name]
		,[IDD1].[table_name]
		,[IDD1].[statssummary_job_id]

		;WITH CTE_RunningTotals 
		AS
		(		
		SELECT
		DENSE_RANK () OVER (ORDER BY avg([TT1].avg_duration_seconds) DESC) as duration_ranking
		,DENSE_RANK () OVER (ORDER BY Count([TT1].[statssummary_job_id])  * avg(cast([TT1].[stats_updated_count] as numeric(5,1))) DESC) AS factored_stats_count_ranking
		,[TT1].[server_name]
		,[TT1].[database_name]
		,[TT1].[schema_name]
		,[TT1].[table_name]
		,datediff(day,max([TT1].[max_statupdate_endtime]),getdate()) as days_since_last_maintenance
		,avg([TT1].[avg_duration_seconds]) as avg_total_duration_table
		,max([IDHD3].[MRRowCount]) as max_row_count
		,COUNT([statssummary_job_id]) as number_of_defrag_jobs
		,cast(avg(cast([TT1].[stats_updated_count] as numeric(5,1))) as numeric(5,1)) as avg_number_of_indexes_defragmented
		from @RankedMaintDuration AS TT1
		LEFT OUTER JOIN
			(
			SELECT 
			[IDHS2].[server_name]
			,[IDHS2].[database_name]
			,[IDHD2].[table_name]
			,MAX([IDHD2].[table_row_count]) AS MRRowCount
			FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDHD2
			INNER JOIN (SELECT 
						[server_name]
						,[database_name]
						,MAX([statssummary_job_id]) as MRIDJobID
						FROM [dbo].[vw_Statistics_Update_History_Summary]
						GROUP BY 
						[server_name]
						,[database_name]) AS IDHS2
			ON [IDHD2].[statssummary_job_id] = [IDHS2].[MRIDJobID]
			GROUP BY 
			[IDHS2].[server_name]
			,[IDHS2].[database_name]
			,[IDHD2].[table_name]
			) AS IDHD3
		ON TT1.[server_name] = IDHD3.[server_name]
		AND [TT1].[database_name] = [IDHD3].[database_name]
		AND [TT1].[table_name] = [IDHD3].[table_name]
		group by 
		[TT1].[server_name]
		,[TT1].[database_name]
		,[TT1].[schema_name]
		,[TT1].[table_name]
		)

		select 
		[T1].[duration_ranking]
		,[T1].[factored_stats_count_ranking]
		,[T1].[server_name]
		,[T1].[database_name]
		,[T1].[schema_name]
		,[T1].[table_name]
		,[T1].[days_since_last_maintenance]
		,[T1].[avg_total_duration_table]
		,[T1].[max_row_count]
		,[T1].[number_of_defrag_jobs]
		,[T1].[avg_number_of_indexes_defragmented]
		,cast((t1.avg_total_duration_table/cast(rt2.runningtotal as numeric(15,2))) as numeric(5,4)) table_percent_of_total_duration
		,rt1.runningtot as duration_running_total
		from CTE_RunningTotals as t1
		cross apply (select sum(avg_total_duration_table) as runningtot
		from CTE_RunningTotals 
		where duration_ranking <= t1.duration_ranking
		) as rt1
		cross apply (select sum(avg_total_duration_table) as runningtotal
		from CTE_RunningTotals 
		) as rt2
		
		COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_MostRecent_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_MostRecent_ForDatabase] 
@pDatabaseName NVARCHAR(128)

AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Statistics Update (S/U) maintenance job history for tables in the selected databases. 
Report data used to view completion state of S/U for the most recent maintenance job.
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

	DECLARE @maxstatistics_job_id INT
	SELECT @maxstatistics_job_id = MAX([statssummary_job_id])
	FROM [dbo].[vw_Statistics_Update_History_Summary]
	WHERE [database_name] LIKE @pDatabaseName

	BEGIN TRANSACTION
	DECLARE @tIDSummary TABLE (
	[statssummary_job_id] [int] NOT NULL,
	[statsupdate_job_date] [datetime] NOT NULL,
	[statsupdate_process_completed_ind] [bit] NOT NULL,
	[statsupdate_performed_ind] [bit] NOT NULL,
	[executioninstanceGUID] [uniqueidentifier] NOT NULL,
	[initiating_job_scheduler_application_name] [varchar](30) NULL,
	[initiating_job_name] [varchar](128) NULL,
	[max_age_of_last_fullscan] [int] NOT NULL,
	[partial_scan_percentage_used] [int] NOT NULL,
	[full_scan_override] [bit] NOT NULL,
	[server_name] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[database_name] [varchar](128) NOT NULL,
	[database_accessible_ind] [bit] NOT NULL,
	[statsupdate_job_starttime] [datetime] NULL,
	[statsupdate_job_endtime] [datetime] NULL,
	[table_count] [int] NOT NULL,
	[statistic_count_total] [int] NOT NULL,
	[statistic_count_updated] [int] NOT NULL,
	[statsupdate_errors_count] [int] NOT NULL,
	[statsupdate_comments] [varchar](1000) NULL
	)

		INSERT INTO @tIDSummary
           (
		   [statssummary_job_id] 
		   ,[statsupdate_job_date]
           ,[statsupdate_process_completed_ind]
           ,[statsupdate_performed_ind]
           ,[executioninstanceGUID]
           ,[initiating_job_scheduler_application_name]
           ,[initiating_job_name]
           ,[max_age_of_last_fullscan]
           ,[partial_scan_percentage_used]
           ,[full_scan_override]
           ,[server_name]
           ,[database_id]
           ,[database_name]
           ,[database_accessible_ind]
           ,[statsupdate_job_starttime]
           ,[statsupdate_job_endtime]
           ,[table_count]
           ,[statistic_count_total]
           ,[statistic_count_updated]
           ,[statsupdate_errors_count]
           ,[statsupdate_comments])
		SELECT [statssummary_job_id]
			,[statsupdate_job_date]
			,[statsupdate_process_completed_ind]
			,[statsupdate_performed_ind]
			,[executioninstanceGUID]
			,[initiating_job_scheduler_application_name]
			,[initiating_job_name]
			,[max_age_of_last_fullscan]
			,[partial_scan_percentage_used]
			,[full_scan_override]
			,[server_name]
			,[database_id]
			,[database_name]
			,[database_accessible_ind]
			,[statsupdate_job_starttime]
			,CASE WHEN [statsupdate_job_endtime] IS NULL THEN [statsupdate_job_starttime] ELSE [statsupdate_job_endtime] END
			,[table_count]
			,[statistic_count_total]
			,[statistic_count_updated]
			,[statsupdate_errors_count]
			,[statsupdate_comments]
		FROM [dbo].[vw_Statistics_Update_History_Summary] AS T4
		WHERE [T4].[database_name] LIKE @pDatabaseName
		AND [T4].[statssummary_job_id] = @maxstatistics_job_id
		
		SELECT 
		[T4].[statssummary_job_id]
		,[T4].[executioninstanceGUID]
		,[T4].[initiating_job_scheduler_application_name]
		,[T4].[initiating_job_name]
		,[T4].[server_name]
		,[T4].[database_name]
		,cast([T4].[database_accessible_ind] as bit) as [database_accessible_ind]
		,cast([T4].[statsupdate_performed_ind] as bit) as [statsupdate_performed_ind]
		,convert(varchar(20), [T4].[statsupdate_job_date],100) as [statsupdate_job_date]
		,convert(varchar(20), [T4].[statsupdate_job_starttime],100) as statistics_job_starttime
		,convert(varchar(20), [T4].[statsupdate_job_endtime],100) as statistics_job_endtime
		,cast(datediff(MILLISECOND,[T4].[statsupdate_job_starttime],[T4].[statsupdate_job_endtime]) as numeric(15,2))/1000 as job_duration_seconds
		,CASE WHEN [T4].[statsupdate_errors_count] > 0 THEN 1 ELSE 0 END AS job_experience_errors
		,[T4].[table_count]
		,[T4].[statistic_count_total]
		,[T4].[statistic_count_updated]
		,[T4].[statsupdate_errors_count]
		,[T4].[statsupdate_comments]
		,[T4].[max_age_of_last_fullscan] as param_max_age_of_last_fullscan
		,[T4].[partial_scan_percentage_used] as param_partial_scan_percentage_used
		,cast([T4].[full_scan_override] as bit) as param_full_scan_override
		FROM @tIDSummary AS T4

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_MostRecent_ForServer]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_MostRecent_ForServer] 
AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Statistics Update (S/U) maintenance job history for all databases on the server. 
Report data used to view type of S/U performed and summary information for the most recent maintenance job.
By utilizing the master.sys.databases table in a LEFT OUTER JOIN relationship to the S/U history tables, procedure provides 
a results set for databases for which NO maintenance has been performed as well as those for which it was done.
As such, this procedure is useful in confirming any job parameter changes in case new databases are added after the initial SSIS environment creation.
*/

SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY

	BEGIN TRANSACTION
		DECLARE @tIDSummary TABLE (
		[statssummary_job_id] [int] NOT NULL,
		[statsupdate_job_date] [datetime] NOT NULL,
		[statsupdate_process_completed_ind] [bit] NOT NULL,
		[statsupdate_performed_ind] [bit] NOT NULL,
		[executioninstanceGUID] [uniqueidentifier] NOT NULL,
		[initiating_job_scheduler_application_name] [varchar](30) NULL,
		[initiating_job_name] [varchar](128) NULL,
		[max_age_of_last_fullscan] [int] NOT NULL,
		[partial_scan_percentage_used] [int] NOT NULL,
		[full_scan_override] [bit] NOT NULL,
		[server_name] [varchar](128) NOT NULL,
		[database_id] [int] NOT NULL,
		[database_name] [varchar](128) NOT NULL,
		[database_accessible_ind] [bit] NOT NULL,
		[statsupdate_job_starttime] [datetime] NULL,
		[statsupdate_job_endtime] [datetime] NULL,
		[table_count] [int] NOT NULL,
		[statistic_count_total] [int] NOT NULL,
		[statistic_count_updated] [int] NOT NULL,
		[statsupdate_errors_count] [int] NOT NULL,
		[statsupdate_comments] [varchar](1000) NULL)
		
			INSERT INTO @tIDSummary
           (
		   [statssummary_job_id] 
		   ,[statsupdate_job_date]
           ,[statsupdate_process_completed_ind]
           ,[statsupdate_performed_ind]
           ,[executioninstanceGUID]
           ,[initiating_job_scheduler_application_name]
           ,[initiating_job_name]
           ,[max_age_of_last_fullscan]
           ,[partial_scan_percentage_used]
           ,[full_scan_override]
           ,[server_name]
           ,[database_id]
           ,[database_name]
           ,[database_accessible_ind]
           ,[statsupdate_job_starttime]
           ,[statsupdate_job_endtime]
           ,[table_count]
           ,[statistic_count_total]
           ,[statistic_count_updated]
           ,[statsupdate_errors_count]
           ,[statsupdate_comments])
		SELECT 
			[T4].[statssummary_job_id]
			,[T4].[statsupdate_job_date]
			,[T4].[statsupdate_process_completed_ind]
			,[T4].[statsupdate_performed_ind]
			,[T4].[executioninstanceGUID]
			,[T4].[initiating_job_scheduler_application_name]
			,[T4].[initiating_job_name]
			,[T4].[max_age_of_last_fullscan]
			,[T4].[partial_scan_percentage_used]
			,[T4].[full_scan_override]
			,[T4].[server_name]
			,[T4].[database_id]
			,[T4].[database_name]
			,[T4].[database_accessible_ind]
			,[T4].[statsupdate_job_starttime]
			,CASE WHEN [T4].[statsupdate_job_endtime] IS NULL THEN [T4].[statsupdate_job_starttime] ELSE [T4].[statsupdate_job_endtime] END
			,[T4].[table_count]
			,[T4].[statistic_count_total]
			,[T4].[statistic_count_updated]
			,[T4].[statsupdate_errors_count]
			,[T4].[statsupdate_comments]
		FROM [dbo].[vw_Statistics_Update_History_Summary] AS T4
		INNER JOIN 
		(SELECT
		MAX([statssummary_job_id]) as MRJobID
		,[database_name]
		FROM [dbo].[vw_Statistics_Update_History_Summary]
		GROUP BY [database_name]) as T2
		ON [T4].[statssummary_job_id] = [T2].[MRJobID]
		AND [T4].[database_name] = [T2].database_name

		SELECT 
			[T4].[statssummary_job_id]
			,[T4].[executioninstanceGUID]
			,[T4].[initiating_job_scheduler_application_name]
			,[T4].[initiating_job_name]
			,ISNULL([T4].[server_name],cast(serverproperty('servername') as nvarchar(128))) as server_name
			,ISNULL([T4].[database_name],[t3].[name]) as database_name
			,cast(isnull([T4].[database_accessible_ind],0) as bit) as [database_accessible_ind]
			,cast(ISNULL([T4].[statsupdate_performed_ind],0) as bit) AS [statsupdate_performed_ind]
			,ISNULL(convert(varchar(20), [T4].[statsupdate_job_date],100),'No maintenance done') as [statsupdate_job_date]
			,ISNULL(convert(varchar(20), [T4].[statsupdate_job_starttime],100) ,'') as [statsupdate_job_starttime]
			,ISNULL(convert(varchar(20), [T4].[statsupdate_job_endtime],100) ,'') as [statsupdate_job_endtime]
			,cast(datediff(MILLISECOND,[T4].[statsupdate_job_starttime],[T4].[statsupdate_job_endtime]) as numeric(15,2))/1000 as job_duration_seconds
			,CASE WHEN [T4].[statsupdate_errors_count] > 0 THEN cast(1 as bit) ELSE cast(0 as bit) END AS job_experience_errors
			,[T3].[state_desc]
			,[T3].[user_access_desc]
			,[T4].[table_count]
			,[T4].[statistic_count_total]
			,[T4].[statistic_count_updated]
			,[T4].[statsupdate_errors_count]
			,cast(isnull([T4].[full_scan_override],0) as bit) as [param_full_scan_override]
			,[T4].[max_age_of_last_fullscan]
			,[T4].[partial_scan_percentage_used]
			,ISNULL([T4].[statsupdate_comments], 'No maintenance found for this database') as statsupdate_comments
			FROM [master].[sys].[databases] AS T3
		LEFT OUTER JOIN @tIDSummary AS T4
		ON [T3].[name] = [T4].[database_name]
		WHERE [T3].[name] NOT IN ('master','model','msdb','tempdb','distribution','ReportServer','ReportServerTempDB')
		AND [T3].[source_database_id] IS NULL

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_MostRecentDetail_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_MostRecentDetail_ForDatabase] 
@pDatabaseName NVARCHAR(128)
,@pShowStatsNoMaint BIT

AS
BEGIN
/*
Author: Danny Howell
Description: Procedure provides detailed Statistics Update (S/U) maintenance job history for tables in the selected databases. 
Report data used to view type of S/U performed for each statistic and table processed by the most recent maintenance job.
The default option excludes tables and statistic for which no maintenance was performed.  
The @pShowStatsNoMaint parameter sets the option to include tables not processed. 
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	DECLARE @ShowAllIndHigh BIT = 1
	DECLARE @ShowAllIndLow BIT = @ShowAllIndHigh
	IF @pShowStatsNoMaint = 1
		BEGIN
			SET @ShowAllIndLow = 0
		END
	BEGIN TRANSACTION
		DECLARE @tSUDetail TABLE (
		[statssummary_job_id] [int] NOT NULL,
		[database_id] [int] NOT NULL,
		[table_id] [bigint] NOT NULL,
		[statistic_id] [int] NOT NULL,
		[database_name] [varchar] (128) NOT NULL,
		[schema_name] [varchar](128) NOT NULL,
		[table_name] [varchar](128) NOT NULL,
		[statistic_name] [varchar](128) NOT NULL,
		[table_row_count] [bigint] NOT NULL,
		[modification_counter] [bigint] NOT NULL,
		[statsupdate_completed_ind] [bit] NOT NULL,
		[statsupdate_performed_ind] [bit] NOT NULL,
		[statsupdate_failed_ind] [bit] NULL,
		[statsupdate_fromindexdefrag] [bit] NULL,
		[statsupdate_scan_type_performed] [int] NOT NULL,
		[maintenance_duration_ms] [bigint] NULL,
		[statsupdate_task_starttime] [datetime] NULL,
		[statsupdate_task_endtime] [datetime] NULL,
		[auto_created] [bit] NULL,
		[user_created] [bit] NULL,
		[system_last_updated] [datetime] NULL,
		[rows_sampled] [bigint] NULL,
		[statistic_specific_comments] [varchar](1000) NULL
		)

	
		DECLARE @maxstatsummary_job_id INT
		SELECT @maxstatsummary_job_id = MAX([statssummary_job_id])
		FROM [dbo].[vw_Statistics_Update_History_Summary]
		WHERE [database_name] LIKE @pDatabaseName
		
		INSERT INTO @tSUDetail
		(
		[statssummary_job_id],
		[database_id],
		[table_id],
		[statistic_id],
		[database_name],
		[schema_name],
		[table_name],
		[statistic_name],
		[table_row_count],
		[modification_counter],
		[statsupdate_completed_ind],
		[statsupdate_performed_ind],
		[statsupdate_failed_ind],
		[statsupdate_fromindexdefrag],
		[statsupdate_scan_type_performed],
		[maintenance_duration_ms],
		[statsupdate_task_starttime],
		[statsupdate_task_endtime],
		[auto_created],
		[user_created],
		[system_last_updated],
		[rows_sampled],
		[statistic_specific_comments]
		)
		SELECT 
		[IDD1].[statssummary_job_id]
		,[IDD1].[database_id]
		,[IDD1].[table_id]
		,[IDD1].[statistic_id]
		,[IDS1].[database_name]
		,[IDD1].[schema_name]
		,[IDD1].[table_name]
		,[IDD1].[statistic_name]
		,[IDD1].[table_row_count]
		,[IDD1].[modification_counter]
		,[IDD1].[statsupdate_completed_ind]
		,[IDD1].[statsupdate_performed_ind]
		,CASE WHEN [IDD1].[statsupdate_task_endtime] IS NULL THEN CAST(1 AS BIT) ELSE [IDD1].[statsupdate_failed_ind] END
		,[IDD1].[statsupdate_fromindexdefrag]
		,CASE WHEN [IDD1].[statsupdate_scan_type_performed] = 0 THEN 0 WHEN [table_row_count] = [rows_sampled] THEN 3 ELSE 1 END
		,datediff(MILLISECOND,[IDD1].[statsupdate_task_starttime],ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])) as maintenance_duration_ms
		,[IDD1].[statsupdate_task_starttime]
		,ISNULL([IDD1].[statsupdate_task_endtime],[IDD1].[statsupdate_task_starttime])
		,[IDD1].[auto_created]
		,[IDD1].[user_created]
		,[IDD1].[system_last_updated]
		,[IDD1].[rows_sampled]
		,[IDD1].[statistic_specific_comments]
		FROM [dbo].[vw_Statistics_Update_History_Detail] AS IDD1
		INNER JOIN [dbo].[vw_Statistics_Update_History_Summary] AS IDS1
		ON [IDD1].[statssummary_job_id] = [IDS1].[statssummary_job_id]
		WHERE [IDS1].[statssummary_job_id] = @maxstatsummary_job_id
		AND [IDD1].[statsupdate_performed_ind]BETWEEN @ShowAllIndLow AND @ShowAllIndHigh
		
		SELECT 
		[statssummary_job_id],
		[database_id],
		[table_id],
		[statistic_id],
		[database_name],
		[schema_name],
		[table_name],
		[statistic_name],
		[table_row_count],
		CAST([rows_sampled] AS NUMERIC(15,3))/
		(CAST(CASE WHEN ISNULL([table_row_count],0) > 0 THEN [table_row_count] ELSE
			CASE WHEN ISNULL([rows_sampled],0) > 0 THEN [rows_sampled] ELSE 1 END 
			END AS numeric(15,2))) as [percentage_used],
		[modification_counter] AS [modification_counter],
		(CAST([modification_counter] AS NUMERIC(18,3)) / 
			CAST(CASE WHEN ISNULL([table_row_count],0) > 0 THEN [table_row_count] ELSE
			CASE WHEN ISNULL([modification_counter],0) > 0 THEN [modification_counter] ELSE 1 END 
			END AS numeric(15,2))) as [percentage_modified],
		CAST([statsupdate_completed_ind] AS BIT) AS [statsupdate_completed_ind],
		CAST([statsupdate_performed_ind] AS BIT) AS [statsupdate_performed_ind],
		CAST([statsupdate_failed_ind] AS BIT) AS [statsupdate_failed_ind],
		CAST([statsupdate_fromindexdefrag] AS BIT) AS [statsupdate_fromindexdefrag],
		[statsupdate_scan_type_performed],
		CASE [statsupdate_scan_type_performed] 
			WHEN 0 THEN 'None'
			WHEN 1 THEN 'Percent'
			WHEN 2 THEN 'Rows'
			WHEN 3 THEN 'Full Scan'
			WHEN 4 THEN 'Resample'
			WHEN 5 THEN 'Percent'
			ELSE 'Unknown' END as [scan_type_performed],
		CAST([maintenance_duration_ms]/1000 AS NUMERIC(15,3)) AS duration_seconds,
		CONVERT(VARCHAR(20),[statsupdate_task_starttime],100) AS [statsupdate_task_starttime],
		[statistic_specific_comments]
		FROM @tSUDetail


	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF




	END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Maintenance_SU_Summary_ForDatabase]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_DataSet_Maintenance_SU_Summary_ForDatabase] 
@pDatabaseName NVARCHAR(128)
,@pLatestDate DATETIME
,@pEarliestDate DATETIME
AS
BEGIN
/*
Author: Danny Howell
Description: 
Procedure provides summary Statistics Update (S/U) maintenance job information for the indicated database for all jobs within the selected date range. 
Report data used to view S/U job facts along with total tables and statistics processed along with error counts as well as the threshold and job parameters used for the most recent job execution.  
*/
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @tIDSummary TABLE (
		[statssummary_job_id] [int] NOT NULL,
		[statsupdate_job_date] [datetime] NOT NULL,
		[statsupdate_process_completed_ind] [bit] NOT NULL,
		[statsupdate_performed_ind] [bit] NOT NULL,
		[executioninstanceGUID] [uniqueidentifier] NOT NULL,
		[initiating_job_scheduler_application_name] [varchar](30) NULL,
		[initiating_job_name] [varchar](128) NULL,
		[max_age_of_last_fullscan] [int] NOT NULL,
		[partial_scan_percentage_used] [int] NOT NULL,
		[full_scan_override] [bit] NOT NULL,
		[server_name] [varchar](128) NOT NULL,
		[database_id] [int] NOT NULL,
		[database_name] [varchar](128) NOT NULL,
		[database_accessible_ind] [bit] NOT NULL,
		[statsupdate_job_starttime] [datetime] NULL,
		[statsupdate_job_endtime] [datetime] NULL,
		[table_count] [int] NOT NULL,
		[statistic_count_total] [int] NOT NULL,
		[statistic_count_updated] [int] NOT NULL,
		[statsupdate_errors_count] [int] NOT NULL,
		[statsupdate_comments] [varchar](1000) NULL)

			INSERT INTO @tIDSummary
				(
				[statssummary_job_id],
				[statsupdate_job_date],
				[statsupdate_process_completed_ind],
				[statsupdate_performed_ind],
				[executioninstanceGUID],
				[initiating_job_scheduler_application_name],
				[initiating_job_name],
				[max_age_of_last_fullscan],
				[partial_scan_percentage_used],
				[full_scan_override],
				[server_name],
				[database_id],
				[database_name],
				[database_accessible_ind],
				[statsupdate_job_starttime],
				[statsupdate_job_endtime],
				[table_count],
				[statistic_count_total],
				[statistic_count_updated],
				[statsupdate_errors_count],
				[statsupdate_comments])
			SELECT 
				[statssummary_job_id],
				[statsupdate_job_date],
				[statsupdate_process_completed_ind],
				[statsupdate_performed_ind],
				[executioninstanceGUID],
				[initiating_job_scheduler_application_name],
				[initiating_job_name],
				[max_age_of_last_fullscan],
				[partial_scan_percentage_used],
				[full_scan_override],
				[server_name],
				[database_id],
				[database_name],
				[database_accessible_ind],
				[statsupdate_job_starttime],
				[statsupdate_job_endtime],
				[table_count],
				[statistic_count_total],
				[statistic_count_updated],
				[statsupdate_errors_count],
				[statsupdate_comments]
			FROM [dbo].[vw_Statistics_Update_History_Summary] AS T4
			WHERE [T4].[database_name] LIKE @pDatabaseName
			AND [T4].[statsupdate_job_date] BETWEEN @pEarliestDate AND @pLatestDate
	
			SELECT 
			[T4].[statssummary_job_id]
			,[T4].[executioninstanceGUID]
			,[T4].[initiating_job_scheduler_application_name]
			,[T4].[initiating_job_name]
			,[T4].[server_name]
			,[T4].[database_name]
			,cast([T4].[database_accessible_ind] as bit) as [database_accessible_ind]
			,cast([T4].[statsupdate_performed_ind] as bit) as [statsupdate_performed_ind]
			,convert(varchar(20), [T4].[statsupdate_job_date],100) as [statsupdate_job_date]
			,convert(varchar(20), [T4].[statsupdate_job_starttime],100) as [statsupdate_job_starttime]
			,convert(varchar(20), [T4].[statsupdate_job_endtime],100) as [statsupdate_job_endtime]
			,cast(datediff(MILLISECOND,[T4].[statsupdate_job_starttime],[T4].[statsupdate_job_endtime]) as numeric(15,2))/1000 as job_duration_seconds
			,CASE WHEN [T4].[statsupdate_errors_count] > 0 THEN cast(1 as bit) ELSE cast(0 as bit) END AS job_experience_errors
			,[T4].[table_count]
			,[T4].[statistic_count_total]
			,[T4].[statistic_count_updated]
			,[T4].[statsupdate_errors_count]
			,cast([T4].[full_scan_override] as bit) as param_full_scan_override
			,[T4].[partial_scan_percentage_used] as param_partial_scan_percentage_used
			,[T4].[max_age_of_last_fullscan] as param_max_age_of_last_fullscan
			,[T4].[statsupdate_comments]
			FROM @tIDSummary AS T4

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Servers_By_Application]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Servers_By_Application] 
(@pApplicationIDs VARCHAR(8000)
,@pIncludeNonProdInd BIT
)

AS 

BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

	BEGIN TRY
		DECLARE @pIncludeDatabaseNoLongerUsedInd BIT = 0
		DECLARE @pIncludeDeletedCopiesOfCurrentDBsInd BIT = 0
		DECLARE @ProductionIndHigh BIT = 1
		DECLARE @ProductionIndLow BIT = @ProductionIndHigh
		IF @pIncludeNonProdInd = 1
		BEGIN
			SET @ProductionIndLow = 0
		END
		BEGIN TRANSACTION
			--if null value is passed then default to all  applications
			DECLARE @T2 TABLE 
			([ServerInstanceId] INT
			,[DatabaseURN] NVARCHAR(256)
			,[ApplicationID] VARCHAR(4000)
			,[UserDatabaseCount] INT)

			INSERT INTO @T2
			EXECUTE [rpt].[usp_DataSet_Databases_By_Application2] 
			@pApplicationIDs
			,@pIncludeDatabaseNoLongerUsedInd
			,@pIncludeDeletedCopiesOfCurrentDBsInd

			-- Begin Return Select of record
			SELECT 
			[BC1].[BusinessCategoryDesc]
			,[SHS1].[ServerSystemID]
			,[SHS1].[HostName]
			,[SHS1].[ProductionInd]
			,[S1].[InstanceName]
			,CAST(CASE WHEN [S1].[RetiredInd] = 1 THEN 1 ELSE
			CASE WHEN [S1].[RetiredInd] = 0 THEN [SHS1].[RetiredInd] ELSE 0 END
			END AS BIT) AS RetiredInstance
			,[SHS1].[InKFBDOM1Domain]
			,[SHS1].[OSCaption]
			,[SHS1].[UsageScope]
      		,[SHS1].[PrimaryDataProcessModelType]
			,ISNULL([SHS1].[PrimaryApplicationUsedFor],'Unknown') AS [PrimaryApplicationUsedFor]
			,ISNULL([SHS1].[LocalHostDescription],'Not Available') AS [LocalHostDescription]
			,CONVERT(VARCHAR(15),[SHS1].[LatestReportedDate],101) AS LatestReportedDate
			,[SIVP1].[SQLVersionMajor]
			,[SIVP1].[SQLVersionMinor]
			,[SIVP1].[SQLBuildNumber]
			,[SIVP1].[SQLVersionDescription]
			,[SQLProductLevel]
			,ISNULL([DBC1].[ApplicationID],-1) AS ApplicationID		
			,ISNULL([DBC1].[ApplicationName],'Unknown-Deleted') as ApplicationName
			,ISNULL([DBC1].[UserDatabaseCount],0) AS UserDBCount
			FROM [dbo].[vw_ServerInstances] AS S1
			INNER JOIN [dbo].[vw_Servers] AS SHS1
			ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
			LEFT OUTER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
			ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
			LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC1
			ON [SHS1].[BusinessCategoryID] = [BC1].[BusinessCategoryID]
			INNER JOIN 
			(
			SELECT
			[T2].[ServerInstanceId]
			,[T2].[ApplicationID]
			--,[T2].[DatabaseURN]
			,[BA1].[ApplicationName]
			,sum([T2].[UserDatabaseCount]) AS UserDatabaseCount
				FROM @T2 AS T2
			INNER JOIN [dbo].[Applications] AS BA1
			ON T2.ApplicationID = BA1.ApplicationId
			GROUP BY 
			[T2].[ServerInstanceId]
			,[T2].[ApplicationID]		
			,[BA1].[ApplicationName]
			) AS DBC1
			ON [S1].[ServerInstanceID] = [DBC1].[ServerInstanceId]
			WHERE 
			[SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
			AND [SHS1].[RetiredInd] = 0
			
		
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Servers_By_BusinessUnitCategory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Servers_By_BusinessUnitCategory]
(@pBusinessCategoryIDs VARCHAR(8000)
,@pIncludeNonProdInd BIT
)

AS 

BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  
-- 
	BEGIN TRY
		DECLARE @ProductionIndHigh BIT = 1
		DECLARE @ProductionIndLow BIT = @ProductionIndHigh
		IF @pIncludeNonProdInd = 1
		BEGIN
			SET @ProductionIndLow = 0
		END

		--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
		--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
		DECLARE @BusinessCategoryIDs TABLE (pBusinessCategroyID INT)
		IF @pBusinessCategoryIDs IS NULL OR CHARINDEX('-1',@pBusinessCategoryIDs,0) > 0
		BEGIN
		INSERT INTO @BusinessCategoryIDs
		SELECT DISTINCT [BusinessCategoryID]
		FROM [dbo].[vw_BusinessCategories]
		
		END
		ELSE
		BEGIN
		--use custom function to split input string into a table of integers
		INSERT INTO @BusinessCategoryIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pBusinessCategoryIDs ,',')
		END
		
		BEGIN TRANSACTION
			--if null value is passed then default to all  applications
			DECLARE @T2 TABLE 
			(
			[ServerInstanceId] INT
			,[UserDatabaseCount] INT)
			INSERT INTO @T2
			SELECT 
			[DA1].[ServerInstanceID]
			,COUNT([DA1].[DatabaseUniqueId]) AS UserDatabaseCount
			FROM [dbo].[vw_DatabaseApplications] AS DA1
			GROUP BY 
			[DA1].[ServerInstanceID]
			
			-- Begin Return Select of record
			SELECT 
			[BC1].[BusinessCategoryDesc]
			,[SHS1].[ServerSystemID]
			,[SHS1].[HostName]
			,[SHS1].[ProductionInd]
			,[S1].[InstanceName]
			,CAST(CASE WHEN [S1].[RetiredInd] = 1 THEN 1 ELSE
			CASE WHEN [S1].[RetiredInd] = 0 THEN [SHS1].[RetiredInd] ELSE 0 END
			END AS BIT) AS RetiredInstance
			,[SHS1].[InKFBDOM1Domain]
			,[SHS1].[OSCaption]
			,[SHS1].[UsageScope]
      		,[SHS1].[PrimaryDataProcessModelType]
			,ISNULL([SHS1].[PrimaryApplicationUsedFor],'Unknown') AS [PrimaryApplicationUsedFor]
			,ISNULL([SHS1].[LocalHostDescription],'Not Available') AS [LocalHostDescription]
			,CONVERT(VARCHAR(15),[SHS1].[LatestReportedDate],101) AS LatestReportedDate
			,[SIVP1].[SQLVersionMajor]
			,[SIVP1].[SQLVersionMinor]
			,[SIVP1].[SQLBuildNumber]
			,[SIVP1].[SQLVersionDescription]
			,[SQLProductLevel]
			,[T2].[UserDatabaseCount]
			FROM [dbo].[vw_ServerInstances] AS S1
			INNER JOIN [dbo].[vw_Servers] AS SHS1
			ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
			LEFT OUTER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
			ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
			LEFT OUTER JOIN [dbo].[vw_BusinessCategories] AS BC1
			ON [SHS1].[BusinessCategoryID] = [BC1].[BusinessCategoryID]
			INNER JOIN @BusinessCategoryIDs AS BC2
			ON [SHS1].[BusinessCategoryID] = [BC2].[pBusinessCategroyID]
			LEFT OUTER JOIN @T2 AS T2
			ON [S1].[ServerInstanceID] = [T2].[ServerInstanceId]
			WHERE 
			[SHS1].[ProductionInd] BETWEEN @ProductionIndLow AND @ProductionIndHigh
			AND 
			CAST(CASE WHEN [S1].[RetiredInd] = 1 THEN 1 ELSE
			CASE WHEN [S1].[RetiredInd] = 0 THEN [SHS1].[RetiredInd] ELSE 0 END
			END AS BIT) = 0
			
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Servers_By_SystemName]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
Procedure created to provide a general dataset of SQL systems with minimal filtering/parameterization using a LOW/HIGH method combined with BETWEEN equations for getting servers with a single server filtered by setting the low and high values to the same value. If the procedure parameter for the server Host Name is null, then this procedure returns all servers. The optional parameter to include retired servers is a secondary data filter.
While the procedure inpu parameter name is ServerSystemName this equates to the HostName field in the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Servers_By_SystemName] 
(@pServerSystemName NVARCHAR(128)
,@pIncludeRetiredInd BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set values to obtain all
BEGIN TRY
	DECLARE @pRetiredIndLow BIT = 0
	DECLARE @pRetiredIndHigh BIT = 0 
	--If NULL value passed for ServerSystemName, get all ServerSystemIDs
	IF @pServerSystemName IS NULL
	BEGIN
		SET @pServerSystemName = '%'
	END
	--The default variable value is set to exclude retired servers but if the parameter indicates to include retired servers, override to include where RetiredInd is true (value=1)
	IF @pIncludeRetiredInd = 1
	BEGIN
		SET @pRetiredIndHigh = 1
	END
		
	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
			[SHS].[ServerSystemID],
			[SHS].[HostName],
			CONVERT(NVARCHAR(15),[SHS].[LatestReportedDate],101) AS [LatestReportedDate],
			CONVERT(NVARCHAR(15),[SHS].[DateAdded],101) AS DateAdded,
			[SHS].[InKFBDOM1Domain],
			[SHS].[RetiredInd],
			[SHS].[ReplacedByHost],
			[SHS].[ProductionInd],
			[SHS].[BusinessCategoryID],
			[SBC].[BusinessCategoryDesc],
			[SHS].[UsageScope],
      		[SHS].[PrimaryDataProcessModelType],
			[SHS].[PrimaryApplicationUsedFor],
			[SHS].[LocalHostDescription],
			[SHS].[ManagedBySQLDBAsInd],
			[SHS].[MonitoredbySQLToolsInd],
			[SHS].[ExcludeFromETLProcessesInd],
			[SHS].[ExcludeFromWMIDataLoadInd],
			[SHS].[OSManufacturer],
			[SHS].[OSName],
			[SHS].[OSVersion],
			[SHS].[OSEdition],
			[SHS].[OSRelease],
			[SHS].[OSCaption]
		FROM [dbo].[vw_Servers] AS SHS
		LEFT OUTER JOIN [dbo].vw_BusinessCategories as SBC
		ON [SHS].[BusinessCategoryID] = [SBC].[BusinessCategoryID]
		WHERE [SHS].[HostName] LIKE @pServerSystemName
		AND [SHS].[RetiredInd] BETWEEN @pRetiredIndLow AND @pRetiredIndHigh
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_Servers_InstanceUpdateCompliance]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
Procedure created to provide a general dataset of SQL systems with minimal filtering/parameterization using a LOW/HIGH method combined with BETWEEN equations for getting servers with a single server filtered by setting the low and high values to the same value. If the procedure parameter for the server Host Name is null, then this procedure returns all servers. The optional parameter to include retired servers is a secondary data filter.
While the procedure inpu parameter name is ServerSystemName this equates to the HostName field in the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_Servers_InstanceUpdateCompliance] 
(@pServerSystemName NVARCHAR(128)
,@pIncludeUpdateCompliant BIT
)

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set values to obtain all
BEGIN TRY
	DECLARE @pComplianceIndLow BIT = 0
	DECLARE @pComplianceIndHigh BIT = 0 
	--If NULL value passed for ServerSystemName, get all ServerSystemIDs
	IF @pServerSystemName IS NULL
	BEGIN
		SET @pServerSystemName = '%'
	END
	--The default variable value is set to exclude retired servers but if the parameter indicates to include retired servers, override to include where RetiredInd is true (value=1)
	IF @pIncludeUpdateCompliant = 1
	BEGIN
		SET @pComplianceIndHigh = 1
	END
		
	BEGIN TRAN
		-- Begin Return Select of record
		SELECT 
			[SHS].[ServerSystemID],
			[SHS].[HostName],
			CONVERT(NVARCHAR(15),[SHS].[LatestReportedDate],101) AS [LatestReportedDate],
			CONVERT(NVARCHAR(15),[SHS].[DateAdded],101) AS DateAdded,
			[SHS].[InKFBDOM1Domain],
			[SHS].[RetiredInd],
			[SHS].[ProductionInd],
			[SHS].[BusinessCategoryID],
			[SBC].[BusinessCategoryDesc],
			[SHS].[UsageScope],
			[SI1].[InstanceName],
			[SI1].[SQLFullVersion],
			[SI1].[SPorCUCompliant],
			[SI1].[InterimUpdateCompliant],
      		[SHS].[PrimaryDataProcessModelType],
			[SHS].[PrimaryApplicationUsedFor],
			[SHS].[LocalHostDescription],
			[SHS].[ManagedBySQLDBAsInd],
			[SHS].[MonitoredbySQLToolsInd],
			[SHS].[ExcludeFromETLProcessesInd],
			[SHS].[ExcludeFromWMIDataLoadInd],
			[SHS].[OSManufacturer],
			[SHS].[OSName],
			[SHS].[OSVersion],
			[SHS].[OSEdition],
			[SHS].[OSRelease],
			[SHS].[OSCaption]
		FROM [dbo].[vw_Servers] AS SHS
		LEFT OUTER JOIN [dbo].vw_BusinessCategories as SBC
		ON [SHS].[BusinessCategoryID] = [SBC].[BusinessCategoryID]
		LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SI1
		ON [SHS].[ServerSystemID] = [SI1].[ServerSystemID]
		WHERE [SHS].[HostName] LIKE @pServerSystemName
		AND [SHS].[RetiredInd] = 0
		AND (([SI1].[SPorCUCompliant]  BETWEEN @pComplianceIndLow AND @pComplianceIndHigh) OR
		([SI1].[InterimUpdateCompliant]  BETWEEN @pComplianceIndLow AND @pComplianceIndHigh))

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_SystemCounts_By_BusinessCategory]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling needed for NULL values or non-existent Application IDs as the application id parameter is built solely from the parameter using values confirmed to exist (there should never be a condition where the input string contains an integer that does not match an application id in the  applications table)
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.
Procedure supplies counts of active servers (SQL Instances) and databases grouped by business category.
***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_SystemCounts_By_BusinessCategory] 

AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	BEGIN TRAN
-- Begin Return Select of record
	DECLARE @T1 TABLE (
	BusinessCategoryID INT NOT NULL,
	BusinessCategoryDesc VARCHAR(128) NOT NULL,
	ProductionInd BIT NULL,
	DatabaseCount INT NULL,
	ServerCount INT NULL)


	INSERT INTO @T1 (
	BusinessCategoryID,
	BusinessCategoryDesc,
	ProductionInd,
	DatabaseCount,
	ServerCount
	)
	SELECT [BusinessCategoryID]
    ,[BusinessCategoryDesc]
	,1
	,0
	,0
    FROM [dbo].[vw_BusinessCategories]
	UNION
	SELECT [BusinessCategoryID]
    ,[BusinessCategoryDesc]
	,0
	,0
	,0
    FROM [dbo].[vw_BusinessCategories]

	UPDATE @T1
	SET [DatabaseCount] = [DB2].[ObjectCount]
	FROM @T1 AS T2
	INNER JOIN
	(
	SELECT 
	[DBapp1].BusinessCategoryID
	,[SHS1].[ProductionInd]
	,COUNT([DB1].[DatabaseUniqueId]) AS ObjectCount
	FROM [dbo].[vw_Databases] AS DB1
	INNER JOIN [dbo].[vw_DatabaseApplications] AS DBApp1
	ON DB1.DatabaseUniqueId = DBApp1.DatabaseUniqueId
	LEFT OUTER JOIN [dbo].[vw_ServerInstances] AS S1
	ON [DB1].[ServerInstanceID] = [S1].[ServerInstanceID]
	INNER JOIN [dbo].[vw_Servers] AS SHS1
	ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
	WHERE 
	[DB1].[DeletedInd] = 0
	GROUP BY 
	[DBapp1].BusinessCategoryID
	,[DBApp1].[BusinessCategoryDesc]
	,[SHS1].[ProductionInd]) AS DB2
	ON T2.BusinessCategoryID = DB2.BusinessCategoryID
	AND T2.ProductionInd = DB2.ProductionInd

	UPDATE @T1
	SET [ServerCount] = [SI1].[ObjectCount]
	FROM @T1 AS T2
	INNER JOIN
	(
	SELECT 
	[BC1].BusinessCategoryID
	,[SHS1].[ProductionInd]
	,COUNT([S1].[ServerInstanceID]) AS ObjectCount
	FROM [dbo].[vw_ServerInstances] AS S1
	INNER JOIN [dbo].[vw_Servers] AS SHS1
	ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
	INNER JOIN [dbo].[vw_BusinessCategories] AS BC1
	ON [SHS1].[BusinessCategoryID] = [BC1].[BusinessCategoryID]
	WHERE 
	[SHS1].[RetiredInd] = 0 AND [S1].[RetiredInd] = 0
	GROUP BY 
	[BC1].BusinessCategoryID
	,[SHS1].[ProductionInd]) AS SI1
	ON T2.BusinessCategoryID = [SI1].[BusinessCategoryID]
	AND T2.ProductionInd = [SI1].[ProductionInd]

	SELECT
	BusinessCategoryID,
	BusinessCategoryDesc,
	CASE ProductionInd WHEN 1 THEN 'Production' ELSE 'Non-Production' END AS ProductionInd,
	DatabaseCount,
	ServerCount
	FROM @T1

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_DataSet_SystemCounts_By_Environment]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for a SQL Reporting Services report.
As this procedure is custom written for use in reporting only, then it can be assumed that the procedure input parameters are controlled by the report's functionality and parameter control.  Therefore there is no testing or error handling 
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
No logical error handling provided in the procedure other than to return information that the provided server system name does not exist and to provide a valid server name.

***************************************************/
CREATE PROCEDURE [rpt].[usp_DataSet_SystemCounts_By_Environment] 
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

BEGIN TRY
	BEGIN TRAN
	
	DECLARE @T1 TABLE (
	[SQLMajorMinorVersion] FLOAT NOT NULL,
	[SQLVersionDescription] VARCHAR(128) NOT NULL,
	[ProductionInd] BIT NULL,
	[DatabaseCount] INT NULL,
	[ServerCount] INT NULL)


	INSERT INTO @T1 (
	[SQLMajorMinorVersion],
	[SQLVersionDescription],
	[ProductionInd],
	[DatabaseCount],
	[ServerCount]
	)
	SELECT DISTINCT
	[SIVP1].[SQLMajorMinorVersion]
    ,REPLACE([SIVP1].[SQLVersionDescription],'SQL Server ','') AS [SQLVersionDescription]
	,1
	,0
	,0
    FROM [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
	UNION
	SELECT DISTINCT
	[SIVP1].[SQLMajorMinorVersion]
    ,REPLACE([SIVP1].[SQLVersionDescription],'SQL Server ','') AS [SQLVersionDescription]
	,0
	,0
	,0
    FROM [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
	
	-- Begin Return Select of record
	UPDATE @T1
	SET [DatabaseCount] = [T3].[DatabaseCount]
	FROM @T1 AS T2
	INNER JOIN 
	(SELECT 
		[SIVP1].[SQLMajorMinorVersion]
		,[SHS1].[ProductionInd]
		,Count([DB1].[DatabaseUniqueId]) AS DatabaseCount
		FROM [dbo].[vw_Databases] AS DB1
		LEFT OUTER JOIN [dbo].[vw_ServerInstances] AS S1
		ON [DB1].[ServerInstanceID] = [S1].[ServerInstanceID]
		INNER JOIN [dbo].[vw_Servers] AS SHS1
		ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
		INNER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
		ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
		WHERE [DB1].[LatestReportedDate] is null
		AND [DB1].[DeletedInd] = 0
		AND [DB1].[SystemObjectInd] = 0
		group by 
		[SIVP1].[SQLMajorMinorVersion]
		,[SIVP1].[SQLVersionDescription]
		,[SHS1].[ProductionInd]) AS T3
	ON [T2].[SQLMajorMinorVersion] = [T3].[SQLMajorMinorVersion]
	AND [T2].[ProductionInd] = [T3].[ProductionInd]

	UPDATE @T1
	SET [ServerCount] = [T3].[ServerCount]
	FROM @T1 AS T2
	INNER JOIN 
		(SELECT 
		[SIVP1].[SQLMajorMinorVersion]
		,[SHS1].[ProductionInd]
		,Count([S1].[ServerInstanceID]) AS ServerCount
		FROM [dbo].[vw_ServerInstances] AS S1
		INNER JOIN [dbo].[vw_Servers] AS SHS1
		ON [S1].[ServerSystemID] = [SHS1].[ServerSystemID]
		INNER JOIN [dbo].[vw_ServerInstance_VersionProperties] AS SIVP1
		ON [S1].[ServerInstanceID] = [SIVP1].[ServerInstanceID]
		WHERE [SHS1].[RetiredInd] = 0 AND [S1].[RetiredInd] = 0
		group by 
		[SIVP1].[SQLMajorMinorVersion]
		,[SIVP1].[SQLVersionDescription]
		,[SHS1].[ProductionInd]) AS T3
	ON [T2].[SQLMajorMinorVersion] = [T3].[SQLMajorMinorVersion]
	AND [T2].[ProductionInd] = [T3].[ProductionInd]


		SELECT 
		[SQLVersionDescription] 
		,CASE [ProductionInd] WHEN 1 THEN 'Production' ELSE 'Non-Production' END AS Environment
		,[DatabaseCount]
		,[ServerCount]
		FROM @T1
		ORDER BY 
		[SQLVersionDescription] 
		,[ProductionInd] DESC
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [rpt].[usp_dim_datetime_populate]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/* 
 * PROCEDURE: [usp_dim_datetime_populate] 
 */


/*
AUTHOR: Tara Cook/Danny Howell (sourced from Internet search)
DESCRIPTION: Stored procedure populates the dim_datetime table for dimensional reporting by looping through every day between the input date range parameters.  Federal, bank and KFB holidays are determined by creating a 'holiday' table which is used to update the dim_datetime table.  The unique/PK of the table is the integer YYYYMMDD.


*/

CREATE PROCEDURE [rpt].[usp_dim_datetime_populate]
     @starting_dt DATE
     , @ending_dt DATE
     , @FiscalYearMonthsOffset int
AS
BEGIN
delete from [rpt].dim_datetime
where DateTimeDimKey > 0

SET NOCOUNT ON
SET DATEFIRST 7     -- Standard for U.S. Week starts on Sunday

--No ETL process loads but need values for NOT NULL columns
DECLARE @ETLUpdateTmstmp DATETIME = GETDATE()
DECLARE @ETLCurrentRecordInd CHAR(1) = 'Y'
DECLARE @UserID CHAR(8) = 'SQLSPROC'
DECLARE @ETLSourceSystemCD CHAR(2) = 'DB'
DECLARE @ETLLastActionCD CHAR(1) = 'I'
DECLARE @ETLSourceSystemID int = 0

-- Standard Holidays
     -- New Years Day - Jan 1
     -- MLK Day - 3rd Monday in Jan
     -- Presidents Day - 3rd Monday in Feb
     -- Memorial Day - Last Mon in May
     -- Independence Day - Jul 4
     -- Labor Day - 1st Mon in Sep
     -- Columbus Day - 2nd Mon in Oct
     -- Veterans Day - Nov 11
     -- Thanksgiving Day - 4th Thurs in Nov
     -- Day after Thanksgiving - Day after 4th Thurs in Nov
     -- Christmas Eve - Dec 24
     -- Christmas Day - Dec 25
     
DECLARE @HolidayTable TABLE (HolidayKey int NOT NULL PRIMARY KEY
     , HolidayDate DATE NOT NULL
     , HolidayName varchar(50) NOT NULL
     , FedHolidayInd bit NOT NULL DEFAULT(0)
     , BankHolidayInd bit NOT NULL DEFAULT(0)
     , KFBHolidayInd bit NOT NULL DEFAULT(0)
     )

DECLARE @Yr int
     , @EndYr int
     , @Offset int
     , @WeekNumberInMonth int
     , @Jan1 DATE
     , @Feb1 DATE
     , @May1 DATE
     , @Sep1 DATE
     , @Oct1 DATE
     , @Nov1 DATE
     , @MemorialDay DATE
     , @ThanksgivingDay DATE
SET @Yr = DATEPART(yyyy, @starting_dt)
SET @EndYr = DATEPART(yyyy, @ending_dt)

WHILE @Yr <= @EndYr
BEGIN
IF @Yr > 1985
BEGIN
     SET @Jan1 = CAST(CAST(@Yr AS char(4)) + '0101' AS DATE)
     SET @Feb1 = CAST(CAST(@Yr AS char(4)) + '0201' AS DATE)
     SET @May1 = CAST(CAST(@Yr AS char(4)) + '0501' AS DATE)
     SET @Sep1 = CAST(CAST(@Yr AS char(4)) + '0901' AS DATE)
     SET @Oct1 = CAST(CAST(@Yr AS char(4)) + '1001' AS DATE)
     SET @Nov1 = CAST(CAST(@Yr AS char(4)) + '1101' AS DATE)

     -- New Years Day logic
     -- Could be celebrated on New Years Day, the Friday before, or the Monday after
     -- depending on whether the day falls on a weekend or not and the value of @FiscalYearMonthsOffset
     IF (DATEPART(dw, @Jan1) > 1) AND (DATEPART(dw, @Jan1) < 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '0101' as int)
                    , CAST(CAST(@Yr AS char(4)) + '0101' AS DATE)
                    , 'New Year''s Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, @Jan1) = 1)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '0102' as int)
                    , CAST(CAST(@Yr AS char(4)) + '0102' AS DATE)
                    , 'New Year''s Day'
		          , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, @Jan1) = 7)
     BEGIN
          -- For most banks, the fiscal year ends 12-31 and New Year's Day is celebrated in the New Year.
          IF @FiscalYearMonthsOffset = 0
          BEGIN
               -- When an organization's fiscal year ends on 12-31, and New Years falls on Saturday, New Years is observed on the following Monday.
               INSERT INTO @HolidayTable
                    SELECT CAST(CAST(@Yr - 1 AS char(4)) + '1231' as int)
                         , CAST(CAST(@Yr - 1 AS char(4)) + '1231' AS DATE)
                         , 'New Year''s Day'
                         ,1 -- 'Y'          -- FedHolidayInd
                         , 0	--'N'          -- BankHolidayInd
                         , 0	--'N'          -- KFBHolidayInd
               INSERT INTO @HolidayTable
                    SELECT CAST(CAST(@Yr AS char(4)) + '0103' as int)
                         , CAST(CAST(@Yr AS char(4)) + '0103' AS DATE)
                         , 'New Year''s Day'
                         , 0	--'N'          -- FedHolidayInd
                         , 1	--'Y'          -- BankHolidayInd
                         , 1	--'Y'          -- KFBHolidayInd
          END
          ELSE
          BEGIN
               -- When an organization's fiscal year ends on a day other than 12-31, and New Years falls on Saturday, New Years is observed on the previous Friday.
               INSERT INTO @HolidayTable
                    SELECT CAST(CAST(@Yr - 1 AS char(4)) + '1231' as int)
                         , CAST(CAST(@Yr - 1 AS char(4)) + '1231' AS DATE)
                         , 'New Year''s Day'
                         , 1	--'Y'          -- FedHolidayInd
                         , 0	--'N'          -- BankHolidayInd
                         , 1	--'Y'          -- KFBHolidayInd
               INSERT INTO @HolidayTable
                    SELECT CAST(CAST(@Yr AS char(4)) + '0103' as int)
                         , CAST(CAST(@Yr AS char(4)) + '0103' AS DATE)
                         , 'New Year''s Day'
                         , 0	--'N'          -- FedHolidayInd
                         , 1	--'Y'          -- BankHolidayInd
                         , 0	--'N'          -- KFBHolidayInd
          END
     END

     -- MLK Day logic
     -- 3rd Monday in Jan
     SET @offset = 2 - DATEPART(dw, @Jan1)
     SET @WeekNumberInMonth = 3
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Jan1), 112) as int)
               , DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Jan1)
               , 'MLK Day'
               , 1	--'Y'          -- FedHolidayInd
               , 1	--'Y'          -- BankHolidayInd
               , 0	--'N'          -- KFBHolidayInd

     -- President's Day logic
     -- 3rd Monday in Feb
     SET @offset = 2 - DATEPART(dw, @Feb1)
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Feb1), 112) as int)
               , DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Feb1)
               , 'President''s Day'
               , 1	--	'Y'          -- FedHolidayInd
               , 1	--	'Y'         -- BankHolidayInd
               , 0	--	'N'          -- KFBHolidayInd

     -- Memorial Day logic
     -- Last Monday in May
     SET @MemorialDay = CASE DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '0531' AS DATE))
                         WHEN 1
                         THEN CAST(CAST(@Yr AS char(4)) + '0525' AS DATE)
                         WHEN 2
                         THEN CAST(CAST(@Yr AS char(4)) + '0531' AS DATE)
                         WHEN 3
                         THEN CAST(CAST(@Yr AS char(4)) + '0530' AS DATE)
                         WHEN 4
                         THEN CAST(CAST(@Yr AS char(4)) + '0529' AS DATE)
                         WHEN 5
                         THEN CAST(CAST(@Yr AS char(4)) + '0528' AS DATE)
                         WHEN 6
                         THEN CAST(CAST(@Yr AS char(4)) + '0527' AS DATE)
                         ELSE CAST(CAST(@Yr AS char(4)) + '0526' AS DATE)
                    END
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), @MemorialDay, 112) as int)
               , @MemorialDay
               , 'Memorial Day'
               , 1	--	'Y'          -- FedHolidayInd
               , 1	--	'Y'          -- BankHolidayInd
               , 1	--	'Y'          -- KFBHolidayInd

     -- Independence Day logic
     -- Jul 4th of each year
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '0704' AS DATE)) > 1) AND (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '0704' AS DATE)) < 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '0704' as int)
                    , CAST(CAST(@Yr AS char(4)) + '0704' AS DATE)
                    , 'Independence Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '0704' AS DATE)) = 1)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '0705' as int)
                    , CAST(CAST(@Yr AS char(4)) + '0705' AS DATE)
                    , 'Independence Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '0704' AS DATE)) = 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '0703' as int)
                    , CAST(CAST(@Yr AS char(4)) + '0703' AS DATE)
                    , 'Independence Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END

     -- Labor Day logic
     -- 1st Monday in September
     SET @offset = 2 - DATEPART(dw, @Sep1)
     SET @WeekNumberInMonth = 1
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Sep1), 112) as int)
               , DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Sep1)
               , 'Labor Day'
               , 1	--	'Y'          -- FedHolidayInd
               , 1	--	'Y'          -- BankHolidayInd
               , 1	--	'Y'          -- KFBHolidayInd

     -- Columbus Day logic
     -- 2nd Monday in October
     -- Usually only observed by Fed Govt and Banks
     SET @offset = 2 - DATEPART(dw, @Oct1)
     SET @WeekNumberInMonth = 2
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Oct1), 112) as int)
               , DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Oct1)
               , 'Columbus Day'
               , 1	--	'Y'          -- FedHolidayInd
               , 1	--	'Y'          -- BankHolidayInd
               , 0	--	'N'          -- KFBHolidayInd

     -- Veterans Day logic
     -- October 11th of each year
     -- Usually only observed by Fed Govt and Banks
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1111' AS DATE)) > 1) AND (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1111' AS DATE)) < 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1111' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1111' AS DATE)
                    , 'Veterans Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 0	--	'N'         -- KFBHolidayInd
 END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1111' AS DATE)) = 1)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1112' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1112' AS DATE)
                    , 'Veterans Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 0	--	'N'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1111' AS DATE)) = 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1110' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1110' AS DATE)
                    , 'Veterans Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 0	--	'N'          -- KFBHolidayInd
     END

     -- Thanksgiving Day logic
     -- 4th Thursday of November
     SET @offset = 5 - DATEPART(dw, @Nov1)
     SET @WeekNumberInMonth = 4
     SET @ThanksgivingDay = DATEADD(dd, @offset + (@WeekNumberInMonth - CASE WHEN @offset >= 0 THEN 1 ELSE 0 END) * 7, @Nov1)
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), @ThanksgivingDay, 112) as int)
               , @ThanksgivingDay
               , 'Thanksgiving Day'
               , 1	--	'Y'          -- FedHolidayInd
               , 1	--	'Y'          -- BankHolidayInd
               , 1	--	'Y'          -- KFBHolidayInd

     -- Day after Thanksgiving Day logic
     -- Not observed by Fed Govt and Banks
     INSERT INTO @HolidayTable
          SELECT CAST(CONVERT(char(8), DATEADD(dd, 1, @ThanksgivingDay), 112) as int)
               , DATEADD(dd, 1, @ThanksgivingDay)
               , 'Day after Thanksgiving'
               , 0	--	'N'          -- FedHolidayInd
               , 0	--	'N'          -- BankHolidayInd
               , 1	--	'Y'          -- KFBHolidayInd

     -- Christmas Eve logic
     -- Federal Govt and Banks do not celebrate Christmas Eve
     -- Logic can get complex when Christmas Day falls on a weekend.
     -- Using this logic, if Christmas Eve falls on Sunday, it will be observed on the following Tuesday.
     -- If Christmas Eve falls on Friday or Saturday, it will be observed on 12-23.
     -- Many companies do not use the following logic.
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)) > 1) AND (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)) < 6)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1224' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)
                    , 'Christmas Eve'
                    , 0	--	'N'          -- FedHolidayInd
                    , 0	--	'N'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)) = 1)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1226' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1226' AS DATE)
                    , 'Christmas Eve'
                    , 0	--	'N'          -- FedHolidayInd
                    , 0	--	'N'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)) > 5)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1223' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1223' AS DATE)
                    , 'Christmas Eve'
                    , 0	--	'N'          -- FedHolidayInd
                    , 0	--	'N'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END

     -- Christmas Day logic
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1225' AS DATE)) > 1) AND (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1225' AS DATE)) < 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1225' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1225' AS DATE)
                    , 'Christmas Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1225' AS DATE)) = 1)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1226' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1226' AS DATE)
                    , 'Christmas Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END
     IF (DATEPART(dw, CAST(CAST(@Yr AS char(4)) + '1225' AS DATE)) = 7)
     BEGIN
          INSERT INTO @HolidayTable
               SELECT CAST(CAST(@Yr AS char(4)) + '1224' as int)
                    , CAST(CAST(@Yr AS char(4)) + '1224' AS DATE)
                    , 'Christmas Day'
                    , 1	--	'Y'          -- FedHolidayInd
                    , 1	--	'Y'          -- BankHolidayInd
                    , 1	--	'Y'          -- KFBHolidayInd
     END

     END
SET @Yr = @Yr + 1
END

DECLARE @Control_Date DATE     --Current date in loop
SET @Control_Date = @starting_dt
DECLARE @Control_Date_int INT

WHILE @Control_Date <= @ending_dt
BEGIN
SET @Control_Date_int = CAST(CONVERT(NVARCHAR(8),@CONTROL_DATE,112) AS INT)
PRINT 'DOING WHILE--' + CAST(DATEDIFF(DAY,@CONTROL_DATE,@ENDING_DT) AS VARCHAR(10))
     SET @Yr = DATEPART(yyyy, @Control_Date)
     INSERT INTO [dim_datetime] ([DateTimeDimKey]
                         , [FullDt]
                         , [MonthNbr]
                         , [QuarterMonthNumber]
                         , [DayOfWeekNbr]
                         , [DayOfWeekNm]
                         , [DayOfWeekAbbrNm]
                         , [DayOfMonthNbr]
                         , [DayOfYearNbr]
                         , [FiscalMonthNbr]
                         , [FiscalQuarterNbr]
                         , [MonthNm]
                         , [MonthAbbrNm]
                         , [QuarterNbr]
                         , [WeekofYearNbr]
                         , [YearMonthNbr]
                         , [QuarterMonthNm]
                         , [YearNbr]
                         , [YearQuarter]
                         , [FiscalYearNbr]
                         , [FiscalYearQtr]
                         , [FiscalYearMonth]
                         , [IsLastDayOfMonthInd]
                         , [IsWeekdayInd]
                         , [IsWeekendInd]
                         , [IsLeapYearInd]
                    )

     SELECT @Control_Date_int AS [DateTimeDimKey]
          , @Control_Date AS [FullDt]
          , DATEPART(mm, @Control_Date) AS [MonthNbr]
          , CASE DATEPART(mm, @Control_Date)
                    WHEN 1 THEN 1
                    WHEN 2 THEN 2
                    WHEN 3 THEN 3
                    WHEN 4 THEN 1
                    WHEN 5 THEN 2
                    WHEN 6 THEN 3
                    WHEN 7 THEN 1
                    WHEN 8 THEN 2
             WHEN 9 THEN 3
                    WHEN 10 THEN 1
                    WHEN 11 THEN 2
                    ELSE 3
               END AS [QuarterMonthNumber]
          , DATEPART(dw, @Control_Date) AS [DayOfWeekNbr]
          , DATENAME(weekday, @Control_Date) AS [DayOfWeekNm]
          , LEFT(DATENAME(weekday, @Control_Date), 3) AS [DayOfWeekAbbrNm]
          , DATEPART(day, @Control_Date) AS [DayOfMonthNbr]
          , DATEPART(dy, @Control_Date) AS [DayOfYearNbr]
          , DATEPART(mm, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS [FiscalMonthNbr]
          , DATEPART(qq, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS [FiscalQuarterNbr]
          , DATENAME(month, @Control_Date) AS [MonthNm]
          , LEFT(DATENAME(month, @Control_Date), 3) AS [MonthAbbrNm]
          , DATEPART(qq, @Control_Date) AS [QuarterNbr]
          , DATEPART(wk, @Control_Date) AS [WeekofYearNbr]
          , LEFT(CONVERT(varchar(8), @Control_Date_int),6) AS [YearMonthNbr]
          , DATENAME(month, @Control_Date) AS [QuarterMonthNm]
          , @Yr AS [YearNbr]
          , CAST(@Yr AS char(4)) + '-' + RIGHT('0' + CAST(DATEPART(qq, @Control_Date) AS char(1)), 2) AS [YearQuarter]
          , DATEPART(yyyy, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS [FiscalYearNbr]
		  , CAST(DATEPART(yyyy, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS char(4)) + 'Q'
                    + RIGHT('0' + CAST(DATEPART(qq, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS varchar(2)), 2) AS [FiscalYearQtr]
          , CAST(DATEPART(yyyy, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS char(4)) + '-'
                    + RIGHT('0' + CAST(DATEPART(mm, DATEADD(mm, @FiscalYearMonthsOffset, @Control_Date)) AS varchar(2)), 2) AS [FiscalYearMonth]
          , CASE
               WHEN @Control_Date = DATEADD(d, -day(DATEADD(mm, 1, @Control_Date)), DATEADD(mm, 1, @Control_Date))
               THEN 'Y'
               ELSE 'N'
               END AS [IsLastDayOfMonthInd]
          , CASE DATEPART(dw, @Control_Date)
                    WHEN 1
                    THEN 'N'
                    WHEN 7
                    THEN 'N'
                    ELSE 'Y'
               END AS [IsWeekdayInd]
          , CASE DATEPART(dw, @Control_Date)
                    WHEN 1
                    THEN 'Y'
                    WHEN 7
                    THEN 'Y'
                    ELSE 'N'
               END AS [IsWeekendInd]
          , CASE WHEN (DATEPART(YEAR, @Control_Date) % 4 = 0) AND (Year(@Control_Date) % 100 != 0 OR Year(@Control_Date) % 400 = 0)     
					THEN 'Y'
					ELSE 'N'
				END AS [IsLeapYearInd] 			

				
	     SET @Control_Date = DATEADD(dd, 1, @Control_Date)
	IF @Control_Date > @ending_dt
		BREAK
		ELSE
		CONTINUE
 
END

UPDATE dateTbl
     SET dateTbl.[IsWorkdayInd] = CASE
                         WHEN dateTbl.IsWeekdayInd = 'Y'
                              AND ISNULL(holTbl.KFBHolidayInd,0) = 0
                         THEN 'N'
                         ELSE 'Y'
                         END
          , dateTbl.[FedHolidayInd] = CASE
                         WHEN ISNULL(holTbl.FedHolidayInd, 0) = 0
                         THEN 'N'
                         ELSE 'Y'
                         END
          , dateTbl.[BankHolidayInd] = CASE
                         WHEN ISNULL(holTbl.BankHolidayInd,0) = 0
                         THEN 'N'
                         ELSE 'Y'
                         END
          , dateTbl.[KFBHolidayInd] = CASE
                         WHEN ISNULL(holTbl.KFBHolidayInd, 0) = 0
                         THEN 'N'
                         ELSE 'Y'
                         END
     FROM rpt.[dim_datetime] dateTbl
          LEFT OUTER JOIN @HolidayTable holTbl
               ON dateTbl.[DateTimeDimKey] = holTbl.HolidayKey
     WHERE DateTimeDimKey BETWEEN CAST(CONVERT(varchar(8), @starting_dt, 112) AS int) AND CAST(CONVERT(varchar(8), @ending_dt, 112) AS int)

END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_Applications]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for SQL Reporting Services report parameters.
It is designed to return only columns which are used to provide and identify the primary key for use by other report parameters or datasets
The procedural logic allows for this to be used in a multiple value parameter box.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
Additionally, the procedure reflects the relational nature of the table.  As the  Applications table is a child table to other parent tables, the procedure structure allows for its use as either a standalone parameter (one in which the parent table values are not provided or used to filter the dataset) or a dependent parameter (one in which parent table values are provided to filter the dataset returned).  Each usage could return 1 to N number of  Application primary keys.
There are no conditions in which both a list of applicationids and a list of businesscategoryids will be sent to the procedure.  It is designed to provide a dataset of applications based upon a list of businesscategories OR a list of applicationids (mutually exclusive)
As this procedure is custom written for use in reporting only and should only be used for providing a source for report parameters.
***************************************************/
CREATE PROCEDURE [rpt].[usp_Parameters_Applications]
(@pBusinessCategoryIDs VARCHAR(8000)
)
AS
BEGIN
DECLARE @BusinessCatgoryIDs TABLE (pBusCatID INT)
DECLARE @ApplicationsIDs TABLE (pAppID INT)

--if a dependent parameter, then the  Application IDs returned will be based upon the parent table value
--parse the parent table values and return the Application records matching that criteria
--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
	--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
IF @pBusinessCategoryIDs IS NULL OR CHARINDEX('-1',@pBusinessCategoryIDs,0) > 0
	BEGIN
		INSERT INTO @BusinessCatgoryIDs
		SELECT DISTINCT
		[BusinessCategoryID]
		FROM [dbo].[vw_BusinessCategories]
	END
	ELSE
	BEGIN
		--use custom function to split input string into a table of integers
		INSERT INTO @BusinessCatgoryIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pBusinessCategoryIDs,',')
	END

--if an independent parameter, then the procedure parameter @pBusinessCategoryID will be NULL and the WHERE condition is based solely on the value returned will be based upon the parent table value. As the BusinessCategory parameter is null, the table variable will contain ALL business categories, therefore only test upon the applicationids string
--Same checks are required for ApplicationIDs as done for BusinessCategoryIDs
	BEGIN
		INSERT INTO @ApplicationsIDs
		SELECT DISTINCT
		[ApplicationId]
        FROM [dbo].[vw_Applications]
		WHERE [BusinessCategoryID] IN (SELECT pBusCatID FROM @BusinessCatgoryIDs)
	END

SELECT [ApplicationId]
      ,[ApplicationName]
  FROM [dbo].[vw_Applications]
  WHERE [ApplicationId] IN (SELECT pAppID FROM  @ApplicationsIDs)
END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_BusinessCategories]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used in SQL Reporting Services report parameters values.
It is designed to return only columns which are used to provide and identify the primary key for use by other report parameters or datasets
The procedural logic allows for this to be used in a multiple value parameter box.
Due to the nature of SSRS parameters, to allow for multiple value parameters, the combination of individual parameters are passed to this procedure as a CSV string.
As this procedure is custom written for use in reporting only and should only be used for providing a source for report parameters.
***************************************************/
CREATE PROCEDURE [rpt].[usp_Parameters_BusinessCategories]
(@pBusinessCategoryIDs VARCHAR(8000)
)
AS
BEGIN
DECLARE @BusinessCatgoryIDs TABLE (pAppID INT)
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.
IF @pBusinessCategoryIDs IS NULL OR CHARINDEX('-1',@pBusinessCategoryIDs,0) > 0
	BEGIN
		INSERT INTO @BusinessCatgoryIDs
		SELECT DISTINCT
		[BusinessCategoryID]
		FROM [dbo].[vw_BusinessCategories]
	END
	ELSE
	BEGIN
		--use custom function to split input string into a table of integers
		INSERT INTO @BusinessCatgoryIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pBusinessCategoryIDs,',')
	END

SELECT DISTINCT
[BusinessCategoryID]
,[BusinessCategoryDesc]
FROM [dbo].[vw_BusinessCategories]
WHERE [BusinessCategoryID] IN (SELECT pAppID FROM @BusinessCatgoryIDs)
END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_DashboardCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [rpt].[usp_Parameters_DashboardCustomizations]
(@pDashboardIDs VARCHAR(8000))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ReportCustomizationIDs TABLE (pReportCustomizationID INT)
	IF @pDashboardIDs IS NULL
	BEGIN
		INSERT INTO @ReportCustomizationIDs
		SELECT [ReportCustomizationID]
        FROM [rpt].[vw_ReportCustomizations]
		
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ReportCustomizationIDs
		SELECT [ReportCustomizationID]
        FROM [rpt].[vw_ReportCustomizations]
		WHERE  [DashboardID] IN
		(SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pDashboardIDs,','))
	END

	SELECT 
	[RC1].[ReportCustomizationID]
	,[ROC1].[ReportObjectName]
	,[ROC1].[ReportCustomizationScope]
	,[ROC1].[TextContent]      
	FROM [rpt].[ReportCustomizations] AS RC1
	LEFT OUTER JOIN [rpt].[vw_ReportObjectCustomizations] AS ROC1
	ON [RC1].[ReportCustomizationID] = [ROC1].[ReportCustomizationID]
	WHERE [RC1].[ReportCustomizationID] IN
	(SELECT pReportCustomizationID
	FROM @ReportCustomizationIDs)
	AND [ROC1].[ReportCustomizationScope] = 'Dashboard'
END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_ReportCustomizations]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [rpt].[usp_Parameters_ReportCustomizations]
(@pReportCustomizationIDs VARCHAR(8000))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ReportCustomizationIDs TABLE (pReportCustomizationID INT)
	IF @pReportCustomizationIDs IS NULL
	BEGIN
		INSERT INTO @ReportCustomizationIDs
		SELECT [ReportCustomizationID]
        FROM [rpt].[vw_ReportCustomizations]
		
	END
	ELSE
	BEGIN
	--use custom function to split input string into a table of integers
		INSERT INTO @ReportCustomizationIDs
		SELECT [ReportCustomizationID]
        FROM [rpt].[vw_ReportCustomizations]
		WHERE  [ReportCustomizationID] IN
		(SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pReportCustomizationIDs,','))
	END

	SELECT 
	[RC1].[ReportCustomizationID]
	,[ROC1].[ReportObjectName]
	,[ROC1].[ReportCustomizationScope]
	,[ROC1].[TextContent]      
	FROM [rpt].[ReportCustomizations] AS RC1
	LEFT OUTER JOIN [rpt].[vw_ReportObjectCustomizations] AS ROC1
	ON [RC1].[ReportCustomizationID] = [ROC1].[ReportCustomizationID]
	WHERE [RC1].[ReportCustomizationID] IN
	(SELECT pReportCustomizationID
	FROM @ReportCustomizationIDs)
	AND [ROC1].[ReportCustomizationScope] = 'Report'
END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_ReportHeaderFooter]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for SQL Reporting Services report informational values such as report name, description and other non-data objects.
As this procedure is custom written for use in reporting only and should only be used for providing a source for report parameters.
***************************************************/
CREATE PROCEDURE [rpt].[usp_Parameters_ReportHeaderFooter]
(@pReportCustomizationID INT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ReportHeaderAndFooter TABLE ([ReportCustomizationID] INT
	,[HeaderReportTitle] VARCHAR(4000),[HeaderReportDescription] VARCHAR(4000),[FooterNotes] VARCHAR(4000))

	INSERT INTO @ReportHeaderAndFooter ([ReportCustomizationID],[HeaderReportTitle],[HeaderReportDescription],[FooterNotes])
	SELECT  
	[ReportCustomizationID]
	,[TextContent]
	,NULL
	,NULL
	FROM [rpt].[vw_ReportObjectCustomizations] 
	WHERE [ReportCustomizationScope] = 'Report'
	AND [ReportObjectName] = 'txtTitle'
	AND [ReportCustomizationID] = @pReportCustomizationID

	UPDATE @ReportHeaderAndFooter
	SET [HeaderReportDescription] = [ROC1].[TextContent]
	FROM @ReportHeaderAndFooter AS T1
	INNER JOIN [rpt].[vw_ReportObjectCustomizations] AS ROC1
	ON [T1].[ReportCustomizationID] = [ROC1].[ReportCustomizationID]
	WHERE [ROC1].[ReportObjectName] = 'txtReportDescription'

	SELECT
	[ReportCustomizationID]
	,[HeaderReportTitle]
	,[HeaderReportDescription]
	,[FooterNotes]
	FROM @ReportHeaderAndFooter

END
GO
/****** Object:  StoredProcedure [rpt].[usp_Parameters_Servers]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: 
This procedure is a custom procedure used as the dataset for SQL Reporting Services report parameters.
As this procedure is custom written for use in reporting only and should only be used for providing a source for report parameters.
***************************************************/
CREATE PROCEDURE [rpt].[usp_Parameters_Servers]
(@pServerSystemIDs VARCHAR(8000))
AS
BEGIN
DECLARE @ServerSystemIDs TABLE (pServerSystemID INT)
--However, due to the nature of SSRS parameters, multiple value parameters cannot also be set to NULL
--to address this issue, yet use this procedure for both single value parameters and multiple value parameters, the value of -1 can be passed to indicate all rows should be returned.  Evaluation of the input parameter, which could be a sting of integers, to the value -1 cannot be done directly else conversion errors occur.  The CHARINDEX function is used to determine if the VARCHAR string contains the value '-1'.  Any value greater than 0 indicates the string contains the value.

IF @pServerSystemIDs IS NULL OR CHARINDEX('-1',@pServerSystemIDs,0) > 0
	BEGIN
		INSERT INTO @ServerSystemIDs
		SELECT DISTINCT
		[ServerSystemID]
		FROM [dbo].[vw_Servers]
	END
	ELSE
	BEGIN
		--use custom function to split input string into a table of integers
		INSERT INTO @ServerSystemIDs
		SELECT item
		FROM dbo.ufn_SplitReportStringINTParametersToTable(@pServerSystemIDs,',')
	END

	SELECT
	[ServerSystemID]
	,[HostName]
	,[RetiredInd]
	FROM [dbo].[vw_Servers]
	WHERE [ServerSystemID] IN (SELECT pServerSystemID FROM @ServerSystemIDs)
		
END
GO
/****** Object:  StoredProcedure [sec].[usp_ADGM_MembersAsofDate]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [sec].[usp_ADGM_MembersAsofDate]
(@AsOfDate DATE
,@GroupSAMAcccountName varchar(256))
AS
BEGIN
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  
	IF @GroupSAMAcccountName IS NULL
	BEGIN
	SET @GroupSAMAcccountName = '%'
	END
	BEGIN TRY
	--Must use a consolidation of the ADUsers table to accomodate when ADUser accounts are disabled and removed from a group
	--but then the deactivated account is re-enabled and added back to AD groups.
	--in cases where the ADUser is deleted and re-added a new GUID is assigned
	--however, IT Security does not immediately delete AD Users when an entity leaves the company.  They disable the existing account which causes the record to be retained using the original GUID
		SELECT 
		[ADGM1].[ADGroupMembersID]
		,[ADGM1].[ETLProcessID]
		,[ADGM1].[ADGroupGUID]
		,[ADGM1].[ADUsersGUID]
		,[ADU1].[samAccountName] AS UserSamAccountName
		,[ADG1].[samAccountName] AS GroupSamAccountName
		,[ADU2].[userAccountDisabledInd]
		,[ADGM1].[GroupMembershipStartDate]
		,[ADGM1].[GroupMembershipEndDate]
		,[ADGM1].[CurrentGroupMembershipInd]
		,[ADGM1].[IsNestedGroupInd]
		FROM [sec].[ADGroupMembers] AS [ADGM1]
		INNER JOIN [sec].[ADGroups] AS [ADG1]
		ON [ADGM1].[ADGroupGUID] = [ADG1].[GUID]
		INNER JOIN 
		(
		SELECT
		MAX([ADUsersId]) AS MAXADUserID
		,[samAccountName]
		,[GUID]
		FROM [sec].[ADUsers] 
		GROUP BY 
		[samAccountName]
		,[GUID]) AS [ADU1]
		INNER JOIN [sec].[ADUsers] AS [ADU2]
		ON [ADU1].[MAXADUserID] = [ADU2].[ADUsersId]
		ON [ADGM1].[ADUsersGUID] = [ADU1].[GUID]
		WHERE @asofdate BETWEEN [GroupMembershipStartDate] and ISNULL([GroupMembershipEndDate],CAST(GETDATE() as date))
		AND [ADG1].[samAccountName] LIKE @GroupSAMAcccountName

	END TRY
	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
END
GO
/****** Object:  StoredProcedure [sec].[usp_ADGroups_AsofDate]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: Stored procedure returns a table of the current Active Directory Groups as of a given date.
Current AD Groups is defined as group object categories who's earliest date reported (FirstReportedDate) is less than or equal to the input date--previously added or newly added groups--
and who's last recorded dated (LatestReportedDate) is NULL or less than the input date.
While originally designed to run once per day, it is theoretically possible that a group is added and deleted on the same day if the ETL process is rerun within a day and the group was added before the first run and deleted on all subsequent runs that same day.  In this rare circumstance the user will show as a current group
*/
CREATE PROCEDURE [sec].[usp_ADGroups_AsofDate]
(@AsOfDate DATE
,@GroupSAMAcccountName varchar(256))
AS
BEGIN
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  
	BEGIN TRY
	--@AsOfDate cannot be null, set to current day if null
	IF @AsOfDate IS NULL
	BEGIN
	SET @AsOfDate = CAST(GETDATE() AS DATE)
	END

	IF @GroupSAMAcccountName IS NULL
	BEGIN
	SET @GroupSAMAcccountName = '%'
	END

		SELECT 
		[ADG1].[ADGroupId]
		,[ADG1].[GUId]
		,[ADG1].[sid]
		,[ADG1].[ETLProcessId]
		,[ADG1].[adsPath]
		,[ADG1].[groupType]
		,[ADG1].[samAccountName]
		,[ADG1].[distinguishedName]
		,[ADG1].[cn]
		,[ADG1].[Description]
		,[ADG1].[SecurityGroupInd]
		,[ADG1].[DisplayName]
		,[ADG1].[objectCategory]
		,[ADG1].[Name]
		,[ADG1].[whenChanged]
		,[ADG1].[department]
		,[ADG1].[whenCreated]
		,[ADG1].[samAccountType]
		,[ADG1].[schemaentry]
		,[ADG1].[schemaclassname]
		,[ADG1].[managedBy]
		,[ADG1].[FirstReportedDate]
		,[ADG1].[LatestReportedDate]
		FROM [sec].[vw_ADGroups] AS [ADG1]
		WHERE @asofdate BETWEEN [ADG1].[FirstReportedDate] and ISNULL([ADG1].[LatestReportedDate],CAST(GETDATE() as date))
		AND [ADG1].[samAccountName] LIKE @GroupSAMAcccountName;

	END TRY
	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
END
GO
/****** Object:  StoredProcedure [sec].[usp_ADUsers_AsofDate]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
Author: Danny Howell
Description: Stored procedure returns a table of the current Active Directory User as of a given date.
Current AD Users is defined as users who's earliest date reported (FirstReportedDate) is less than or equal to the input date--previously added or newly added users--
and who's last recorded dated (LatestReportedDate) is NULL or less than the input date.
Active Directory is not used to record employees and this dataset does not report 'current employees' as users are retained for a period of time past their date of employment termination
While originally designed to run once per day, it is theoretically possible that a user is added and deleted on the same day if the ETL process is rerun within a day and the user was added before the first run and deleted on all subsequent runs that same day.  In this rare circumstance the user will show as a current member
*/
CREATE PROCEDURE [sec].[usp_ADUsers_AsofDate]
(@AsOfDate DATE
,@UserSAMAcccountName varchar(256))
AS
BEGIN
	SET NOCOUNT ON 
	--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
	SET XACT_ABORT ON  
	BEGIN TRY
	--Default to the current date if @AsOfDate is null
	IF @AsOfDate IS NULL
	BEGIN
	SET @AsOfDate = CAST(GETDATE() AS DATE)
	END

	IF @UserSAMAcccountName IS NULL
	BEGIN
	SET @UserSAMAcccountName = '%'
	END

		SELECT 
		[ADU1].[ADUsersId]
		,[ADU1].[GUId]
		,[ADU1].[ETLProcessId]
		,[ADU1].[sid]
		,[ADU1].[containerADSPath]
		,[ADU1].[samAccountName]
		,[ADU1].[GivenName]
		,[ADU1].[SN]
		,[ADU1].[Manager]
		,[ADU1].[Title]
		,[ADU1].[cn]
		,[ADU1].[objectCategory]
		,[ADU1].[userprincipalname]
		,[ADU1].[samAccountType]
		,[ADU1].[primaryGroup]
		,[ADU1].[Description]
		,[ADU1].[DisplayName]
		,[ADU1].[department]
		,[ADU1].[userAccountControl]
		,[ADU1].[userAccountDisabledInd]
		,[ADU1].[WhenChanged]
		,[ADU1].[WhenCreated]
		,[ADU1].[DistinguishedName]
		,[ADU1].[Name]
		,[ADU1].[FirstReportedDate]
		,[ADU1].[LatestReportedDate]
		FROM [sec].[vw_ADUsers] AS [ADU1]
		WHERE @asofdate BETWEEN [ADU1].[FirstReportedDate] and ISNULL([ADU1].[LatestReportedDate],CAST(GETDATE() as date))
		AND [ADU1].[samAccountName] LIKE @UserSAMAcccountName;

	END TRY
	BEGIN CATCH
		EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
	END CATCH
END
GO
/****** Object:  StoredProcedure [security].[usp_DevelopmentReporting_ReportData]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [security].[usp_DevelopmentReporting_ReportData]
AS
BEGIN
--run procedure to create temp tables used for reporting data--for performance purposes of the report, temp tables will hold the data instead of generating the data at report run time
EXEC [security].[usp_Report_ADGMs];
EXEC [security].[usp_Report_ServerPrincipals];
EXEC [security].[usp_Report_DBRMs];

DECLARE @ExcludedDatabases TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @ExcludedDatabases (DatabaseName)
VALUES
('SSISDB')
INSERT INTO @ExcludedDatabases (DatabaseName)
VALUES
('KFBSQLMgmt')


IF EXISTS (SELECT * FROM tempdb.sys.objects where Type = 'U' and name like 'DBRMCTE')
BEGIN
DROP TABLE tempdb.dbo.dbrmcte
END
IF EXISTS (SELECT * FROM tempdb.sys.objects where Type = 'U' and name like 'SPWITHDBROLES')
BEGIN
DROP TABLE tempdb.dbo.SPWITHDBROLES
END

CREATE TABLE tempdb.dbo.dbrmcte 
--DECLARE [tempdb].[dbo].[dbrmcte] TABLE (
([DatabaseID] INT NOT NULL
,[DBPSid] VARBINARY(85) NULL
,[DatabasePrincipalsId] INT NOT NULL
,[DatabaseRolesId] INT NOT NULL
,[DBRServerId] INT NOT NULL
,[DBRDatabaseId] INT NOT NULL
,[DatabaseName] VARCHAR(128) NOT NULL
,[DBPUserName] VARCHAR(128) NOT NULL
,[DBRPrincipalId] INT NULL
,[DBRName] VARCHAR(128) NOT NULL
,[ADsamAccountName] VARCHAR(256) NULL
,[IsNestedADGroupInd] BIT NULL
,[userAccountDisabledInd] BIT NULL
,[ADGMChangeTypeCd] INT NULL
,[ADGChangeTypeCd] INT  NULL
,[ADGMUChangeTypeCd] INT NULL
,[ADUChangeTypeCd] INT NULL
,[DBRMChangeTypeCd] INT NOT NULL
,[DBRChangeTypeCd] INT NOT NULL
,[DBPChangeTypeCd] INT NOT NULL)


INSERT INTO [tempdb].[dbo].[dbrmcte] (
[DatabaseID] 
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[userAccountDisabledInd]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd])
SELECT 
[DB1].DatabaseID
,[DBRM1].[DBPSid]
,[DBRM1].[DatabasePrincipalsId]
,[DBRM1].[DatabaseRolesId]
,[DBRM1].[DBRServerId]
,[DBRM1].[DBRDatabaseId]
,[DB1].[DatabaseName]
,[DBRM1].[DBPUserName]
,[DBRM1].[DBRPrincipalId]
,[DBRM1].[DBRName]
,[ADGMCP1].[ADUsamAccountName]
,[ADGMCP1].[IsNestedGroupInd]
,[ADUCP1].[userAccountDisabledInd]
,[ADGMCP1].[ADGMChangeTypeCd]
,[ADGMCP1].[ADGChangeTypeCd]
,[ADGMCP1].[ADUChangeTypeCd]
,[ADUCP1].[ChangeTypeCd]
,[DBRM1].[DBRMChangeTypeCd] 
,[DBRM1].[DBRChangeTypeCd]
,[DBRM1].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tDBRM] as DBRM1
LEFT OUTER JOIN [security].[vw_ADUsers_CurrentETLProcessId] AS ADUCP1
ON [DBRM1].[DBPSid] = [ADUCP1].[sid]
LEFT OUTER JOIN [tempdb].[dbo].[tADGM] AS ADGMCP1 
ON [DBRM1].[DBPSid] = [ADGMCP1].[ADGSid]
INNER JOIN [security].[vw_Databases_CurrentETLProcessId] AS DB1
ON [DBRM1].[DBRServerId] = [DB1].[ServerId]
AND [DBRM1].[DBRDatabaseId] = [DB1].[DatabaseID]
WHERE [DB1].[DatabaseName] NOT IN (SELECT DatabaseName FROM @ExcludedDatabases)
AND [DB1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 0)


CREATE TABLE [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId] INT NOT NULL
,[ServerRoleId] INT NULL
,[AccessToAllDatabasesInd] BIT NOT NULL
,[GUId] VARBINARY(85) NULL
,[SysAdminInd] BIT NOT NULL
,[IsDisabledind] BIT NOT NULL
,[DeletedDomainAccountInd] BIT NOT NULL
,[ADAccountInd] BIT NOT NULL
,[CustomRoleInd] BIT NOT NULL
,[RolePrincipalId] INT NOT NULL
,[SRName] VARCHAR(128) NOT NULL
,[SPName] VARCHAR(256) NULL
,[SRMChangeTypeCd] INT NULL
,[SRChangeTypeCd] INT NULL
,[SPChangeTypeCd] INT NULL
,[SRMADGroupMemberName] VARCHAR(256) NULL
,[SRMADGMChangeTypeCd] INT NULL
,[SRMADGChangeTypeCd] INT NULL
,[SRMADUChangeTypeCd] INT NULL
,[DBPSid] VARBINARY(85) NULL
,[DatabasePrincipalsId] INT NULL
,[DatabaseRolesId] INT NULL
,[DBRServerId] INT NULL
,[DBRDatabaseId] INT NULL
,[DatabaseName] VARCHAR(128) NULL
,[DBPUserName] VARCHAR(256) NULL
,[DBRPrincipalId] INT NULL
,[DBRName] VARCHAR(128) NULL
,[ADsamAccountName] VARCHAR(256) NULL
,[IsNestedADGroupInd] BIT NULL
,[UserAccountDisabled] BIT NULL
,[ADGMChangeTypeCd] INT NULL
,[ADGChangeTypeCd] INT NULL
,[ADGMUChangeTypeCd] INT NULL
,[ADUChangeTypeCd] INT NULL
,[DBRMChangeTypeCd] INT NULL
,[DBRChangeTypeCd] INT NULL
,[DBPChangeTypeCd] INT NULL
);

INSERT INTO [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId]
,[ServerRoleId]
,[AccessToAllDatabasesInd]
,[GUId]
,[SysAdminInd]
,[IsDisabledind]
,[DeletedDomainAccountInd]
,[ADAccountInd]
,[CustomRoleInd]
,[RolePrincipalId]
,[SRName]
,[SPName]
,[SRMChangeTypeCd]
,[SRChangeTypeCd]
,[SPChangeTypeCd]
,[SRMADGroupMemberName]
,[SRMADGMChangeTypeCd]
,[SRMADGChangeTypeCd]
,[SRMADUChangeTypeCd]
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[UserAccountDisabled]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd]
)
-- Build and return the report data as a table
SELECT 
[SRM1].[ServerId]
,[SRM1].[ServerRoleId]
,[SRM1].[AccessToAllDatabasesInd]
,[SRM1].[GUId]
,[SRM1].[SysAdminInd]
,[SRM1].[IsDisabledind]
,[SRM1].[DeletedDomainAccountInd]
,[SRM1].[ADAccountInd]
,[SRM1].[CustomRoleInd]
,[SRM1].[RolePrincipalId]
,[SRM1].[SRName]
,[SRM1].[SPName]
,[SRM1].[SRMChangeTypeCd]
,[SRM1].[SRChangeTypeCd]
,[SRM1].[SPChangeTypeCd]
,NULL 
,NULL 
,NULL
,NULL
,[DBRMCTE].[DBPSid]
,[DBRMCTE].[DatabasePrincipalsId]
,[DBRMCTE].[DatabaseRolesId]
,[DBRMCTE].[DBRServerId]
,[DBRMCTE].[DBRDatabaseId]
,[DBRMCTE].[DatabaseName]
,[DBRMCTE].[DBPUserName]
,[DBRMCTE].[DBRPrincipalId]
,[DBRMCTE].[DBRName]
,[DBRMCTE].[ADsamAccountName]
,[DBRMCTE].[IsNestedADGroupInd]
,[DBRMCTE].[userAccountDisabledInd]
,[DBRMCTE].[ADGMChangeTypeCd]
,[DBRMCTE].[ADGChangeTypeCd]
,[DBRMCTE].[ADGMUChangeTypeCd]
,[DBRMCTE].[ADUChangeTypeCd]
,[DBRMCTE].[DBRMChangeTypeCd] 
,[DBRMCTE].[DBRChangeTypeCd]
,[DBRMCTE].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tSRMs] AS SRM1
INNER JOIN [tempdb].[dbo].[dbrmcte] as DBRMCTE 
ON [SRM1].[ServerId] = [DBRMCTE].[DBRServerId]
AND [SRM1].[SQLSid] = [DBRMCTE].[DBPSid]
WHERE [SRM1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 0)

INSERT INTO [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId]
,[ServerRoleId]
,[AccessToAllDatabasesInd]
,[GUId]
,[SysAdminInd]
,[IsDisabledind]
,[DeletedDomainAccountInd]
,[ADAccountInd]
,[CustomRoleInd]
,[RolePrincipalId]
,[SRName]
,[SPName]
,[SRMChangeTypeCd]
,[SRChangeTypeCd]
,[SPChangeTypeCd]
,[SRMADGroupMemberName]
,[SRMADGMChangeTypeCd]
,[SRMADGChangeTypeCd]
,[SRMADUChangeTypeCd]
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[UserAccountDisabled]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd]
)
-- Build and return the report data as a table
SELECT 
[SRM1].[ServerId]
,[SRM1].[ServerRoleId]
,[SRM1].[AccessToAllDatabasesInd]
,[SRM1].[GUId]
,[SRM1].[SysAdminInd]
,[SRM1].[IsDisabledind]
,[SRM1].[DeletedDomainAccountInd]
,[SRM1].[ADAccountInd]
,[SRM1].[CustomRoleInd]
,[SRM1].[RolePrincipalId]
,[SRM1].[SRName]
,[SRM1].[SPName]
,[SRM1].[SRMChangeTypeCd]
,[SRM1].[SRChangeTypeCd]
,[SRM1].[SPChangeTypeCd]
,[SPADGM1].[ADUsamAccountName] 
,[SPADGM1].[ADGMChangeTypeCd]
,[SPADGM1].[ADGChangeTypeCd]
,[SPADGM1].[ADUChangeTypeCd]
,[DBRMCTE].[DBPSid]
,[DBRMCTE].[DatabasePrincipalsId]
,[DBRMCTE].[DatabaseRolesId]
,[DBRMCTE].[DBRServerId]
,ISNULL([DBRMCTE].[DBRDatabaseId],0)
,[DBRMCTE].[DatabaseName]
,[DBRMCTE].[DBPUserName]
,[DBRMCTE].[DBRPrincipalId]
,[DBRMCTE].[DBRName]
,[DBRMCTE].[ADsamAccountName]
,[DBRMCTE].[IsNestedADGroupInd]
,[DBRMCTE].[userAccountDisabledInd]
,[DBRMCTE].[ADGMChangeTypeCd]
,[DBRMCTE].[ADGChangeTypeCd]
,[DBRMCTE].[ADGMUChangeTypeCd]
,[DBRMCTE].[ADUChangeTypeCd]
,[DBRMCTE].[DBRMChangeTypeCd] 
,[DBRMCTE].[DBRChangeTypeCd]
,[DBRMCTE].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tSRMs] AS SRM1
LEFT OUTER JOIN [tempdb].[dbo].[tADGM] AS SPADGM1
ON [SRM1].[GUId] = [SPADGM1].[ADGroupGuid]
LEFT OUTER JOIN [tempdb].[dbo].[dbrmcte] as DBRMCTE 
ON [SRM1].[ServerId] = [DBRMCTE].[DBRServerId]
AND [SRM1].[SQLSid] = [DBRMCTE].[DBPSid]
WHERE [DBRMCTE].[DBPSid] IS NULL
AND [SRM1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 0)

SELECT
s1.ServerName AS ServerName
,[S1].ServerReportingName AS ServerReportingName
,[E1].ETLProcessId
,[E1].ProcessDt AS ETLLoadDate
,[T1].[ServerId] AS ServerId
,[T1].[ServerRoleId] AS ServerRoleId
,(ISNULL(ABS([T1].[IsDisabledind]),0) +
ISNULL(ABS([T1].[DeletedDomainAccountInd]),0) + 
ISNULL(ABS([T1].[IsNestedADGroupInd]),0) + 
isnull(ABS([T1].[UserAccountDisabled]),0) )  AS ActionRequiredInd
,[T1].[AccessToAllDatabasesInd] AS AccesstoAllDatabasesInd
,[T1].[SysAdminInd] AS SysAdminInd
,[T1].[IsDisabledind] AS IsDisabledInd
,[T1].[DeletedDomainAccountInd] AS DeletedDomainAccountInd
,isnull([T1].[UserAccountDisabled],0) as userAccountDisabled
,ISNULL([SR1].[SystemName],'Need Description') AS SRName
,ISNULL([SR1].ReportingDescription,'Need Description') AS SRReportingName
--,[SR1].[SystemName] AS SRName
--,[SR1].ReportingDescription AS SRReportingName
,[T1].[SPName] AS SPName
,[T1].[SRMADGroupMemberName] AS SRADGroupMemberName
,[T1].[DBRDatabaseId] as DatabaseId
,ISNULL([T1].[DatabaseName],'No access to any database') as DatabaseName
,[T1].[DBPUserName] AS DBPUserName
,[T1].[DBRPrincipalId]
,[T1].[DBRServerId]
,[T1].[DBRDatabaseId]
,CASE WHEN [T1].[DatabaseName] IS NULL THEN -1 ELSE  [DBR1].DatabaseID END AS dbrEVAL
,CASE WHEN [T1].[DatabaseName] IS NULL THEN 'Not Applicable' ELSE ISNULL([DBR1].[SystemName],'Role for ID ' + cast([T1].[DBRPrincipalId] as varchar(6)) + ' Name: ' + [T1].[DBRName] + 'Needs to be added to RolesTable') END AS DBRName
,CASE WHEN [T1].[DatabaseName] IS NULL THEN 'Not Applicable' ELSE ISNULL([DBR1].ReportingDescription,'Need Description') END AS DBRReportingName
,ISNULL([T1].[IsNestedADGroupInd],0) AS IsNestedADGroupInd
,[T1].[ADsamAccountName] as DBPsamAccountName
,(ISNULL(ABS([T1].[SRMChangeTypeCd]),0)  
	+ISNULL(ABS([T1].[SRChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SPChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADGMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADGChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGMUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBRMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBRChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBPChangeTypeCd]),0)) AS AccountChangeInd
,(
ISNULL([AC7].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC8].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC9].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC10].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC11].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC12].ChangeTypeReportingDescription + ';','')
) as SPChangeTypeDesc
,(
ISNULL([AC4].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC5].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC6].ChangeTypeReportingDescription + ';','')  +
	ISNULL([AC1].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC2].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC3].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC32].ChangeTypeReportingDescription + ';','')
) AS DBADChangeTypeDesc
FROM [tempdb].[dbo].[SPWITHDBROLES] AS T1
INNER JOIN [security].[Servers] AS S1
ON [T1].[ServerId] = [s1].[ServerId]
LEFT OUTER JOIN 
(
SELECT
 [ServerId]
,[PrincipalId]
,[DatabaseID]
,[SystemName]
      ,[ReportingDescription]
      ,[Definition]
  FROM [security].[RolesReporting]
WHERE  [RoleScope] = 'Server') AS SR1
ON [T1].[ServerId] = [SR1].[ServerId]
and 0 = [SR1].[DatabaseID]
and [t1].[RolePrincipalId] = [SR1].[PrincipalId]
LEFT OUTER JOIN 
(
SELECT
 [ServerId]
 ,[PrincipalId]
,[DatabaseID]
,[SystemName]
      ,[ReportingDescription]
      --,[Definition]
  FROM [security].[RolesReporting]
WHERE  [RoleScope] = 'Database'
) AS DBR1
ON [T1].[DBRPrincipalId] = [DBR1].[PrincipalId]
AND [T1].[DBRServerId] = [DBR1].[ServerId]
AND [T1].[DBRDatabaseId] = [DBR1].[DatabaseID]
LEFT OUTER JOIN 
(SELECT AC1S.ChangeTypeCd,AC1S.ChangeTypeShortDescription,AC1S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC1S
	WHERE AC1S.AuditScope = 'ADGMs')	AS AC1
ON [T1].[ADGMChangeTypeCd] = AC1.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC2S.ChangeTypeCd,AC2S.ChangeTypeShortDescription,AC2S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC2S
	WHERE AC2S.AuditScope = 'ADGroups') AS AC2
ON [T1].[ADGChangeTypeCd] = [AC2].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC3S.ChangeTypeCd,AC3S.ChangeTypeShortDescription,AC3S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC3S
	WHERE AC3S.AuditScope = 'ADUsers') AS AC3
ON [T1].[ADGMUChangeTypeCd] = [AC3].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC32S.ChangeTypeCd,AC32S.ChangeTypeShortDescription,AC32S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC32S
	WHERE AC32S.AuditScope = 'ADUsers') AS AC32
ON [T1].[ADUChangeTypeCd] = [AC3].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC4S.ChangeTypeCd,AC4S.ChangeTypeShortDescription,AC4S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC4S
	WHERE AC4S.AuditScope = 'DBRMs')	AS AC4
ON [T1].[DBRMChangeTypeCd] = AC4.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC5S.ChangeTypeCd,AC5S.ChangeTypeShortDescription,AC5S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC5S
	WHERE AC5S.AuditScope =  'DatabaseRoles') AS AC5
ON [T1].[DBRChangeTypeCd] = [AC5].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC6S.ChangeTypeCd,AC6S.ChangeTypeShortDescription,AC6S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC6S
	WHERE AC6S.AuditScope = 'DatabasePrincipals') AS AC6
ON [T1].[DBPChangeTypeCd] = [AC6].[ChangeTypeCd]
LEFT OUTER JOIN 
	(SELECT AC7S.ChangeTypeCd,AC7S.ChangeTypeShortDescription,AC7S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC7S
		WHERE AC7S.AuditScope = 'SRMs')	AS AC7
ON [T1].[SRMChangeTypeCd] = [AC7].[ChangeTypeCd]
INNER JOIN 
	(SELECT AC8S.ChangeTypeCd,AC8S.ChangeTypeShortDescription,AC8S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC8S
		WHERE AC8S.AuditScope = 'ServerRoles')	AS AC8
ON [T1].[SRChangeTypeCd] = AC8.[ChangeTypeCd]
INNER JOIN 
	(SELECT AC9S.ChangeTypeCd,AC9S.ChangeTypeShortDescription,AC9S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC9S
		WHERE AC9S.AuditScope = 'ServerPrincipals')	AS AC9
ON [T1].[SPChangeTypeCd] = AC9.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC10S.ChangeTypeCd,AC10S.ChangeTypeShortDescription,AC10S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC10S
	WHERE AC10S.AuditScope = 'ADGMs')	AS AC10
ON [T1].[SRMADGMChangeTypeCd] = AC10.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC11S.ChangeTypeCd,AC11S.ChangeTypeShortDescription,AC11S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC11S
	WHERE AC11S.AuditScope = 'ADGroups') AS AC11
ON [T1].[SRMADGChangeTypeCd]= [AC11].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC12S.ChangeTypeCd,AC12S.ChangeTypeShortDescription,AC12S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC12S
	WHERE AC12S.AuditScope = 'ADUsers') AS AC12
ON [T1].[SRMADUChangeTypeCd] = [AC12].[ChangeTypeCd]
INNER JOIN [security].[ETLProcessControl] AS E1
ON [S1].ETLProcessId = [E1].ETLProcessId
WHERE [S1].[IncludeInAuditingReportInd] = 1
AND [S1].[ProductionServerInd] = 0
ORDER BY [S1].[ServerReportingName],[DBRDatabaseId],[T1].[SRMADGroupMemberName], [T1].[ADsamAccountName] ,[SR1].[ReportingDescription],[T1].[DBPUserName],[DBR1].[ReportingDescription]



END
GO
/****** Object:  StoredProcedure [security].[usp_ETLProcessControl_ETLLoad]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [security].[usp_ETLProcessControl_ETLLoad] 
    @ProcessDt date
AS 
SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	DECLARE @PriorRecordInd INT
	SELECT @PriorRecordInd = ISNULL(MAX(ETLProcessId) ,0)
	FROM [security].[ETLProcessControl] 
	
	DECLARE @RecordInd bit = 0
	UPDATE [security].[ETLProcessControl] 
	SET [CurrentRecordsInd] = @RecordInd
	WHERE [ETLProcessId] = @PriorRecordInd
	
	SET @RecordInd = 1
	INSERT INTO [security].[ETLProcessControl] ([CurrentRecordsInd], [ProcessDt])
	SELECT @RecordInd, @ProcessDt
	
	-- Begin Return Select <- do not remove
	SELECT [ETLProcessId], [CurrentRecordsInd], [ProcessDt],@PriorRecordInd
	FROM   [security].[ETLProcessControl]
	WHERE  [ETLProcessId] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT
GO
/****** Object:  StoredProcedure [security].[usp_ETLProcesses_Ins]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************
Author: Danny Howell
Description: Standardized INSERT operation on ETLProcesses table.  Also sets the current record flag on the previous ETL process for this process group as not being current
Procedure standardizes operation for inserting records to the table.
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [security].[usp_ETLProcesses_Ins] (
@ETLProcessGroupID int,
@InitiatingJobName  NVARCHAR(128),
@ProcessFailedInd bit 

)
AS 
BEGIN
--Setting NOCOUNT ON removes the row count as output
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
BEGIN TRY
	BEGIN TRANSACTION COMPLETETRAN
	BEGIN TRANSACTION T1
		DECLARE @ProcessDt as DATE
		SET @ProcessDt = CAST(GETDATE() AS DATE)

		DECLARE @PriorRecordInd INT
		SELECT @PriorRecordInd = ISNULL(MAX(ETLProcessId) ,0)
		FROM [security].[ETLProcessControl]
		WHERE [ETLProcessGroupID] = @ETLProcessGroupID
			
		DECLARE @RecordInd bit
		SET @RecordInd = 0
		UPDATE [security].[ETLProcessControl]
		SET [CurrentRecordsInd] = @RecordInd
		WHERE [ETLProcessGroupID] = @ETLProcessGroupID
		and [ETLProcessId] = @PriorRecordInd
		COMMIT TRANSACTION T1

		SET @RecordInd = 1
	BEGIN TRANSACTION T2
		INSERT INTO [security].[ETLProcessControl]
		([ETLProcessGroupID]
		,[InitiatingJobName]
		,[ProcessDt]
		,[CurrentRecordsInd]
		,[ProcessFailedInd])
		VALUES
		(@ETLProcessGroupID
		,@InitiatingJobName
		,@ProcessDt
		,@RecordInd
		,cast(0 as bit))
	
		-- Begin Return Select <- do not remove

		SELECT [ETLProcessId]
		,[ETLProcessGroupID]
		,[InitiatingJobName]
		,[ProcessDt]
		,[CurrentRecordsInd]
		,[ProcessFailedInd]
		,@PriorRecordInd
		FROM [security].[ETLProcessControl]
		WHERE  [ETLProcessId] = SCOPE_IDENTITY()
		COMMIT TRANSACTION T2
	COMMIT TRANSACTION COMPLETETRAN

END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [security].[usp_ProductionReporting_ReportData]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [security].[usp_ProductionReporting_ReportData]
AS
BEGIN
--run procedure to create temp tables used for reporting data--for performance purposes of the report, temp tables will hold the data instead of generating the data at report run time
EXEC [security].[usp_Report_ADGMs];
EXEC [security].[usp_Report_ServerPrincipals];
EXEC [security].[usp_Report_DBRMs];

DECLARE @ExcludedDatabases TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @ExcludedDatabases (DatabaseName)
VALUES
('SSISDB')
INSERT INTO @ExcludedDatabases (DatabaseName)
VALUES
('KFBSQLMgmt')


IF EXISTS (SELECT * FROM tempdb.sys.objects where Type = 'U' and name like 'DBRMCTE')
BEGIN
DROP TABLE tempdb.dbo.dbrmcte
END
IF EXISTS (SELECT * FROM tempdb.sys.objects where Type = 'U' and name like 'SPWITHDBROLES')
BEGIN
DROP TABLE tempdb.dbo.SPWITHDBROLES
END

CREATE TABLE tempdb.dbo.dbrmcte 
--DECLARE [tempdb].[dbo].[dbrmcte] TABLE (
([DatabaseID] INT NOT NULL
,[DBPSid] VARBINARY(85) NULL
,[DatabasePrincipalsId] INT NOT NULL
,[DatabaseRolesId] INT NOT NULL
,[DBRServerId] INT NOT NULL
,[DBRDatabaseId] INT NOT NULL
,[DatabaseName] VARCHAR(128) NOT NULL
,[DBPUserName] VARCHAR(128) NOT NULL
,[DBRPrincipalId] INT NULL
,[DBRName] VARCHAR(128) NOT NULL
,[ADsamAccountName] VARCHAR(256) NULL
,[IsNestedADGroupInd] BIT NULL
,[userAccountDisabledInd] BIT NULL
,[ADGMChangeTypeCd] INT NULL
,[ADGChangeTypeCd] INT  NULL
,[ADGMUChangeTypeCd] INT NULL
,[ADUChangeTypeCd] INT NULL
,[DBRMChangeTypeCd] INT NOT NULL
,[DBRChangeTypeCd] INT NOT NULL
,[DBPChangeTypeCd] INT NOT NULL)


INSERT INTO [tempdb].[dbo].[dbrmcte] (
[DatabaseID] 
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[userAccountDisabledInd]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd])
SELECT 
[DB1].DatabaseID
,[DBRM1].[DBPSid]
,[DBRM1].[DatabasePrincipalsId]
,[DBRM1].[DatabaseRolesId]
,[DBRM1].[DBRServerId]
,[DBRM1].[DBRDatabaseId]
,[DB1].[DatabaseName]
,[DBRM1].[DBPUserName]
,[DBRM1].[DBRPrincipalId]
,[DBRM1].[DBRName]
,[ADGMCP1].[ADUsamAccountName]
,[ADGMCP1].[IsNestedGroupInd]
,[ADUCP1].[userAccountDisabledInd]
,[ADGMCP1].[ADGMChangeTypeCd]
,[ADGMCP1].[ADGChangeTypeCd]
,[ADGMCP1].[ADUChangeTypeCd]
,[ADUCP1].[ChangeTypeCd]
,[DBRM1].[DBRMChangeTypeCd] 
,[DBRM1].[DBRChangeTypeCd]
,[DBRM1].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tDBRM] as DBRM1
LEFT OUTER JOIN [security].[vw_ADUsers_CurrentETLProcessId] AS ADUCP1
ON [DBRM1].[DBPSid] = [ADUCP1].[sid]
LEFT OUTER JOIN [tempdb].[dbo].[tADGM] AS ADGMCP1 
ON [DBRM1].[DBPSid] = [ADGMCP1].[ADGSid]
INNER JOIN [security].[vw_Databases_CurrentETLProcessId] AS DB1
ON [DBRM1].[DBRServerId] = [DB1].[ServerId]
AND [DBRM1].[DBRDatabaseId] = [DB1].[DatabaseID]
WHERE [DB1].[DatabaseName] NOT IN (SELECT DatabaseName FROM @ExcludedDatabases)
AND [DB1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 1)


CREATE TABLE [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId] INT NOT NULL
,[ServerRoleId] INT NULL
,[AccessToAllDatabasesInd] BIT NOT NULL
,[GUId] VARBINARY(85) NULL
,[SysAdminInd] BIT NOT NULL
,[IsDisabledind] BIT NOT NULL
,[DeletedDomainAccountInd] BIT NOT NULL
,[ADAccountInd] BIT NOT NULL
,[CustomRoleInd] BIT NOT NULL
,[RolePrincipalId] INT NOT NULL
,[SRName] VARCHAR(128) NOT NULL
,[SPName] VARCHAR(256) NULL
,[SRMChangeTypeCd] INT NULL
,[SRChangeTypeCd] INT NULL
,[SPChangeTypeCd] INT NULL
,[SRMADGroupMemberName] VARCHAR(256) NULL
,[SRMADGMChangeTypeCd] INT NULL
,[SRMADGChangeTypeCd] INT NULL
,[SRMADUChangeTypeCd] INT NULL
,[DBPSid] VARBINARY(85) NULL
,[DatabasePrincipalsId] INT NULL
,[DatabaseRolesId] INT NULL
,[DBRServerId] INT NULL
,[DBRDatabaseId] INT NULL
,[DatabaseName] VARCHAR(128) NULL
,[DBPUserName] VARCHAR(256) NULL
,[DBRPrincipalId] INT NULL
,[DBRName] VARCHAR(128) NULL
,[ADsamAccountName] VARCHAR(256) NULL
,[IsNestedADGroupInd] BIT NULL
,[UserAccountDisabled] BIT NULL
,[ADGMChangeTypeCd] INT NULL
,[ADGChangeTypeCd] INT NULL
,[ADGMUChangeTypeCd] INT NULL
,[ADUChangeTypeCd] INT NULL
,[DBRMChangeTypeCd] INT NULL
,[DBRChangeTypeCd] INT NULL
,[DBPChangeTypeCd] INT NULL
);

INSERT INTO [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId]
,[ServerRoleId]
,[AccessToAllDatabasesInd]
,[GUId]
,[SysAdminInd]
,[IsDisabledind]
,[DeletedDomainAccountInd]
,[ADAccountInd]
,[CustomRoleInd]
,[RolePrincipalId]
,[SRName]
,[SPName]
,[SRMChangeTypeCd]
,[SRChangeTypeCd]
,[SPChangeTypeCd]
,[SRMADGroupMemberName]
,[SRMADGMChangeTypeCd]
,[SRMADGChangeTypeCd]
,[SRMADUChangeTypeCd]
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[UserAccountDisabled]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd]
)
-- Build and return the report data as a table
SELECT 
[SRM1].[ServerId]
,[SRM1].[ServerRoleId]
,[SRM1].[AccessToAllDatabasesInd]
,[SRM1].[GUId]
,[SRM1].[SysAdminInd]
,[SRM1].[IsDisabledind]
,[SRM1].[DeletedDomainAccountInd]
,[SRM1].[ADAccountInd]
,[SRM1].[CustomRoleInd]
,[SRM1].[RolePrincipalId]
,[SRM1].[SRName]
,[SRM1].[SPName]
,[SRM1].[SRMChangeTypeCd]
,[SRM1].[SRChangeTypeCd]
,[SRM1].[SPChangeTypeCd]
,NULL 
,NULL 
,NULL
,NULL
,[DBRMCTE].[DBPSid]
,[DBRMCTE].[DatabasePrincipalsId]
,[DBRMCTE].[DatabaseRolesId]
,[DBRMCTE].[DBRServerId]
,[DBRMCTE].[DBRDatabaseId]
,[DBRMCTE].[DatabaseName]
,[DBRMCTE].[DBPUserName]
,[DBRMCTE].[DBRPrincipalId]
,[DBRMCTE].[DBRName]
,[DBRMCTE].[ADsamAccountName]
,[DBRMCTE].[IsNestedADGroupInd]
,[DBRMCTE].[userAccountDisabledInd]
,[DBRMCTE].[ADGMChangeTypeCd]
,[DBRMCTE].[ADGChangeTypeCd]
,[DBRMCTE].[ADGMUChangeTypeCd]
,[DBRMCTE].[ADUChangeTypeCd]
,[DBRMCTE].[DBRMChangeTypeCd] 
,[DBRMCTE].[DBRChangeTypeCd]
,[DBRMCTE].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tSRMs] AS SRM1
INNER JOIN [tempdb].[dbo].[dbrmcte] as DBRMCTE 
ON [SRM1].[ServerId] = [DBRMCTE].[DBRServerId]
AND [SRM1].[SQLSid] = [DBRMCTE].[DBPSid]
WHERE [SRM1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 1)

INSERT INTO [tempdb].[dbo].[SPWITHDBROLES] (
[ServerId]
,[ServerRoleId]
,[AccessToAllDatabasesInd]
,[GUId]
,[SysAdminInd]
,[IsDisabledind]
,[DeletedDomainAccountInd]
,[ADAccountInd]
,[CustomRoleInd]
,[RolePrincipalId]
,[SRName]
,[SPName]
,[SRMChangeTypeCd]
,[SRChangeTypeCd]
,[SPChangeTypeCd]
,[SRMADGroupMemberName]
,[SRMADGMChangeTypeCd]
,[SRMADGChangeTypeCd]
,[SRMADUChangeTypeCd]
,[DBPSid]
,[DatabasePrincipalsId]
,[DatabaseRolesId]
,[DBRServerId]
,[DBRDatabaseId]
,[DatabaseName]
,[DBPUserName]
,[DBRPrincipalId]
,[DBRName]
,[ADsamAccountName]
,[IsNestedADGroupInd]
,[UserAccountDisabled]
,[ADGMChangeTypeCd]
,[ADGChangeTypeCd]
,[ADGMUChangeTypeCd]
,[ADUChangeTypeCd]
,[DBRMChangeTypeCd]
,[DBRChangeTypeCd]
,[DBPChangeTypeCd]
)
-- Build and return the report data as a table
SELECT 
[SRM1].[ServerId]
,[SRM1].[ServerRoleId]
,[SRM1].[AccessToAllDatabasesInd]
,[SRM1].[GUId]
,[SRM1].[SysAdminInd]
,[SRM1].[IsDisabledind]
,[SRM1].[DeletedDomainAccountInd]
,[SRM1].[ADAccountInd]
,[SRM1].[CustomRoleInd]
,[SRM1].[RolePrincipalId]
,[SRM1].[SRName]
,[SRM1].[SPName]
,[SRM1].[SRMChangeTypeCd]
,[SRM1].[SRChangeTypeCd]
,[SRM1].[SPChangeTypeCd]
,[SPADGM1].[ADUsamAccountName] 
,[SPADGM1].[ADGMChangeTypeCd]
,[SPADGM1].[ADGChangeTypeCd]
,[SPADGM1].[ADUChangeTypeCd]
,[DBRMCTE].[DBPSid]
,[DBRMCTE].[DatabasePrincipalsId]
,[DBRMCTE].[DatabaseRolesId]
,[DBRMCTE].[DBRServerId]
,ISNULL([DBRMCTE].[DBRDatabaseId],0)
,[DBRMCTE].[DatabaseName]
,[DBRMCTE].[DBPUserName]
,[DBRMCTE].[DBRPrincipalId]
,[DBRMCTE].[DBRName]
,[DBRMCTE].[ADsamAccountName]
,[DBRMCTE].[IsNestedADGroupInd]
,[DBRMCTE].[userAccountDisabledInd]
,[DBRMCTE].[ADGMChangeTypeCd]
,[DBRMCTE].[ADGChangeTypeCd]
,[DBRMCTE].[ADGMUChangeTypeCd]
,[DBRMCTE].[ADUChangeTypeCd]
,[DBRMCTE].[DBRMChangeTypeCd] 
,[DBRMCTE].[DBRChangeTypeCd]
,[DBRMCTE].[DBPChangeTypeCd]
FROM [tempdb].[dbo].[tSRMs] AS SRM1
LEFT OUTER JOIN [tempdb].[dbo].[tADGM] AS SPADGM1
ON [SRM1].[GUId] = [SPADGM1].[ADGroupGuid]
LEFT OUTER JOIN [tempdb].[dbo].[dbrmcte] as DBRMCTE 
ON [SRM1].[ServerId] = [DBRMCTE].[DBRServerId]
AND [SRM1].[SQLSid] = [DBRMCTE].[DBPSid]
WHERE [DBRMCTE].[DBPSid] IS NULL
AND [SRM1].[ServerId] IN (SELECT [ServerId] FROM [security].[Servers] WHERE [ProductionServerInd] = 1)

SELECT
s1.ServerName AS ServerName
,[S1].ServerReportingName AS ServerReportingName
,[E1].ETLProcessId
,[E1].ProcessDt AS ETLLoadDate
,[T1].[ServerId] AS ServerId
,[T1].[ServerRoleId] AS ServerRoleId
,(ISNULL(ABS([T1].[IsDisabledind]),0) +
ISNULL(ABS([T1].[DeletedDomainAccountInd]),0) + 
ISNULL(ABS([T1].[IsNestedADGroupInd]),0) + 
isnull(ABS([T1].[UserAccountDisabled]),0) )  AS ActionRequiredInd
,[T1].[AccessToAllDatabasesInd] AS AccesstoAllDatabasesInd
,[T1].[SysAdminInd] AS SysAdminInd
,[T1].[IsDisabledind] AS IsDisabledInd
,[T1].[DeletedDomainAccountInd] AS DeletedDomainAccountInd
,isnull([T1].[UserAccountDisabled],0) as userAccountDisabled
,[T1].[SRName]
,ISNULL([SR1].[SystemName],'Need Description') AS SRName
,ISNULL([SR1].ReportingDescription,'Need Description') AS SRReportingName
,[T1].[SPName] AS SPName
,[T1].[SRMADGroupMemberName] AS SRADGroupMemberName
,[T1].[DBRDatabaseId] as DatabaseId
,ISNULL([T1].[DatabaseName],'No access to any database') as DatabaseName
,[T1].[DBPUserName] AS DBPUserName
,[T1].[DBRPrincipalId]
,[T1].[DBRServerId]
,[T1].[DBRDatabaseId]
,[T1].[DBRName]
,CASE WHEN [T1].[DatabaseName] IS NULL THEN 'Not Applicable' ELSE ISNULL([DBR1].[SystemName],'Role for ID ' + cast([T1].[DBRPrincipalId] as varchar(6)) + ' Name: ' + [T1].[DBRName] + 'Needs to be added to RolesTable') END AS DBRName
,CASE WHEN [T1].[DatabaseName] IS NULL THEN 'Not Applicable' ELSE ISNULL([DBR1].ReportingDescription,'Need Description') END AS DBRReportingName
,ISNULL([T1].[IsNestedADGroupInd],0) AS IsNestedADGroupInd
,[T1].[ADsamAccountName] as DBPsamAccountName
,(ISNULL(ABS([T1].[SRMChangeTypeCd]),0)  
	+ISNULL(ABS([T1].[SRChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SPChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADGMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADGChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[SRMADUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADGMUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[ADUChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBRMChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBRChangeTypeCd]),0)
	+ ISNULL(ABS([T1].[DBPChangeTypeCd]),0)) AS AccountChangeInd
,(
ISNULL([AC7].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC8].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC9].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC10].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC11].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC12].ChangeTypeReportingDescription + ';','')
) as SPChangeTypeDesc
,(
ISNULL([AC4].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC5].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC6].ChangeTypeReportingDescription + ';','')  +
	ISNULL([AC1].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC2].ChangeTypeReportingDescription + ';','') + 
	ISNULL([AC3].ChangeTypeReportingDescription + ';','') +
	ISNULL([AC32].ChangeTypeReportingDescription + ';','')
) AS DBADChangeTypeDesc
FROM [tempdb].[dbo].[SPWITHDBROLES] AS T1
INNER JOIN [security].[Servers] AS S1
ON [T1].[ServerId] = [s1].[ServerId]
LEFT OUTER JOIN 
(
SELECT 
[SystemName]
,[ReportingDescription]
,[Definition]
FROM [security].[vw_RolesReporting]
WHERE  [RoleScope] = 'Server') AS SR1
ON [T1].[SRName] = [SR1].[SystemName]
LEFT OUTER JOIN 
(
SELECT 
[SystemName]
,[ReportingDescription]
,[Definition]
FROM [security].[vw_RolesReporting]
WHERE  [RoleScope] = 'Database'
) AS DBR1
ON [T1].[DBRName] = [DBR1].[SystemName]
LEFT OUTER JOIN 
(SELECT AC1S.ChangeTypeCd,AC1S.ChangeTypeShortDescription,AC1S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC1S
	WHERE AC1S.AuditScope = 'ADGMs')	AS AC1
ON [T1].[ADGMChangeTypeCd] = AC1.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC2S.ChangeTypeCd,AC2S.ChangeTypeShortDescription,AC2S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC2S
	WHERE AC2S.AuditScope = 'ADGroups') AS AC2
ON [T1].[ADGChangeTypeCd] = [AC2].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC3S.ChangeTypeCd,AC3S.ChangeTypeShortDescription,AC3S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC3S
	WHERE AC3S.AuditScope = 'ADUsers') AS AC3
ON [T1].[ADGMUChangeTypeCd] = [AC3].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC32S.ChangeTypeCd,AC32S.ChangeTypeShortDescription,AC32S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC32S
	WHERE AC32S.AuditScope = 'ADUsers') AS AC32
ON [T1].[ADUChangeTypeCd] = [AC3].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC4S.ChangeTypeCd,AC4S.ChangeTypeShortDescription,AC4S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC4S
	WHERE AC4S.AuditScope = 'DBRMs')	AS AC4
ON [T1].[DBRMChangeTypeCd] = AC4.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC5S.ChangeTypeCd,AC5S.ChangeTypeShortDescription,AC5S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC5S
	WHERE AC5S.AuditScope =  'DatabaseRoles') AS AC5
ON [T1].[DBRChangeTypeCd] = [AC5].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC6S.ChangeTypeCd,AC6S.ChangeTypeShortDescription,AC6S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC6S
	WHERE AC6S.AuditScope = 'DatabasePrincipals') AS AC6
ON [T1].[DBPChangeTypeCd] = [AC6].[ChangeTypeCd]
LEFT OUTER JOIN 
	(SELECT AC7S.ChangeTypeCd,AC7S.ChangeTypeShortDescription,AC7S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC7S
		WHERE AC7S.AuditScope = 'SRMs')	AS AC7
ON [T1].[SRMChangeTypeCd] = [AC7].[ChangeTypeCd]
INNER JOIN 
	(SELECT AC8S.ChangeTypeCd,AC8S.ChangeTypeShortDescription,AC8S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC8S
		WHERE AC8S.AuditScope = 'ServerRoles')	AS AC8
ON [T1].[SRChangeTypeCd] = AC8.[ChangeTypeCd]
INNER JOIN 
	(SELECT AC9S.ChangeTypeCd,AC9S.ChangeTypeShortDescription,AC9S.ChangeTypeReportingDescription
		FROM [security].[AuditingChangeCodes] AS AC9S
		WHERE AC9S.AuditScope = 'ServerPrincipals')	AS AC9
ON [T1].[SPChangeTypeCd] = AC9.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC10S.ChangeTypeCd,AC10S.ChangeTypeShortDescription,AC10S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC10S
	WHERE AC10S.AuditScope = 'ADGMs')	AS AC10
ON [T1].[SRMADGMChangeTypeCd] = AC10.[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC11S.ChangeTypeCd,AC11S.ChangeTypeShortDescription,AC11S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC11S
	WHERE AC11S.AuditScope = 'ADGroups') AS AC11
ON [T1].[SRMADGChangeTypeCd]= [AC11].[ChangeTypeCd]
LEFT OUTER JOIN 
(SELECT AC12S.ChangeTypeCd,AC12S.ChangeTypeShortDescription,AC12S.ChangeTypeReportingDescription
	FROM [security].[AuditingChangeCodes] AS AC12S
	WHERE AC12S.AuditScope = 'ADUsers') AS AC12
ON [T1].[SRMADUChangeTypeCd] = [AC12].[ChangeTypeCd]
INNER JOIN [security].[ETLProcessControl] AS E1
ON [S1].ETLProcessId = [E1].ETLProcessId
WHERE [S1].[IncludeInAuditingReportInd] = 1
AND [S1].[ProductionServerInd] = 1
ORDER BY 
[S1].[ServerReportingName]
,[DBRDatabaseId]
,[T1].[SRMADGroupMemberName]
, [T1].[ADsamAccountName] 
--,[SR1].[ReportingDescription]
,[T1].[DBPUserName]
--,[DBR1].[ReportingDescription]



END
GO
/****** Object:  StoredProcedure [security].[usp_Report_ADGMs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/* *************************************************************************
Author: Danny Howell
Description: procedure creates the data set of ADGroups, ADUsers, and ADGroupMember changes with changes made in the most recent load.
--All ADGroups with flags indicating groups added, unchanged or deleted
--All ADUsers with flags indicating users added, unchanged or deleted
--All ADGroupMembers with flags indicating users that have been added, unchanged or deleted from a group (includes users deleted because the group was deleted)
This procedure depends upon several views which limit the group types to SECURITY groups only and members of a group that are either users or nested SECURITY groups.
Because the ADGM table only loads SECURITY groups, no DISTRIBUTION groups or their members are included.
However, because the ADGroups table does include BOTH SECURITY AND DISTRIBUTION groups, several views and sub-queries are required to correctly report the nested group membership
As of the time of this procedure's authoring, there is no attempt to iteratively retrieve nested group membership.  Groups as a member of another group are simply reported as members of the parent group.
**************************************************************************/
CREATE PROCEDURE [security].[usp_Report_ADGMs]
AS
BEGIN
SET NOCOUNT ON;

--STEP 1: Create temporary table of ADGroupMember changes for use by later queries 
IF NOT EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] = 'tADGM' and [TYPE] like 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
CREATE TABLE tempdb.dbo.tADGM (
ADGroupGuid UNIQUEIDENTIFIER NOT NULL
,ADUsersGuid UNIQUEIDENTIFIER NOT NULL
,[IsNestedGroupInd] BIT NOT NULL
,ADGMChangeTypeCd INT NOT NULL
,ADGSid VARBINARY(85) NOT NULL
,ADGsamAccountName VARCHAR(256) NOT NULL
,ADGChangeTypeCd INT NOT NULL
,ADUSid VARBINARY(85) NOT NULL
,ADUsamAccountName VARCHAR(256) NOT NULL
,ADUChangeTypeCd INT NOT NULL
)
END
ELSE
BEGIN
TRUNCATE TABLE tempdb.dbo.tADGM
END

--STEP 2: --because these are full history tables, changes are determined using SQL INTERSECT and EXCEPT functions on the view of current and prior ADGM ETL processes.  Create a temporary table to hold the ADGM state
IF NOT EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] = 'tADGMChanges' and [TYPE] like 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
CREATE TABLE tempdb.dbo.tADGMChanges
(
[ADGroupGuid] UNIQUEIDENTIFIER NOT NULL
,[ADUsersGuid] UNIQUEIDENTIFIER NOT NULL
,[MostRecentADGroupId] INT NULL
,[MostRecentADUserId] INT NULL
,[IsNestedGroupInd] BIT NOT NULL
,[ADGMChangeTypeCd] INT NOT NULL)
END
ELSE
BEGIN 
TRUNCATE TABLE tempdb.dbo.tADGMChanges
END

-- With the nature of the ADGM table being a history table, and the ADGroups/ADUsers tables being slowly changing dimension tables, the ADGM records the AD Group/AD User ID at the time of ETL load.  But due to this, historical changes in the AD Groups/Users incorrectly appear as deletions/adds to the ADGM due to those tables creating a new record on a historical value changes.  To account for these differences, the ADGM table must compare current and prior based upon the GUID (which does not change) on a historical record change instead of the ADGroupId/ADUserId key value. However, the ADGroupsID and ADUserId keys are needed to join to those tables.  So create the ADGM changes using GUIDs, then populate the temp table with the most recent (max) ID from their respective tables.

DECLARE @ChangeTypeCd int
SET @ChangeTypeCd = 0
INSERT INTO tempdb.dbo.tADGMChanges ([ADGroupGuid],[ADUsersGuid],[IsNestedGroupInd],[ADGMChangeTypeCd])
SELECT [ADGroupGUID]
      ,[ADUsersGuid]
      ,[IsNestedGroupInd]
      ,@ChangeTypeCd
FROM [security].[vw_ADGroupMembers_CurrentETLProcessId]
WHERE [ETLProcessStartID] <> [ETLProcessEndID]


SET @ChangeTypeCd = 1
INSERT INTO tempdb.dbo.tADGMChanges ([ADGroupGuid],[ADUsersGuid],[IsNestedGroupInd],[ADGMChangeTypeCd])
SELECT [ADGroupGUID]
      ,[ADUsersGuid]
      ,[IsNestedGroupInd]
      ,@ChangeTypeCd
FROM [security].[vw_ADGroupMembers_CurrentETLProcessId]
WHERE [ETLProcessStartID] = [ETLProcessEndID]

SET @ChangeTypeCd = -1
INSERT INTO tempdb.dbo.tADGMChanges ([ADGroupGuid],[ADUsersGuid],[IsNestedGroupInd],[ADGMChangeTypeCd])
SELECT [ADGroupGUID]
      ,[ADUsersGuid]
      ,[IsNestedGroupInd]
      ,@ChangeTypeCd
FROM [security].[vw_ADGroupMembers_PriorETLProcessId]


--Although uniqueness of records using the GUIDs so to find deletes and additions, the tables' ADGroupID and ADUsersId fields are still required to join to their respective tables.  the relevant information from the ADGroups and ADUsers tables are the most recent historical record (SCDCurrentRecordInd = 1) which is best found obtaining the Maximum ID value in each table

--update AD groups with their most recent ADGroupId
UPDATE tempdb.dbo.tADGMChanges 
SET [MostRecentADGroupId] = T3.[MaxADGroupId]
FROM [tempdb].[dbo].[tADGMChanges] as T1
INNER JOIN 
	(SELECT [Guid], MAX([ADGroupId]) AS MaxADGroupId FROM [security].[ADGroups] GROUP BY [guid]) as T3
ON T1.ADGroupGuid = T3.[GUId]


--update AD Users group members; need to restrict the updates to the proper type determined by IsNestedGroupInd 
--only update the ADUserID field for users where the group member is NOT a nested group
UPDATE tempdb.dbo.tADGMChanges 
SET [MostRecentADUserId] = T2.[MaxADUserId]
FROM [tempdb].[dbo].[tADGMChanges] as T1
INNER JOIN 
	(SELECT [Guid], MAX([ADUsersId]) AS MaxADUserId FROM [security].[ADUsers] GROUP BY [guid]) AS T2
ON T1.ADUsersGuid = T2.[GUId]
WHERE [IsNestedGroupInd] = 0

--update AD groups as nested groups
--only update the ADUserID field for groups where the group member is a nested group
UPDATE tempdb.dbo.tADGMChanges 
SET [MostRecentADUserId] = T3.[MaxADGroupId]
FROM [tempdb].[dbo].[tADGMChanges] as T1
INNER JOIN 
	(SELECT [Guid], MAX([ADGroupId]) AS MaxADGroupId FROM [security].[ADGroups] GROUP BY [guid]) as T3
ON T1.ADUsersGuid = T3.[GUId]
WHERE [IsNestedGroupInd] = 1


--Here is the most complicated portion of the stored procedure and it is primarily due nested groups membership and to the fact that both the ADGroups and ADUsers table use a sequential primary key.
--Because both tables use an auto-increment field as the PK which is used in joins, the same integer value for a group member could exist in both the ADUsers' table and the ADGroups table.  A simple join between tADGMChanges and ADGroups when getting nested groups results in join errors if scope of the join is not limited.  This is accomplished using the sub-select statements on the tADGMChanges queries when joining it to the proper table when getting group members.
INSERT INTO [tempdb].[dbo].[tADGM]
           ([ADGroupGuid]
           ,[ADUsersGuid]
           ,[IsNestedGroupInd]
           ,[ADGMChangeTypeCd]
           ,[ADGSid]
           ,[ADGsamAccountName]
           ,[ADGChangeTypeCd]
           ,[ADUSid]
           ,[ADUsamAccountName]
           ,[ADUChangeTypeCd])
SELECT 
[adgms1].ADGroupGuid
,[ADGMs1].ADUsersGuid
,[ADGMs1].[IsNestedGroupInd]
,[ADGMs1].[ADGMChangeTypeCd]
,[ADGCPId].[sid] AS ADGSid
,[ADGCPid].samAccountName as ADGsamAccountName
,[ADGCPid].[ChangeTypeCd] as ADGChangeTypeCd
,[ADUCPId].[sid] AS ADUSid
,([ADUCPId].[cn] + ' (' + [ADUCPId].[samAccountName] + ')') AS ADUsamAccountName
,[ADUCPId].[ChangeTypeCd] AS ADUChangeTypeCd
--FROM [security].[vw_ADGroups_CurrentETLProcessID] AS ADGCPId
FROM [security].[ADGroups] AS ADGCPId
INNER JOIN
(
SELECT 
	 [ADGroupGuid]
      ,[ADUsersGuid]
      ,[MostRecentADGroupId]
      ,[MostRecentADUserId]
      ,[IsNestedGroupInd]
      ,[ADGMChangeTypeCd]
	FROM [tempdb].[dbo].[tADGMChanges]
	WHERE [IsNestedGroupInd] = 0
) AS ADGMs1
ON [ADGMs1].[MostRecentADGroupId] = [ADGCPId].[ADGroupId]
--INNER JOIN [security].[vw_ADUsers_CurrentETLProcessId] AS ADUCPId
INNER JOIN 
(
SELECT 
T1.[ADUsersId]
,[T1].[sid]
,[t1].[cn]
,[T1].[samAccountName]
,[T1].[ChangeTypeCd]
FROM  [security].[ADUsers] AS T1
INNER JOIN 
	(SELECT GUID, MAX(ADUsersId) as MostRecentADUID
	FROM  [security].[ADUsers]
	GROUP BY GUID) AS T2
ON T1.GUId = T2.GUId
AND T1.ADUsersId = T2.MostRecentADUID
--select * from [security].[ADUsers]
) AS ADUCPId
ON [ADGMs1].[MostRecentADUserId] = [ADUCPId].[ADUsersId]

INSERT INTO [tempdb].[dbo].[tADGM]
           ([ADGroupGuid]
           ,[ADUsersGuid]
           ,[IsNestedGroupInd]
           ,[ADGMChangeTypeCd]
           ,[ADGSid]
           ,[ADGsamAccountName]
           ,[ADGChangeTypeCd]
           ,[ADUSid]
           ,[ADUsamAccountName]
           ,[ADUChangeTypeCd])
SELECT 
[adgms1].ADGroupGuid
,[ADGMs1].ADUsersGuid
,[ADGMs1].[IsNestedGroupInd]
,[ADGMs1].[ADGMChangeTypeCd]
,[ADGCPId].[sid] AS ADGSid
,[ADGCPid].samAccountName as ADGsamAccountName
,[ADGCPid].[ChangeTypeCd] as ADGChangeTypeCd
,[ADUCPId].[sid] AS ADUSid
,[ADUCPId].[samAccountName] AS ADUsamAccountName
,[ADUCPId].[ChangeTypeCd] AS ADUChangeTypeCd
--FROM [security].[vw_ADGroups_CurrentETLProcessID] AS ADGCPId
FROM [security].[ADGroups] AS ADGCPId
INNER JOIN  
(SELECT 
	 [ADGroupGuid]
      ,[ADUsersGuid]
      ,[MostRecentADGroupId]
      ,[MostRecentADUserId]
      ,[IsNestedGroupInd]
      ,[ADGMChangeTypeCd]
	FROM [tempdb].[dbo].[tADGMChanges]
	WHERE [IsNestedGroupInd] = 1
)AS ADGMs1
ON [ADGMs1].[MostRecentADGroupId] = [ADGCPId].[ADGroupId]
--INNER JOIN [security].[vw_ADGroups_CurrentETLProcessID] AS ADUCPId
INNER JOIN 
(
SELECT 
[T1].[ADGroupId]
,[T1].[sid]
,[T1].[samAccountName]
,[T1].[ChangeTypeCd]
FROM  [security].[ADGroups] AS T1
INNER JOIN 
	(SELECT GUID, MAX(ADGroupId) as MostRecentADGID
	FROM  [security].[ADGroups]
	GROUP BY GUID) AS T2
ON T1.GUId = T2.GUId
AND T1.ADGroupId = T2.MostRecentADGID
) AS ADUCPId
ON [ADGMs1].[MostRecentADUserId] = [ADUCPId].[ADGroupId]

END
GO
/****** Object:  StoredProcedure [security].[usp_Report_DBRMs]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/* *************************************************************************
Author: Danny Howell
Description: procedure creates the data set of DatabaseRoles, DatabasePrincipals and DatabaseRoleMember changes with changes made in the most recent load.
--All DBRoles with flags indicating groups added, unchanged or deleted
--All DBPrinciapls with flags indicating users added, unchanged or deleted
--All DBRoleMembers with flags indicating users that have been added, unchanged or deleted from a group (includes users deleted because the group was deleted)
This procedure is written unquely for reporting database users and their database roles for reporting the current security configuration for servers and databases subject to reporting and auditing.  Because of the KFBSQLMgmt ETL load and structure, server principals that have elevated privleges (i.e. those server principals assigned to roles that have access to ALL databases) are also added to the database principals indicating their 'inherited' database permissions.

The procedure below does NOT create an additional entry for the 'public' role for those principals that have an explicit, non-public role assigned.  Since every DB user is automatically assigned the public role in addition to its' explicit database role, adding another entry for these principals for their 'public' role is extraneous.

NOTE: it is standard KFB practice and recommended SQL Best Practices to NOT change the permissions of the system 'public' role to grant any permissions on any securable other than those set by default.  In other words, the 'public' role should only be granted the rights as set by the default Microsoft granted rights as described 
https://msdn.microsoft.com/en-us/library/ms181127.aspx.  By default, this role has NO permissions to any user defined object and has READ only access to certain system object.
**************************************************************************/
CREATE PROCEDURE [security].[usp_Report_DBRMs]
AS
BEGIN
SET NOCOUNT ON;

----STEP 1: Create temporary table of ADGroupMember changes for use by later queries 
--Create the table that will ultimately hold the database role members
IF NOT EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] = 'tDBRM' and [TYPE] like 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
CREATE TABLE tempdb.dbo.tDBRM 
(
[DatabasePrincipalsId] INT NOT NULL
,[DatabaseRolesId] INT NOT NULL
,[DBRMChangeTypeCd] INT NOT NULL
,[DBRServerId] INT NOT NULL
,[DBRDatabaseId] INT NULL
,[DBRPrincipalId] INT NOT NULL
,[InheritedServerRoleInd] BIT NULL
,[DBRName] VARCHAR(128) NOT NULL
,[DBRModifyDt] DATETIME NULL
,[DBRChangeTypeCd] INT NOT NULL
,[DBPSid] VARBINARY(85) NULL
,[DBPUserName] VARCHAR(128) NULL
,[DBPModifyDt] DATETIME NULL
,[DBPChangeTypeCd] INT NOT NULL
)
END
ELSE
BEGIN
TRUNCATE TABLE tempdb.dbo.tDBRM
END

--STEP 2: --because these are full history tables, changes are determined using SQL INTERSECT and EXCEPT functions on the view of current and prior ADGM ETL processes.  Create a temporary table to hold the ADGM state
IF NOT EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] = 'tDBRMChanges' and [TYPE] like 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
CREATE TABLE tempdb.dbo.tDBRMChanges
(
[DatabasePrincipalsId] INT NOT NULL
,[DatabaseRolesId] INT NOT NULL
,DBRMChangeTypeCd INT NOT NULL
)
END
ELSE
BEGIN 
TRUNCATE TABLE tempdb.dbo.tDBRMChanges
END

-- With the nature of the ADGM table being a history table, and the ADGroups/ADUsers tables being slowly changing dimension tables, the ADGM records the AD Group/AD User ID at the time of ETL load.  But due to this, historical changes in the AD Groups/Users incorrectly appear as deletions/adds to the ADGM due to those tables creating a new record on a historical value changes.  To account for these differences, the ADGM table must compare current and prior based upon the GUID (which does not change) on a historical record change instead of the ADGroupId/ADUserId key value. However, the ADGroupsID and ADUserId keys are needed to join to those tables.  So create the ADGM changes using GUIDs, then populate the temp table with the most recent (max) ID from their respective tables.

DECLARE @ChangeTypeCd int
SET @ChangeTypeCd = 0
INSERT INTO [tempdb].[dbo].[tDBRMChanges] ([DatabasePrincipalsId],[DatabaseRolesId],[DBRMChangeTypeCd])
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_CurrentETLProcessId]
INTERSECT
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_PriorETLProcessId]


SET @ChangeTypeCd = 1
INSERT INTO [tempdb].[dbo].[tDBRMChanges] ([DatabasePrincipalsId],[DatabaseRolesId],[DBRMChangeTypeCd])
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_CurrentETLProcessId]
EXCEPT
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_PriorETLProcessId]


SET @ChangeTypeCd = -1
INSERT INTO [tempdb].[dbo].[tDBRMChanges] ([DatabasePrincipalsId],[DatabaseRolesId],[DBRMChangeTypeCd])
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_PriorETLProcessId]
EXCEPT
SELECT [DatabasePrincipalsId]
      ,[DatabaseRolesId]
      ,@ChangeTypeCd
FROM [security].[vw_DatabaseRoleMembers_CurrentETLProcessId]

--Although uniqueness of records using the GUIDs so to find deletes and additions, the tables' ADGroupID and ADUsersId fields are still required to join to their respective tables.  the relevant information from the ADGroups and ADUsers tables are the most recent historical record (SCDCurrentRecordInd = 1) which is best found obtaining the Maximum ID value in each table


--Here is the most complicated portion of the stored procedure and it is primarily due nested groups membership and to the fact that both the ADGroups and ADUsers table use a sequential primary key.
--Because both tables use an auto-increment field as the PK which is used in joins, the same integer value for a group member could exist in both the ADUsers' table and the ADGroups table.  A simple join between tDBRMChanges and ADGroups when getting nested groups results in join errors if scope of the join is not limited.  This is accomplished using the sub-select statements on the tDBRMChanges queries when joining it to the proper table when getting group members.

INSERT INTO [tempdb].[dbo].[tDBRM]
           ([DatabasePrincipalsId]
           ,[DatabaseRolesId]
           ,[DBRMChangeTypeCd]
           ,[DBRServerId]
           ,[DBRDatabaseId]
           ,[DBRPrincipalId]
		 ,[InheritedServerRoleInd]
           ,[DBRName]
           ,[DBRModifyDt]
           ,[DBRChangeTypeCd]
           ,[DBPSid]
           ,[DBPUserName]
           ,[DBPModifyDt]
           ,[DBPChangeTypeCd])
SELECT 
[DBRMs1].[DatabasePrincipalsId]
,[DBRMs1].[DatabaseRolesId]
,[DBRMs1].[DBRMChangeTypeCd]
,[DBRCP1].[ServerId] as DBRServerId
,[DBRCP1].[DatabaseID] as DBRDatabaseId
,[DBRCP1].[PrincipalId] AS DBRPrincipalId
,0
,[DBRCP1].[Name] AS DBRName
,[DBRCP1].[ModifyDt] AS DBRModifyDt
,[DBRCP1].[ChangeTypeCd] as DBRChangeTypeCd
,[DBPCP1].[SID] as DBPSid
,[DBPCP1].[UserName] as DBPUserName
,[DBPCP1].[ModifyDt] as DBPModifyDt
,[DBPCP1].[ChangeTypeCd] as DBPChangeTypeCd
FROM  [tempdb].[dbo].[tDBRMChanges] as DBRMs1
INNER JOIN  [security].[vw_DatabaseRoles_CurrentETLProcessId] AS DBRCP1
ON [DBRMs1].[DatabaseRolesId] = [DBRCP1].[DatabaseRolesId]
INNER JOIN [security].[vw_DatabasePrincipals_CurrentETLProcessId] AS DBPCP1
ON [DBRMs1].[DatabasePrincipalsId] = [DBPCP1].[DatabasePrincipalsId]

--add the database principals for each database that do not have an explicitly assigned role other than public
INSERT INTO [tempdb].[dbo].[tDBRM]
      ([DatabasePrincipalsId]
           ,[DatabaseRolesId]
           ,[DBRMChangeTypeCd]
           ,[DBRServerId]
           ,[DBRDatabaseId]
           ,[DBRPrincipalId]
		 ,[InheritedServerRoleInd]
           ,[DBRName]
           ,[DBRModifyDt]
           ,[DBRChangeTypeCd]
           ,[DBPSid]
           ,[DBPUserName]
           ,[DBPModifyDt]
           ,[DBPChangeTypeCd])
SELECT 
[DBPCP2].[DatabasePrincipalsId] as DBRDatabasePrincipalsId
,0 AS [DatabaseRolesId]
,0 AS [DBRMChangeTypeCd]
,[DBPCP2].[ServerId] as DBRServerId
,[DBPCP2].[DatabaseID]  as DBRDatabaseId
,0 AS DBRPrincipalId
,0
,'public' AS DBRName
,NULL AS DBRModifyDt
,0 as DBRChangeTypeCd
,[DBPCP2].[SID] as DBPSid
,[DBPCP2].[UserName] as DBPUserName
,[DBPCP2].[ModifyDt] as DBPModifyDt
,[DBPCP2].[ChangeTypeCd] as DBPChangeTypeCd
 FROM [security].[vw_DatabasePrincipals_CurrentETLProcessId] AS DBPCP2
LEFT OUTER JOIN tempdb.dbo.tDBRMChanges as T2
ON [DBPCP2].[DatabasePrincipalsId] = [T2].[DatabasePrincipalsId]
WHERE [T2].[DatabasePrincipalsId] IS NULL

-- add the server principals who are members of Server Roles that have access to all databases
INSERT INTO [tempdb].[dbo].[tDBRM]
           ([DatabasePrincipalsId]
           ,[DatabaseRolesId]
           ,[DBRMChangeTypeCd]
           ,[DBRServerId]
           ,[DBRDatabaseId]
           ,[DBRPrincipalId]
		 ,[InheritedServerRoleInd]
           ,[DBRName]
           ,[DBRModifyDt]
           ,[DBRChangeTypeCd]
           ,[DBPSid]
           ,[DBPUserName]
           ,[DBPModifyDt]
           ,[DBPChangeTypeCd])
SELECT 
0
,0
,[tSRMs].[SPChangeTypeCd]
,[tSRMs].[ServerId]
,[DB1].DatabaseID
,[tSRMs].[ServerRoleId]
,1
,[tSRMs].[SRName]
,[tSRMs].[SRModifyDt] --'Need Modified dt'
,[tSRMs].[SRChangeTypeCd]
,[tSRMs].[SQLSid]
,[tSRMs].[SPName]
,NULL --'need server princ modify dt'
,[tSRMs].[SPChangeTypeCd]
FROM [tempdb].[dbo].[tSRMs] as tSRMs
FULL OUTER JOIN [security].[vw_Databases_CurrentETLProcessId] AS DB1
ON tSRMs.[ServerId] = [DB1].[ServerId]
where AccessToAllDatabasesInd = 1





END
GO
/****** Object:  StoredProcedure [security].[usp_Report_ServerPrincipals]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/* *************************************************************************
Author: Danny Howell
Description: procedure creates the data set of server principals with what they are currently and the changes since the last report--what server principals there are and what changes were made since the last report. Since this is an audit report, the report must return the current server principals (SPs) with the change since prior ETL load
along with SPs that existed on the prior report who's rights have been revoked.
This is provided through the vw_ServerPrincipals_CurrentETLProcessId

Description: procedure creates the data set of Server Roles, Server Principals and Server Role Member changes with changes made in the most recent load.
--All Server Roles with flags indicating groups added, unchanged or deleted
--All Server Princiapls with flags indicating users added, unchanged or deleted
--All Server RoleMembers with flags indicating users that have been added, unchanged or deleted from a group (includes users deleted because the group was deleted)
This procedure is written unquely for reporting database users and their server roles for reporting the current security configuration for servers and databases subject to reporting and auditing.  Because of the KFBSQLMgmt ETL load and structure, server principals that have elevated privleges (i.e. those server principals assigned to roles that have access to ALL databases) are also added to the database principals indicating their 'inherited' database permissions.

The procedure below does NOT create an additional entry for the 'public' role for those principals that have an explicit, non-public role assigned.  Since every server login is automatically assigned the public role in addition to its' explicit server role, adding another entry for these principals for their 'public' role is extraneous.

NOTE: it is standard KFB practice and recommended SQL Best Practices to NOT change the permissions of the system 'public' role to grant any permissions on any securable other than those set by default.  In other words, the 'public' role should only be granted the rights as set by the default Microsoft granted rights as described 
https://msdn.microsoft.com/en-us/library/ms181127.aspx.  By default, this role has NO permissions to any user defined object and has READ only access to certain system object.
**************************************************************************/
CREATE PROCEDURE [security].[usp_Report_ServerPrincipals]
AS
BEGIN
SET NOCOUNT ON;


--STEP 1: Create temporary tableS of server role member changes
-- create table to hold SRM results
IF EXISTS (SELECT * FROM tempdb.sys.objects WHERE [Name] LIKE 'tSRMs' AND [type] = 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
DROP TABLE [tempdb].[dbo].[tSRMs]
END

BEGIN
CREATE TABLE [tempdb].[dbo].[tSRMs](
[ServerId] INT NOT NULL
,[ServerPrincipalsId] INT NOT NULL
,[ServerRoleId] INT NOT NULL
,[SRMChangeTypeCd] INT NOT NULL
,[RolePrincipalId] INT NOT NULL
,[SRName] VARCHAR(128) NOT NULL
,[SRChangeTypeCd] VARCHAR(128) NOT NULL
,[AccessToAllDatabasesInd] BIT NOT NULL
,[SysAdminInd] BIT NOT NULL
,[CustomRoleInd] BIT NOT NULL
,[SRModifyDt] DATETIME NULL
,[GUId] UNIQUEIDENTIFIER NULL
,[SQLSid] VARBINARY(85) NULL
,[SPChangeTypeCd] INT NOT NULL
,[SPName] VARCHAR(128) NULL
,[SPsamAccountName] VARCHAR(256) NULL
,[IsDisabledind] BIT NULL
,[ADAccountInd] BIT NULL
,[DeletedDomainAccountInd] BIT NULL
)

END


-- The server principals query will be used multiple times so create a temporary table to hold the results
IF EXISTS (SELECT * FROM tempdb.sys.objects WHERE [Name] LIKE 'tSPs' AND [type] = 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN
DROP TABLE [tempdb].[dbo].[tSPs]
END

BEGIN
CREATE TABLE [tempdb].[dbo].[tSPs]
([ServerPrincipalsId] INT NOT NULL
,[ServerId] INT NOT NULL
,[PrincipalId] INT NOT NULL
,[GUId] UNIQUEIDENTIFIER NULL
,[SQLSid] VARBINARY(85) NOT NULL
,[SPChangeTypeCd] INT NOT NULL
,[IsDisabledind] BIT NOT NULL
,[ADGroupInd] BIT NOT NULL
,[Name] VARCHAR(128) NULL
,[samAccountName] VARCHAR(256) NULL
,[DeletedDomainAccountInd] BIT NOT NULL
,[ServerPrincipalTypeCd] CHAR(1) NULL
,[ADAccountInd] BIT NOT NULL)
END


-- Add the server principals to the temp table with their AD information and change code text.  A left outer join is required to AD information to get both SQL and Windows account in one statement. Since SQL server logins could be 1) SQL users, 2) Local Windows Users or 3) Domain Windows users, AND because local OS users are not imported to this database, both would return NULL when joined to AD user or groups.  To distinguish between deleted AD accounts and local OS accounts, a custom function exists Use the custom function dbo.ufn_LocalorDeletedDomain to distinguish between Local server OS user/group accounts and AD user/group accounts 
INSERT INTO [tempdb].[dbo].[tSPs]
           ([ServerPrincipalsId]
           ,[ServerId]
           ,[PrincipalId]
		 ,[GUId]
		 ,[SQLSid]
		 ,[SPChangeTypeCd]
           ,[IsDisabledind]
           ,[ADGroupInd]
           ,[Name]
           ,[samAccountName]
           ,[DeletedDomainAccountInd]
           ,[ServerPrincipalTypeCd]
           ,[ADAccountInd])
SELECT 
	[SPCEPId].[ServerPrincipalsId]
	,[SPCEPId].[ServerId]
	,[SPCEPId].[PrincipalId]
	,[ADAccts1].[GUId]
	,[SPCEPId].[SQLSid]
	,[SPCEPid].[ChangeTypeCd]
	,[SPCEPId].[IsDisabledind]
	,[SPCEPId].[ADGroupInd]
	,[SPCEPId].[Name]
	,[ADAccts1].samAccountName
	,CASE [SPCEPId].[ADAccountInd] WHEN 1 THEN dbo.ufn_LocalorDeletedDomain([spcepid].[Name],[adaccts1].[guid]) else 0 end as DeletedDomainAccountInd
	,[SPCEPId].[ServerPrincipalTypeCd]
	,[SPCEPId].[ADAccountInd]
FROM [security].[vw_ServerPrincipals_CurrentETLProcessId] as SPCEPId
LEFT OUTER JOIN 
	(
	SELECT [ADUsersId],[guid],[sid],[samaccountname] FROM [security].[vw_ADUsers_CurrentETLProcessId] 
	UNION
	SELECT [ADGroupId],[Guid],[sid],[samaccountname] FROM [security].[vw_ADGroups_CurrentETLProcessID]
) AS ADAccts1
ON SPCEPId.SQLSid = ADAccts1.[sid]




--STEP 2: --because these are full history tables, changes are determined using SQL INTERSECT and EXCEPT functions on the view of current and prior SRM ETL processes.  Create a temporary table to hold the SRM state
IF EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] = 'tSRMChanges' and [TYPE] like 'U' AND [SCHEMA_ID] = SCHEMA_ID('dbo'))
BEGIN 
DROP TABLE tempdb.dbo.tSRMChanges
END
CREATE TABLE tempdb.dbo.tSRMChanges
([ServerPrincipalsId] int not null,
[ServerRoleId] int NOT NULL,
[SRMChangeTypeCd] INT NOT NULL)

DECLARE @ChangeTypeCd int
SET @ChangeTypeCd = 0
INSERT INTO tempdb.dbo.tSRMChanges ([ServerPrincipalsId],[ServerRoleId],[SRMChangeTypeCd])
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_CurrentETLProcessId]
INTERSECT
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_PriorETLProcessId]

SET @ChangeTypeCd = 1
INSERT INTO tempdb.dbo.tSRMChanges ([ServerPrincipalsId],[ServerRoleId],[SRMChangeTypeCd])
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_CurrentETLProcessId]
EXCEPT
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_PriorETLProcessId]

SET @ChangeTypeCd = -1
INSERT INTO tempdb.dbo.tSRMChanges ([ServerPrincipalsId],[ServerRoleId],[SRMChangeTypeCd])
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_PriorETLProcessId]
EXCEPT
SELECT 
	[ServerPrincipalsId]
	,[ServerRoleId]
	,@ChangeTypeCd
FROM [security].[vw_ServerRoleMembers_CurrentETLProcessId]

--Next get server roles in similar fashion
INSERT INTO [tempdb].[dbo].[tSRMs]
          ([ServerId]
           ,[ServerPrincipalsId]
           ,[ServerRoleId]
 ,[SRMChangeTypeCd]
		 ,[RolePrincipalId]
           ,[SRName]
           ,[SRChangeTypeCd]
           ,[AccessToAllDatabasesInd]
           ,[SysAdminInd]
           ,[CustomRoleInd]
		 ,[SRModifyDt]
           ,[GUId]
           ,[SQLSid]
           ,[SPChangeTypeCd]
           ,[IsDisabledind]
           ,[ADAccountInd]
		 ,[DeletedDomainAccountInd]
           ,[SPName]
           ,[SPsamAccountName])
SELECT 
[SRCPId].[ServerId]
,SRMs1.ServerPrincipalsId
,SRMs1.ServerRoleId
,SRMs1.SRMChangeTypeCd
,[SRCPId].[RolePrincipalId]
,[SRCPId].[Name] AS SRName
,[SRCPId].[ChangeTypeCd] AS SRChangeTypeCd
,[SRCPId].[AccessToAllDatabasesInd]
,[SRCPId].[SysAdminInd]
,[SRCPId].[CustomRoleInd]
,[SRCPId].[ModifyDt]
,[SPS1].[GUId]
,[SPS1].[SQLSid]
,[SPS1].[SPChangeTypeCd]
,[SPS1].[IsDisabledind]
,[SPS1].[ADAccountInd]
,0
--,[SPS1].[DeletedDomainAccountInd]
,[sps1].[Name] AS SPName
,[SPS1].samAccountName AS SPsamAccountName
FROM [tempdb].[dbo].tSRMChanges AS SRMs1
INNER JOIN [security].[vw_ServerRoles_CurrentETLProcessId] AS SRCPId
ON [SRMs1].[ServerRoleId] = [SRCPId].[ServerRoleId]  
INNER JOIN [tempdb].[dbo].[tSPs] AS SPS1
ON  SRMS1.ServerPrincipalsId = SPS1.ServerPrincipalsId 


INSERT INTO [tempdb].[dbo].[tSRMs]
           ([ServerId]
           ,[ServerPrincipalsId]
           ,[ServerRoleId]
           ,[SRMChangeTypeCd]
		 ,[RolePrincipalId]
           ,[SRName]
           ,[SRChangeTypeCd]
           ,[AccessToAllDatabasesInd]
           ,[SysAdminInd]
           ,[CustomRoleInd]
		 ,[SRModifyDt]
           ,[GUId]
           ,[SQLSid]
           ,[SPChangeTypeCd]
           ,[IsDisabledind]
           ,[ADAccountInd]
		 ,[DeletedDomainAccountInd]
           ,[SPName]
           ,[SPsamAccountName]
)
SELECT 
[SPCPId2].[ServerId]
,[SPCPId2].[ServerPrincipalsId]
, 0 AS ServerRoleId --as the public role
,[SPCPid2].[SPChangeTypeCd] AS SRMChangeTypeCd -- all users automatically inherit the public role when added so it is based upon the change type code of the SP
,0 AS RolePrincipalId
,'public' as SRName
,0 AS SRChangeTypeCd-- the public role is never removed, added or changed since it is a defined system generated role
,0 AS AccesstoAllDatabasesInd
,0 AS [SysAdminInd]
,0 AS CustomRoleInd
,NULL
,[SPCPId2].[GUId]
,[SPCPId2].[SQLSid]
,[SPCPId2].[SPChangeTypeCd]
,[SPCPId2].[IsDisabledind]
,[SPCPId2].[ADAccountInd]
,0
--,[SPCPId2].[DeletedDomainAccountInd]
,[SPCPId2].[Name] as SPName
,[SPCPId2].samAccountName AS SPsamAccountName
 FROM [tempdb].[dbo].[tSPs] AS SPCPId2
LEFT OUTER JOIN [security].[vw_ServerRoleMembers_CurrentETLProcessId] AS SRS2
ON SPCPId2.[ServerPrincipalsId] = [SRS2].[ServerPrincipalsId]
WHERE [SRS2].ServerPrincipalsId IS NULL

END
GO
/****** Object:  StoredProcedure [security].[usp_RolesReporting_SetDefaultDescriptions]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [security].[usp_RolesReporting_SetDefaultDescriptions]
AS
BEGIN
--Post package fixes
DECLARE @RoleScope varchar(128)
DECLARE @SystemName varchar(128)
DECLARE @ReportingDescription varchar(128)
DECLARE @ReplacedReportingDescription varchar(128)
SET @RoleScope = 'Database'
SET @SystemName = 'db_backupoperator'
SET @ReportingDescription = 'Backup Databases operator'
SET @ReplacedReportingDescription = 'Need Reporting Description'

UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 

SET @SystemName = 'db_datareader'
SET @ReportingDescription = 'Read Access (All)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 
 

SET @SystemName = 'db_datawriter'
SET @ReportingDescription = 'Write Access (All)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 

 
SET @SystemName = 'db_ddladmin'
SET @ReportingDescription = 'DDL Administrator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 

 
SET @SystemName = 'db_denydatareader'
SET @ReportingDescription = 'Explicitly denied rights to read data'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 
 

SET @SystemName = 'db_executor'
SET @ReportingDescription = 'Execute Stored Procedures (1)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'db_owner'
SET @ReportingDescription = 'Administrator Access'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 

 
SET @SystemName = 'dbcreator'
SET @ReportingDescription = 'Database Creator(Inherited)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'IMIS'
SET @ReportingDescription = 'Defined by Application'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'public'
SET @ReportingDescription = 'Limited Access'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'sysadmin'
SET @ReportingDescription = 'System Administrator(Inherited)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'sysadmin'
SET @ReportingDescription = 'System Administrator(Inherited)'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @RoleScope = 'Server'
SET @SystemName = 'bulkadmin'
SET @ReportingDescription = 'Bulk Insert Administrator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'dbcreator'
SET @ReportingDescription = 'Database Creator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'diskadmin'
SET @ReportingDescription = 'OS Disk Administrator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'public'
SET @ReportingDescription = 'Limited Access'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'securityadmin'
SET @ReportingDescription = 'Server and Database Security Administrator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 


SET @SystemName = 'sysadmin'
SET @ReportingDescription = 'System Administrator'
SET @ReplacedReportingDescription = 'Need Reporting Description'
UPDATE [security].[RolesReporting]
 SET 
[ReportingDescription] = @ReportingDescription
,[Definition] = NULL
 WHERE  [SystemName] = @SystemName
 AND [RoleScope] = @RoleScope
 AND [ReportingDescription] = @ReplacedReportingDescription 

 END
GO
/****** Object:  StoredProcedure [security].[usp_RolesReporting_upd]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [security].[usp_RolesReporting_upd]
(@RoleScope varchar(128)
,@SystemName varchar(128)
,@ReportingDescription varchar(128)
,@Definition varchar(512)
,@InheritedServerRoleInd bit
,@InheritedServerRoleID int
,@AccesstoAllDatabasesInd bit
,@SysAdminInd bit
,@CustomRoleInd bit
)
AS
BEGIN
SET NOCOUNT ON 
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back eliminating the need to build ROLLBACK TRANSACTION into the procedure
SET XACT_ABORT ON  

--Set default and non-null values--if some values are NULL passed, then set a 'default' value
BEGIN TRY
	BEGIN TRAN
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currObject NVARCHAR(128)
	DECLARE @currprod NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'RoleScope'
	IF @RoleScope IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END

	SET @currObject = 'systemName '
	IF @SystemName  IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	UPDATE [security].[RolesReporting]
	SET 
	[ReportingDescription] = @ReportingDescription
	,[Definition] = @Definition
	,[InheritedServerRoleInd] = @InheritedServerRoleInd
	,[InheritedServerRoleID] = @InheritedServerRoleID
	,[AccesstoAllDatabasesInd] = @AccesstoAllDatabasesInd
	,[SysAdminInd] = @SysAdminInd
	,[CustomRoleInd] = @CustomRoleInd
	WHERE 
	[SystemName] = @SystemName
	AND [RoleScope] = @RoleScope

	COMMIT TRANSACTION

	SELECT 
	[RoleReportingID]
	,[RoleScope]
	,[SystemName]
	,[ReportingDescription]
	,[Definition]
	,[InheritedServerRoleInd]
	,[InheritedServerRoleID]
	,[AccesstoAllDatabasesInd]
	,[SysAdminInd]
	,[CustomRoleInd]
	FROM [security].[RolesReporting]
	WHERE 
	[SystemName] = @SystemName
	AND [RoleScope] = @RoleScope

END TRY

BEGIN CATCH
	EXEC dbo.usp_ErrorHandling_SystemErrors_Get
END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [security].[usp_Servers_Upd_Retire]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Danny Howell
-- Create date:	01/03/2020
-- Description:	Procedure used to retire servers used in the security.servers table for systems permanently shutdown and deleted 
--				This will remove the input host name and all its SQL instances from processing by the SSIS packages used for KFB SQL management
-- =============================================
CREATE PROCEDURE [security].[usp_Servers_Upd_Retire]
	@pServerID INT
	,@pServerIsReplaced BIT
	,@pReplacementServerInstanceID INT
AS
BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
DECLARE @ReplacementServerInstanceID INT
DECLARE @ReplacementServerName VARCHAR(128)
DECLARE @ReplacementServerInstanceName VARCHAR(128)

BEGIN TRY
	DECLARE @ServerInstanceID INT
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)
	DECLARE @currObject NVARCHAR(128)
	SELECT @currprod = OBJECT_NAME(@@PROCID)
	SET @currObject = 'Server System ID'
	IF @pServerID IS NULL
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
		THROW 60000 , @msg, 1 
	END
	
	--If Server is being replaced, then validate a replacement server instance is assigned
	IF @pServerIsReplaced = 1
	BEGIN
		SET @currObject = 'Replacement Server System ID -- from dbo.ServerInstances'
		IF @pReplacementServerInstanceID IS NULL
		BEGIN
			EXEC sys.sp_addmessage
			@msgnum   = 60000
			,@severity = 10
			,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - NULL entry was passed to the input parameter'
			,@lang = 'us_english'
			,@replace = 'replace'; 
			SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
			THROW 60000 , @msg, 1 
		END
		ELSE
		BEGIN
			IF EXISTS (SELECT * FROM [dbo].[ServerInstances] WHERE [ServerInstanceID] = @pReplacementServerInstanceID)
			BEGIN
				SELECT 
				@ReplacementServerName = [S1].[HostName],
				@ReplacementServerInstanceID = [SI1].[ServerInstanceID], @ReplacementServerInstanceName = [SI1].[InstanceName] 
				FROM [dbo].[ServerInstances] AS SI1
				INNER JOIN [dbo].[Servers] AS S1
				ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
				WHERE [ServerInstanceID] = @pReplacementServerInstanceID


			END
			ELSE
			BEGIN
				EXEC sys.sp_addmessage
				@msgnum   = 60000
				,@severity = 10
				,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - A server instance ID matching the input parameter was not found.'
				,@lang = 'us_english'
				,@replace = 'replace'; 
				SET @msg = FORMATMESSAGE(60000, @currprod,@currObject);
				THROW 60000 , @msg, 1 
			END
		END
	END

	
	IF NOT EXISTS (SELECT * FROM [security].[Servers] WHERE ServerID = @pServerID)	
	BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60001
		,@severity = 10
		,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - %d does not exist.'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg  = FORMATMESSAGE(60001, @currprod,@currObject, @pServerID);
		THROW 60001 , @msg, 1; 
	END
	
	BEGIN TRANSACTION
		UPDATE [security].[Servers]
		SET [AuditDiscontinuedInd] = 1
		,[IncludeInAuditingReportInd] = 0
		,[ReplacedByServerName] = @ReplacementServerName
		WHERE [ServerID] = @pServerID
		
	COMMIT TRANSACTION

	SELECT 
	'Server Retired'
	,[ServerId]
	,[ProductionServerInd]
	,[ServerName]
	,[AuditDiscontinuedInd]
	,[ReplacedByServerName]
	,[IncludeInAuditingReportInd]
	,[ETLProcessId]
	,[ServerReportingName]
	,[InstanceName]
	,[ServerInstanceID]
	FROM [security].[Servers]
	WHERE [ServerId] = @pServerID

	BEGIN TRANSACTION
		-- Insert Replacement
		DECLARE @NextServerID INT

		DECLARE @ProductionServerInd BIT
		DECLARE @IncludeInAuditingReportInd BIT
		DECLARE @ETLProcessId INT
		DECLARE @ServerReportingName VARCHAR(256)
		SELECT @NextServerID = (MAX([ServerId]) + 1) FROM [security].[Servers]

		SELECT 
		@ProductionServerInd = [ProductionServerInd]
		,@IncludeInAuditingReportInd =[IncludeInAuditingReportInd]
		,@ETLProcessId = [ETLProcessId]
		,@ServerReportingName = [ServerReportingName]
		FROM [security].[Servers]
		WHERE [ServerID] = @pServerID


		INSERT INTO [security].[Servers]
		([ServerId]
		,[ProductionServerInd]
		,[ServerName]
		,[AuditDiscontinuedInd]
		,[ReplacedByServerName]
		,[IncludeInAuditingReportInd]
		,[ETLProcessId]
		,[ServerReportingName]
		,[InstanceName]
		,[ServerInstanceID])
		VALUES
		(@NextServerID
		,@ProductionServerInd
		,@ReplacementServerName
		,0
		,NULL
		,@IncludeInAuditingReportInd
		,@ETLProcessId
		,@ServerReportingName
		,@ReplacementServerInstanceName
		,@ReplacementServerInstanceID)
	COMMIT TRANSACTION

	SELECT 
	[SS1].[ServerId]
	,[SS1].[ProductionServerInd]
	,[SS1].[ServerName]
	,[SS1].[AuditDiscontinuedInd]
	,[SS1].[ReplacedByServerName]
	,[SS1].[IncludeInAuditingReportInd]
	,[SS1].[ETLProcessId]
	,[SS1].[ServerReportingName]
	,[SS1].[InstanceName]
	,[SS1].[ServerInstanceID]
	,[SI1].[HostName]
	,[SI1].[InstanceName]
	,[SI1].[LocalHostDescription]
	,[SI1].[SQLVersionDescription]
	FROM [security].[Servers] AS SS1
	LEFT OUTER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] AS SI1
	ON [SS1].[ServerInstanceID] = [SI1].[ServerInstanceID]
	WHERE [SS1].[ServerId] =  @NextServerID
	END TRY

	BEGIN CATCH
		EXEC dbo.usp_ErrorHandling_SystemErrors_Get
	END CATCH
SET NOCOUNT OFF
SET XACT_ABORT OFF
	
END
GO
/****** Object:  StoredProcedure [sqlaudit].[usp_ServerAuditOutput]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [sqlaudit].[usp_ServerAuditOutput]
AS
BEGIN

SELECT [ServerAuditOutputID]
,[ETLProcessId]
,[ServerInstanceID]
,[server_instance_name]
,[audit_id]
,(DATEADD(MI,DATEPART(TZ,SYSDATETIMEOFFSET()),[event_time])) as event_time_localtz
,[action_id]
,[class_type]
,[session_id]
,[ipaddress]
,[pooled_connection]
,[audit_file_offset]
,[sequence_number]
,[database_name]
,[database_principal_id]
,[database_principal_name]
,[file_name]
,[is_column_permission]
,[object_id]
,[object_name]
,[schema_name]
,[server_principal_id]
,[server_principal_name]
,[server_principal_sid]
,[session_server_principal_name]
,[statement]
,[succeeded]
,[target_database_principal_id]
,[target_database_principal_name]
,[target_server_principal_id]
,[target_server_principal_name]
,[target_server_principal_sid]
,[user_defined_event_id]
,[user_defined_information]
FROM [sqlaudit].[ServerAuditOutputs]
ORDER BY ServerInstanceID, event_time desc
END
GO
/****** Object:  StoredProcedure [sqlaudit].[usp_ServerAuditOutputs_Del_OlderThanCutoff]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/***************************************************
Author: Danny Howell
Description: Standardized DELETE operation on ServerAuditOutputs table by server instance.
Procedure standardizes operation for deleting records from the table older than a given parameter in days.
The CutoffDt is the number of days to retain.
DateAdded is not included here as this will only be set during insert operations
Includes TRY...CATCH block and calls standardized error handling stored procedure in case of rollback
***************************************************/
CREATE PROCEDURE [sqlaudit].[usp_ServerAuditOutputs_Del_OlderThanCutoff] (
@HostName NVARCHAR(128),
@InstanceName NVARCHAR(128),
@CutoffDays INT
)
AS 

BEGIN
SET NOCOUNT ON 
SET XACT_ABORT ON  
--Set default and non-null values
BEGIN TRY
	DECLARE @DefaultRetentionDays INT
	DECLARE @msg NVARCHAR(2048)
	DECLARE @currprod NVARCHAR(128)

	SET @DefaultRetentionDays = 30
	SELECT @currprod = OBJECT_NAME(@@PROCID)

	DECLARE @ServerInstanceIDs TABLE (pServerSystemID INT, pServerInstanceID INT)
	IF @HostName IS NULL 
	BEGIN
		INSERT INTO @ServerInstanceIDs (pServerSystemID, pServerInstanceID)
		SELECT DISTINCT
		[SI1].[ServerSystemID]
		,[SI1].[ServerInstanceID]
		FROM [dbo].[vw_ServerInstances] AS [SI1]
		INNER JOIN [dbo].[vw_Servers] AS [S1]
		ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
		WHERE [SI1].[RetiredInd] = 0
		SET @msg  = N'A NULL entry was passed to the HostName input parameter in the procedure.  ServerAuditOutputs for all servers and all SQL Instances is run.'
		PRINT @msg
	END
	ELSE
	BEGIN
		--if just specifying the server host name, then process all instances on that server
		IF @InstanceName IS NULL
		BEGIN
			INSERT INTO @ServerInstanceIDs (pServerSystemID, pServerInstanceID)
			SELECT DISTINCT
			[SI1].[ServerSystemID]
			,[SI1].[ServerInstanceID]
			FROM [dbo].[vw_ServerInstances] AS [SI1]
			INNER JOIN [dbo].[vw_Servers] AS [S1]
			ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
			WHERE [SI1].[RetiredInd] = 0
			AND [S1].[HostName] = @HostName
			SET @msg  = (N'A NULL entry was passed to the InstanceName input parameter in the procedure.  ServerAuditOutputs for all SQL Instances on the named host is run. (' + @HostName + ')' )
			PRINT @msg
		END
		ELSE
		BEGIN
			INSERT INTO @ServerInstanceIDs (pServerSystemID, pServerInstanceID)
			SELECT DISTINCT
			[SI1].[ServerSystemID]
			,[SI1].[ServerInstanceID]
			FROM [dbo].[vw_ServerInstances] AS [SI1]
			INNER JOIN [dbo].[vw_Servers] AS [S1]
			ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
			WHERE [SI1].[RetiredInd] = 0
			AND [S1].[HostName] = @HostName
			AND [SI1].[InstanceName] = @InstanceName

			SET @msg  = N'ServerAuditOutputs for the named SQL Instance on the named host is run.(' + @HostName + '\' + @InstanceName + ')'
			PRINT @msg
		END
	END

	--If count of systems in the temporary table is 0 then throw an error

	IF @CutoffDays IS NULL
	BEGIN
		SET @msg  = N'A NULL entry was passed to the CutoffDays input parameter in the procedure %s.  The default value of 30 days from the current day retention will be used.'
		PRINT @msg
		SET @CutoffDays = @DefaultRetentionDays
	END
	ELSE
	BEGIN
		IF @CutoffDays < @DefaultRetentionDays
		BEGIN
		EXEC sys.sp_addmessage
		@msgnum   = 60000
		,@severity = 10
		,@msgtext  = N'A value less than 30 days was passed to the CutoffDays input parameter in the procedure %s.  Please provide a value greater than the default retention(%i).'
		,@lang = 'us_english'
		,@replace = 'replace'; 
		SET @msg = FORMATMESSAGE(60000,@currprod,@DefaultRetentionDays); 
		THROW 60000 , @msg, 1; 
		END
	END
	SET @CutoffDays = (@CutoffDays * -1)

	IF (SELECT COUNT(*) FROM @ServerInstanceIDs) < 1
	BEGIN
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'A SQL Instance could not be found using the input parameters. (%s\%s).  Please provide a valid host name and instance name.'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000,@HostName,@InstanceName); 
	THROW 60000 , @msg, 1; 
	END

	
	DECLARE @EarliestAuditDate DATE	
	SET @EarliestAuditDate = CAST(DATEADD(DAY,@CutoffDays,GETDATE()) AS DATE)

	SELECT 
	[S1].[HostName]
	,[SI1].[InstanceName]
	,[SAO1].[event_time_date]
	,COUNT([SAO1].[ServerAuditOutputID]) AS SAORecordCount
	FROM [sqlaudit].[ServerAuditOutputs] AS [SAO1]
	INNER JOIN [dbo].[vw_ServerInstances] AS [SI1]
	ON [SAO1].[ServerInstanceID] = [SI1].[ServerInstanceID]
	INNER JOIN [dbo].[vw_Servers] AS [S1]
	ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
	INNER JOIN @ServerInstanceIDs AS T2
	ON [T2].[pServerSystemID] = [SI1].[ServerSystemID]
	AND [T2].[pServerInstanceID]= [SI1].[ServerInstanceID]
	WHERE [SAO1].[event_time_date] < @EarliestAuditDate
	GROUP BY 
	[S1].[HostName]
	,[SI1].[InstanceName]
	,[SAO1].[event_time_date]
	ORDER BY cast([SAO1].[event_time_date] as date) ASC
	,[S1].[HostName] ASC
	,[SI1].[InstanceName] 

	BEGIN TRAN	
		DELETE  [sqlaudit].[ServerAuditOutputs] 
		FROM [sqlaudit].[ServerAuditOutputs] AS [SAO1]
		INNER JOIN [dbo].[vw_ServerInstances] AS [SI1]
		ON [SAO1].[ServerInstanceID] = [SI1].[ServerInstanceID]
		INNER JOIN [dbo].[vw_Servers] AS [S1]
		ON [SI1].[ServerSystemID] = [S1].[ServerSystemID]
		INNER JOIN @ServerInstanceIDs AS T2
		ON [T2].[pServerSystemID] = [SI1].[ServerSystemID]
		AND [T2].[pServerInstanceID]= [SI1].[ServerInstanceID]
		WHERE [SAO1].[event_time_date] < @EarliestAuditDate
		
	COMMIT TRANSACTION
	
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
		
	END
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF
END
GO
/****** Object:  StoredProcedure [sqlaudit].[usp_ServerAudits_ValidateETL]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [sqlaudit].[usp_ServerAudits_ValidateETL]
AS
BEGIN
SELECT 
t2.hostname
,t2.instancename
,COUNT([T1].[ServerAuditsID]) AS AuditCount
,count([T3].[ServerAuditSpecificationsID]) as AuditSpecCount
FROM [dbo].[vw_ServerInstances_InventoryDiagram] as t2
left outer join  [sqlaudit].[ServerAudits] as T1
on [t2].[ServerInstanceID] = [t1].[serverinstanceId]
LEFT OUTER JOIN [sqlaudit].[ServerAuditSpecifications] as t3
on [T1].[ServerAuditsID] = [t3].[ServerAuditsID]
GROUP BY
t2.hostname
,t2.instancename
having COUNT([T1].[ServerAuditsID]) < 3 
OR count([T3].[ServerAuditSpecificationsID]) < 3 
order by t2.hostname asc, t2.instancename

select
[t1].[name] as AuditSpecName
,[t2].[name] as AuditName
,[t3].[HostName]
,[t3].[InstanceName]
from [sqlaudit].[ServerAuditSpecifications] as [t1]
left outer join [sqlaudit].[ServerAudits] AS [t2]
on [t1].[ServerAuditsID] = [t2].[ServerAuditsID]
left outer join [dbo].[vw_ServerInstances_InventoryDiagram] as t3
on [t2].[ServerInstanceID] = [t3].[ServerInstanceID]
where [t2].[name] is null


SELECT 
[t3].[HostName]
,[t3].[InstanceName]
,[T1].[ServerAuditsID]
,[T2].[name]
,[T2].[is_state_enabled]
,[T1].[ETLProcessId]
,[T1].[ServerInstanceID]
,[T1].[audit_id]
,COUNT([T1].[ServerAuditOutputID]) AS AuditRecordCount
,MAX([T1].[audit_file_offset]) AS MaxAuditFileOffset
,MIN([T1].[audit_file_offset]) AS MinAuditFileOffset
,MAX([T1].[event_time]) as MaxEventTime
,MIN([T1].[event_time]) as MinEventTime
 FROM [sqlaudit].[ServerAuditOutputs] as t1
 INNER JOIN [sqlaudit].[ServerAudits] as T2
 ON [T1].[ServerAuditsID] = [T2].[ServerAuditsID]
 INNER JOIN [dbo].[vw_ServerInstances_InventoryDiagram] as t3
 ON [t1].[ServerInstanceID] = [t3].[ServerInstanceID]
 GROUP BY
 [t3].[HostName]
,[t3].[InstanceName]
,[T1].[ServerAuditsID]
,[T2].[name]
,[T2].[is_state_enabled]
,[T1].[ETLProcessId]
,[T1].[ServerInstanceID]
,[T1].[audit_id]
ORDER BY 
[t3].[HostName]
,[t3].[InstanceName]
,[T2].[name]

END
GO
/****** Object:  StoredProcedure [sqlaudit].[usp_ServerAuditsOutput_MatchedLoginsForServer]    Script Date: 8/9/2021 10:26:23 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Danny Howell
-- Create date: 07/09/2020
-- Description:	Procedure matching session logins and log outs
-- =============================================
CREATE PROCEDURE [sqlaudit].[usp_ServerAuditsOutput_MatchedLoginsForServer] 
	-- Add the parameters for the stored procedure here
	@pServerHostName varchar(128), 
	@pInstanceName varchar(128) 
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
BEGIN TRY
DECLARE @msg NVARCHAR(2048)
DECLARE @currprod NVARCHAR(128)
DECLARE @currObject NVARCHAR(128)
SELECT @currprod = OBJECT_NAME(@@PROCID)

DECLARE @ServerInstanceIDs TABLE (pServerInstanceID INT)
DECLARE @InstanceNames TABLE (pInstanceName VARCHAR(128))
DECLARE @LoginActionID VARCHAR(128)
DECLARE @LogOutActionID VARCHAR(128)
DECLARE @AuditName NVARCHAR(128)
SET @AuditName = 'Server-LogOnEvents'
--Populate the ActionIDs table for the login actions
SET @LoginActionID = 'LGIS'
SET @LogOutActionID = 'LGO'


IF @pInstanceName IS NULL
BEGIN
	INSERT INTO @InstanceNames(pInstanceName)
	SELECT DISTINCT [InstanceName]
	FROM [dbo].[ServerInstances]
	WHERE [RetiredInd] = 0
END
ELSE
BEGIN
	INSERT INTO @InstanceNames(pInstanceName)
	SELECT DISTINCT [InstanceName]
	FROM [dbo].[ServerInstances]
	WHERE [RetiredInd] = 0
	AND [InstanceName] LIKE @pInstanceName
END


--Validate @pServerHostName variable
IF @pServerHostName IS NULL
BEGIN
	INSERT INTO @ServerInstanceIDs (pServerInstanceID)
	SELECT DISTINCT [T1].[ServerInstanceID]
	FROM [dbo].[ServerInstances] AS [T1]
	WHERE [RetiredInd] = 0
	AND [InstanceName] IN (SELECT [InstanceName] FROM @InstanceNames)
END
ELSE
BEGIN
	INSERT INTO @ServerInstanceIDs (pServerInstanceID)
	SELECT [T1].[ServerInstanceID]
	FROM [dbo].[ServerInstances] AS [T1]
	INNER JOIN [dbo].[Servers] AS [T2]
	ON [T1].[ServerSystemID] = [T2].[ServerSystemID]
	WHERE [t1].[InstanceName] IN (SELECT [pInstanceName] FROM @InstanceNames)
	AND [T1].[RetiredInd] = 0
	AND [T2].[HostName] LIKE @pServerHostName
END

--Throw error if table variable has no server instance IDs
IF (SELECT COUNT(*) FROM @ServerInstanceIDs) < 1
BEGIN
	--Throw error
	EXEC sys.sp_addmessage
	@msgnum   = 60000
	,@severity = 10
	,@msgtext  = N'Invalid input parameters passed to the procedure %s: %s - No server instances could be found for the input values (%s) and (%s).'
	,@lang = 'us_english'
	,@replace = 'replace'; 
	SET @msg = FORMATMESSAGE(60000, @currprod,@currObject,@pServerHostName,@pInstanceName);
	THROW 60000 , @msg, 1 
END


SELECT
ROW_NUMBER() OVER(PARTITION BY [session_id],[session_server_principal_name] ORDER BY [event_time],[action_id],[audit_file_offset]) AS Row
,[ServerAuditOutputID]
,[audit_id]
,[action_id]
,[audit_file_offset]
,[class_type]
,[ipaddress]
,[event_time]
,[server_principal_name]
,[session_id]
,[session_server_principal_name]
,[succeeded]
FROM [sqlaudit].[vw_ServerAuditOutputs_ServerInstances] AS [T1]
INNER JOIN @ServerInstanceIDs AS [T2]
ON [T1].[ServerInstanceID] = [T2].[pServerInstanceID]
--WHERE [T1].[action_id] = @LoginActionID
--UNION
--SELECT
--ROW_NUMBER() OVER(PARTITION BY [session_id],[session_server_principal_name] ORDER BY [event_time] DESC, [audit_file_offset]) AS Row
--,[ServerAuditOutputID]
--,[audit_id]
--,[action_id]
--,[audit_file_offset]
--,[class_type]
--,[ipaddress]
--,[event_time]
--,[server_principal_name]
--,[session_id]
--,[session_server_principal_name]
--,[succeeded]
--FROM [sqlaudit].[vw_ServerAuditOutputs_ServerInstances] AS [T1]
--INNER JOIN @ServerInstanceIDs AS [T2]
--ON [T1].[ServerInstanceID] = [T2].[pServerInstanceID]
--WHERE [T1].[action_id] = @LogOutActionID
/*
https://stackoverflow.com/questions/50706981/connection-logging

*/

END TRY



BEGIN CATCH
	EXEC [dbo].[usp_ErrorHandling_SystemErrors_Get]
END CATCH


    
END
GO
