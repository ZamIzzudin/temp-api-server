import session from "express-session";
import { config } from "../config";

export const sessionMiddleware = session({
  name: config.sessionName,
  secret: config.sessionSecret,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: config.nodeEnv === "production",
    sameSite: "lax",
    maxAge: config.sessionTtlSeconds * 1000,
  },
  rolling: true,
});
