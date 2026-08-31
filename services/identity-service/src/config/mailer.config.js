import nodemailer from "nodemailer";
import { env } from "./env.js";

const transporter = nodemailer.createTransport({
  host: env.SMTP.HOST,
  port: Number(env.SMTP.PORT) || 587,
  secure: env.SMTP.PORT === "465", // true for 465, false for other ports
  auth: {
    user: env.SMTP.USER,
    pass: env.SMTP.PASSWORD,
  },
});

/**
 * إرسال إيميل إعادة تعيين كلمة المرور
 */
export const sendPasswordResetEmail = async (toEmail, resetToken) => {
  // رابط الواجهة الأمامية (Frontend) الذي سيتوجه إليه المستخدم
  const resetUrl = `${env.CLIENT_URL || "http://localhost:5000"}/reset-password?token=${resetToken}`;

  const mailOptions = {
    from: env.SMTP.FROM,
    to: toEmail,
    subject: "Password Reset Request",
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6;">
        <h2>Password Reset Request</h2>
        <p>You requested to reset your password. Click the link below to set a new password:</p>
        <p>
          <a href="${resetUrl}" style="background-color: #007bff; color: #fff; padding: 10px 15px; text-decoration: none; border-radius: 4px; display: inline-block;">
            Reset Password
          </a>
        </p>
        <p>This link will expire in 15 minutes.</p>
        <p>If you didn't request this, please ignore this email.</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
};
