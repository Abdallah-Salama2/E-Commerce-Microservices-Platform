// notification-service/src/config/mailer.config.js
import nodemailer from "nodemailer";
import { env } from "./env.js";
import { getLogger } from "../utils/logger.js";

const transporter = nodemailer.createTransport({
  host: env.SMTP.HOST,
  port: Number(env.SMTP.PORT) || 587,
  secure: env.SMTP.PORT === "465",
  auth: {
    user: env.SMTP.USER,
    pass: env.SMTP.PASSWORD,
  },
});

export const sendOrderConfirmedEmail = async (toEmail, orderId) => {
  const mailOptions = {
    from: env.SMTP.FROM,
    to: toEmail,
    subject: `Your order #${orderId} is confirmed`,
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6;">
        <h2>Order Confirmed</h2>
        <p>Good news — your order <strong>#${orderId}</strong> has been confirmed and is being prepared.</p>
        <p>We'll let you know once it ships.</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
  getLogger().info(
    { previewUrl: nodemailer.getTestMessageUrl(mailOptions) },
    "Email preview (Ethereal)",
  );
};

export const sendOrderCancelledEmail = async (toEmail, orderId) => {
  const mailOptions = {
    from: env.SMTP.FROM,
    to: toEmail,
    subject: `Your order #${orderId} was cancelled`,
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6;">
        <h2>Order Cancelled</h2>
        <p>Unfortunately, order <strong>#${orderId}</strong> couldn't be fulfilled and has been cancelled.</p>
        <p>If any payment was taken, it will be refunded. Contact support if you have questions.</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
    getLogger().info(
    { previewUrl: nodemailer.getTestMessageUrl(mailOptions) },
    "Email preview (Ethereal)",
  );
};
