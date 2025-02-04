USE [msdb]
GO
/****** Object:  UserDefinedFunction [dbo].[UFN_Convert_Database_Name_String]    Script Date: 03/06/2013 10:13:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[UFN_Convert_Database_Name_String] (@p1 nvarchar(max))
RETURNS @Databases TABLE(Database_id INT NOT NULL, Database_Name nvarchar(128) NOT NULL)

AS

BEGIN
--make temporary tables
--This table will hold the database names to exclude from the list
DECLARE @Database_01 TABLE(Database_ID INT, Database_Name nvarchar(max)
	, Database_Status bit)

--This table will hold the database names to include on the list
 DECLARE @Database_02 TABLE(Database_ID INT, Database_Name nvarchar(max)
	,Database_Status bit)

 DECLARE @Database_Item nvarchar(max)
 DECLARE @Position int


--remove quoted identifiers from the string
SET @p1= LTRIM(RTRIM(@p1))
SET @p1= REPLACE(@p1,' ','')
SET @p1= REPLACE(@p1,'[','')
SET @p1= REPLACE(@p1,']','')
SET @p1= REPLACE(@p1,'''','')
SET @p1= REPLACE(@p1,'"','')


--FIRST, TURN THE STRING INTO A TABLE OF DATABASE NAMES
--set up loop to go through the string to extract database name 
 WHILE CHARINDEX(',,',@p1) > 0 SET @p1= REPLACE(@p1,',,',',')

--if the string begins or ends in a comma, extract out the part of the string that does not begin/end with that character
	IF RIGHT(@p1,1) = ',' SET @p1= LEFT(@p1,LEN(@p1) - 1)
	IF LEFT(@p1,1) = ',' SET @p1= RIGHT(@p1,LEN(@p1) - 1)

--while the length of the string is greater than zero, loop through the string, extracting out the database name & writing it to a temporary table.
		 WHILE LEN(@p1) > 0
			 BEGIN
				 SET @Position = CHARINDEX(',', @p1)
				 IF @Position = 0  --IF no more commas are found in the string then it must be at the end
					 BEGIN
					 SET @Database_Item = @p1
					 SET @p1= ''
					 END
				 ELSE
					 BEGIN  --else extract the portion of the string 
					 SET @Database_Item = LEFT(@p1, @Position - 1) --set variable = begining of string 
					 SET @p1= RIGHT(@p1, LEN(@p1) - @Position) --reset the list to the remainder without the string above
					 END
			 INSERT INTO @Database_01 (Database_ID,Database_Name) VALUES (DB_ID(@Database_Item) , @Database_Item) --add the database name to the temporary table
			 END

--Database status is a flag to set a string value as a valid database to return--1 is a valid status, 0 is not
--the -% string is used to specifically exclude a database by name ex. 'user_databases, - AdventureWorks' would return all user databases
--except AdventureWorks
--use the Database_Status flag to indicate those databases from a class to specifically exclude
--initially, set all database name strings to 1
UPDATE @Database_01
SET Database_Status = 1  
WHERE Database_Name NOT LIKE '-%'

-- set the database name strings to 0 where the name begins with a minus (-)
UPDATE @Database_01
SET Database_Name = RIGHT(Database_Name,LEN(Database_Name) - 1), Database_Status = 0
WHERE Database_Name LIKE '-%'

--SECOND, ADD THE VALID STRING RECORDS FROM THE FIRST TEMP TABLE TO THE SECOND TEMP TABLE
-- add the valid strings to the second temporary table
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status)
SELECT DISTINCT Database_ID, Database_Name, Database_Status
FROM @Database_01
WHERE Database_Name NOT IN('SYSTEM_DATABASES','ALL_USER_DATABASES')

--THIRD ADD SYS TABLES WITH THE APPROPRIATE Database_Status FLAG
--if the user specifies system_databases, then remove that string from the @databases table and insert the rows for system dbs and flag the databases as returnable
IF EXISTS (SELECT * FROM @Database_01 WHERE Database_Name = 'SYSTEM_DATABASES' AND Database_Status = 0)
BEGIN
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('master'),'master', 0)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('model'),'model', 0)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('msdb'),'msdb', 0)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('distribution'),'distribution', 0)
END

--if the user specifies system_databases, then remove that string from the @databases table and insert the rows for system dbs and flag the databases as not returnable
IF EXISTS (SELECT * FROM @Database_01 WHERE Database_Name = 'SYSTEM_DATABASES' AND Database_Status = 1)
BEGIN
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(DB_ID('master'), 'master', 1)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('model'),'model', 1)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('msdb'),'msdb', 1)
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status) VALUES(db_id('distribution'),'distribution', 0)
END

--if the user specifies system_databases, then remove that string from the @databases table and insert the rows for system dbs and flag the databases as returnable
IF EXISTS (SELECT * FROM @Database_01 WHERE Database_Name = 'ALL_USER_DATABASES' AND Database_Status = 0)
BEGIN
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status)
SELECT [database_id], [name], 0
FROM sys.databases
WHERE [name] NOT IN ('master','model','msdb','distribution','tempdb')
END


--if the user specifies system_databases, then remove that string from the @databases table and insert the rows for system dbs and flag the databases as not returnable
IF EXISTS (SELECT * FROM @Database_01 WHERE Database_Name = 'ALL_USER_DATABASES' AND Database_Status = 1)
BEGIN
INSERT INTO @Database_02 (Database_ID, Database_Name, Database_Status)
SELECT [database_id], [name], 1
FROM sys.databases
WHERE [name] NOT IN ('master','model','msdb','distribution','tempdb')
END

--Finally, add to the return table records from the
--sys.databases that match the names marked for inclusion 
--and exclude the databases not named or marked for exclusion
INSERT INTO @Databases (Database_id, Database_Name)
SELECT [database_id],[name]
FROM sys.databases
WHERE [name] <> 'tempdb'
AND source_database_id IS NULL
INTERSECT
SELECT Database_ID, Database_Name
FROM @Database_02
WHERE Database_Status = 1
EXCEPT
SELECT Database_ID, Database_Name
FROM @Database_02
WHERE Database_Status = 0


RETURN
--RETURN @RETURNSTATUS

--ReturnCode:
END

