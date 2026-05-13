import { Router } from "express";
import { z } from "zod";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { requireAction } from "../../middlewares/authorization";
import { customParamCreateSchema, customParamUpdateSchema } from "./custom-param.schema";

export const customParamRouter = Router();

customParamRouter.get("/", requireAction("custom-param", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q ? Prisma.sql`WHERE coalesce(m.param_name,'') ILIKE ${`%${q}%`} OR coalesce(c.param_value_string,'') ILIKE ${`%${q}%`}` : Prisma.empty;

  const items = await prisma.$queryRaw<Array<{ id: number; param_name: string | null; param_value_string: string | null; createdAt: Date | null; updatedAt: Date | null }>>(
    Prisma.sql`SELECT m.id, m.param_name, c.param_value_string, c."createdAt", c."updatedAt" FROM public.master_custom_params m LEFT JOIN public.custom_params c ON c.master_custom_params_id = m.id ${where} ORDER BY m.id ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.master_custom_params m LEFT JOIN public.custom_params c ON c.master_custom_params_id = m.id ${where}`);
  const total = Number(totalRows[0]?.count ?? 0n);

  return res.json({ items: items.map((x) => ({ id: String(x.id), key: x.param_name ?? "", value: x.param_value_string ?? "", createdAt: x.createdAt, updatedAt: x.updatedAt })), total, page, perPage, totalPages: Math.max(1, Math.ceil(total / perPage)) });
});

customParamRouter.post("/", requireAction("custom-param", "add"), async (req, res) => {
  const parsed = customParamCreateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload custom param tidak valid" });

  const dup = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.master_custom_params WHERE lower(param_name)=lower(${parsed.data.key}) LIMIT 1`;
  if (dup.length > 0) return res.status(409).json({ message: "Key custom param tidak boleh sama" });

  const master = await prisma.$queryRaw<Array<{ id: number; param_name: string | null }>>`
    INSERT INTO public.master_custom_params (param_name, type, status, "createdaAt", "updatedAt") VALUES (${parsed.data.key}, 'string', 1, now(), now()) RETURNING id, param_name
  `;
  await prisma.$executeRaw`INSERT INTO public.custom_params (master_custom_params_id, param_value_string, status, "createdAt", "updatedAt") VALUES (${master[0].id}, ${parsed.data.value}, 1, now(), now())`;

  return res.status(201).json({ message: "Custom param berhasil dibuat", data: { id: String(master[0].id), key: master[0].param_name ?? "", value: parsed.data.value } });
});

customParamRouter.put("/:id", requireAction("custom-param", "edit"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  const body = customParamUpdateSchema.safeParse(req.body);
  if (!params.success || !body.success) return res.status(400).json({ message: "Payload custom param tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID custom param tidak valid" });

  await prisma.$executeRaw`UPDATE public.master_custom_params SET param_name=${body.data.key}, "updatedAt"=now() WHERE id=${id}`;
  await prisma.$executeRaw`UPDATE public.custom_params SET param_value_string=${body.data.value}, "updatedAt"=now() WHERE master_custom_params_id=${id}`;
  return res.json({ message: "Custom param berhasil diperbarui", data: { id: String(id), key: body.data.key, value: body.data.value } });
});

customParamRouter.delete("/:id", requireAction("custom-param", "delete"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  if (!params.success) return res.status(400).json({ message: "ID custom param tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID custom param tidak valid" });

  await prisma.$executeRaw`DELETE FROM public.custom_params WHERE master_custom_params_id=${id}`;
  await prisma.$executeRaw`DELETE FROM public.master_custom_params WHERE id=${id}`;
  return res.json({ success: true, message: "Custom param berhasil dihapus" });
});
