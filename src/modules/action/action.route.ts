import { Router } from "express";
import { z } from "zod";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { actionCreateSchema, actionUpdateSchema } from "./action.schema";
import { requireAction } from "../../middlewares/authorization";

export const actionRouter = Router();

actionRouter.get("/options", requireAction("menu", "view"), async (_req, res) => {
  const data = await prisma.$queryRaw<Array<{ id: number; action_key: string | null; action_name: string | null }>>`
    SELECT id, action_key, action_name FROM public.actions ORDER BY action_name ASC
  `;
  return res.json(data.map((x) => ({ id: String(x.id), code: x.action_key ?? "", name: x.action_name ?? "" })));
});

actionRouter.get("/", requireAction("action", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q ? Prisma.sql`WHERE coalesce(action_key,'') ILIKE ${`%${q}%`} OR coalesce(action_name,'') ILIKE ${`%${q}%`}` : Prisma.empty;

  const items = await prisma.$queryRaw<Array<{ id: number; action_key: string | null; action_name: string | null; createdAt: Date }>>(
    Prisma.sql`SELECT id, action_key, action_name, "createdAt" FROM public.actions ${where} ORDER BY "createdAt" ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.actions ${where}`);
  const total = Number(totalRows[0]?.count ?? 0n);

  return res.json({
    items: items.map((x) => ({ id: String(x.id), code: x.action_key ?? "", name: x.action_name ?? "", createdAt: x.createdAt })),
    total,
    page,
    perPage,
    totalPages: Math.max(1, Math.ceil(total / perPage)),
  });
});

actionRouter.post("/", requireAction("action", "add"), async (req, res) => {
  const parsed = actionCreateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload action tidak valid" });

  const duplicate = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.actions WHERE lower(action_key) = lower(${parsed.data.code}) LIMIT 1`;
  if (duplicate.length > 0) return res.status(409).json({ message: "Kode action tidak boleh sama" });

  const created = await prisma.$queryRaw<Array<{ id: number; action_key: string | null; action_name: string | null; createdAt: Date; updatedAt: Date }>>`
    INSERT INTO public.actions (action_key, action_name, "createdAt", "updatedAt") VALUES (${parsed.data.code}, ${parsed.data.name}, now(), now()) RETURNING id, action_key, action_name, "createdAt", "updatedAt"
  `;

  return res.status(201).json({ message: "Action berhasil dibuat", data: { id: String(created[0].id), code: created[0].action_key ?? "", name: created[0].action_name ?? "", createdAt: created[0].createdAt, updatedAt: created[0].updatedAt } });
});

actionRouter.put("/:id", requireAction("action", "edit"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  const body = actionUpdateSchema.safeParse(req.body);
  if (!params.success || !body.success) return res.status(400).json({ message: "Payload action tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID action tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.actions WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "Action tidak ditemukan" });

  const duplicate = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.actions WHERE lower(action_key) = lower(${body.data.code}) AND id <> ${id} LIMIT 1`;
  if (duplicate.length > 0) return res.status(409).json({ message: "Kode action tidak boleh sama" });

  const updated = await prisma.$queryRaw<Array<{ id: number; action_key: string | null; action_name: string | null; updatedAt: Date }>>`
    UPDATE public.actions SET action_key = ${body.data.code}, action_name = ${body.data.name}, "updatedAt" = now() WHERE id = ${id} RETURNING id, action_key, action_name, "updatedAt"
  `;

  return res.json({ message: "Action berhasil diperbarui", data: { id: String(updated[0].id), code: updated[0].action_key ?? "", name: updated[0].action_name ?? "", updatedAt: updated[0].updatedAt } });
});

actionRouter.delete("/:id", requireAction("action", "delete"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  if (!params.success) return res.status(400).json({ message: "ID action tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID action tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.actions WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "Action tidak ditemukan" });

  const used = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.acls WHERE actions_action_id = ${id} AND coalesce(acl_allowed,false) = true LIMIT 1`;
  if (used.length > 0) {
    return res.status(409).json({ message: "Action masih digunakan oleh privilege role." });
  }

  await prisma.$executeRaw`DELETE FROM public.actions WHERE id = ${id}`;
  return res.json({ success: true, message: "Action berhasil dihapus" });
});
