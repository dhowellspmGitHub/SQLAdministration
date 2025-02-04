USE [KFBSQLMgmt_DEV]
GO

/****** Object:  StoredProcedure [dbo].[Find_Text_In_SP]    Script Date: 5/25/2016 1:51:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter PROCEDURE [dbo].[Find_Text_In_SP]
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
   SO.Name, 
   SC.colid,
   SC.[text]
   FROM sysobjects SO (NOLOCK)
   INNER JOIN syscomments SC (NOLOCK) on SO.Id = SC.ID
   AND SO.Type in ('P','FN','TF')
	AND SC.Text LIKE @WCStringToFind
   ORDER BY SO.Name, SC.colid



GO


