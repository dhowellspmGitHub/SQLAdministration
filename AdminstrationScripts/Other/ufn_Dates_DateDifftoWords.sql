 CREATE FUNCTION [dbo].[datediffToWords] 
( 
    @d1 DATETIME, 
    @d2 DATETIME 
) 
RETURNS VARCHAR(255) 
AS 
BEGIN 
    DECLARE @minutes INT, @word VARCHAR(255) 
	DECLARE @Seconds INT
	
	SET @Seconds = ABS(DATEDIFF(SECOND, @d1, @d2))
	IF @Seconds = 0
		SET @word = '0 seconds'
	ELSE
	  BEGIN
		SET @word = ''

		-- Handle the Days
		IF @Seconds >= (24*60*60)
		  BEGIN
			IF @Seconds/(24*60*60) = 1
			  BEGIN
				SET @word = RTRIM(@Seconds/(24*60*60)) + ' day'
				SET @Seconds = @Seconds % (24*60*60)				-- remove the days
				IF @Seconds >= (60*60)
					IF @Seconds/(60*60) = 1
						SET @word = @word + ', 1 hour'
					ELSE
						SET @word = @word + ', ' +  RTRIM(@Seconds/(60*60)) + ' hours'
			  END
			ELSE
				SET @word = RTRIM(@Seconds/(24*60*60)) + ' days'
			RETURN @word
		  END


		-- Handle the Hours
		SET @Seconds = @Seconds % (24*60*60)						-- remove the days
		IF @Seconds >= (60*60)
		  BEGIN
			IF @Seconds/(60*60) = 1
			  BEGIN
				SET @word = RTRIM(@Seconds/(60*60)) + ' hour'
				SET @Seconds = @Seconds % (60*60)					-- remove the hours
				IF @Seconds >= 60
					IF @Seconds/60 = 1
						SET @word = @word + ', 1 minute'
					ELSE
						SET @word = @word + ', ' +  RTRIM(@Seconds/60) + ' minutes'
			  END
			ELSE
				SET @word = RTRIM(@Seconds/(60*60)) + ' hours'
			RETURN @word
		  END


		-- Handle the Minutes
		SET @Seconds = @Seconds % (60*60)							-- remove the hours
		IF @Seconds >= 60
		  BEGIN
			IF @Seconds/60 = 1
			  BEGIN
				SET @word = @word + RTRIM(@Seconds/60) + ' minute' 
				SET @Seconds = @Seconds % 60						-- remove the minutes
				IF @Seconds = 1
					SET @word = @word + ', 1 second'
				ELSE
					SET @word = @word + ', ' +  RTRIM(@Seconds) + ' seconds'
			  END
			ELSE
				SET @word = @word + RTRIM(@Seconds/60) + ' minutes' 
			RETURN @word
		  END

		-- Handle the Seconds
		SET @Seconds = @Seconds % 60
		IF @Seconds = 1 
			SET @word = @word + RTRIM(@Seconds) + ' second' 
		ELSE
			SET @word = @word + RTRIM(@Seconds) + ' seconds' 
	  END

/*
    SET @minutes = ABS(DATEDIFF(MINUTE, @d1, @d2)) 
    IF @minutes = 0 
        SET @word = '0 minutes' 
    ELSE 
      BEGIN 
        SET @word = '' 
        IF @minutes >= (24*60) 
            SET @word = @word  
            + RTRIM(@minutes/(24*60))+' day(s), ' 
        SET @minutes = @minutes % (24*60) 
        IF @minutes >= 60 
            SET @word = @word + RTRIM(@minutes/60)+' hour(s), ' 
        SET @minutes = @minutes % 60 
        SET @word = @word + RTRIM(@minutes)+' minute(s)' 
      END 
*/

    RETURN @word 
END 

GO