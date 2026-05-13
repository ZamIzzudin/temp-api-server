import { PrismaClient } from "@prisma/client";

declare global {
  var __prisma__: PrismaClient | undefined;
}

export const prisma =
  global.__prisma__ ??
  new PrismaClient({
    log: ["error", "warn"],
    datasources: {
      db: {
        url: process.env.USE_DATABASE_DUMP === "true" ? process.env.DATABASE_DUMP : process.env.DATABASE_URL,
      },
    },
  });

if (!global.__prisma__) {
  global.__prisma__ = prisma;
}
