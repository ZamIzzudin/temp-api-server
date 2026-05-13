import { Router } from "express";
import { z } from "zod";
import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";
import { menuCreateSchema, menuUpdateSchema } from "./menu.schema";
import { requireAction } from "../../middlewares/authorization";

const toCode = (name: string) => name.toLowerCase().trim().replace(/\s+/g, "-");

export const menuRouter = Router();

menuRouter.get("/", requireAction("menu", "view"), async (req, res) => {
  const page = Math.max(1, Number(req.query.page ?? 1));
  const perPage = Math.min(15, Math.max(1, Number(req.query.perPage ?? 15)));
  const q = String(req.query.q ?? "").trim();
  const where = q ? Prisma.sql`WHERE coalesce(m.module_name,'') ILIKE ${`%${q}%`}` : Prisma.empty;

  const data = await prisma.$queryRaw<Array<{ id: number; module_name: string | null; createdAt: Date; updatedAt: Date }>>(
    Prisma.sql`SELECT id, module_name, "createdAt", "updatedAt" FROM public.modules m ${where} ORDER BY "createdAt" ASC OFFSET ${(page - 1) * perPage} LIMIT ${perPage}`,
  );
  const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.modules m ${where}`);
  const moduleIds = data.map((x) => x.id);
  const links = moduleIds.length > 0
    ? await prisma.$queryRaw<Array<{ id: number; modules_module_id: number | null }>>(Prisma.sql`SELECT id, modules_module_id FROM public.actions WHERE modules_module_id IN (${Prisma.join(moduleIds)})`)
    : [];

  const map = new Map<number, string[]>();
  for (const row of links) {
    if (!row.modules_module_id) continue;
    const curr = map.get(row.modules_module_id) ?? [];
    curr.push(String(row.id));
    map.set(row.modules_module_id, curr);
  }

  const total = Number(totalRows[0]?.count ?? 0n);
  return res.json({
    items: data.map((menu, idx) => ({
      id: String(menu.id),
      code: toCode(menu.module_name ?? `module-${menu.id}`),
      name: menu.module_name ?? "",
      path: `/${toCode(menu.module_name ?? `module-${menu.id}`)}`,
      icon: "SquareMenu",
      sortOrder: idx + 1,
      parentMenuId: null,
      createdAt: menu.createdAt,
      updatedAt: menu.updatedAt,
      actionIds: map.get(menu.id) ?? [],
    })),
    total,
    page,
    perPage,
    totalPages: Math.max(1, Math.ceil(total / perPage)),
  });
});

menuRouter.post("/", requireAction("menu", "add"), async (req, res) => {
  const parsed = menuCreateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: "Payload menu tidak valid" });

  const duplicate = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.modules WHERE lower(module_name)=lower(${parsed.data.name}) LIMIT 1`;
  if (duplicate.length > 0) return res.status(409).json({ message: "Kode menu tidak boleh sama" });

  const created = await prisma.$queryRaw<Array<{ id: number; module_name: string | null; createdAt: Date; updatedAt: Date }>>`
    INSERT INTO public.modules (module_name, "createdAt", "updatedAt") VALUES (${parsed.data.name}, now(), now()) RETURNING id, module_name, "createdAt", "updatedAt"
  `;

  if (parsed.data.actionIds.length > 0) {
    for (const actionIdRaw of parsed.data.actionIds) {
      const actionId = Number(actionIdRaw);
      if (!Number.isInteger(actionId)) continue;
      await prisma.$executeRaw`UPDATE public.actions SET modules_module_id = ${created[0].id}, "updatedAt" = now() WHERE id = ${actionId}`;
    }
  }

  return res.status(201).json({ message: "Menu berhasil dibuat", data: { id: String(created[0].id), code: toCode(created[0].module_name ?? ""), name: created[0].module_name ?? "", path: parsed.data.path, icon: parsed.data.icon, sortOrder: parsed.data.sortOrder, parentMenuId: null } });
});

menuRouter.put("/:id", requireAction("menu", "edit"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  const body = menuUpdateSchema.safeParse(req.body);
  if (!params.success || !body.success) return res.status(400).json({ message: "Payload menu tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID menu tidak valid" });

  const existing = await prisma.$queryRaw<Array<{ id: number }>>`SELECT id FROM public.modules WHERE id = ${id} LIMIT 1`;
  if (existing.length === 0) return res.status(404).json({ message: "Menu tidak ditemukan" });

  await prisma.$executeRaw`UPDATE public.modules SET module_name = ${body.data.name}, "updatedAt" = now() WHERE id = ${id}`;

  if (Array.isArray(body.data.actionIds)) {
    await prisma.$executeRaw`UPDATE public.actions SET modules_module_id = NULL, "updatedAt" = now() WHERE modules_module_id = ${id}`;
    for (const actionIdRaw of body.data.actionIds) {
      const actionId = Number(actionIdRaw);
      if (!Number.isInteger(actionId)) continue;
      await prisma.$executeRaw`UPDATE public.actions SET modules_module_id = ${id}, "updatedAt" = now() WHERE id = ${actionId}`;
    }
  }

  return res.json({ message: "Menu berhasil diperbarui", data: { id: String(id), code: body.data.code, name: body.data.name, path: body.data.path, icon: body.data.icon, sortOrder: body.data.sortOrder, parentMenuId: null } });
});

menuRouter.delete("/:id", requireAction("menu", "delete"), async (req, res) => {
  const params = z.object({ id: z.string().min(1) }).safeParse(req.params);
  if (!params.success) return res.status(400).json({ message: "ID menu tidak valid" });

  const id = Number(params.data.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: "ID menu tidak valid" });

  const usedInRolePrivilege = await prisma.$queryRaw<Array<{ id: number }>>`
    SELECT a.id FROM public.acls a JOIN public.actions act ON act.id = a.actions_action_id WHERE act.modules_module_id = ${id} AND coalesce(a.acl_allowed,false)=true LIMIT 1
  `;
  if (usedInRolePrivilege.length > 0) return res.status(409).json({ message: "Menu ini masih dipakai pada mapping privilege role." });

  await prisma.$executeRaw`UPDATE public.actions SET modules_module_id = NULL, "updatedAt" = now() WHERE modules_module_id = ${id}`;
  await prisma.$executeRaw`DELETE FROM public.modules WHERE id = ${id}`;
  return res.json({ success: true, message: "Menu berhasil dihapus" });
});
