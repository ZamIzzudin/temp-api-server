import { Router } from "express";
import bcrypt from "bcrypt";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { userCreateSchema, userUpdateSchema } from "./user.schema";
import { requireAction } from "../../middlewares/authorization";

export const userRouter = Router();

userRouter.get("/", requireAction("user", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q ? Prisma.sql`AND coalesce(u.user_email,'') ILIKE ${`%${q}%`}` : Prisma.empty;

  const users = await prisma.$queryRaw<Array<{ id: number; user_email: string | null; user_type_user_type_id: number | null }>>(
    Prisma.sql`SELECT u.id, u.user_email, u.user_type_user_type_id FROM public.users u WHERE coalesce(u.status,1)=1 ${where} ORDER BY u."createdAt" ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.users u WHERE coalesce(u.status,1)=1 ${where}`);
  const total = Number(totalRows[0]?.count ?? 0n);

  const roleIds = Array.from(new Set(users.map((u) => u.user_type_user_type_id).filter((x): x is number => Number.isInteger(x))));
  const roles = roleIds.length > 0
    ? await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null }>>(Prisma.sql`SELECT id, user_type_name FROM public.user_types WHERE id IN (${Prisma.join(roleIds)})`)
    : [];
  const roleMap = new Map(roles.map((r) => [r.id, r]));

  return res.json({
    items: users.map((user) => ({
      id: String(user.id),
      username: user.user_email?.split("@")[0] ?? "user",
      email: user.user_email ?? "",
      role: user.user_type_user_type_id
        ? { id: String(user.user_type_user_type_id), code: `role-${user.user_type_user_type_id}`, name: roleMap.get(user.user_type_user_type_id)?.user_type_name ?? "" }
        : null,
    })),
    total,
    page,
    perPage,
    totalPages: Math.max(1, Math.ceil(total / perPage)),
  });
});

userRouter.get("/role-options", requireAction("user", "add"), async (_req, res) => {
  const roles = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null; user_type_show_on_register: boolean | null }>>`
    SELECT id, user_type_name, user_type_show_on_register FROM public.user_types WHERE coalesce(user_type_show_on_register,false)=false ORDER BY user_type_name ASC
  `;
  return res.json(roles.map((r) => ({ id: String(r.id), code: `role-${r.id}`, name: r.user_type_name ?? "" })));
});

userRouter.post("/", requireAction("user", "add"), async (req, res) => {
  const parsed = userCreateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload user tidak valid. Gunakan email valid dan password minimal 6 karakter." });

  const roleId = Number(parsed.data.roleId);
  if (!Number.isInteger(roleId)) return res.status(400).json({ message: "Role internal yang dipilih tidak valid" });

  const duplicateEmail = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.users WHERE lower(user_email)=lower(${parsed.data.email}) LIMIT 1`;
  if (duplicateEmail.length > 0) return res.status(409).json({ message: "Email tidak boleh sama" });

  const passwordHash = await bcrypt.hash(parsed.data.password, 10);
  const created = await prisma.$queryRaw<Array<{ id: number; user_email: string | null }>>`
    INSERT INTO public.users (user_email, user_password, user_type_user_type_id, user_status, "createdAt", "updatedAt", status)
    VALUES (${parsed.data.email}, ${passwordHash}, ${roleId}, 'approved'::public.enum_users_user_status, now(), now(), 1)
    RETURNING id, user_email
  `;

  return res.status(201).json({ message: "User berhasil dibuat", data: { id: String(created[0].id), username: parsed.data.username, email: created[0].user_email ?? "" } });
});

userRouter.put("/:id", requireAction("user", "edit"), async (req, res) => {
  const id = Number(String(req.params.id ?? ""));
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID user tidak valid" });

  const parsed = userUpdateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload user tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number; user_password: string | null }>>`SELECT id, user_password FROM public.users WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "User tidak ditemukan" });

  const duplicateEmail = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.users WHERE lower(user_email)=lower(${parsed.data.email}) AND id <> ${id} LIMIT 1`;
  if (duplicateEmail.length > 0) return res.status(409).json({ message: "Email tidak boleh sama" });

  const roleId = Number(parsed.data.roleId);
  const passwordHash = parsed.data.password ? await bcrypt.hash(parsed.data.password, 10) : (existing[0].user_password ?? "");

  const updated = await prisma.$queryRaw<Array<{ id: number; user_email: string | null }>>`
    UPDATE public.users SET user_email=${parsed.data.email}, user_password=${passwordHash}, user_type_user_type_id=${roleId}, "updatedAt"=now() WHERE id=${id} RETURNING id, user_email
  `;

  return res.json({ message: "User berhasil diperbarui", data: { id: String(updated[0].id), username: parsed.data.username, email: updated[0].user_email ?? "" } });
});

userRouter.delete("/:id", requireAction("user", "delete"), async (req, res) => {
  const id = Number(String(req.params.id ?? ""));
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID user tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.users WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "User tidak ditemukan" });

  await prisma.$executeRaw`UPDATE public.users SET status = 0, "updatedAt" = now() WHERE id = ${id}`;
  return res.json({ success: true, message: "User berhasil dihapus" });
});
