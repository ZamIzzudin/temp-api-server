import { privilegeRepository } from "./privilege.repository";
import type { UserPrivilegePayload } from "./privilege.types";
import type { UpdateMappingsRequest } from "./privilege.schema";

const menuCode = (name: string, id: number) => (name?.toLowerCase().trim().replace(/\s+/g, "-") || `menu-${id}`);

export const privilegeService = {
  getRoleOptions: async () => {
    const roles = await privilegeRepository.findAllRoles();
    return roles.map((role) => ({ id: String(role.id), code: `role-${role.id}`, name: role.user_type_name ?? "" }));
  },

  getRoleMatrix: async (roleCode: string) => {
    const role = await privilegeRepository.findRoleByCode(roleCode);
    if (!role) return null;

    const [actions, menus, mappings] = await Promise.all([
      privilegeRepository.findAllActions(),
      privilegeRepository.findAllMenusWithMenuActions(),
      privilegeRepository.findRoleMappingsByRoleId(role.id),
    ]);

    const mappedActionIds = new Set(mappings.map((x) => x.action_id).filter((x): x is number => Number.isInteger(x)));
    const grouped = new Map<number, { menuCode: string; menuName: string; actionIds: string[]; checked: string[] }>();

    for (const row of menus) {
      const menuId = row.menu_id;
      const existing = grouped.get(menuId) ?? { menuCode: menuCode(row.module_name ?? "", menuId), menuName: row.module_name ?? "", actionIds: [], checked: [] };
      if (row.action_id) {
        const sid = String(row.action_id);
        existing.actionIds.push(sid);
        if (mappedActionIds.has(row.action_id)) existing.checked.push(sid);
      }
      grouped.set(menuId, existing);
    }

    return {
      role: { id: String(role.id), code: `role-${role.id}`, name: role.user_type_name ?? "" },
      actions: actions.map((a) => ({ id: String(a.id), code: a.action_key ?? "", name: a.action_name ?? "" })),
      rows: Array.from(grouped.entries()).map(([id, v]) => ({ menuId: String(id), menuCode: v.menuCode, menuName: v.menuName, parentMenuId: null, path: `/${v.menuCode}`, checkedActionIds: Array.from(new Set(v.checked)), availableActionIds: Array.from(new Set(v.actionIds)) })),
    };
  },

  getUserPrivileges: async (userId: string): Promise<UserPrivilegePayload | null> => {
    const rows = await privilegeRepository.findUserWithPrivileges(userId);
    if (!rows || rows.length === 0) return null;

    const first = rows[0];
    const menuMap = new Map<string, { id: string; code: string; name: string; path: string | null; icon: string; actions: Set<string> }>();
    for (const row of rows) {
      if (!row.module_id) continue;
      const id = String(row.module_id);
      const code = menuCode(row.module_name ?? "", row.module_id);
      const entry = menuMap.get(id) ?? { id, code, name: row.module_name ?? "", path: `/${code}`, icon: "SquareMenu", actions: new Set<string>() };
      if (row.action_key) entry.actions.add(row.action_key);
      menuMap.set(id, entry);
    }

    return {
      userId: String(first.user_id),
      username: (first.user_email ?? "").split("@")[0] ?? "user",
      email: first.user_email ?? "",
      roles: first.role_id ? [`role-${first.role_id}`] : [],
      menus: Array.from(menuMap.values()).map((m) => ({ ...m, actions: Array.from(m.actions), subMenus: [] })),
    };
  },

  updateRoleMappings: async (payload: UpdateMappingsRequest) => {
    const role = await privilegeRepository.findRoleByCode(payload.roleCode);
    if (!role) return { ok: false as const, reason: "role_not_found" as const };

    const actions = await privilegeRepository.findActionsByCodes(payload.mappings.flatMap((m) => m.actionCodes));
    const actionByCode = new Map(actions.map((a) => [a.action_key ?? "", a.id]));
    const selected = new Set<number>();

    for (const mapping of payload.mappings) {
      for (const actionCode of mapping.actionCodes) {
        const id = actionByCode.get(actionCode);
        if (id) selected.add(id);
      }
    }

    await privilegeRepository.replaceRoleMappings(role.id, Array.from(selected));
    return { ok: true as const };
  },
};
