USE [master]
GO

/****** Object:  StoredProcedure [dbo].[sp_help_revlogin]    Script Date: 3/26/2024 5:39:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 IF OBJECT_ID ('sp_help_revlogin') IS NOT NULL
  DROP PROCEDURE sp_help_revlogin
  GO
  
  CREATE PROCEDURE [dbo].[sp_help_revlogin]   
  (
      @login_name sysname = NULL
	  ,@specific_database varchar(128) = NULL
	  ,@ADGroupAppName varchar(30) = NULL
	  --,@KFBSQLAppID varchar(3) = NULL
  )
  AS
  BEGIN
      DECLARE @name                     SYSNAME
      DECLARE @type                     VARCHAR (1)
      DECLARE @hasaccess                INT
      DECLARE @denylogin                INT
      DECLARE @is_disabled              INT
      DECLARE @PWD_varbinary            VARBINARY (256)
      DECLARE @PWD_string               VARCHAR (514)
      DECLARE @SID_varbinary            VARBINARY (85)
      DECLARE @SID_string               VARCHAR (514)
      DECLARE @tmpstr                   NVARCHAR (1024)
      DECLARE @is_policy_checked        VARCHAR (3)
      DECLARE @is_expiration_checked    VARCHAR (3)
      Declare @Prefix                   VARCHAR(255)
      DECLARE @defaultdb                SYSNAME
      DECLARE @defaultlanguage          SYSNAME     
      DECLARE @tmpstrRole               VARCHAR (1024)

	  DECLARE @def_db					VARCHAR(128)
	  DECLARE @def_appname				VARCHAR(30)
	  --DECLARE @appidsearchstring		VARCHAR(7)
	
	
	IF (@specific_database IS NULL)
	BEGIN
		SET @def_db = '%'
	END
	ELSE
	BEGIN
		SET @def_db = @specific_database
	END

	IF EXISTS (SELECT * FROM [tempdb].[sys].[tables] WHERE [name] = 'database_credentials_move')
	BEGIN
		DELETE FROM [tempdb].[dbo].[database_credentials_move]
		WHERE [database_name] like @specific_database
	END
	ELSE
	BEGIN
		CREATE TABLE [tempdb].[dbo].[database_credentials_move] ([database_name] varchar(128), [database_principal] varchar(128))
	END


	IF (@specific_database IS NULL)
	BEGIN
		SET @def_db = '%'
	END
	ELSE
	BEGIN
		SET @def_db = @specific_database
		SET @tmpstr = ''	
		SET @tmpstr='USE [' + @specific_database + '] ' + CHAR(13) +
		'INSERT INTO [tempdb].[dbo].[database_credentials_move] ([database_principal])' + char(13) +
		'SELECT name from sys.database_principals WHERE TYPE IN (' + CHAR(39) + 'S' + CHAR(39) + ',' + CHAR(39) + 'U' + CHAR(39) + ',' + CHAR(39) + 'G' + CHAR(39) + ') AND principal_id > 4' 
		print @tmpstr
		exec sp_executesql @tmpstr
	END
		
	IF (@ADGroupAppName IS NULL)
	BEGIN
		SET @def_appname = '%'
	END
	ELSE
	BEGIN
		SET @def_appname = ('%'+@ADGroupAppName+'%')
	END

	/*
	IF (@KFBSQLAppID IS NULL)
	BEGIN
		SET @appidsearchstring = '%'
	END
	ELSE
	BEGIN
		SET @appidsearchstring = '%'+ @KFBSQLAppID + '%'
	END
	print @appidsearchstring
	*/


	/* Exclude credentials created at server installation */
	DECLARE @loginexclusions TABLE (excludedusers NVARCHAR(128))
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT Service\MSSQLSERVER')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT SERVICE\SQLSERVERAGENT')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT SERVICE\SQLTELEMETRY')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT SERVICE\SQLWriter')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT SERVICE\Winmgmt')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\AzureDSCSA')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQLServices2018PRD')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES('KFBDOM1\SQLServices2018DEV')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQLServices2024DEV')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQLServices2024PRD')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQL_Server_SysAdmins')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQLMgtApp')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\SQL_Admins')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('KFBDOM1\FTPSQLMaint')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('NT AUTHORITY\SYSTEM')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('SQLMgtApp')
	/* Exclude credentials no longer in use that may be on the old server */
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('AzureDscSA')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('D42DiscoveryRO')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('discoveryreadonly')
	INSERT INTO @loginexclusions (excludedusers)
	VALUES ('SSISSysAdmin')
	   	  
  IF (@login_name IS NULL)
  BEGIN
	  -- If the login_name is empty, the procedure is to create all logins.  But this must take into account if the @specific_database is also null.  If @specific_database is null, then it is for all databases, else it is for the specific database.
      DECLARE login_curs CURSOR 
      FOR 
          SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin, p.default_language_name  
          FROM  sys.server_principals p 
          LEFT JOIN sys.syslogins l 
		  ON ( l.name = p.name ) 
          WHERE p.type IN ( 'S','G','U' ) 
          AND p.name <> 'sa'
          AND p.name not like '##%'
		  and p.name NOT IN (SELECT [excludedusers] FROM @loginexclusions)
		  AND p.default_database_name NOT in ('master','model','msdb','tempdb','SSISDB')
		  --AND p.name like @appidsearchstring
          ORDER BY p.name
  END
  ELSE -- @specific_database is not null or login_name is not null
          DECLARE login_curs CURSOR 
          FOR 
              SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin, p.default_language_name  
              FROM  sys.server_principals p 
              LEFT JOIN sys.syslogins l 
			  ON ( l.name = p.name ) 
			  INNER JOIN [tempdb].[dbo].[database_credentials_move] as tc1
			  on p.name = tc1.database_principal
              WHERE p.type IN ( 'S', 'G', 'U' ) 
				AND ((p.name = @login_name) OR (p.name like @def_appname))
				and p.name NOT IN (SELECT [excludedusers] FROM @loginexclusions)
				AND p.default_database_name NOT in ('master','model','msdb','tempdb','SSISDB')
				ORDER BY p.name

          OPEN login_curs 
          FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @defaultlanguage 
          IF (@@fetch_status = -1)
          BEGIN
                PRINT 'No login(s) found.'
                CLOSE login_curs
                DEALLOCATE login_curs
                RETURN -1
          END

          SET @tmpstr = '/* sp_help_revlogin script '
          PRINT @tmpstr

          SET @tmpstr = '** Generated ' + CONVERT (varchar, GETDATE()) + ' on ' + @@SERVERNAME + ' */'

          PRINT @tmpstr
          PRINT ''

          WHILE (@@fetch_status <> -1)
          BEGIN
            IF (@@fetch_status <> -2)
            BEGIN
                  PRINT ''

                  SET @tmpstr = '-- Login: ' + @name
                  PRINT @tmpstr

                  SET @tmpstr='IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'''+@name+''')'
				  Print @tmpstr 
                  Print 'BEGIN'

                  IF (@type IN ('G','U'))
					  BEGIN -- NT authenticated account/group 
						SET @tmpstr= 'IF EXISTS (SELECT * FROM [master].[sys].[databases] WHERE [name] =' + CHAR(39) +  @defaultdb + CHAR(39) +') 
						BEGIN'
						PRINT @tmpstr
						SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_DATABASE = [' + @defaultdb + ']' + ', DEFAULT_LANGUAGE = [' + @defaultlanguage + ']' 
					
					  END
                  ELSE 
                  BEGIN -- SQL Server authentication
                          -- obtain password and sid
                          SET @PWD_varbinary = CAST( LOGINPROPERTY( @name, 'PasswordHash' ) AS varbinary (256) )

                          EXEC sp_hexadecimal @PWD_varbinary, @PWD_string OUT
                          EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT

                          -- obtain password policy state
                          SELECT @is_policy_checked     = CASE is_policy_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END 
                          FROM sys.sql_logins 
                          WHERE name = @name

                          SELECT @is_expiration_checked = CASE is_expiration_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END 
                          FROM sys.sql_logins 
                          WHERE name = @name

						 SET @tmpstr= 'IF EXISTS (SELECT * FROM [master].[sys].[databases] WHERE [name] =' + CHAR(39) +  @defaultdb + CHAR(39) +') BEGIN'
						PRINT @tmpstr
                          SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' 
                                          + @SID_string + ', DEFAULT_DATABASE = [' + @defaultdb + ']' + ', DEFAULT_LANGUAGE = [' + @defaultlanguage + ']'

                          IF ( @is_policy_checked IS NOT NULL )
                          BEGIN
                            SET @tmpstr = @tmpstr + ', CHECK_POLICY = ' + @is_policy_checked
                          END

                          IF ( @is_expiration_checked IS NOT NULL )
                          BEGIN
                            SET @tmpstr = @tmpstr + ', CHECK_EXPIRATION = ' + @is_expiration_checked
                          END
						  
				END

          IF (@denylogin = 1)
          BEGIN -- login is denied access
              SET @tmpstr = @tmpstr + '; DENY CONNECT SQL TO ' + QUOTENAME( @name )
          END
          ELSE IF (@hasaccess = 0)
          BEGIN -- login exists but does not have access
              SET @tmpstr = @tmpstr + '; REVOKE CONNECT SQL TO ' + QUOTENAME( @name )
          END
          IF (@is_disabled = 1)
          BEGIN -- login is disabled
              SET @tmpstr = @tmpstr + '; ALTER LOGIN ' + QUOTENAME( @name ) + ' DISABLE'
          END 

          SET @Prefix = '
          EXEC master.dbo.sp_addsrvrolemember @loginame='''

          SET @tmpstrRole=''

          SELECT @tmpstrRole = @tmpstrRole
              + CASE WHEN sysadmin        = 1 THEN @Prefix + [LoginName] + ''', @rolename=''sysadmin'''        ELSE '' END
              + CASE WHEN securityadmin   = 1 THEN @Prefix + [LoginName] + ''', @rolename=''securityadmin'''   ELSE '' END
              + CASE WHEN serveradmin     = 1 THEN @Prefix + [LoginName] + ''', @rolename=''serveradmin'''     ELSE '' END
              + CASE WHEN setupadmin      = 1 THEN @Prefix + [LoginName] + ''', @rolename=''setupadmin'''      ELSE '' END
              + CASE WHEN processadmin    = 1 THEN @Prefix + [LoginName] + ''', @rolename=''processadmin'''    ELSE '' END
              + CASE WHEN diskadmin       = 1 THEN @Prefix + [LoginName] + ''', @rolename=''diskadmin'''       ELSE '' END
              + CASE WHEN dbcreator       = 1 THEN @Prefix + [LoginName] + ''', @rolename=''dbcreator'''       ELSE '' END
              + CASE WHEN bulkadmin       = 1 THEN @Prefix + [LoginName] + ''', @rolename=''bulkadmin'''       ELSE '' END
            FROM (
                      SELECT CONVERT(VARCHAR(100),SUSER_SNAME(sid)) AS [LoginName],
                              sysadmin,
                              securityadmin,
                              serveradmin,
                              setupadmin,
                              processadmin,
                              diskadmin,
                              dbcreator,
                              bulkadmin
                      FROM sys.syslogins
                      WHERE (       sysadmin<>0
                              OR    securityadmin<>0
                              OR    serveradmin<>0
                              OR    setupadmin <>0
                              OR    processadmin <>0
                              OR    diskadmin<>0
                              OR    dbcreator<>0
                              OR    bulkadmin<>0
                          ) 
                          AND name=@name 
                ) L 

              PRINT @tmpstr
              PRINT @tmpstrRole
              PRINT 'END'
			  PRINT 'END'
			  
          END 
          FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @defaultlanguage 
      END
      CLOSE login_curs
      DEALLOCATE login_curs
      RETURN 0
  END
GO


