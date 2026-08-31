-- 20260823_160953_get_user_by_email.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:09:53.977Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_user_by_email
@Email NVARCHAR (255)
AS
BEGIN
    SELECT id,
           email,
           password_hash,
           first_name,
           last_name,
           is_active
    FROM   users
    WHERE  email = @Email;
END
