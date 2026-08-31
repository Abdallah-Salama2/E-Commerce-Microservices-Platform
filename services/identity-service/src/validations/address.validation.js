import Joi from "joi";

export const createAddressSchema = Joi.object({
  label: Joi.string().trim().max(50).optional().allow("", null),
  fullName: Joi.string().trim().max(100).required(),
  phone: Joi.string()
    .trim()
    .pattern(/^\+?[0-9]{7,15}$/)
    .required()
    .messages({
      "string.pattern.base": "Phone number must be a valid format",
    }),
  line1: Joi.string().trim().max(255).required(),
  line2: Joi.string().trim().max(255).optional().allow("", null),
  city: Joi.string().trim().max(100).required(),
  governorate: Joi.string().trim().max(100).required(),
  country: Joi.string().trim().max(100).required(),
  postalCode: Joi.string().trim().max(20).optional().allow("", null),
  isDefault: Joi.boolean().default(false),
});

export const addressIdSchema = Joi.object({
  id: Joi.number().integer().positive().required().messages({
    "number.base": "Address ID must be a numeric value",
    "number.positive": "Address ID must be a positive integer",
  }),
});