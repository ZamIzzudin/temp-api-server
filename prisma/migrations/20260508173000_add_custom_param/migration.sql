CREATE TABLE "public"."t_mtr_custom_param" (
  "id" TEXT NOT NULL,
  "key" TEXT NOT NULL,
  "value" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "t_mtr_custom_param_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "t_mtr_custom_param_key_key" ON "public"."t_mtr_custom_param"("key");
