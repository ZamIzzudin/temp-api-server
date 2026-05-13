import { z } from "zod";

export const customParamCreateSchema = z.object({
  key: z.string().min(1),
  value: z.string().min(1),
});

export const customParamUpdateSchema = customParamCreateSchema;
