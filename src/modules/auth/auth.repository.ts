import { dumpDb } from "../../lib/dump-db";

export const authRepository = {
  findByEmail: (email: string) => dumpDb.findUserByEmail(email),
  findRoleById: (id: number) => dumpDb.findRoleById(id),
  findAllRoles: () => dumpDb.findRoleOptions({ includeAll: true }),
};
