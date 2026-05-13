import { z } from "zod";

export const menuCreateSchema = z.object({
  code: z.string().min(1),
  name: z.string().min(1),
  path: z.string().nullable(),
  icon: z.string().min(1),
  sortOrder: z.number().int().min(0),
  parentMenuId: z.string().nullable(),
  actionIds: z.array(z.string().min(1)).default([]),
});

export const menuUpdateSchema = menuCreateSchema.extend({
  actionIds: z.array(z.string().min(1)).optional(),
});
