-- 20260829_191257_get_user_by_id.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-29T16:12:57.542Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_user_by_id
@Id BIGINT
AS
BEGIN
    SELECT id,
           email,
           first_name AS firstName,
           last_name AS lastName
    FROM   users
    WHERE  id = @Id;
END


