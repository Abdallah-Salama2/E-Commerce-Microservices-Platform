import { Router } from "express";
import {
  adjustStock,
  getStocksByIds,
  setStock,
} from "../controllers/stock.controller.js";
import { authorize } from "../middlewares/role.middleware.js";
import { authenticate } from "../middlewares/auth.middleware.js";

import { validate } from "../middlewares/validate.middleware.js";
import {
  stockIdsQuerySchema,
  productIdParamSchema,
  adjustStockBodySchema,
  setStockBodySchema,
} from "../validations/stock.validation.js";

const router = Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     StockRecord:
 *       type: object
 *       description: Shape returned by all three stock endpoints.
 *       properties:
 *         productId: { type: string, example: "26", description: "Returned as a string by the mssql driver (bigint column)." }
 *         quantity: { type: integer, example: 42 }
 *         updatedAt: { type: string, format: date-time, example: "2026-08-27T11:27:18.858Z" }
 */

/**
 * @swagger
 * /stock/batch:
 *   get:
 *     summary: Fetch current stock quantities for a batch of product IDs
 *     description: >
 *       Public, no auth. Returns quantity for every ID that has a stock row;
 *       any requested ID with no matching row is silently omitted (no error,
 *       no placeholder) — same convention as catalog-service's /products/batch.
 *     tags: [Stock]
 *     parameters:
 *       - in: query
 *         name: ids
 *         required: true
 *         schema: { type: string, example: "1,2,3" }
 *         description: Comma-separated list of product IDs.
 *     responses:
 *       200:
 *         description: Stock rows matching the given IDs (subset if some don't exist)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string }
 *                 data:
 *                   type: array
 *                   items: { $ref: '#/components/schemas/StockRecord' }
 */
router.get("/batch", validate(stockIdsQuerySchema, "query"), getStocksByIds);

/**
 * @swagger
 * /stock/{productId}:
 *   patch:
 *     summary: Adjust stock by a relative delta
 *     description: >
 *       Admin only. Applies `delta` to the current quantity (positive or
 *       negative). Fails if the resulting quantity would go negative, or if
 *       no stock row exists for this product.
 *     tags: [Stock]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: productId
 *         required: true
 *         schema: { type: integer, example: 26 }
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [delta]
 *             properties:
 *               delta: { type: integer, example: -5, description: "Non-zero integer; can be negative." }
 *     responses:
 *       200:
 *         description: Stock adjusted
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string }
 *                 data: { $ref: '#/components/schemas/StockRecord' }
 *       400:
 *         description: >
 *           `delta` missing/zero/non-integer, OR error 50202 "Adjustment
 *           would result in negative stock."
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Missing or invalid access token
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       403:
 *         description: Authenticated but not an Admin
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       404:
 *         description: Error 50201 "Stock row for this product does not exist."
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.patch(
  "/:productId",
  authenticate,
  authorize("Admin"),
  validate(productIdParamSchema, "params"),
  validate(adjustStockBodySchema, "body"),
  adjustStock,
);

/**
 * @swagger
 * /stock/{productId}:
 *   put:
 *     summary: Set stock to an exact quantity
 *     description: >
 *       Admin only. Overwrites the current quantity entirely (use PATCH for
 *       a relative adjustment instead). Zero is a valid value — used to
 *       explicitly mark a product out of stock.
 *     tags: [Stock]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: productId
 *         required: true
 *         schema: { type: integer, example: 26 }
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [newQuantity]
 *             properties:
 *               newQuantity: { type: integer, minimum: 0, example: 0 }
 *     responses:
 *       200:
 *         description: Stock set
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string }
 *                 data: { $ref: '#/components/schemas/StockRecord' }
 *       400:
 *         description: "`newQuantity` missing, negative, or non-integer"
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Missing or invalid access token
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       403:
 *         description: Authenticated but not an Admin
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       404:
 *         description: Error 50201 "Stock row for this product does not exist."
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.put(
  "/:productId",
  authenticate,
  authorize("Admin"),
  validate(productIdParamSchema, "params"),
  validate(setStockBodySchema, "body"),
  setStock,
);

export default router;
