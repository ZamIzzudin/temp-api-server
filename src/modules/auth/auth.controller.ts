import type { Request, Response } from "express";
import { config } from "../../config";
import { authService } from "./auth.service";
import { loginSchema } from "./auth.schema";

export const authController = {
  login: async (req: Request, res: Response) => {
    const parsed = loginSchema.safeParse(req.body);

    if (!parsed.success) {
      return res.status(400).json({ message: "Email valid dan password wajib diisi" });
    }

    const user = await authService.login(parsed.data);

    if (!user) {
      return res.status(401).json({ message: "Email, password, atau role tidak valid" });
    }

    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
    };

    return res.json({
      id: user.id,
      username: user.username,
      email: user.email,
    });
  },

  roleOptions: async (_req: Request, res: Response) => {
    const roles = await authService.listRoleOptions();
    return res.json(roles);
  },

  me: async (req: Request, res: Response) => {
    if (!req.session.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    return res.json(req.session.user);
  },

  logout: async (req: Request, res: Response) => {
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).json({ message: "Gagal logout" });
      }

      const isProduction = config.nodeEnv === "production";
      res.clearCookie(config.sessionName, {
        httpOnly: true,
        sameSite: isProduction ? "none" : "lax",
        secure: isProduction,
      });

      return res.json({ success: true });
    });
  },
};
