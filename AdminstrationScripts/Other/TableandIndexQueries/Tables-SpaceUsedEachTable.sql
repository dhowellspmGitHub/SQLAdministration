use tempdb
go

declare @SpaceUsed TABLE (
	 TableName sysname
	,NumRows BIGINT
	,ReservedSpace VARCHAR(50)
	,DataSpace VARCHAR(50)
	,IndexSize VARCHAR(50)
	,UnusedSpace VARCHAR(50)
	) 

DECLARE @str VARCHAR(500)
SET @str =  'exec sp_spaceused ''?'''
INSERT INTO @SpaceUsed 
EXEC sp_msforeachtable @command1=@str

SELECT * FROM @SpaceUsed ORDER BY TableName