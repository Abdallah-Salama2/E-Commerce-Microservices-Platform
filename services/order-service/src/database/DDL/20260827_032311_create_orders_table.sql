-- 20260827_032311_create_orders_table.sql
-- Service: order-service
-- Type: DDL
-- Created: 2026-08-27T00:23:11.369Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'orders')
    BEGIN
 CREATE TABLE orders (
            id                        BIGINT           IDENTITY (1, 1) PRIMARY KEY,
            user_id                   BIGINT           NOT NULL,
            status                    NVARCHAR (20)    DEFAULT 'Pending' NOT NULL,
            idempotency_key           UNIQUEIDENTIFIER NOT NULL UNIQUE,
            shipping_address_snapshot NVARCHAR (MAX)   NOT NULL,
            subtotal                  DECIMAL (10, 2)  NOT NULL,
            shipping_fee              DECIMAL (10, 2)  DEFAULT 0.00 NOT NULL,
            tax_amount                DECIMAL (10, 2)  DEFAULT 0.00 NOT NULL,
            discount_amount           DECIMAL (10, 2)  DEFAULT 0.00 NOT NULL,
            total_amount              DECIMAL (10, 2)  NOT NULL,
            coupon_id                 BIGINT           NULL,
            payment_method            NVARCHAR (20)    DEFAULT 'COD' NOT NULL,
            created_at                DATETIME2        DEFAULT SYSUTCDATETIME() NOT NULL,
            updated_at                DATETIME2        DEFAULT SYSUTCDATETIME() NOT NULL,
            updated_by                BIGINT           NULL,
            -- Check constraints for valid positive numbers
        -- Check constraints for valid positive numbers
            CONSTRAINT CHK_orders_subtotal CHECK (subtotal >= 0),
            CONSTRAINT CHK_orders_shipping_fee CHECK (shipping_fee >= 0),
            CONSTRAINT CHK_orders_tax_amount CHECK (tax_amount >= 0),
            CONSTRAINT CHK_orders_discount_amount CHECK (discount_amount >= 0),
            CONSTRAINT CHK_orders_total_amount CHECK (total_amount >= 0),
            CONSTRAINT CHK_orders_status CHECK (status IN ('Pending', 'Processing', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled')),
            -- Enforce mathematical breakdown integrity
            CONSTRAINT CK_orders_total_matches_breakdown CHECK (total_amount = (subtotal + shipping_fee + tax_amount - discount_amount)),
            
            CONSTRAINT FK_orders_coupons FOREIGN KEY (coupon_id) REFERENCES coupons (id)
        );
        -- Index for admin dashboard status tracking
        CREATE INDEX IX_orders_status_created
            ON orders(status, created_at DESC);
    END
