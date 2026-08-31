-- 20260823_143512_create_user_roles_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:35:12.064Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'user_roles')
    CREATE TABLE user_roles (
        user_id    BIGINT    NOT NULL,
        role_id    INT       NOT NULL,
        created_by BIGINT    NULL,
        created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,

        -- 1. Composite primary key to prevent duplicate role assignments to the same user
        -- user can take multiple roles but not same role twice
    CONSTRAINT PK_user_roles PRIMARY KEY (user_id, role_id),

    CONSTRAINT FK_user_roles_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,

    CONSTRAINT FK_user_roles_roles FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,

    CONSTRAINT FK_user_roles_created_by FOREIGN KEY (created_by) REFERENCES users (id)
    );