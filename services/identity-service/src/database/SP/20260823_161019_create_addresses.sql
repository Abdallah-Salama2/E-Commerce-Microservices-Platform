-- 20260823_161019_create_addresses.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:19.258Z
-- ============================================================================
CREATE OR ALTER PROCEDURE create_address
    @UserId BIGINT,
    @Label NVARCHAR(50) = NULL,
    @FullName NVARCHAR(150),
    @Phone NVARCHAR(20),
    @Line1 NVARCHAR(255),
    @Line2 NVARCHAR(255) = NULL,
    @City NVARCHAR(100),
    @Governorate NVARCHAR(100),
    @Country NVARCHAR(100) = 'Egypt',
    @PostalCode NVARCHAR(20) = NULL,
    @IsDefault BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- A user should never end up with zero default addresses —
        -- if this is their first, force it to be the default regardless
        -- of what was passed in.
        IF NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = @UserId)
            SET @IsDefault = 1;

        -- Same "unset all, then set one" pattern as prd.set_primary_product_image
        IF @IsDefault = 1
        BEGIN
            UPDATE addresses
            SET is_default = 0
            WHERE user_id = @UserId;
        END

        INSERT INTO addresses (
            user_id, label, full_name, phone, line1, line2,
            city, governorate, country, postal_code, is_default,
            created_at, updated_at
        )
        VALUES (
            @UserId, @Label, @FullName, @Phone, @Line1, @Line2,
            @City, @Governorate, @Country, @PostalCode, @IsDefault,
            SYSUTCDATETIME(), SYSUTCDATETIME()
        );

        DECLARE @NewAddressId BIGINT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            id,
            user_id AS userId,
            label,
            full_name AS fullName,
            phone,
            line1,
            line2,
            city,
            governorate,
            country,
            postal_code AS postalCode,
            is_default AS isDefault,
            created_at AS createdAt,
            updated_at AS updatedAt
        FROM addresses
        WHERE id = @NewAddressId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END

