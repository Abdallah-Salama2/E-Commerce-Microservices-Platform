-- 20260823_160952_create_user.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:09:52.137Z
-- ============================================================================
CREATE OR ALTER PROCEDURE create_user
@Email NVARCHAR (255), @PasswordHash NVARCHAR (255), @FirstName NVARCHAR (100), @LastName NVARCHAR (100), @Phone NVARCHAR (20), @RoleName NVARCHAR (50)
AS
BEGIN
    DECLARE @NewUserId AS BIGINT, @RoleId AS INT;
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY

        IF EXISTS (SELECT 1
                   FROM   users
                   WHERE  email = @Email)
            BEGIN
                ;THROW 50001, 'Email already exists.', 1;
            END
        INSERT  INTO users (email, password_hash, first_name, last_name, phone)
        VALUES            (@Email, @PasswordHash, @FirstName, @LastName, @Phone);
        SET @NewUserId = SCOPE_IDENTITY();
        SELECT @RoleId = id
        FROM   roles
        WHERE  name = @RoleName;
        IF @RoleId IS NULL
            BEGIN
                ;THROW 50002, 'Role does not exist.', 1;
            END
        INSERT  INTO user_roles (user_id, role_id)
        VALUES                 (@NewUserId, @RoleId);
        COMMIT TRANSACTION;
        SELECT id,
               first_name,
               email,
               created_at
        FROM   users
        WHERE  id = @NewUserId;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END

