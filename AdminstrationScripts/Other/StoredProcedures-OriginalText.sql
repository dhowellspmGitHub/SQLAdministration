/*********************************************************************************
Name:		Database_Stored_Procedures_VW_SEL_Original_Stored_Procedure_Text

Author:		Danny Howell

Date:		

Description:		Return a table of all stored procedures with their original text

*********************************************************************************/


SELECT 
ss.name AS schemaname
,so.name AS objectname
,so.type_desc AS objectdescription
,so.create_date AS createdate	
,sc.definition AS creationtext
,sp.numberofparameters AS numberofparameters
,ISNULL(USER_NAME(sc.execute_as_principal_id),'as caller') AS executeas
FROM sys.objects so
INNER JOIN sys.sql_modules sc 
ON so.object_id = sc.object_id
INNER JOIN sys.schemas ss
ON so.schema_id = ss.schema_id
INNER JOIN 
(SELECT OBJECT_ID
, COUNT(parameter_id) AS numberofparameters
FROM sys.parameters
GROUP BY OBJECT_ID) sp
ON so.object_id = sp.object_id
ORDER BY so.name
