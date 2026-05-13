import "dotenv/config";

const useDumpDatabase = (process.env.USE_DATABASE_DUMP ?? "false").toLowerCase() === "true";

export const config = {
  port: Number(process.env.PORT ?? 4000),
  nodeEnv: process.env.NODE_ENV ?? "development",
  useDumpDatabase,
  databaseUrl: useDumpDatabase ? process.env.DATABASE_DUMP ?? "" : process.env.DATABASE_URL ?? "",
  sessionSecret: process.env.SESSION_SECRET ?? "super-secret-change-me",
  sessionName: process.env.SESSION_NAME ?? "internal_session",
  sessionTtlSeconds: Number(process.env.SESSION_TTL_SECONDS ?? 60 * 60 * 8),
  corsOrigin: process.env.CORS_ORIGIN ?? "http://localhost:3000",
  seedGenesisUsername: process.env.SEED_GENESIS_USERNAME ?? "Genesis Admin",
  seedGenesisEmail: process.env.SEED_GENESIS_EMAIL ?? "genesis@example.com",
  seedGenesisPassword: process.env.SEED_GENESIS_PASSWORD ?? "genesis123",
  appLoginUrl: process.env.APP_LOGIN_URL ?? "http://localhost:3000",
  smtpHost: process.env.SMTP_HOST ?? "",
  smtpPort: Number(process.env.SMTP_PORT ?? 587),
  smtpSecure: process.env.SMTP_SECURE === "true",
  smtpUser: process.env.SMTP_USER ?? "",
  smtpPass: process.env.SMTP_PASS ?? "",
  smtpFrom: process.env.SMTP_FROM ?? "",
};
