export type UserPrivilegePayload = {
  userId: string;
  username: string;
  email: string;
  roles: string[];
  menus: Array<{
    id: string;
    code: string;
    name: string;
    path: string | null;
    icon: string;
    actions: string[];
    subMenus: Array<{
      id: string;
      code: string;
      name: string;
      path: string | null;
      icon: string;
      actions: string[];
    }>;
  }>;
};
