import Joi from "joi";

const ALLOWED_STATUSES = [
  "Pending",
  "Processing",
  "Confirmed",
  "Shipped",
  "Delivered",
  "Cancelled",
];

// Added schema to validate route parameters (:id)
export const orderIdParamSchema = Joi.object({
  id: Joi.number().integer().positive().required(),
});

export const placeOrderSchema = Joi.object({
  addressId: Joi.number().integer().positive().required(),
  idempotencyKey: Joi.string().guid({ version: "uuidv4" }).required(),
});

export const updateOrderStatusSchema = Joi.object({
  newStatus: Joi.string()
    .valid(...ALLOWED_STATUSES)
    .required()
    .messages({
      "any.only": `newStatus must be one of: ${ALLOWED_STATUSES.join(", ")}`,
      "any.required": "newStatus field is required",
    }),
}).required();

export const getOrdersQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  pageSize: Joi.number().integer().min(1).max(100).default(20),
  sortOrder: Joi.string().valid("ASC", "DESC").default("DESC"),
  // Reused ALLOWED_STATUSES to prevent drift and feature gaps
  status: Joi.string().valid(...ALLOWED_STATUSES).optional(),
});