import Joi from "joi";

const PHONE_REGEX = /^\+?[1-9]\d{7,14}$/;

export const registerSchema = Joi.object({
  firstName: Joi.string().trim().min(2).max(50).required().messages({
    "string.empty": "First name is required",
    "string.min": "First name must be at least 2 characters",
    "string.max": "First name cannot exceed 50 characters",
  }),
  lastName: Joi.string().trim().min(2).max(50).required().messages({
    "string.empty": "Last name is required",
    "string.min": "Last name must be at least 2 characters",
    "string.max": "Last name cannot exceed 50 characters",
  }),
  email: Joi.string().trim().email().max(255).required().messages({
    "string.email": "Invalid email format",
    "string.max": "Email cannot exceed 255 characters",
    "string.empty": "Email is required",
  }),
  password: Joi.string().min(8).max(72, "utf8").required().messages({
    "string.empty": "Password is required",
    "string.min": "Password must be at least 8 characters",
    "string.max": "Password cannot exceed 72 bytes",
  }),
  phone: Joi.string().pattern(PHONE_REGEX).optional().messages({
    "string.pattern.base": "Invalid phone number format",
  }),
});

export const loginSchema = Joi.object({
  email: Joi.string().trim().email().max(255).required().messages({
    "string.email": "Invalid email format",
    "string.max": "Email cannot exceed 255 characters",
    "string.empty": "Email is required",
  }),
  password: Joi.string().max(72, "utf8").required().messages({
    "string.empty": "Password is required",
    "string.max": "Password cannot exceed 72 bytes",
  }),
}).required();

export const forgotPasswordSchema = Joi.object({
  email: Joi.string().trim().email().max(255).required().messages({
    "string.email": "Invalid email format",
    "string.max": "Email cannot exceed 255 characters",
    "string.empty": "Email is required",
  }),
});

export const resetPasswordSchema = Joi.object({
  token: Joi.string().hex().length(64).required().messages({
    "string.hex": "Invalid token format",
    "string.length": "Invalid token format",
  }),
  newPassword: Joi.string().min(8).max(72, "utf8").required().messages({
    "string.min": "Password must be at least 8 characters",
    "string.max": "Password cannot exceed 72 bytes",
  }),
});
