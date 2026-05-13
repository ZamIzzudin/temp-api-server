import { z } from "zod";

export const updateMappingsSchema = z.object({
  roleCode: z.string().min(1),
  mappings: z.array(
    z.object({
      menuCode: z.string().min(1),
      actionCodes: z.array(z.string().min(1)),
    }),
  ),
});

export type UpdateMappingsRequest = z.infer<typeof updateMappingsSchema>;
