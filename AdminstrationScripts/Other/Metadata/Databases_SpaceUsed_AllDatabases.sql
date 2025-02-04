WITH CTE (database_name,sqlfilename, filetype, filetypedesc, filepath, onlinestatus, sizeinbytes)
AS
(
	SELECT
	D.name,
	F.Name AS FileType,
	F.[type],
	F.[type_desc],
	F.physical_name AS PhysicalFile,
	F.state_desc AS OnlineStatus,
	CAST(F.size*8 AS bigint)/(1024^1)  as SizeInBytes
	FROM 
	sys.master_files F
	INNER JOIN sys.databases D ON D.database_id = F.database_id
)

Select 
@@SERVERNAME,
database_name, 
filetype,
filetypedesc,
substring(filepath,1,1) as driveletter,
sum(sizeinbytes) as totalsizeinbytes
from CTE
group by database_name
,filetype
,filetypedesc
,substring(filepath,1,1)
order by database_name
,filetype
,filetypedesc
,substring(filepath,1,1)