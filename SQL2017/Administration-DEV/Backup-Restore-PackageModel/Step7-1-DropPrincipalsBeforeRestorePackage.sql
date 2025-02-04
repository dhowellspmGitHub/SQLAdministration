USE [RUTest1]
GO
/****** Object:  User [SSISSysAdmin]    Script Date: 8/9/2021 5:22:20 PM ******/
--DROP USER [SSISSysAdmin]
GO

DECLARE @RoleName sysname
set @RoleName = N'db_reporting'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [db_reporting]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP ROLE [db_reporting]
GO

DECLARE @RoleName sysname
set @RoleName = N'db_executor'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [db_executor]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP ROLE [db_executor]
GO

DECLARE @RoleName sysname
set @RoleName = N'db_ddlviewer'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [db_ddlviewer]    Script Date: 8/9/2021 5:22:20 PM ******/
--DROP ROLE [db_ddlviewer]
GO

/****** Object:  User [SQLMgtApp]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP USER [SQLMgtApp]
GO
/****** Object:  User [KFBDOM1\SQL_Admins]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP USER [KFBDOM1\SQL_Admins]
GO
/****** Object:  User [KFBDOM1\NPSNMIDSVC]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP USER [KFBDOM1\NPSNMIDSVC]
GO
/****** Object:  User [EPS06001181]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP USER [EPS06001181]
GO
/****** Object:  User [APS06000181]    Script Date: 8/9/2021 5:22:20 PM ******/
DROP USER [APS06000181]
GO
