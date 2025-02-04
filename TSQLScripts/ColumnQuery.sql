USE [KFBSQLMgmt]
GO
declare @orgcname varchar(128)
declare @cnametoconfirm varchar(128)
set @orgcname = 'ETLProcessID'
set @cnametoconfirm = 'ETLProcessID'

select 
'[' + OBJECT_SCHEMA_NAME(c1.object_id) + '].[' + object_name(c1.object_id) + ']'
,c1.name
,t1.type_desc
,t3.*
from sys.columns as c1
inner join sys.objects as t1
on c1.object_id = t1.object_id
left outer join 
(
select 
OBJECT_SCHEMA_NAME(c1.object_id) as oschemaname
,object_name(c1.object_id) as oname
,c1.name as cname
,t1.type_desc as ttype
from sys.columns as c1
inner join sys.objects as t1
on c1.object_id = t1.object_id
where c1.name like @cnametoconfirm
) as t3
on OBJECT_SCHEMA_NAME(t1.object_id) = t3.oschemaname
and object_name(t1.object_id) = t3.oname
where c1.name like @orgcname
and OBJECT_SCHEMA_NAME(c1.object_id) like 'security'
order by 
t1.type_desc
,OBJECT_SCHEMA_NAME(c1.object_id)
,object_name(c1.object_id)

/*

,[FirstReportedDate]
,[LatestReportedDate]

*/

--ALTER TABLE 
--[security].[ServerRoles]
--ADD [LatestReportedDate] DATE NULL;
