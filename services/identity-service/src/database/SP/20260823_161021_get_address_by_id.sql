-- 20260823_161021_get_address_by_id.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:21.258Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_address_by_id
    @Id BIGINT,
    @UserId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Ownership check baked directly into the WHERE clause — never trust
    -- the service layer alone to have scoped this to the right user.
    IF NOT EXISTS (
        SELECT 1 FROM addresses WHERE id = @Id AND user_id = @UserId
    )
    BEGIN
        ;THROW 50004, 'Address not found.', 1;
    END

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
    WHERE id = @Id AND user_id = @UserId;
END

