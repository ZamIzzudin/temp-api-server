import bcrypt from "bcrypt";
import { authRepository } from "./auth.repository";
import type { LoginRequest } from "./auth.schema";

export const authService = {
  login: async (payload: LoginRequest) => {
    const user = await authRepository.findByEmail(payload.email);

    if (!user) return null;
    if (!user.user_password) return null;

    const roleId = Number(payload.roleId);
    if (!Number.isInteger(roleId) || user.user_type_user_type_id !== roleId) return null;

    const role = await authRepository.findRoleById(roleId);
    if (!role) return null;

    const isValid = await bcrypt.compare(payload.password, user.user_password);
    if (!isValid) return null;

    return {
      id: String(user.id),
      username: user.user_email?.split("@")[0] ?? "user",
      email: user.user_email ?? "",
      role: { id: String(role.id), code: `role-${role.id}`, name: role.user_type_name ?? "" },
    };
  },

  listRoleOptions: () => authRepository.findAllRoles(),
};
