import { AppError } from "../utils/appError.js";
//requireRole
export const authorize = (roleName) => {
  return (req, res, next) => {
    if (!req.user || !req.user.roles || !req.user.roles.includes(roleName)) {
      return next(
        new AppError(
          "Forbidden: You do not have permission to perform this action",
          403,
        ),
      );
    }

    next();
  };
};
