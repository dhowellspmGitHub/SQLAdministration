use BIAS_DEV
go

DECLARE @ROWNUM INT, @TNAME VARCHAR(128), @COLNAME VARCHAR(128), @CURDFNAME VARCHAR(128), @NEWDFNAME VARCHAR(128)
DECLARE @TSQL NVARCHAR(2000)

DECLARE DFCURSOR CURSOR FOR
select 
ROW_NUMBER () OVER (PARTITION BY [sdfc1].[parent_object_id] ORDER BY [sdfc1].PARENT_COLUMN_ID),
object_name([sdfc1].[parent_object_id]) as [table_name],
[scol1].[name] as [column_name],
[sdfc1].[name] as [current_name]
from sys.default_constraints as sdfc1
left outer join sys.columns as scol1
on sdfc1.parent_object_id = scol1.object_id
and sdfc1.parent_column_id = scol1.column_id

OPEN DFCURSOR
FETCH NEXT FROM DFCURSOR
INTO @ROWNUM, @TNAME, @COLNAME, @CURDFNAME

WHILE @@FETCH_STATUS = 0
BEGIN
SET @NEWDFNAME = ('DF_' + @TNAME + '_' + @COLNAME + '_' + CAST(@ROWNUM AS VARCHAR(3)))

SET @TSQL = 'EXEC SP_RENAME ' + CHAR(39) + @CURDFNAME + CHAR(39) + ',' + CHAR(39) + @NEWDFNAME + CHAR(39)
PRINT @TSQL
EXEC SP_EXECUTESQL @TSQL



FETCH NEXT FROM DFCURSOR
INTO @ROWNUM, @TNAME, @COLNAME, @CURDFNAME
END
CLOSE DFCURSOR
DEALLOCATE DFCURSOR

select 
ROW_NUMBER () OVER (PARTITION BY [sdfc1].[parent_object_id] ORDER BY [sdfc1].PARENT_COLUMN_ID),
object_name([sdfc1].[parent_object_id]) as [table_name],
[scol1].[name] as [column_name],
[sdfc1].[name] as [current_name]
from sys.default_constraints as sdfc1
left outer join sys.columns as scol1
on sdfc1.parent_object_id = scol1.object_id
and sdfc1.parent_column_id = scol1.column_id