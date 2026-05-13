import { Prisma } from "@prisma/client";
import { prisma } from "./prisma";

type DumpUser = {
  id: number;
  user_email: string | null;
  user_password: string | null;
  user_type_user_type_id: number | null;
  user_status: string | null;
  createdAt: Date;
};

type DumpRole = {
  id: number;
  user_type_name: string | null;
  user_type_form: string | null;
  user_type_show_on_register: boolean | null;
};

export const dumpDb = {
  async findUserByEmail(email: string): Promise<DumpUser | null> {
    const rows = await prisma.$queryRaw<DumpUser[]>`SELECT id, user_email, user_password, user_type_user_type_id, user_status::text as user_status, "createdAt" FROM public.users WHERE lower(user_email) = lower(${email}) AND coalesce(status,1)=1 LIMIT 1`;
    return rows[0] ?? null;
  },

  async findUserById(id: number): Promise<DumpUser | null> {
    const rows = await prisma.$queryRaw<DumpUser[]>`SELECT id, user_email, user_password, user_type_user_type_id, user_status::text as user_status, "createdAt" FROM public.users WHERE id = ${id} AND coalesce(status,1)=1 LIMIT 1`;
    return rows[0] ?? null;
  },

  async findRoleById(id: number): Promise<DumpRole | null> {
    const rows = await prisma.$queryRaw<DumpRole[]>`SELECT id, user_type_name, user_type_form::text as user_type_form, user_type_show_on_register FROM public.user_types WHERE id = ${id} LIMIT 1`;
    return rows[0] ?? null;
  },

  async findRoleOptions({ includeAll }: { includeAll: boolean }) {
    const rows = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null }>>`
      SELECT id, user_type_name
      FROM public.user_types
      WHERE ${includeAll} OR coalesce(user_type_show_on_register,false)=true
      ORDER BY user_type_name ASC
    `;

    return rows.map((r) => ({ id: String(r.id), code: `role-${r.id}`, name: r.user_type_name ?? "" }));
  },

  async listRoles(search: string, skip: number, take: number) {
    const where = search ? Prisma.sql`WHERE coalesce(user_type_name,'') ILIKE ${`%${search}%`}` : Prisma.empty;
    const items = await prisma.$queryRaw<Array<{ id: number; user_type_name: string | null; user_type_form: string | null; createdAt: Date }>>(
      Prisma.sql`SELECT id, user_type_name, user_type_form::text as user_type_form, "createdAt" FROM public.user_types ${where} ORDER BY "createdAt" ASC OFFSET ${skip} LIMIT ${take}`,
    );
    const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.user_types ${where}`);
    return { items, total: Number(totalRows[0]?.count ?? 0n) };
  },

  async listUsers(search: string, skip: number, take: number) {
    const where = search
      ? Prisma.sql`WHERE (coalesce(u.user_email,'') ILIKE ${`%${search}%`}) AND coalesce(u.status,1)=1`
      : Prisma.sql`WHERE coalesce(u.status,1)=1`;
    const items = await prisma.$queryRaw<Array<{ id: number; user_email: string | null; user_type_user_type_id: number | null; createdAt: Date; role_name: string | null }>>(
      Prisma.sql`SELECT u.id, u.user_email, u.user_type_user_type_id, u."createdAt", r.user_type_name as role_name FROM public.users u LEFT JOIN public.user_types r ON r.id = u.user_type_user_type_id ${where} ORDER BY u."createdAt" ASC OFFSET ${skip} LIMIT ${take}`,
    );
    const totalRows = await prisma.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`SELECT count(*)::bigint as count FROM public.users u ${where}`);
    return { items, total: Number(totalRows[0]?.count ?? 0n) };
  },
};
