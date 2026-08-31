import { Router } from "express";
import { requireInternalSecret } from "../middlewares/internalAuth.middleware.js";
import { clearCartForUser } from "../controllers/internal.controller.js";

const router = Router();

// Everything under this router requires the internal secret, not a user
// JWT — deliberately kept in its own file/prefix (mounted at, e.g.,
// /api/internal in app.js) so it's obvious at a glance which routes are
// meant for other services to call, never a browser/frontend client.
router.use(requireInternalSecret);

router.post("/cart/clear", clearCartForUser);

export default router;