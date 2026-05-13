import "dotenv/config";
import bcrypt from "bcrypt";
import { prisma } from "./lib/prisma";
import { config } from "./config";

type RoleSeed = {
  name: string;
  form: "regulator" | "operator" | "shipper" | "consignee" | "visitor";
  showOnRegister: boolean;
};

const defaultRoles: RoleSeed[] = [
  { name: "Super Admin", form: "regulator", showOnRegister: false },
  { name: "Operator", form: "operator", showOnRegister: true },
  { name: "Shipper", form: "shipper", showOnRegister: true },
  { name: "Consignee", form: "consignee", showOnRegister: true },
  { name: "External User", form: "visitor", showOnRegister: true },
];

const defaultModules = ["Dashboard", "User", "Action", "Role", "Menu", "Privilege", "Approve Registration", "Custom Param"];

const defaultActions = [
  { key: "view", name: "View" },
  { key: "add", name: "Add" },
  { key: "edit", name: "Edit" },
  { key: "delete", name: "Delete" },
  { key: "approve", name: "Approve" },
];

const defaultCustomParams = [
  { key: "app_name", value: "SITOLAUT" },
  { key: "support_email", value: "support@example.com" },
  { key: "booking_expired_hours", value: "24" },
];

const toModuleKey = (value: string) => value.toLowerCase().trim().replace(/\s+/g, "-");

const seedRoles = async () => {
  const roleIdByName = new Map<string, number>();

  for (const role of defaultRoles) {
    const rows = await prisma.$queryRaw<Array<{ id: number }>>`
      SELECT id FROM public.user_types WHERE lower(user_type_name) = lower(${role.name}) LIMIT 1
    `;

    if (rows.length === 0) {
      const created = await prisma.$queryRaw<Array<{ id: number }>>`
        INSERT INTO public.user_types (user_type_name, user_type_form, user_type_show_on_register, "createdAt", "updatedAt")
        VALUES (${role.name}, ${role.form}::public.enum_user_types_user_type_form, ${role.showOnRegister}, now(), now()) RETURNING id
      `;
      roleIdByName.set(role.name, created[0].id);
      continue;
    }

    roleIdByName.set(role.name, rows[0].id);
    await prisma.$executeRaw`
      UPDATE public.user_types
      SET user_type_form = ${role.form}::public.enum_user_types_user_type_form,
          user_type_show_on_register = ${role.showOnRegister},
          "updatedAt" = now()
      WHERE id = ${rows[0].id}
    `;
  }

  return roleIdByName;
};

const seedModulesAndActions = async () => {
  const moduleIdByKey = new Map<string, number>();
  const actionIds: number[] = [];

  for (const moduleName of defaultModules) {
    const found = await prisma.$queryRaw<Array<{ id: number }>>`
      SELECT id FROM public.modules WHERE lower(module_name) = lower(${moduleName}) LIMIT 1
    `;

    if (found.length === 0) {
      const created = await prisma.$queryRaw<Array<{ id: number }>>`
        INSERT INTO public.modules (module_name, "createdAt", "updatedAt")
        VALUES (${moduleName}, now(), now()) RETURNING id
      `;
      moduleIdByKey.set(toModuleKey(moduleName), created[0].id);
    } else {
      moduleIdByKey.set(toModuleKey(moduleName), found[0].id);
    }
  }

  for (const moduleName of defaultModules) {
    const moduleId = moduleIdByKey.get(toModuleKey(moduleName));
    if (!moduleId) continue;

    for (const action of defaultActions) {
      const found = await prisma.$queryRaw<Array<{ id: number }>>`
        SELECT id FROM public.actions
        WHERE lower(action_key) = lower(${action.key}) AND modules_module_id = ${moduleId}
        LIMIT 1
      `;

      if (found.length === 0) {
        const created = await prisma.$queryRaw<Array<{ id: number }>>`
          INSERT INTO public.actions (action_name, action_key, modules_module_id, "createdAt", "updatedAt")
          VALUES (${action.name}, ${action.key}, ${moduleId}, now(), now()) RETURNING id
        `;
        actionIds.push(created[0].id);
      } else {
        actionIds.push(found[0].id);
        await prisma.$executeRaw`
          UPDATE public.actions
          SET action_name = ${action.name}, "updatedAt" = now()
          WHERE id = ${found[0].id}
        `;
      }
    }
  }

  return actionIds;
};

const seedCustomParams = async () => {
  for (const param of defaultCustomParams) {
    const masterRows = await prisma.$queryRaw<Array<{ id: number }>>`
      SELECT id FROM public.master_custom_params WHERE lower(param_name)=lower(${param.key}) LIMIT 1
    `;

    let masterId = masterRows[0]?.id;
    if (!masterId) {
      const created = await prisma.$queryRaw<Array<{ id: number }>>`
        INSERT INTO public.master_custom_params (param_name, type, status, "updatedAt")
        VALUES (${param.key}, 'string', 1, now()) RETURNING id
      `;
      masterId = created[0].id;
    }

    const detailRows = await prisma.$queryRaw<Array<{ id: number }>>`
      SELECT id FROM public.custom_params WHERE master_custom_params_id=${masterId} LIMIT 1
    `;

    if (detailRows.length === 0) {
      await prisma.$executeRaw`
        INSERT INTO public.custom_params (master_custom_params_id, param_value_string, status, "createdAt", "updatedAt")
        VALUES (${masterId}, ${param.value}, 1, now(), now())
      `;
    } else {
      await prisma.$executeRaw`
        UPDATE public.custom_params
        SET param_value_string=${param.value}, status=1, "updatedAt"=now()
        WHERE id=${detailRows[0].id}
      `;
    }
  }
};

export const seedGenesisAccount = async () => {
  const passwordHash = await bcrypt.hash(config.seedGenesisPassword, 10);
  const roleIdByName = await seedRoles();
  const superAdminRoleId = roleIdByName.get("Super Admin");
  if (!superAdminRoleId) throw new Error("Super Admin role not found after seeding");

  const actionIds = await seedModulesAndActions();

  const userRows = await prisma.$queryRaw<Array<{ id: number }>>`
    SELECT id FROM public.users WHERE lower(user_email) = lower(${config.seedGenesisEmail}) LIMIT 1
  `;

  if (userRows.length === 0) {
    await prisma.$executeRaw`
      INSERT INTO public.users (user_email, user_password, user_type_user_type_id, user_status, "createdAt", "updatedAt", status)
      VALUES (${config.seedGenesisEmail}, ${passwordHash}, ${superAdminRoleId}, 'approved'::public.enum_users_user_status, now(), now(), 1)
    `;
  } else {
    await prisma.$executeRaw`
      UPDATE public.users
      SET user_password = ${passwordHash},
          user_type_user_type_id = ${superAdminRoleId},
          user_status = 'approved'::public.enum_users_user_status,
          status = 1,
          "updatedAt" = now()
      WHERE id = ${userRows[0].id}
    `;
  }

  await prisma.$executeRaw`DELETE FROM public.acls WHERE user_type_id = ${superAdminRoleId}`;
  for (const actionId of actionIds) {
    await prisma.$executeRaw`
      INSERT INTO public.acls (user_type_id, actions_action_id, acl_allowed, "createdAt", "updatedAt")
      VALUES (${superAdminRoleId}, ${actionId}, true, now(), now())
    `;
  }

  await seedCustomParams();
};

export const runSeed = async () => {
  await prisma.$connect();
  await seedGenesisAccount();
  await prisma.$disconnect();
};

if (require.main === module) {
  runSeed().catch(async (error) => {
    console.error("Prisma seed failed", error);
    await prisma.$disconnect();
    process.exit(1);
  });
}
