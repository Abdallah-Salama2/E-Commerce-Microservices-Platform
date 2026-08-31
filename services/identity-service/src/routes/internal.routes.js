import { Router } from "express";
import { requireInternalSecret } from "../middlewares/internalAuth.middleware.js";
import { getUserContact } from "../controllers/internal.controller.js";

const router = Router();

router.use(requireInternalSecret);
router.get("/users/:id/contact", getUserContact);

export default router;