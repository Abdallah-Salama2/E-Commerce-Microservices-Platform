import { Router } from "express";
import { index, show, store } from "../controllers/address.controller.js";
import { authenticate } from "../middlewares/auth.middleware.js";
import { validate } from "../middlewares/validate.middleware.js";
import {
  addressIdSchema,
  createAddressSchema,
} from "../validations/address.validation.js";

const router = Router();

// Require bearer authentication for all address endpoints
router.use(authenticate);

/**
 * @swagger
 * components:
 *   schemas:
 *     Address:
 *       type: object
 *       properties:
 *         id: { type: string, example: "12" }
 *         userId: { type: string, example: "8" }
 *         label: { type: string, nullable: true, example: "Home" }
 *         fullName: { type: string, example: "Jane Doe" }
 *         phone: { type: string, example: "+201234567890" }
 *         line1: { type: string, example: "123 Main St" }
 *         line2: { type: string, nullable: true, example: "Apt 4B" }
 *         city: { type: string, example: "Cairo" }
 *         governorate: { type: string, example: "Cairo" }
 *         country: { type: string, example: "Egypt" }
 *         postalCode: { type: string, nullable: true, example: "11511" }
 *         isDefault: { type: boolean, example: true }
 *         createdAt: { type: string, format: date-time }
 *         updatedAt: { type: string, format: date-time }
 */

/**
 * @swagger
 * /addresses:
 *   get:
 *     summary: Retrieve all addresses for the authenticated user
 *     tags: [Addresses]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of user addresses
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Addresses fetched successfully" }
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Address'
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.get("/", index);

/**
 * @swagger
 * /addresses:
 *   post:
 *     summary: Create a new shipping address
 *     tags: [Addresses]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [fullName, phone, line1, city, governorate, country]
 *             properties:
 *               label: { type: string, maxLength: 50, example: "Home" }
 *               fullName: { type: string, maxLength: 100, example: "Jane Doe" }
 *               phone: { type: string, example: "+201234567890", description: "Format: +?[0-9]{7,15}" }
 *               line1: { type: string, maxLength: 255, example: "123 Main St" }
 *               line2: { type: string, maxLength: 255, example: "Apt 4B" }
 *               city: { type: string, maxLength: 100, example: "Cairo" }
 *               governorate: { type: string, maxLength: 100, example: "Cairo" }
 *               country: { type: string, maxLength: 100, example: "Egypt" }
 *               postalCode: { type: string, maxLength: 20, example: "11511" }
 *               isDefault: { type: boolean, default: false }
 *     responses:
 *       201:
 *         description: Address created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Address created successfully" }
 *                 data: { $ref: '#/components/schemas/Address' }
 *       400:
 *         description: Validation error (missing fields, bad format, or length exceeded)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post("/", validate(createAddressSchema, "body"), store);

/**
 * @swagger
 * /addresses/{id}:
 *   get:
 *     summary: Get a specific address by ID
 *     tags: [Addresses]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *           minimum: 1
 *         description: Positive integer ID of the target address
 *     responses:
 *       200:
 *         description: Address details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Address fetched successfully" }
 *                 data: { $ref: '#/components/schemas/Address' }
 *       400:
 *         description: Invalid address ID parameter (non-numeric or non-positive)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       404:
 *         description: Address not found for this user
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.get("/:id", validate(addressIdSchema, "params"), show);

export default router;