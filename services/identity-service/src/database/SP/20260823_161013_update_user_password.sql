-- 20260823_161013_update_user_password.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:13.472Z
-- ============================================================================
CREATE OR ALTER PROCEDURE update_user_password
@UserId BIGINT, @PasswordHash NVARCHAR (255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE users
    SET    password_hash = @PasswordHash,
           updated_at    = SYSUTCDATETIME()
    WHERE  id = @UserId;
END

