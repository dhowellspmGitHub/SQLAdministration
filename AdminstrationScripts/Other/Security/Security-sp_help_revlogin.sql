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
	  ,@default_database varchar(128) = NULL
	  ,@ADGroupAppName varchar(30) = NULL
	  ,@KFBSQLAppID varchar(3) = NULL
  )
  AS
  BEGIN
		SET NOCOUNT ON
      DECLARE @name                     SYSNAME
      DECLARE @type                     VARCHAR (1)
      DECLARE @hasaccess                INT
      DECLARE @denylogin                INT
      DECLARE @is_disabled              INT
      DECLARE @PWD_varbinary            VARBINARY (256)
      DECLARE @PWD_string               VARCHAR (514)
      DECLARE @SID_varbinary            VARBINARY (85)
      DECLARE @SID_string               VARCHAR (514)
      DECLARE @tmpstr                   VARCHAR (1024)
      DECLARE @is_policy_checked        VARCHAR (3)
      DECLARE @is_expiration_checked    VARCHAR (3)
      Declare @Prefix                   VARCHAR(255)
      DECLARE @defaultdb                SYSNAME
      DECLARE @defaultlanguage          SYSNAME     
      DECLARE @tmpstrRole               VARCHAR (1024)

	  DECLARE @def_db					VARCHAR(128)
	  DECLARE @def_appname				VARCHAR(30)
	  DECLARE @appidsearchstring		VARCHAR(7)

	IF (@default_database IS NULL)
	BEGIN
		SET @def_db = '%'
	END
	ELSE
	BEGIN
		SET @def_db = @default_database
	END
		
	IF (@ADGroupAppName IS NULL)
	BEGIN
		SET @def_appname = '%'
	END
	ELSE
	BEGIN
		SET @def_appname = ('%'+@ADGroupAppName+'%')
	END


	IF (@KFBSQLAppID IS NULL)
	BEGIN
		SET @appidsearchstring = '%'
	END
	ELSE
	BEGIN
		SET @appidsearchstring = '%'+ @KFBSQLAppID + '%'
	END
	

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
	

	/****** Object:  Table [dbo].[tempusers]    Script Date: 1/5/2025 1:06:20 PM ******/
	IF  EXISTS (SELECT * FROM [tempdb].sys.objects WHERE name = 'tempusers' AND type in (N'U'))
	BEGIN
	DROP TABLE [tempdb].[dbo].[tempusers]
	END

	CREATE TABLE [tempdb].[dbo].[tempusers](
		[sid] [varbinary](85) NULL,
		[name] [sysname] NOT NULL,
		[type] [char](1) NOT NULL,
		[is_disabled] [bit] NULL,
		[default_database_name] [sysname] NULL,
		[hasaccess] [int] NULL,
		[denylogin] [int] NULL,
		[default_language_name] [sysname] NULL
	) ON [PRIMARY]


		-- Insert all users have their default database matching the string or their name contains the AppID
		INSERT INTO [tempdb].[dbo].[tempusers]
		([sid]
		,[name]
		,[type]
		,[is_disabled]
		,[default_database_name]
		,[hasaccess]
		,[denylogin]
		,[default_language_name])
		SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin, p.default_language_name  
		FROM  sys.server_principals p 
		LEFT JOIN sys.syslogins     l ON ( l.name = p.name ) 
		WHERE p.type IN ( 'S','G','U' ) 
		AND p.name <> 'sa'
		AND p.name not like '##%'
		and p.name NOT IN (SELECT [excludedusers] FROM @loginexclusions)
		AND (p.default_database_name like @def_db)

		-- Insert all users have their default database matching the string or their name contains the AppID
		INSERT INTO [tempdb].[dbo].[tempusers]
		([sid]
		,[name]
		,[type]
		,[is_disabled]
		,[default_database_name]
		,[hasaccess]
		,[denylogin]
		,[default_language_name])
		SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin, p.default_language_name  
		FROM  sys.server_principals p 
		LEFT JOIN sys.syslogins        l ON ( l.name = p.name ) 
		WHERE p.type IN ( 'S', 'G', 'U' ) 
		AND ((p.name = @login_name) OR (p.name like @def_appname))
		and p.name NOT IN (SELECT [excludedusers] FROM @loginexclusions)

		-- Insert all users have their default database matching the string or their name contains the AppID
		INSERT INTO [tempdb].[dbo].[tempusers]
		([sid]
		,[name]
		,[type]
		,[is_disabled]
		,[default_database_name]
		,[hasaccess]
		,[denylogin]
		,[default_language_name])
		SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin, p.default_language_name  
		FROM  sys.server_principals p 
		LEFT JOIN sys.syslogins        l ON ( l.name = p.name ) 
		WHERE p.type IN ( 'S', 'G', 'U' ) 
		AND (p.name like @appidsearchstring)
		and p.name NOT IN (SELECT [excludedusers] FROM @loginexclusions)




      DECLARE login_curs CURSOR 
      FOR 
		SELECT [sid]
		,[name]
		,[type]
		,[is_disabled]
		,[default_database_name]
		,[hasaccess]
		,[denylogin]
		,[default_language_name]
		FROM [tempdb].[dbo].[tempusers] as p
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
				IF (@type IN ('G','U'))
					BEGIN -- NT authenticated account/group 
						SET @tmpstr = ''
						SET @tmpstr = '-- Login: ' + @name
						PRINT @tmpstr
						SET @tmpstr='IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'''+@name+''')'
						Print @tmpstr 
						Print 'BEGIN'
						SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_LANGUAGE = [' + @defaultlanguage + ']' 
						PRINT @tmpstr
						SET @tmpstr = 'END'
						PRINT @tmpstr
					END
                  ELSE 
                  BEGIN -- SQL Server authentication
                          -- obtain password and sid
					set @tmpstr = ''
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

					SET @tmpstr = ''
					SET @tmpstr = '-- Login: ' + @name
					PRINT @tmpstr
					SET @tmpstr='IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'''+@name+''')'
					Print @tmpstr 
					Print 'BEGIN'
						
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
						WHERE (sysadmin<>0
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
		  END 
          FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @defaultlanguage 
      END
      CLOSE login_curs
      DEALLOCATE login_curs
      RETURN 0
  END
GO


