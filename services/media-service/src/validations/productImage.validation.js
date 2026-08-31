import Joi from "joi";


export const productIdParamSchema = Joi.object({
  id: Joi.number().integer().positive().required().messages({
    "number.base": "Product ID must be a number",
    "number.integer": "Product ID must be an integer",
    "number.positive": "Product ID must be a positive integer",
    "any.required": "Product ID is required",
  }),
});


export const productImageParamSchema = Joi.object({
  id: Joi.number().integer().positive().required().messages({
    "number.base": "Product ID must be a valid number",
    "number.positive": "Product ID must be a positive integer",
    "any.required": "Product ID is required",
  }),
  imageId: Joi.number().integer().positive().required().messages({
    "number.base": "Image ID must be a valid number",
    "number.positive": "Image ID must be a positive integer",
    "any.required": "Image ID is required",
  }),
});

export const imagesBatchQuerySchema = Joi.object({
  ids: Joi.string().pattern(/^\d+(,\d+)*$/).required().messages({
    "string.pattern.base": "ids must be a comma-separated list of positive integers",
  }),
});
