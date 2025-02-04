/*********************************************************************************
Name:		Database_Databases_USP_UPD_Change_Owner_All_Databases

Author:		Danny Howell

Date:		

Description:		Change the owner on all non-system databases to KFBDOM1\AdminSQL

*********************************************************************************/
--change database owner on all non-system databases to kfbdom1\adminsql
DECLARE @tsql NVARCHAR(2000)
DECLARE @dbname NVARCHAR(256)
DECLARE @tbl TABLE (databasename NVARCHAR(256), iter INT)
INSERT INTO @tbl
SELECT name,  0 FROM sys.databases WHERE database_id > 4 AND name NOT LIKE 'distribution'

WHILE EXISTS (SELECT databasename FROM @tbl WHERE iter = 0)
BEGIN
SELECT @dbname = databasename FROM @tbl WHERE iter = 0
SET @tsql = 'use ' + QUOTENAME(@dbname)
SET @tsql = @tsql + ' exec sp_changedbowner ' + CHAR(39) + 'kfbdom1\adminsql' + CHAR(39)
--exec sp_executesql  @tsql
PRINT @tsql
UPDATE @tbl
SET iter = 1 WHERE databasename = @dbname
END
