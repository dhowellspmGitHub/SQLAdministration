/* The below statements are useful in locating database objects that contain references to external databases --either through linked servers or to other databases on the same server. */


USE [peoplesearchdev]
GO
DECLARE @externalrefs TABLE (
[database_name_checked] NVARCHAR(128),
[database_id] BIGINT,
[item_searched_for] NVARCHAR(25),
[item_type_searched_for] NVARCHAR(25),
[OBJECT_ID] BIGINT,
[type_desc] NVARCHAR(128),
[name] VARCHAR(128),
[create_date] DATETIME,
[modify_date] DATETIME,
[definition] NVARCHAR(MAX),
[hassynonyms] bit,
[synonymcount] int
)

DECLARE @synonymrefs TABLE (
[database_name_checked] NVARCHAR(128),
[database_id] BIGINT,
[reference_item_searched_for] NVARCHAR(128),
[item_type_searched_for] NVARCHAR(128),
[item_searched_for_schema] NVARCHAR(128),
[item_searched_for] NVARCHAR(128),
[search_string] NVARCHAR(128),
[OBJECT_ID] BIGINT,
[objectnamecontainingsynonym] VARCHAR(128),
[synonymrefersto] NVARCHAR(MAX)) 

DECLARE @curdbname NVARCHAR(128);
DECLARE @curdbid BIGINT;
DECLARE @curitemtype NVARCHAR(128);
DECLARE @StringToSearch VARCHAR(100);
DECLARE @StringToSearchWildCard VARCHAR(100);
DECLARE @synStringToSearch VARCHAR(100);
DECLARE @synexists bit;
DECLARE @syncount int;


DECLARE dbcur CURSOR
FOR 
SELECT DB_NAME(),-1, 'server',name FROM master.sys.servers
UNION
SELECT DB_NAME(),DB_ID(), 'database',name FROM master.sys.databases
WHERE database_id > 4
AND name NOT LIKE DB_NAME();

OPEN dbcur;
FETCH NEXT FROM dbcur 
INTO @curdbname,@curdbid, @curitemtype, @stringtosearch

WHILE @@FETCH_STATUS = 0
BEGIN
SET @synexists = 0;
SET @syncount = 0;
SET @StringToSearchWildCard = '%' + @StringToSearch + '%'
IF EXISTS (SELECT DB_NAME(),DB_ID(), type_desc,object_schema_name(OBJECT_ID),name,base_object_name FROM sys.synonyms where base_object_name like  @StringToSearchWildCard )
BEGIN

		select @synexists = 1,@syncount = count(*) FROM sys.synonyms where base_object_name like  @StringToSearchWildCard 
		BEGIN
			DECLARE @synitemtype NVARCHAR(128);
			DECLARE @synschemaname VARCHAR(128);
			DECLARE @synobjectname VARCHAR(128);
			DECLARE @synbaseobjectname VARCHAR(128);
			
			DECLARE syncur CURSOR
			FOR 
			SELECT type_desc,object_schema_name(OBJECT_ID),name,base_object_name FROM sys.synonyms where base_object_name like  @StringToSearchWildCard

			OPEN syncur;
			FETCH NEXT FROM syncur 
			INTO  @synitemtype, @synschemaname,@synobjectname,@synbaseobjectname

			WHILE @@FETCH_STATUS = 0
				BEGIN
				SET @synStringToSearch = '%' + @synschemaname + '%.%' + @synobjectname + '%'
				INSERT INTO @synonymrefs (
					[database_name_checked],
					[database_id],
					[reference_item_searched_for],
					[item_searched_for_schema],
					[item_searched_for],
					[item_type_searched_for],
					[search_string],
					[OBJECT_ID],
					[objectnamecontainingsynonym],
					[synonymrefersto])
				SELECT 
				@curdbname,
				@curdbid,
				@StringToSearch,
				@synschemaname,
				@synobjectname,
				@synitemtype,
				@StringToSearchWildCard,
				so.object_id,
				so.name,
				@synbaseobjectname
				   FROM sys.objects SO (NOLOCK)
				   INNER JOIN sys.sql_modules SC (NOLOCK) ON SO.object_Id = SC.object_ID
				   WHERE REPLACE(REPLACE(SC.[definition],'[',''),']','') LIKE @synStringToSearch

				FETCH NEXT FROM syncur 
				INTO  @synitemtype, @synschemaname,@synobjectname,@synbaseobjectname
				END
			CLOSE syncur;
			DEALLOCATE syncur;


		END
	
END


IF EXISTS (SELECT *
   FROM sys.objects SO (NOLOCK)
   INNER JOIN sys.sql_modules SC (NOLOCK) ON SO.object_Id = SC.object_ID
   WHERE SC.[definition] LIKE @StringToSearchWildCard)
		BEGIN
			INSERT INTO @externalrefs
			(
			[database_name_checked],
			[database_id],
			[item_type_searched_for],
			[item_searched_for],
			[OBJECT_ID],
			[type_desc],
			[name],
			[create_date],
			[modify_date],
			[definition],
			[hassynonyms],
			[synonymcount]
			)
			SELECT 
			@curdbname,
			@curdbid,
			@curitemtype,
			@STRINGTOSEARCH,
			so.[object_id],
			so.[type_desc],
			SO.Name,
			so.[create_date],
			so.[modify_date],
			sc.[definition],
			@synexists,
			@syncount
			FROM sys.objects SO (NOLOCK)
			INNER JOIN sys.sql_modules SC (NOLOCK) ON SO.object_Id = SC.object_ID
			WHERE SC.[definition] LIKE @StringToSearchWildCard
			ORDER BY so.type, SO.Name
		END
ELSE
BEGIN
		INSERT INTO @externalrefs
		(
		[database_name_checked],
		[database_id],
		[item_type_searched_for],
		[item_searched_for],
		[name],
		[hassynonyms],
		[synonymcount]
		)
		VALUES
		(@curdbname,
		@curdbid,
		@curitemtype,
		@STRINGTOSEARCH,
		'Not Found',
		@synexists,
		@syncount)

END

FETCH NEXT FROM dbcur 
INTO @curdbname,@curdbid, @curitemtype, @stringtosearch
END

CLOSE dbcur;
DEALLOCATE dbcur;


SELECT 
@@SERVERNAME,
[database_name_checked],
[database_id],
CASE WHEN OBJECT_ID IS NULL THEN 'N' ELSE 'Y' END AS external_ref_found,
CASE WHEN OBJECT_ID IS NULL THEN 'N' ELSE
	CASE WHEN database_id < 0 THEN 'Y' ELSE 'N' END 
END AS other_server,
[item_searched_for],
[name],
[object_id],
[type_desc],
[hassynonyms],
[synonymcount]
FROM @externalrefs
ORDER BY item_type_searched_for DESC, external_ref_found DESC, item_searched_for

SELECT DISTINCT * FROM @synonymrefs
ORDER BY 
[database_id],
[reference_item_searched_for],
[item_searched_for_schema],
[item_type_searched_for] 

