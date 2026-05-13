import { config } from "../../config";
import { sendEmail } from "../../lib/mailer";

const baseEmailTemplate = ({
  preheader,
  title,
  greeting,
  body,
  ctaLabel,
  ctaUrl,
  footerNote,
}: {
  preheader: string;
  title: string;
  greeting: string;
  body: string;
  ctaLabel?: string;
  ctaUrl?: string;
  footerNote: string;
}) => {
  const ctaBlock =
    ctaLabel && ctaUrl
      ? `<tr><td style="padding:0 32px 24px 32px;"><a href="${ctaUrl}" style="display:inline-block;background:#2563eb;color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:8px;font-size:14px;font-weight:600;">${ctaLabel}</a></td></tr>`
      : "";

  return `<!doctype html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${title}</title>
  </head>
  <body style="margin:0;padding:0;background:#f3f6fb;font-family:Arial,Helvetica,sans-serif;color:#1f2937;">
    <div style="display:none;max-height:0;overflow:hidden;opacity:0;">${preheader}</div>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f3f6fb;padding:24px 12px;">
      <tr>
        <td align="center">
          <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:620px;background:#ffffff;border-radius:12px;overflow:hidden;border:1px solid #e5e7eb;">
            <tr>
              <td style="background:linear-gradient(135deg,#2563eb,#1d4ed8);padding:20px 32px;color:#ffffff;">
                <p style="margin:0;font-size:12px;letter-spacing:0.8px;text-transform:uppercase;opacity:0.9;">Tol Laut System</p>
                <h1 style="margin:8px 0 0 0;font-size:22px;line-height:1.3;">${title}</h1>
              </td>
            </tr>
            <tr>
              <td style="padding:28px 32px 12px 32px;">
                <p style="margin:0 0 12px 0;font-size:15px;line-height:1.7;">${greeting}</p>
                <p style="margin:0;font-size:15px;line-height:1.7;">${body}</p>
              </td>
            </tr>
            ${ctaBlock}
            <tr>
              <td style="padding:0 32px 28px 32px;">
                <p style="margin:0;padding:12px 14px;background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;font-size:13px;line-height:1.6;color:#4b5563;">${footerNote}</p>
              </td>
            </tr>
            <tr>
              <td style="padding:14px 32px;background:#f9fafb;border-top:1px solid #e5e7eb;">
                <p style="margin:0;font-size:12px;line-height:1.6;color:#6b7280;">Email ini dikirim otomatis. Mohon tidak membalas langsung ke email ini.</p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>`;
};

export const sendRegistrationPendingEmail = async (to: string, username: string) => {
  const subject = "Registrasi berhasil - menunggu verifikasi";

  await sendEmail({
    to,
    subject,
    text: `Halo ${username}, registrasi akun Anda berhasil. Saat ini akun masih menunggu proses verifikasi dari tim admin. Kami akan mengirimkan email lanjutan setelah akun Anda disetujui.`,
    html: baseEmailTemplate({
      preheader: "Registrasi berhasil dan sedang menunggu verifikasi admin.",
      title: "Registrasi Berhasil",
      greeting: `Halo <strong>${username}</strong>,`,
      body: "Terima kasih telah melakukan pendaftaran. Data Anda sudah kami terima dan saat ini sedang menunggu proses verifikasi oleh tim admin. Setelah disetujui, Anda akan menerima email konfirmasi untuk mulai login.",
      footerNote:
        "Jika Anda merasa tidak pernah melakukan pendaftaran, abaikan email ini atau hubungi tim administrator sistem Anda.",
    }),
  });
};

export const sendRegistrationApprovedEmail = async (to: string, username: string) => {
  const subject = "Akun Anda telah disetujui";

  await sendEmail({
    to,
    subject,
    text: `Halo ${username}, akun Anda telah disetujui dan sekarang sudah bisa digunakan. Silakan login melalui ${config.appLoginUrl}.`,
    html: baseEmailTemplate({
      preheader: "Akun Anda sudah disetujui dan siap digunakan.",
      title: "Akun Disetujui",
      greeting: `Halo <strong>${username}</strong>,`,
      body: "Selamat, akun Anda telah berhasil diverifikasi. Anda sekarang sudah dapat mengakses sistem menggunakan email dan password yang didaftarkan.",
      ctaLabel: "Masuk ke Halaman Login",
      ctaUrl: config.appLoginUrl,
      footerNote:
        "Demi keamanan akun, pastikan Anda tidak membagikan kredensial login kepada pihak lain.",
    }),
  });
};
