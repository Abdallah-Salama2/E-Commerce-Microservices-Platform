import { AppError } from "../utils/appError.js";

// source: which part of the request to validate — defaults to body,
// but Phase 4 will need "params" for routes like PATCH /categories/:id
// and possibly "query" for list/filter endpoints like GET /products?category=...
export const validate =
  (schema, source = "body") =>
  (req, res, next) => {
    const { error, value } = schema.validate(req[source] ?? {}, {
      abortEarly: false, // collect all validation errors, not just the first
      stripUnknown: true, // silently drop fields not defined in the schema
    });

    if (error) {
      const message = error.details.map((d) => d.message).join(", ");
      return next(new AppError(message, 400));
    }
    // [LOG 1]
    // console.log("1. Insi de Validate Middleware:", {
    //   pageValue: value.page,
    //   pageType: typeof value.page,
    // });
    // req.query is getter-only in Express, so mutate its keys instead of replacing it
    if (source === "query") {
      req.validatedQuery = value;
    } else {
      req[source] = value;
    }
    next();
  };
