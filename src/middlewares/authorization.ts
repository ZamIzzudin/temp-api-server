import type { NextFunction, Request, Response } from "express";
import { privilegeService } from "../modules/privilege/privilege.service";

type RequiredAction = "view" | "add" | "edit" | "delete" | "approve";

export const requireAction = (menuCode: string, action: RequiredAction) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const payload = await privilegeService.getUserPrivileges(req.session.user.id);
    if (!payload) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const menu = payload.menus.find((item) => item.code === menuCode)
      ?? payload.menus.flatMap((item) => item.subMenus).find((item) => item.code === menuCode);

    if (!menu || !menu.actions.includes(action)) {
      return res.status(403).json({ message: "Forbidden" });
    }

    next();
  };
};
