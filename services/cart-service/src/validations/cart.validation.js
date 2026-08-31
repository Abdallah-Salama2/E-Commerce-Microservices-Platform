import Joi from "joi";

export const addCartItemSchema = Joi.object({
  productId: Joi.number().integer().positive().required().messages({
    "number.base": "ProductId must be a number",
    "number.positive": "ProductId must be a positive integer",
    "any.required": "ProductId is required",
  }),
  quantity: Joi.number().integer().min(1).required().messages({
    "number.base": "Quantity must be a number",
    "number.min": "Quantity must be at least 1",
    "any.required": "Quantity is required",
  }),
});

export const updateCartItemSchema = Joi.object({
  quantity: Joi.number().integer().min(1).required().messages({
    "number.base": "Quantity must be a number",
    "number.min": "Quantity must be at least 1",
    "any.required": "Quantity is required",
  }),
});

export const productIdParamSchema = Joi.object({
  productId: Joi.number().integer().positive().required().messages({
    "number.base": "Product ID must be a number",
    "number.positive": "Product ID must be a positive integer",
    "any.required": "Product ID is required",
  }),
});

/**
 * Only used by the internal /merge endpoint (identity-service -> this
 * service, on login) -- never called by the browser. userId comes
 * through as a string in JWT claims throughout this project (mssql
 * BigInt columns are returned as strings by the driver), so validated
 * as a string here too, for consistency with how it flows everywhere else.
 */
export const mergeCartSchema = Joi.object({
  userId: Joi.string().required().messages({
    "any.required": "userId is required",
  }),
  guestSessionId: Joi.string().guid({ version: "uuidv4" }).required().messages({
    "string.guid": "guestSessionId must be a valid UUID",
    "any.required": "guestSessionId is required",
  }),
});