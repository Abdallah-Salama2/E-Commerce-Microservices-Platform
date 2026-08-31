-- 20260826_190358_seed_stock.sql
-- Service: Inventory-service
-- Type: DML
-- Created: 2026-08-26T16:03:58.779Z
-- ============================================================================
-- ============================================================================
-- 20260826_184500_seed_stock.sql
-- Service: Inventory-service
-- Type: Data Seed
-- Context: Decoupled Inventory DB (refers to Catalog product_id 1..50)
-- ============================================================================

MERGE INTO stock AS target
USING (VALUES
    -- Electronics (IDs 1 - 13)
    (1, 50),   -- iPhone 15 Pro Max
    (2, 75),   -- Samsung Galaxy S24
    (3, 40),   -- Google Pixel 8
    (4, 60),   -- OnePlus 12
    (5, 30),   -- Dell XPS 15
    (6, 85),   -- MacBook Air M3
    (7, 25),   -- ASUS ROG Zephyrus
    (8, 120),  -- Sony WH-1000XM5
    (9, 150),  -- Apple AirPods Pro
    (10, 200), -- JBL Flip Speaker
    (11, 90),  -- Apple Watch Series 9
    (12, 110), -- Fitbit Charge 6
    (13, 45),  -- Garmin Forerunner 265

    -- Fashion (IDs 14 - 25)
    (14, 80),  -- Classic Denim Jacket
    (15, 120), -- Slim Fit Chino Pants
    (16, 300), -- Leather Belt
    (17, 65),  -- Wool Sweater
    (18, 95),  -- Floral Summer Dress
    (19, 40),  -- Wool Blend Coat
    (20, 70),  -- Silk Blouse
    (21, 85),  -- Pleated Midi Skirt
    (22, 140), -- Running Sneakers
    (23, 60),  -- Leather Boots
    (24, 180), -- Canvas Sneakers
    (25, 50),  -- Dress Shoes

    -- Home & Kitchen (IDs 26 - 31)
    (26, 35),  -- Espresso Machine
    (27, 90),  -- High-Speed Blender
    (28, 45),  -- Ergonomic Office Chair
    (29, 15),  -- Wooden Dining Table
    (30, 10),  -- 3-Seat Fabric Sofa
    (31, 25),  -- 5-Tier Bookshelf

    -- Sports & Outdoors (IDs 32 - 38)
    (32, 30),  -- Adjustable Dumbbells
    (33, 250), -- Yoga Mat
    (34, 400), -- Resistance Bands Set
    (35, 20),  -- 4-Person Camping Tent
    (36, 65),  -- Sleeping Bag
    (37, 50),  -- Hiking Backpack
    (38, 40),  -- Portable Camping Stove

    -- Books (IDs 39 - 44)
    (39, 150), -- Mystery Novel Collection
    (40, 130), -- Fantasy Novel Trilogy
    (41, 90),  -- Science Fiction Anthology
    (42, 210), -- Personal Finance Guide
    (43, 175), -- Everyday Cookbook
    (44, 110), -- Biography Collection

    -- Beauty & Personal Care (IDs 45 - 50)
    (45, 160), -- Vitamin C Serum
    (46, 220), -- Daily Moisturizer Cream
    (47, 180), -- Mineral Sunscreen SPF 50
    (48, 130), -- Matte Lipstick Set
    (49, 95),  -- Eyeshadow Palette
    (50, 105)  -- Liquid Foundation
) AS source (product_id, quantity)
ON target.product_id = source.product_id
WHEN NOT MATCHED THEN
    INSERT (product_id, quantity)
    VALUES (source.product_id, source.quantity);

