import { z } from "zod";

export const roleCreateSchema = z.object({
  code: z.string().min(1),
  name: z.string().min(1),
  category: z.enum(["internal", "external"]),
});

export const roleUpdateSchema = roleCreateSchema;
