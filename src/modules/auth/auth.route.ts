import { Router } from "express";
import { authController } from "./auth.controller";

export const authRouter = Router();

authRouter.post("/login", authController.login);
authRouter.get("/role-options", authController.roleOptions);
authRouter.get("/me", authController.me);
authRouter.post("/logout", authController.logout);
