-- CreateTable
CREATE TABLE "public"."t_mtr_user" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_mtr_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_mtr_role" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT 'internal',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_mtr_role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_trx_registration" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_trx_registration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_mtr_action" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_mtr_action_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_mtr_menu" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "path" TEXT,
    "icon" TEXT NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "parentMenuId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_mtr_menu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_mtr_menu_action" (
    "id" TEXT NOT NULL,
    "menuId" TEXT NOT NULL,
    "actionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_mtr_menu_action_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."t_trx_role_menu_action" (
    "id" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "menuActionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "t_trx_role_menu_action_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_user_email_key" ON "public"."t_mtr_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_role_code_key" ON "public"."t_mtr_role"("code");

-- CreateIndex
CREATE UNIQUE INDEX "t_trx_registration_email_key" ON "public"."t_trx_registration"("email");

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_action_code_key" ON "public"."t_mtr_action"("code");

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_menu_code_key" ON "public"."t_mtr_menu"("code");

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_menu_parentMenuId_code_key" ON "public"."t_mtr_menu"("parentMenuId", "code");

-- CreateIndex
CREATE UNIQUE INDEX "t_mtr_menu_action_menuId_actionId_key" ON "public"."t_mtr_menu_action"("menuId", "actionId");

-- CreateIndex
CREATE UNIQUE INDEX "t_trx_role_menu_action_roleId_menuActionId_key" ON "public"."t_trx_role_menu_action"("roleId", "menuActionId");

-- AddForeignKey
ALTER TABLE "public"."t_mtr_user" ADD CONSTRAINT "t_mtr_user_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."t_mtr_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_trx_registration" ADD CONSTRAINT "t_trx_registration_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."t_mtr_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_mtr_menu" ADD CONSTRAINT "t_mtr_menu_parentMenuId_fkey" FOREIGN KEY ("parentMenuId") REFERENCES "public"."t_mtr_menu"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_mtr_menu_action" ADD CONSTRAINT "t_mtr_menu_action_menuId_fkey" FOREIGN KEY ("menuId") REFERENCES "public"."t_mtr_menu"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_mtr_menu_action" ADD CONSTRAINT "t_mtr_menu_action_actionId_fkey" FOREIGN KEY ("actionId") REFERENCES "public"."t_mtr_action"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_trx_role_menu_action" ADD CONSTRAINT "t_trx_role_menu_action_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."t_mtr_role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."t_trx_role_menu_action" ADD CONSTRAINT "t_trx_role_menu_action_menuActionId_fkey" FOREIGN KEY ("menuActionId") REFERENCES "public"."t_mtr_menu_action"("id") ON DELETE CASCADE ON UPDATE CASCADE;
