import "dotenv/config";
import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import { config } from "./config";
import { prisma } from "./lib/prisma";
import { sessionMiddleware } from "./middlewares/session";
import { authRouter } from "./modules/auth/auth.route";
import { privilegeRouter } from "./modules/privilege/privilege.route";
import { actionRouter } from "./modules/action/action.route";
import { roleRouter } from "./modules/role/role.route";
import { menuRouter } from "./modules/menu/menu.route";
import { userRouter } from "./modules/user/user.route";
import { registrationRouter } from "./modules/registration/registration.route";
import { customParamRouter } from "./modules/custom-param/custom-param.route";
import { seedGenesisAccount } from "./seed";

const app = express();

app.use(
  cors({
    origin: config.corsOrigin,
    credentials: true,
  }),
);
app.use(cookieParser());
app.use(express.json());
app.use((req, res, next) => {
  res.on("finish", () => {
    const now = new Date();
    const time = now.toTimeString().slice(0, 8);
    console.log(`[${time}] ${req.method} ${req.originalUrl} ${res.statusCode}`);
  });

  next();
});
app.use(sessionMiddleware);

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.use("/auth", authRouter);
app.use("/privileges", privilegeRouter);
app.use("/actions", actionRouter);
app.use("/roles", roleRouter);
app.use("/menus", menuRouter);
app.use("/users", userRouter);
app.use("/registrations", registrationRouter);
app.use("/custom-params", customParamRouter);

const start = async () => {
  await prisma.$connect();
  await seedGenesisAccount();

  app.listen(config.port, () => {
    console.log(`api-server listening on http://localhost:${config.port}`);
  });
};

start().catch((error) => {
  console.error("Failed to start api-server", error);
  process.exit(1);
});
