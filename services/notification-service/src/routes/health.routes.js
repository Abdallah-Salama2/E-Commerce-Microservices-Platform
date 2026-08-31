import { Router } from "express";

const router = Router();

router.get("/health", (req, res) => {
  res.status(200).json({ success: true, message: "notification-service is healthy" });
});

export default router;