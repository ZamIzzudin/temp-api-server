import { Router } from "express";
import bcrypt from "bcrypt";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { requireAction } from "../../middlewares/authorization";
import { registerSchema, registrationDecisionSchema } from "./registration.schema";
import { sendRegistrationApprovedEmail, sendRegistrationPendingEmail } from "./registration.mail";

export const registrationRouter = Router();

registrationRouter.get("/role-options", async (_req, res) => {
  const roles = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null }>>`
    SELECT id, user_type_name FROM public.user_types WHERE coalesce(user_type_show_on_register,false)=true ORDER BY user_type_name ASC
  `;

  return res.json(roles.map((r) => ({ id: String(r.id), code: `role-${r.id}`, name: r.user_type_name ?? "" })));
});

registrationRouter.post("/register", async (req, res) => {
  const parsed = registerSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload registrasi tidak valid. Gunakan email valid dan password minimal 6 karakter." });

  const roleId = Number(parsed.data.roleId);
  if (!Number.isInteger(roleId)) return res.status(400).json({ message: "Role eksternal tidak valid" });

  const existingUser = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.users WHERE lower(user_email)=lower(${parsed.data.email}) LIMIT 1`;
  if (existingUser.length > 0) return res.status(409).json({ message: "Email sudah terdaftar" });

  const role = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.user_types WHERE id=${roleId} AND coalesce(user_type_show_on_register,false)=true LIMIT 1`;
  if (role.length === 0) return res.status(400).json({ message: "Role eksternal tidak valid" });

  const passwordHash = await bcrypt.hash(parsed.data.password, 10);
  await prisma.$executeRaw`
    INSERT INTO public.users (user_email, user_password, user_type_user_type_id, user_status, "createdAt", "updatedAt", status)
    VALUES (${parsed.data.email}, ${passwordHash}, ${roleId}, 'waiting'::public.enum_users_user_status, now(), now(), 1)
  `;

  try {
    await sendRegistrationPendingEmail(parsed.data.email, parsed.data.username);
  } catch (error) {
    console.error("Failed to send pending registration email", error);
  }

  return res.status(201).json({ message: "Registrasi berhasil, menunggu approval" });
});

registrationRouter.get("/pending", requireAction("approve-registration", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q
    ? Prisma.sql`WHERE u.user_status = 'waiting'::public.enum_users_user_status AND (coalesce(u.user_email,'') ILIKE ${`%${q}%`})`
    : Prisma.sql`WHERE u.user_status = 'waiting'::public.enum_users_user_status`;

  const rows = await prisma.$queryRaw<Array<{ id: number; user_email: string | null; createdAt: Date; role_id: number | null; role_name: string | null }>>(
    Prisma.sql`SELECT u.id, u.user_email, u."createdAt", r.id as role_id, r.user_type_name as role_name FROM public.users u LEFT JOIN public.user_types r ON r.id = u.user_type_user_type_id ${where} ORDER BY u."createdAt" ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.users u ${where}`);
  const total = Number(totalRows[0]?.count ?? 0n);

  return res.json({
    items: rows.map((row) => ({ id: String(row.id), username: row.user_email?.split("@")[0] ?? "user", email: row.user_email ?? "", role: row.role_id ? { id: String(row.role_id), code: `role-${row.role_id}`, name: row.role_name ?? "" } : null, createdAt: row.createdAt })),
    total,
    page,
    perPage,
    totalPages: Math.max(1, Math.ceil(total / perPage)),
  });
});

registrationRouter.post("/approve", requireAction("approve-registration", "approve"), async (req, res) => {
  const parsed = registrationDecisionSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload approval tidak valid" });

  const id = Number(parsed.data.registrationId);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "Data registrasi tidak ditemukan" });

  const row = await prisma.$queryRaw<Array<{ id: number; user_email: string | null }>>`SELECT id, user_email FROM public.users WHERE id = ${id} AND user_status = 'waiting'::public.enum_users_user_status LIMIT 1`;
  if (row.length === 0) return res.status(404).json({ message: "Data registrasi tidak ditemukan" });

  await prisma.$executeRaw`UPDATE public.users SET user_status='approved'::public.enum_users_user_status, "updatedAt"=now() WHERE id=${id}`;

  try {
    await sendRegistrationApprovedEmail(row[0].user_email ?? "", row[0].user_email?.split("@")[0] ?? "user");
  } catch (error) {
    console.error("Failed to send registration approved email", error);
  }

  return res.json({ success: true });
});

registrationRouter.post("/reject", requireAction("approve-registration", "approve"), async (req, res) => {
  const parsed = registrationDecisionSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload reject tidak valid" });

  const id = Number(parsed.data.registrationId);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "Data registrasi tidak ditemukan" });

  await prisma.$executeRaw`UPDATE public.users SET user_status='rejected'::public.enum_users_user_status, "updatedAt"=now() WHERE id=${id}`;
  return res.json({ success: true });
});
