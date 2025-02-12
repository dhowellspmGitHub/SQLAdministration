USE [CI_M]
GO

CREATE PROCEDURE [dbo].[Find_Text_In_SP]
@StringToFind varchar(100) 
AS 
DECLARE @WCStringToFind VARCHAR(100)
   SET @WCStringToFind = '%' + @StringToFind + '%'
   SELECT Distinct 
   DB_NAME() AS DatabaseSearched,
   @StringToFind as StringToFind,
   SO.Name
   FROM sysobjects SO (NOLOCK)
   INNER JOIN syscomments SC (NOLOCK) on SO.Id = SC.ID
   AND SO.Type in ('P','FN','TF')
	AND SC.Text LIKE @WCStringToFind
   ORDER BY SO.Name
/*
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
   */
GO



create table #objectswithsynonyms 
(dbsearched varchar(128) NULL,
stringtofind varchar(128) null,
spname varchar(128) null)

declare @synname varchar(128)
declare syncursor cursor
for
select name
from sys.synonyms

open syncursor
fetch next from syncursor
into @synname
while @@FETCH_STATUS = 0
begin
insert into #objectswithsynonyms (dbsearched,stringtofind,spname)
EXEC [dbo].[Find_Text_In_SP] @StringToFind = @synname
fetch next from syncursor
into @synname
end

close syncursor
deallocate syncursor


select 
s1.name,
t2.*
from sys.synonyms as s1
Left outer join #objectswithsynonyms as t2
on s1.name = t2.stringtofind
where spname is null

drop table #objectswithsynonyms
