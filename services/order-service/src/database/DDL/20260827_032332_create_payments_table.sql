-- 20260827_032332_create_payments_table.sql
-- Service: order-service
-- Type: DDL
-- Created: 2026-08-27T00:23:32.700Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'payments')
    BEGIN
        CREATE TABLE payments (
            id         BIGINT          IDENTITY (1, 1) PRIMARY KEY,
            order_id   BIGINT          NOT NULL,
            type       NVARCHAR (20)   DEFAULT 'COD' NOT NULL,
            amount     DECIMAL (10, 2) NOT NULL,
            currency   NVARCHAR (3)    DEFAULT 'EGP' NOT NULL,
            status     NVARCHAR (20)   DEFAULT 'Pending' NOT NULL,
            created_by BIGINT          NULL,
            created_at DATETIME2       DEFAULT SYSUTCDATETIME() NOT NULL,
            updated_by BIGINT          NULL,
            updated_at DATETIME2       DEFAULT SYSUTCDATETIME() NOT NULL,
            -- Check constraints for business integrity
        CONSTRAINT CHK_payments_amount CHECK (amount >= 0),
            CONSTRAINT CHK_payments_type CHECK (type IN ('COD', 'CreditCard', 'MobileWallet')),
            CONSTRAINT CHK_payments_status CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
            -- Foreign Keys
        CONSTRAINT FK_payments_orders FOREIGN KEY (order_id) REFERENCES orders (id)
        );
        -- Index for tracking payments related to a specific order
        CREATE INDEX IX_payments_order_id
            ON payments(order_id)
            INCLUDE(type, amount, status, created_at);
    END