use eBusiness_PmtInt_DEV
go

select 
db_name() as database_name
,so1.name
--,definition
,uses_ansi_nulls
,uses_quoted_identifier
from sys.sql_modules as sm1
inner join sys.objects as so1
on sm1.object_id = so1.object_id
--where so1.name in 
--  (
--  'kfb_convert_transaction_data'
--,'kfb_pre_2016_convert_transaction_data'
--,'kfb_combined_old_element_lookup'
--,'kfb_convert_curline'
--,'kfb_convert_elements_lookup'
--,'kfb_convert_update_elements_lookup'
--   )
order by so1.name

SELECT Distinct 
   DB_NAME() AS DatabaseSearched,
      SO.Name, 
   SC.colid,
   SC.[text]
   FROM sysobjects SO (NOLOCK)
   INNER JOIN syscomments SC (NOLOCK) on SO.Id = SC.ID
   AND SO.Type in ('P','FN','TF')
	--AND SC.Text LIKE @WCStringToFind
   ORDER BY SO.Name, SC.colid