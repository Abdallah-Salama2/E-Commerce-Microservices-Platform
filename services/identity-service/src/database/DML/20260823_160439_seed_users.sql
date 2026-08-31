-- 20260823_160439_seed_users.sql
-- Service: identity-service
-- Type: DML
-- Created: 2026-08-23T13:04:39.425Z
-- ============================================================================

-------------------------------------------------------------------
-- Seed Initial Users, User Roles, and Addresses (Safe for re-execution)
-------------------------------------------------------------------
BEGIN TRANSACTION;

BEGIN TRY
    -------------------------------------------------------------------
    -- 1. Declare Local Variables for Role IDs and User IDs
    -------------------------------------------------------------------
    DECLARE @AdminRoleId AS INT, @CustomerRoleId AS INT;
    DECLARE @AdminUserId AS BIGINT, @CustomerUserId AS BIGINT, @Customer2UserId AS BIGINT;

    -- Fetch existing Role IDs from roles
    SELECT @AdminRoleId = id
    FROM   roles
    WHERE  name = 'Admin';
    
    SELECT @CustomerRoleId = id
    FROM   roles
    WHERE  name = 'Customer';
    
    -------------------------------------------------------------------
    -- 2. Insert Admin User (Password: mySecretPassword)
    -------------------------------------------------------------------
    IF NOT EXISTS (SELECT 1
                   FROM   users
                   WHERE  email = 'admin@example.com')
        BEGIN
            INSERT  INTO users (email, password_hash, first_name, last_name, phone)
            VALUES            ('admin@example.com', '$2b$10$p4PjBar7q2b9mkpe7xmaA.P5OUPOo7TIPbOCOgqvqLNYYve2Zdixq', 'System', 'Admin', '+1234567890');
            SET @AdminUserId = SCOPE_IDENTITY();
        END
    ELSE
        BEGIN
            SELECT @AdminUserId = id
            FROM   users
            WHERE  email = 'admin@example.com';
        END
        
    -------------------------------------------------------------------
    -- 3. Insert Customer 1 (Password: mySecretPassword)
    -------------------------------------------------------------------
    IF NOT EXISTS (SELECT 1
                   FROM   users
                   WHERE  email = 'customer@example.com')
        BEGIN
            INSERT  INTO users (email, password_hash, first_name, last_name, phone)
            VALUES            ('customer@example.com', '$2b$10$p4PjBar7q2b9mkpe7xmaA.P5OUPOo7TIPbOCOgqvqLNYYve2Zdixq', 'John', 'Doe', '+1987654321');
            SET @CustomerUserId = SCOPE_IDENTITY();
        END
    ELSE
        BEGIN
            SELECT @CustomerUserId = id
            FROM   users
            WHERE  email = 'customer@example.com';
        END

    -------------------------------------------------------------------
    -- 4. Insert Customer 2 (Password: mySecretPassword)
    -------------------------------------------------------------------
    IF NOT EXISTS (SELECT 1
                   FROM   users
                   WHERE  email = 'customer2@example.com')
        BEGIN
            INSERT  INTO users (email, password_hash, first_name, last_name, phone)
            VALUES            ('customer2@example.com', '$2b$10$p4PjBar7q2b9mkpe7xmaA.P5OUPOo7TIPbOCOgqvqLNYYve2Zdixq', 'Jane', 'Smith', '+1122334455');
            SET @Customer2UserId = SCOPE_IDENTITY();
        END
    ELSE
        BEGIN
            SELECT @Customer2UserId = id
            FROM   users
            WHERE  email = 'customer2@example.com';
        END
        
    -------------------------------------------------------------------
    -- 5. Assign Roles in user_roles Table
    -------------------------------------------------------------------
    -- Assign Admin Role
    IF NOT EXISTS (SELECT 1
                   FROM   user_roles
                   WHERE  user_id = @AdminUserId
                          AND role_id = @AdminRoleId)
        BEGIN
            INSERT  INTO user_roles (user_id, role_id)
            VALUES                 (@AdminUserId, @AdminRoleId);
        END
        
    -- Assign Customer Role to Customer 1
    IF NOT EXISTS (SELECT 1
                   FROM   user_roles
                   WHERE  user_id = @CustomerUserId
                          AND role_id = @CustomerRoleId)
        BEGIN
            INSERT  INTO user_roles (user_id, role_id)
            VALUES                 (@CustomerUserId, @CustomerRoleId);
        END

    -- Assign Customer Role to Customer 2
    IF NOT EXISTS (SELECT 1
                   FROM   user_roles
                   WHERE  user_id = @Customer2UserId
                          AND role_id = @CustomerRoleId)
        BEGIN
            INSERT  INTO user_roles (user_id, role_id)
            VALUES                 (@Customer2UserId, @CustomerRoleId);
        END

    -------------------------------------------------------------------
    -- 6. Insert Addresses for Users
    -------------------------------------------------------------------
    -- Admin Address
    IF NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = @AdminUserId)
        BEGIN
            INSERT INTO addresses (user_id, label, full_name, phone, line1, line2, city, governorate, country, postal_code, is_default)
            VALUES (@AdminUserId, 'Office', 'System Admin', '+1234567890', '123 Tech Street', 'Suite 100', 'Cairo', 'Cairo Governorate', 'Egypt', '11511', 1);
        END

    -- Customer 1 Address
    IF NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = @CustomerUserId)
        BEGIN
            INSERT INTO addresses (user_id, label, full_name, phone, line1, line2, city, governorate, country, postal_code, is_default)
            VALUES (@CustomerUserId, 'Home', 'John Doe', '+1987654321', '456 Nile Corniche', NULL, 'Giza', 'Giza Governorate', 'Egypt', '12511', 1);
        END

    -- Customer 2 Address
    IF NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = @Customer2UserId)
        BEGIN
            INSERT INTO addresses (user_id, label, full_name, phone, line1, line2, city, governorate, country, postal_code, is_default)
            VALUES (@Customer2UserId, 'Home', 'Jane Smith', '+1122334455', '789 El Horreya Road', 'Apartment 4B', 'Alexandria', 'Alexandria Governorate', 'Egypt', '21521', 1);
        END
        
    COMMIT TRANSACTION;
    PRINT '✅ Seed users, roles, and addresses inserted successfully!';
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW;
END CATCH