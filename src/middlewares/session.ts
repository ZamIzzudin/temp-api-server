import session from "express-session";
import { config } from "../config";

const isProduction = config.nodeEnv === "production";

export const sessionMiddleware = session({
  name: config.sessionName,
  secret: config.sessionSecret,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: isProduction,
    sameSite: isProduction ? "none" : "lax",
    maxAge: config.sessionTtlSeconds * 1000,
  },
  rolling: true,
});
