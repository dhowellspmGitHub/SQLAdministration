use imis_test2
go

--Create a table to hold results
CREATE TABLE #ORPHLOGINS 
(DATABASE_NAME NVARCHAR(128),
LOCAL_USER_ID NVARCHAR(128),
LOCAL_USER_SID VARBINARY(100),
CMDRUN VARCHAR(2000) NULL,
IS_PROCESSED INT NOT NULL DEFAULT(0))

--Declare variables
DECLARE @SRVNAME NVARCHAR(128)
DECLARE @DB_NAME NVARCHAR(128)
DECLARE @TSQL2 NVARCHAR(1000)
DECLARE @USERNAME NVARCHAR(128)
DECLARE @LOCAL_USER_SID VARBINARY(100)
DECLARE @ERROR_NUMBER INT
DECLARE @ERROR_MESSAGE VARCHAR(4000)
DECLARE @ERROR_SEVERITY VARCHAR(20)
DECLARE @ERROR_STATE VARCHAR(20)
DECLARE @ERROR_PROCEDURE VARCHAR(50)
DECLARE @ERROR_LINE AS VARCHAR(6)

SELECT @SRVNAME = CONVERT(NVARCHAR(128),SERVERPROPERTY('SERVERNAME' ))
set @db_name = DB_NAME()

INSERT INTO #ORPHLOGINS (LOCAL_USER_ID,LOCAL_USER_SID) exec sp_change_users_login @Action='Report' 
UPDATE #ORPHLOGINS	
SET DATABASE_NAME = @DB_NAME 
WHERE DATABASE_NAME  IS NULL

WHILE EXISTS (SELECT LOCAL_USER_ID FROM #ORPHLOGINS WHERE IS_PROCESSED = 0)
BEGIN
	SELECT TOP 1 @USERNAME = LOCAL_USER_ID,@LOCAL_USER_SID = LOCAL_USER_SID  FROM #ORPHLOGINS WHERE IS_PROCESSED = 0
	BEGIN TRY
		PRINT 'Attempting remapping of user ' + @username
		PRINT 'EXEC SP_CHANGE_USERS_LOGIN @ACTION=' + CHAR(39) + 'AUTO_FIX' + CHAR(39) + ', @USERNAMEPATTERN= ' + @USERNAME 
		EXEC SP_CHANGE_USERS_LOGIN @ACTION='AUTO_FIX' , @USERNAMEPATTERN= @USERNAME 
		UPDATE #ORPHLOGINS
		SET IS_PROCESSED = 1 
		WHERE LOCAL_USER_ID = @USERNAME
	END TRY
	BEGIN CATCH
		 SELECT @ERROR_NUMBER = ERROR_NUMBER() ,
				@ERROR_MESSAGE = ERROR_MESSAGE(),
				@ERROR_SEVERITY = cast(left(ERROR_SEVERITY(),20) as varchar(20)),
				@ERROR_STATE = CAST(LEFT(ERROR_STATE(),20) AS VARCHAR(20)),
				@ERROR_PROCEDURE = CAST(LEFT(ERROR_PROCEDURE(),50) AS VARCHAR(50)),
				@ERROR_LINE = CAST(LEFT(ERROR_LINE(),6) AS VARCHAR(6))
		/*
		        ERROR_SEVERITY() AS ErrorSeverity,
		        ERROR_STATE() as ErrorState,
		        ERROR_PROCEDURE() as ErrorProcedure,
		        ERROR_LINE() as ErrorLine,
		*/
		PRINT 'Running sp_change_users_login failed for user:' + @USERNAME 
		PRINT @USERNAME + '--ERROR: Number:' + CAST(@ERROR_NUMBER AS VARCHAR(7)) + '--Error Msg:' + @ERROR_MESSAGE + '--Error Procedure' + @ERROR_PROCEDURE + '--Error Severity' + @ERROR_SEVERITY
		IF @ERROR_NUMBER = 15600  -- USER CANNOT BE MATCHED TO SQL LOGIN--DELETE THE USER
		BEGIN
				BEGIN TRY
				PRINT 'USER ' + @USERNAME + ' CANNOT BE MATCHED TO SQL LOGIN--DELETING THE USER'
				SET @TSQL2 = 'DROP USER [' + @USERNAME + ']'
				EXEC SP_EXECUTESQL @TSQL2
				END TRY
				BEGIN CATCH
			 SELECT @ERROR_NUMBER = ERROR_NUMBER() ,
			@ERROR_MESSAGE =  ERROR_MESSAGE();
			IF @ERROR_NUMBER = 203 -- USER OWNS A SCHEMA 
				PRINT 'USER ' + @USERNAME + ' USER OWNS A SCHEMA--CHANGING SCHEMA OWNERSHIP TO DBO, THEN ATTEMPTING TO DELETE THE USER AGAIN'
				PRINT @USERNAME + '--' + CAST(@ERROR_NUMBER AS VARCHAR(7)) + '--' + @ERROR_MESSAGE
				PRINT 'Changing Schema ownership to DBO on schema:' + @USERNAME
				SET @TSQL2 = 'ALTER AUTHORIZATION ON SCHEMA::' + @USERNAME + ' TO DBO '
				SET @TSQL2 = @TSQL2 + ' DROP USER [' + @USERNAME + ']'
				PRINT @TSQL2
				EXEC SP_EXECUTESQL @TSQL2
				END CATCH
		END

		UPDATE #ORPHLOGINS
		SET IS_PROCESSED = 1 
		WHERE LOCAL_USER_ID = @USERNAME
		END CATCH
IF (SELECT COUNT(*) FROM #ORPHLOGINS WHERE IS_PROCESSED = 0) =0
      BREAK
   ELSE
      CONTINUE
END

SELECT * FROM #ORPHLOGINS

DROP TABLE #ORPHLOGINS


SELECT DB_NAME()
,ROLES.NAME
,DP1.PRINCIPAL_ID
,ISNULL(SP.IS_DISABLED,0) as IS_DISABLED
,DP1.NAME
,DP1.DEFAULT_SCHEMA_NAME
,SP.NAME
,DP1.SID
FROM SYS.DATABASE_PRINCIPALS DP1
LEFT OUTER JOIN 
(
SELECT DRM.ROLE_PRINCIPAL_ID, DRM.MEMBER_PRINCIPAL_ID
,DP.NAME, DP.TYPE_DESC FROM SYS.DATABASE_PRINCIPALS DP
INNER JOIN SYS.DATABASE_ROLE_MEMBERS DRM
ON DP.PRINCIPAL_ID = DRM.ROLE_PRINCIPAL_ID
WHERE DP.TYPE LIKE 'R' ) AS ROLES ON
ROLES.MEMBER_PRINCIPAL_ID = DP1.PRINCIPAL_ID
LEFT OUTER JOIN MASTER.SYS.SERVER_PRINCIPALS SP ON 
SP.SID = DP1.SID
WHERE DP1.TYPE IN ('S','U', 'G')
ORDER BY SP.NAME