import { z } from "zod";

export const userCreateSchema = z.object({
  username: z.string().min(1),
  email: z.string().email(),
  password: z.string().min(6),
  roleId: z.string().min(1),
});

export const userUpdateSchema = z.object({
  username: z.string().min(1),
  email: z.string().email(),
  password: z.string().min(6).optional(),
  roleId: z.string().min(1),
});
