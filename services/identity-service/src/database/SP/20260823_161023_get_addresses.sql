-- 20260823_161023_get_addresses.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:23.204Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_addresses
    @UserId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

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
    WHERE user_id = @UserId
    ORDER BY is_default DESC, created_at DESC;
END

