import { Router } from "express";
import { z } from "zod";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { roleCreateSchema, roleUpdateSchema } from "./role.schema";
import { requireAction } from "../../middlewares/authorization";

export const roleRouter = Router();

roleRouter.get("/", requireAction("role", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q ? Prisma.sql`WHERE coalesce(user_type_name,'') ILIKE ${`%${q}%`}` : Prisma.empty;

  const items = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null; user_type_show_on_register: boolean | null; createdAt: Date }>>(
    Prisma.sql`SELECT id, user_type_name, user_type_show_on_register, "createdAt" FROM public.user_types ${where} ORDER BY "createdAt" ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.user_types ${where}`);
  const total = Number(totalRows[0]?.count ?? 0n);

  return res.json({
    items: items.map((r) => ({ id: String(r.id), code: `role-${r.id}`, name: r.user_type_name ?? "", category: r.user_type_show_on_register ? "external" : "internal", createdAt: r.createdAt })),
    total,
    page,
    perPage,
    totalPages: Math.max(1, Math.ceil(total / perPage)),
  });
});

roleRouter.post("/", requireAction("role", "add"), async (req, res) => {
  const parsed = roleCreateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload role tidak valid" });

  const duplicate = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.user_types WHERE lower(user_type_name) = lower(${parsed.data.name}) LIMIT 1`;
  if (duplicate.length > 0) return res.status(409).json({ message: "Nama role tidak boleh sama" });

  const created = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null; user_type_show_on_register: boolean | null }>>`
    INSERT INTO public.user_types (user_type_name, user_type_show_on_register, "createdAt", "updatedAt") VALUES (${parsed.data.name}, ${parsed.data.category === "external"}, now(), now()) RETURNING id, user_type_name, user_type_show_on_register
  `;

  return res.status(201).json({ message: "Role berhasil dibuat", data: { id: String(created[0].id), code: `role-${created[0].id}`, name: created[0].user_type_name ?? "", category: created[0].user_type_show_on_register ? "external" : "internal" } });
});

roleRouter.put("/:id", requireAction("role", "edit"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  const body = roleUpdateSchema.safeParse(req.body);
  if (!params.success || !body.success) return res.status(400).json({ message: "Payload role tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID role tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.user_types WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "Role tidak ditemukan" });

  const updated = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null; user_type_show_on_register: boolean | null }>>`
    UPDATE public.user_types SET user_type_name = ${body.data.name}, user_type_show_on_register = ${body.data.category === "external"}, "updatedAt" = now() WHERE id = ${id} RETURNING id, user_type_name, user_type_show_on_register
  `;

  return res.json({ message: "Role berhasil diperbarui", data: { id: String(updated[0].id), code: `role-${updated[0].id}`, name: updated[0].user_type_name ?? "", category: updated[0].user_type_show_on_register ? "external" : "internal" } });
});

roleRouter.delete("/:id", requireAction("role", "delete"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  if (!params.success) return res.status(400).json({ message: "ID role tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID role tidak valid" });

  const usedByUsers = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.users WHERE user_type_user_type_id = ${id} LIMIT 1`;
  if (usedByUsers.length > 0) return res.status(409).json({ message: "Role masih digunakan oleh user." });

  await prisma.$executeRaw`DELETE FROM public.user_types WHERE id = ${id}`;
  return res.json({ success: true, message: "Role berhasil dihapus" });
});
