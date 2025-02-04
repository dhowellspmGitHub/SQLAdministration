use BIAS_PRD
go
declare @rowgrowthpcnt int
set @rowgrowthpcnt = 10

declare @SpaceUsed TABLE (
	 TableName sysname
	,NumRows BIGINT
	,ReservedSpace VARCHAR(50)
	,DataSpace VARCHAR(50)
	,IndexSize VARCHAR(50)
	,UnusedSpace VARCHAR(50)
	) 
DECLARE @tname NVARCHAR(128)
DECLARE @str VARCHAR(500)
--SET @str =  'exec sp_spaceused ''?'''
DECLARE tnamecur CURSOR FOR
SELECT name
FROM sys.tables

OPEN tnamecur
FETCH NEXT FROM tnamecur
INTO @tname

WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @SpaceUsed 
EXEC sp_spaceused @objname = @tname


FETCH NEXT FROM tnamecur
INTO @tname
END

CLOSE tnamecur
DEALLOCATE tnamecur;

IF @rowgrowthpcnt is null
BEGIN
SET @rowgrowthpcnt = 0
END;

WITH currenttablespace (TableName, NumRows, UnusedSpace_KB, ReservedSpace_KB, DataSpace_KB, IndexSize_KB)
AS (
SELECT 
TableName
,NumRows
,cast(ltrim(rtrim(REPLACE(UnusedSpace,'KB',''))) as bigint) as UnusedSpace_KB
,cast(ltrim(rtrim(REPLACE(reservedspace,'KB',''))) as bigint) AS ReservedSpace_KB
,cast(ltrim(rtrim(REPLACE(DataSpace,'KB',''))) as bigint) AS DataSpace_KB
,cast(ltrim(rtrim(REPLACE(IndexSize,'KB',''))) as bigint) as IndexSize_KB
FROM @SpaceUsed 
),

calctablespace (TableName,NumRows, CurrentUsedSpace,UnusedSpace_KB,ReservedSpace_KB,AvgBytePerRecord)
AS (
SELECT
TableName
,NumRows
,(DataSpace_KB + IndexSize_KB) as CurrentUsedSpace
,UnusedSpace_KB
,ReservedSpace_KB
,(case when NumRows = 0 then cast((DataSpace_KB + IndexSize_KB) as numeric(14,2))/1 else
cast(cast((DataSpace_KB + IndexSize_KB) as numeric(14,2))/cast(NumRows as numeric(14,2)) as numeric(8,2)) end) * 1024 as AvgBytePerRecord
FROM currenttablespace
)

select 
TableName
,UnusedSpace_KB
,NumRows as currentrowcount
,cast(round(NumRows * (1+cast(@rowgrowthpcnt as decimal(4,2))/100),0) as bigint) as plannedrowcount
,CurrentUsedSpace
,cast(round((AvgBytePerRecord * cast(round(NumRows * (cast(@rowgrowthpcnt as decimal(4,2))/100),0) as bigint))/1024,1) as numeric(14,1)) as plannedtablegrowth
,cast(round(((AvgBytePerRecord * cast(round(NumRows * (1+cast(@rowgrowthpcnt as decimal(4,2))/100),0) as bigint))/1024),1) as numeric(14,1)) as anticipatedtablesizeKB
from calctablespace
ORDER BY TableName