import rateLimit from "express-rate-limit";

// 1. عداد واسع وكريم للـ Public Read (محلات الزباين / البوتات)
export const publicReadLimiter = rateLimit({
  windowMs: 60 * 1000, // دقيقة واحدة
  max: 100, // 100 طلب في الدقيقة لكل IP (رقم محترم جداً لمستخدم طبيعي، ويكسر الـ Scraper)
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Too many requests from this IP, please try again later." },
});

// 2. عداد أضيق للـ Admin Mutations (التعديل والكتابة)
export const adminWriteLimiter = rateLimit({
  windowMs: 60 * 1000, // دقيقة واحدة
  max: 20, // 20 طلب في الدقيقة كفاية أوي لأي أدمن بشري، ويحمي من أي سكريبت خبيث أو لوب
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Too many admin requests, please slow down." },
});