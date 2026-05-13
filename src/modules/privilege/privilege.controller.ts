import type { Request, Response } from "express";
import { privilegeService } from "./privilege.service";
import { updateMappingsSchema } from "./privilege.schema";

export const privilegeController = {
  roleOptions: async (req: Request, res: Response) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const roles = await privilegeService.getRoleOptions();
    return res.json(roles);
  },

  roleMatrix: async (req: Request, res: Response) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const roleCode = String(req.query.roleCode ?? "");
    if (!roleCode) {
      return res.status(400).json({ message: "roleCode wajib diisi" });
    }

    const matrix = await privilegeService.getRoleMatrix(roleCode);
    if (!matrix) {
      return res.status(404).json({ message: "Role tidak ditemukan" });
    }

    return res.json(matrix);
  },

  me: async (req: Request, res: Response) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const payload = await privilegeService.getUserPrivileges(req.session.user.id);

    if (!payload) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    return res.json(payload);
  },

  updateRoleMappings: async (req: Request, res: Response) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const parsed = updateMappingsSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ message: "Payload mapping privilege tidak valid" });
    }

    const result = await privilegeService.updateRoleMappings(parsed.data);
    if (!result.ok) {
      return res.status(404).json({ message: "Role tidak ditemukan" });
    }

    return res.json({ success: true });
  },
};
