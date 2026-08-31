-- 20260827_032310_create_coupons_table.sql
-- Service: order-service
-- Type: DDL
-- Created: 2026-08-27T00:23:41.890Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'coupons')
    BEGIN
        CREATE TABLE coupons (
            id               BIGINT          IDENTITY (1, 1) PRIMARY KEY,
            code             NVARCHAR (50)   NOT NULL UNIQUE,
            discount_type    NVARCHAR (20)   NOT NULL,
            discount_value   DECIMAL (10, 2) NOT NULL,
            min_order_amount DECIMAL (10, 2) NULL,
            max_usage_count  INT             NULL,
            usage_count      INT             DEFAULT 0 NOT NULL,
            expires_at       DATETIME2       NULL,
            is_active        BIT             DEFAULT 1 NOT NULL,
            created_by       BIGINT          NULL,
            created_at       DATETIME2       DEFAULT SYSUTCDATETIME() NOT NULL,
            updated_by       BIGINT          NULL,
            updated_at       DATETIME2       DEFAULT SYSUTCDATETIME() NOT NULL,
            -- Check constraints for discount types & values
        CONSTRAINT CHK_coupons_discount_type CHECK (discount_type IN ('Percentage', 'FixedAmount')),
            CONSTRAINT CHK_coupons_discount_value CHECK (discount_value >= 0),
            CONSTRAINT CHK_coupons_min_order_amount CHECK (min_order_amount IS NULL
                                                           OR min_order_amount >= 0),
            CONSTRAINT CHK_coupons_usage_count CHECK (usage_count >= 0),
            CONSTRAINT CHK_coupons_max_usage_count CHECK (max_usage_count IS NULL
                                                          OR max_usage_count > 0),

        );
        -- Index for fast lookup of active coupons during checkout
        CREATE INDEX IX_coupons_code_active
            ON coupons(code)
            INCLUDE(discount_type, discount_value, min_order_amount, expires_at, is_active);
    END

