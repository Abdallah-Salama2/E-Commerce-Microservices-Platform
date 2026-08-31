// validations/stock.validation.js
import Joi from "joi";

// نفس الـ Pattern اللي المراجع طلبه بالظبط
export const stockIdsQuerySchema = Joi.object({
  ids: Joi.string()
    .pattern(/^\d+(,\d+){0,49}$/)
    .required()
    .messages({
      "string.pattern.base": "ids must be a comma-separated list of up to 50 positive integers",
      "any.required": "ids query parameter is required",
    }),
});

export const productIdParamSchema = Joi.object({
  productId: Joi.number().integer().positive().required().messages({
    "number.base": "Product ID must be a number",
    "number.integer": "Product ID must be an integer",
    "number.positive": "Product ID must be a positive integer",
    "any.required": "Product ID is required",
  }),
});

// بالمرة نحط Schema للـ Body عشان نشيل الـ if conditions من الكنترولر
export const adjustStockBodySchema = Joi.object({
  delta: Joi.number().integer().invalid(0).required().messages({
    "any.invalid": "delta must be a non-zero integer.",
    "any.required": "delta is required."
  }),
});

export const setStockBodySchema = Joi.object({
  newQuantity: Joi.number().integer().min(0).required().messages({
    "number.min": "newQuantity cannot be negative.",
    "any.required": "newQuantity is required."
  }),
});