-- 20260829_040517_create_notification_logs_table.sql
-- Service: notification-service
-- Type: DDL
-- Created: 2026-08-29T01:05:17.393Z
-- ============================================================================
CREATE TABLE notification_log (
    id           BIGINT        IDENTITY(1,1) NOT NULL PRIMARY KEY,
    order_id     BIGINT        NOT NULL,  -- references order-service's orders.id — no FK possible
    event_type   NVARCHAR(50)  NOT NULL,  -- 'order.confirmed' | 'order.cancelled'
    sent_at      DATETIME2(7)  NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_notification_log_order_event UNIQUE (order_id, event_type)
);

