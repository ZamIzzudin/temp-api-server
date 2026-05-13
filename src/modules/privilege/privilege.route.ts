import { Router } from "express";
import { privilegeController } from "./privilege.controller";
import { requireAction } from "../../middlewares/authorization";

export const privilegeRouter = Router();

privilegeRouter.get("/roles", requireAction("privilege", "view"), privilegeController.roleOptions);
privilegeRouter.get("/role-matrix", requireAction("privilege", "view"), privilegeController.roleMatrix);
privilegeRouter.get("/me", privilegeController.me);
privilegeRouter.put("/role-mappings", requireAction("privilege", "approve"), privilegeController.updateRoleMappings);
