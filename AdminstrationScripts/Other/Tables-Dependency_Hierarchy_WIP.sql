 USE [OBprod_admin]
GO
/****** Object:  StoredProcedure [dbo].[uspPrintDependencies]    Script Date: 05/21/2013 16:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspPrintDependencies]
(
    @obj_name varchar(300),
   --@parent_object_id int, 
    @level int
)
AS
SET NOCOUNT ON
DECLARE @sub_obj_name varchar(300)
DECLARE @pobjectid int

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'database_dependencies') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[database_dependencies](
	[dependedupon_object_id] [int] NULL,
	[dependedupon_object_name] [nvarchar] (128) NULL,
	[dependency_level] [int] NULL,
	[dependent_object_id] [int] NULL,
	[dependent_object_name] [nvarchar] (128) NULL
) ON [PRIMARY]
END

if @level > 0 begin
    PRINT Cast(@level as nvarchar(3)) + Replicate('--',@level) + @obj_name
end
else begin
    PRINT Cast(@level as nvarchar(3)) + @obj_name
   
end


DECLARE myCursor CURSOR LOCAL FOR 
    SELECT DISTINCT 
    
	object_name(a.depid)
   ,object_name(a.id)
   FROM dbo.sysdepends a
      WHERE a.depid = object_id(@obj_name)
OPEN myCursor
SET @level = @level + 1
FETCH NEXT FROM myCursor INTO @sub_obj_name 
WHILE @@FETCH_STATUS = 0 
BEGIN 
	print 'Within cursor' + @sub_obj_name
			INSERT INTO [OBprod_admin].[dbo].[database_dependencies]
			([dependedupon_object_id]
			,[dependedupon_object_name]
			,[dependency_level]
			,[dependent_object_id]
			,[dependent_object_name] 
           )
     VALUES
           ( object_id(@obj_name)
          ,@obj_name  
           ,@level
          ,object_id(@sub_obj_name)
           ,@sub_obj_name
                   )
    EXEC uspPrintDependencies @sub_obj_name, @level 
    FETCH NEXT FROM myCursor INTO @sub_obj_name 
END
CLOSE myCursor
DEALLOCATE myCursor

