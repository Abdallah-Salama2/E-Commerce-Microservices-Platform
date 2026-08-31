import multer from "multer";
import { AppError } from "../utils/appError.js"; // حسب مسار الـ AppError عندك

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedMimeTypes = ["image/jpeg", "image/png", "image/webp"];
    if (allowedMimeTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(
        new AppError("Only JPEG, PNG, and WEBP images are allowed", 400),
        false,
      );
    }
  },
});

export const uploadSingleImage = (req, res, next) => {
  upload.single("image")(req, res, (err) => {
    if (err instanceof multer.MulterError) {
      if (err.code === "LIMIT_FILE_SIZE") {
        return next(
          new AppError(
            "File size limit exceeded. Maximum allowed size is 5MB",
            400,
          ),
        );
      }
      return next(new AppError(`Upload error: ${err.message}`, 400));
    } else if (err) {
      return next(err);
    }
    next();
  });
};
