import { z } from "zod";

export const registerSchema = z.object({
  username: z.string().min(1),
  email: z.string().email(),
  password: z.string().min(6),
  roleId: z.string().min(1),
});

export const registrationDecisionSchema = z.object({
  registrationId: z.string().min(1),
});

export type RegisterRequest = z.infer<typeof registerSchema>;
