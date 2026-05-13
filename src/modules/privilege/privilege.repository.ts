import { Prisma } from "@prisma/client";
import { prisma } from "../../lib/prisma";

export const privilegeRepository = {
  async findUserWithPrivileges(userId: string) {
    const id = Number(userId);
    if (!Number.isInteger(id)) return null;

    const rows = await prisma.$queryRaw<Array<{ user_id: number; user_email: string | null; role_id: number | null; role_name: string | null; module_id: number | null; module_name: string | null; action_id: number | null; action_key: string | null }>>`
      SELECT u.id as user_id, u.user_email, r.id as role_id, r.user_type_name as role_name, m.id as module_id, m.module_name, a.id as action_id, a.action_key
      FROM public.users u
      LEFT JOIN public.user_types r ON r.id = u.user_type_user_type_id
      LEFT JOIN public.acls acl ON acl.user_type_id = r.id AND coalesce(acl.acl_allowed,false)=true
      LEFT JOIN public.actions a ON a.id = acl.actions_action_id
      LEFT JOIN public.modules m ON m.id = a.modules_module_id
      WHERE u.id = ${id}
    `;

    if (rows.length === 0) return null;
    return rows;
  },

  findRoleByCode: async (code: string) => {
    const numeric = Number(code.replace(/^role-/, ""));
    if (!Number.isInteger(numeric)) return null;
    const rows = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null }>>`SELECT id, user_type_name FROM public.user_types WHERE id = ${numeric} LIMIT 1`;
    return rows[0] ?? null;
  },

  findAllRoles: () =>
    prisma.$queryRaw<Array<{ id: number; user_type_name: string | null }>>`
      SELECT id, user_type_name FROM public.user_types ORDER BY user_type_name ASC
    `,

  findMenusByIds: (ids: string[]) => {
    const numeric = ids.map(Number).filter(Number.isInteger);
    if (numeric.length === 0) return Promise.resolve([] as Array<{ id: number; module_name: string | null }>);
    return prisma.$queryRaw<Array<{ id: number; module_name: string | null }>>(Prisma.sql`SELECT id, module_name FROM public.modules WHERE id IN (${Prisma.join(numeric)})`);
  },

  findActionsByCodes: async (codes: string[]) => {
    if (codes.length === 0) return [] as Array<{ id: number; action_key: string | null }>;
    return prisma.$queryRaw<Array<{ id: number; action_key: string | null }>>(Prisma.sql`SELECT id, action_key FROM public.actions WHERE action_key IN (${Prisma.join(codes)})`);
  },

  findAllActions: () => prisma.$queryRaw<Array<{ id: number; action_key: string | null; action_name: string | null }>>`SELECT id, action_key, action_name FROM public.actions ORDER BY action_name ASC`,

  findAllMenusWithMenuActions: () => prisma.$queryRaw<Array<{ menu_id: number; module_name: string | null; action_id: number | null; action_key: string | null }>>`
    SELECT m.id as menu_id, m.module_name, a.id as action_id, a.action_key
    FROM public.modules m
    LEFT JOIN public.actions a ON a.modules_module_id = m.id
    ORDER BY m.module_name ASC
  `,

  findRoleMappingsByRoleId: (roleId: number) => prisma.$queryRaw<Array<{ action_id: number | null }>>`SELECT actions_action_id as action_id FROM public.acls WHERE user_type_id = ${roleId} AND coalesce(acl_allowed,false)=true`,

  async replaceRoleMappings(roleId: number, actionIds: number[]) {
    await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`DELETE FROM public.acls WHERE user_type_id = ${roleId}`;
      for (const actionId of actionIds) {
        await tx.$executeRaw`INSERT INTO public.acls (user_type_id, actions_action_id, acl_allowed, "createdAt", "updatedAt") VALUES (${roleId}, ${actionId}, true, now(), now())`;
      }
    });
  },
};
