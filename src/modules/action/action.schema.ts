import { z } from "zod";

export const actionCreateSchema = z.object({
  code: z.string().min(1),
  name: z.string().min(1),
});

export const actionUpdateSchema = actionCreateSchema;
