import nodemailer from "nodemailer";
import { config } from "../config";

const canSendMail = Boolean(config.smtpHost && config.smtpUser && config.smtpPass && config.smtpFrom);

const transporter = canSendMail
  ? nodemailer.createTransport({
      host: config.smtpHost,
      port: config.smtpPort,
      secure: config.smtpSecure,
      auth: {
        user: config.smtpUser,
        pass: config.smtpPass,
      },
    })
  : null;

export const sendEmail = async (payload: { to: string; subject: string; html: string; text: string }) => {
  if (!transporter) {
    return;
  }

  await transporter.sendMail({
    from: config.smtpFrom,
    to: payload.to,
    subject: payload.subject,
    html: payload.html,
    text: payload.text,
  });
};
