-- 20260823_160955_get_user_roles_by_user_id.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:09:55.788Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_user_roles_by_user_id
@UserId BIGINT
AS
BEGIN
    SELECT r.name
    FROM   roles AS r
           INNER JOIN
           user_roles AS ur
           ON r.id = ur.role_id
    WHERE  ur.user_id = @UserId;
END