USE KFBSQLMgmt;
GO
-- Verify that the stored procedure does not already exist.
IF OBJECT_ID ( 'usp_get_error_info', 'P' ) IS NOT NULL 
    DROP PROCEDURE usp_get_error_info;
GO

-- Create procedure to retrieve error information.
CREATE PROCEDURE usp_get_error_info
AS
SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;
GO
