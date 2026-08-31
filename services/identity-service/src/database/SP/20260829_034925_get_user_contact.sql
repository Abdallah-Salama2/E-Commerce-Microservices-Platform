-- 20260829_034925_get_user_contact.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-29T00:49:25.644Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_user_contact
    @UserId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM users WHERE id = @UserId)
    BEGIN
        ;THROW 50101, 'User not found.', 1;
    END

    SELECT id AS userId, email
    FROM users
    WHERE id = @UserId;
END;

