CREATE FUNCTION [dbo].[posSubString]
(@strSource varchar(400),
@strToFind varchar(200)) RETURNS int
AS

BEGIN

DECLARE
@position int,
@maxPos int,
@longSubStr int,
@res int,
@strSub varchar(200)

SET @position = 0
SET @res = 0
SET @longSubStr = LEN(RTRIM(LTRIM(@strToFind)))
SET @maxPos = LEN(@strSource) - @longSubStr


WHILE (@position <= @strToFind)
BEGIN
SET @strSub = SUBSTRING(@strSource, @position, @longSubStr)

IF (@strToFind = @StrSub)
BEGIN
SET @res = @position - 1
RETURN @res
END
ELSE
SET @position = @position + 1
END


RETURN @res

END

GO 