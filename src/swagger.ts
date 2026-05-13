import { Express } from "express";
import swaggerUi from "swagger-ui-express";

const openApiSpec = {
  openapi: "3.0.3",
  info: {
    title: "SITOLAUT API",
    version: "1.0.0",
    description: "",
  },
  servers: [{ url: "http://localhost:4000" }],
  tags: [
    { name: "Health" },
    { name: "Auth" },
    { name: "Registration" },
    { name: "Privileges" },
    { name: "Actions" },
    { name: "Roles" },
    { name: "Menus" },
    { name: "Users" },
    { name: "Custom Params" },
  ],
  components: {
    securitySchemes: {
      sessionCookie: {
        type: "apiKey",
        in: "cookie",
        name: "internal_session",
        description: "Session cookie from /auth/login",
      },
    },
    schemas: {
      MessageResponse: {
        type: "object",
        properties: {
          message: { type: "string" },
        },
      },
      SuccessResponse: {
        type: "object",
        properties: {
          success: { type: "boolean", example: true },
        },
      },
      RoleOption: {
        type: "object",
        properties: {
          id: { type: "string", example: "1" },
          code: { type: "string", example: "role-1" },
          name: { type: "string", example: "Super Admin" },
        },
      },
      UserSession: {
        type: "object",
        properties: {
          id: { type: "string", example: "1" },
          username: { type: "string", example: "admin" },
          email: { type: "string", example: "admin@admin.com" },
        },
      },
      PaginationMeta: {
        type: "object",
        properties: {
          total: { type: "integer", example: 1 },
          page: { type: "integer", example: 1 },
          perPage: { type: "integer", example: 15 },
          totalPages: { type: "integer", example: 1 },
        },
      },
    },
  },
  paths: {
    "/health": {
      get: {
        tags: ["Health"],
        summary: "Health check",
        responses: {
          "200": {
            description: "OK",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: { ok: { type: "boolean", example: true } },
                },
              },
            },
          },
        },
      },
    },
    "/auth/role-options": {
      get: {
        tags: ["Auth"],
        summary: "Get role options for login",
        responses: {
          "200": {
            description: "Role list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/RoleOption" },
                },
              },
            },
          },
        },
      },
    },
    "/auth/login": {
      post: {
        tags: ["Auth"],
        summary: "Login with email, password, role",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["email", "password", "roleId"],
                properties: {
                  email: { type: "string", format: "email" },
                  password: { type: "string" },
                  roleId: { type: "string" },
                },
              },
            },
          },
        },
        responses: {
          "200": {
            description: "Authenticated user",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/UserSession" },
              },
            },
          },
          "400": { description: "Invalid payload" },
          "401": { description: "Invalid credentials/role" },
        },
      },
    },
    "/auth/me": {
      get: {
        tags: ["Auth"],
        summary: "Get active session user",
        security: [{ sessionCookie: [] }],
        responses: {
          "200": {
            description: "Session user",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/UserSession" },
              },
            },
          },
          "401": { description: "Unauthorized" },
        },
      },
    },
    "/auth/logout": {
      post: {
        tags: ["Auth"],
        summary: "Logout and clear session",
        security: [{ sessionCookie: [] }],
        responses: {
          "200": {
            description: "Logged out",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/SuccessResponse" },
              },
            },
          },
        },
      },
    },
    "/registrations/role-options": {
      get: {
        tags: ["Registration"],
        summary: "Get external role options",
        responses: {
          "200": {
            description: "Role list",
            content: {
              "application/json": {
                schema: { type: "array", items: { $ref: "#/components/schemas/RoleOption" } },
              },
            },
          },
        },
      },
    },
    "/registrations/register": {
      post: {
        tags: ["Registration"],
        summary: "Register external user",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["username", "email", "password", "roleId"],
                properties: {
                  username: { type: "string" },
                  email: { type: "string", format: "email" },
                  password: { type: "string", minLength: 6 },
                  roleId: { type: "string" },
                },
              },
            },
          },
        },
        responses: {
          "201": { description: "Registration submitted" },
          "400": { description: "Invalid payload" },
          "409": { description: "Duplicate email" },
        },
      },
    },
    "/registrations/pending": {
      get: {
        tags: ["Registration"],
        summary: "Get pending registrations",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: {
          "200": { description: "Paginated pending registrations" },
          "401": { description: "Unauthorized" },
          "403": { description: "Forbidden" },
        },
      },
    },
    "/registrations/approve": {
      post: {
        tags: ["Registration"],
        summary: "Approve registration",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: { "application/json": { schema: { type: "object", required: ["registrationId"], properties: { registrationId: { type: "string" } } } } },
        },
        responses: { "200": { description: "Approved" }, "404": { description: "Not found" } },
      },
    },
    "/registrations/reject": {
      post: {
        tags: ["Registration"],
        summary: "Reject registration",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: { "application/json": { schema: { type: "object", required: ["registrationId"], properties: { registrationId: { type: "string" } } } } },
        },
        responses: { "200": { description: "Rejected" } },
      },
    },
    "/privileges/roles": { get: { tags: ["Privileges"], summary: "Get role options", security: [{ sessionCookie: [] }], responses: { "200": { description: "Role list" } } } },
    "/privileges/role-matrix": {
      get: {
        tags: ["Privileges"],
        summary: "Get role privilege matrix",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "roleCode", in: "query", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Role matrix" } },
      },
    },
    "/privileges/role-mappings": {
      put: {
        tags: ["Privileges"],
        summary: "Replace role privilege mappings",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["roleCode", "mappings"],
                properties: {
                  roleCode: { type: "string" },
                  mappings: {
                    type: "array",
                    items: {
                      type: "object",
                      required: ["menuCode", "actionCodes"],
                      properties: {
                        menuCode: { type: "string" },
                        actionCodes: { type: "array", items: { type: "string" } },
                      },
                    },
                  },
                },
              },
            },
          },
        },
        responses: { "200": { description: "Updated" } },
      },
    },
    "/privileges/me": { get: { tags: ["Privileges"], summary: "Get current user privileges", security: [{ sessionCookie: [] }], responses: { "200": { description: "Privilege tree" } } } },

    "/actions/options": { get: { tags: ["Actions"], summary: "Get action options", security: [{ sessionCookie: [] }], responses: { "200": { description: "Action options" } } } },
    "/actions": {
      get: {
        tags: ["Actions"],
        summary: "List actions",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: { "200": { description: "Paginated actions" } },
      },
      post: {
        tags: ["Actions"],
        summary: "Create action",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: { "application/json": { schema: { type: "object", required: ["code", "name"], properties: { code: { type: "string" }, name: { type: "string" } } } } },
        },
        responses: { "201": { description: "Created" } },
      },
    },
    "/actions/{id}": {
      put: {
        tags: ["Actions"],
        summary: "Update action",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        requestBody: { required: true, content: { "application/json": { schema: { type: "object", required: ["code", "name"], properties: { code: { type: "string" }, name: { type: "string" } } } } } },
        responses: { "200": { description: "Updated" } },
      },
      delete: {
        tags: ["Actions"],
        summary: "Delete action",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Deleted" } },
      },
    },

    "/roles": {
      get: {
        tags: ["Roles"],
        summary: "List roles",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: { "200": { description: "Paginated roles" } },
      },
      post: {
        tags: ["Roles"],
        summary: "Create role",
        security: [{ sessionCookie: [] }],
        requestBody: { required: true, content: { "application/json": { schema: { type: "object", required: ["code", "name", "category"], properties: { code: { type: "string" }, name: { type: "string" }, category: { type: "string", enum: ["internal", "external"] } } } } } },
        responses: { "201": { description: "Created" } },
      },
    },
    "/roles/{id}": {
      put: {
        tags: ["Roles"],
        summary: "Update role",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        requestBody: { required: true, content: { "application/json": { schema: { type: "object", required: ["code", "name", "category"], properties: { code: { type: "string" }, name: { type: "string" }, category: { type: "string", enum: ["internal", "external"] } } } } } },
        responses: { "200": { description: "Updated" } },
      },
      delete: {
        tags: ["Roles"],
        summary: "Delete role",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Deleted" } },
      },
    },

    "/menus": {
      get: {
        tags: ["Menus"],
        summary: "List menus",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: { "200": { description: "Paginated menus" } },
      },
      post: {
        tags: ["Menus"],
        summary: "Create menu",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["code", "name", "path", "icon", "sortOrder", "actionIds"],
                properties: {
                  code: { type: "string" },
                  name: { type: "string" },
                  path: { type: "string" },
                  icon: { type: "string" },
                  sortOrder: { type: "integer" },
                  parentMenuId: { type: "string", nullable: true },
                  actionIds: { type: "array", items: { type: "string" } },
                },
              },
            },
          },
        },
        responses: { "201": { description: "Created" } },
      },
    },
    "/menus/{id}": {
      put: {
        tags: ["Menus"],
        summary: "Update menu",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["code", "name", "path", "icon", "sortOrder"],
                properties: {
                  code: { type: "string" },
                  name: { type: "string" },
                  path: { type: "string" },
                  icon: { type: "string" },
                  sortOrder: { type: "integer" },
                  parentMenuId: { type: "string", nullable: true },
                  actionIds: { type: "array", items: { type: "string" } },
                },
              },
            },
          },
        },
        responses: { "200": { description: "Updated" } },
      },
      delete: {
        tags: ["Menus"],
        summary: "Delete menu",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Deleted" } },
      },
    },

    "/users": {
      get: {
        tags: ["Users"],
        summary: "List users",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: { "200": { description: "Paginated users" } },
      },
      post: {
        tags: ["Users"],
        summary: "Create user",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["username", "email", "password", "roleId"],
                properties: {
                  username: { type: "string" },
                  email: { type: "string", format: "email" },
                  password: { type: "string", minLength: 6 },
                  roleId: { type: "string" },
                },
              },
            },
          },
        },
        responses: { "201": { description: "Created" } },
      },
    },
    "/users/role-options": { get: { tags: ["Users"], summary: "Get role options for user create", security: [{ sessionCookie: [] }], responses: { "200": { description: "Role options" } } } },
    "/users/{id}": {
      put: {
        tags: ["Users"],
        summary: "Update user",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["username", "email", "roleId"],
                properties: {
                  username: { type: "string" },
                  email: { type: "string", format: "email" },
                  roleId: { type: "string" },
                  password: { type: "string" },
                },
              },
            },
          },
        },
        responses: { "200": { description: "Updated" } },
      },
      delete: {
        tags: ["Users"],
        summary: "Delete user (soft delete)",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Deleted" } },
      },
    },

    "/custom-params": {
      get: {
        tags: ["Custom Params"],
        summary: "List custom params",
        security: [{ sessionCookie: [] }],
        parameters: [
          { name: "page", in: "query", schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", schema: { type: "integer", default: 15, maximum: 15 } },
          { name: "q", in: "query", schema: { type: "string" } },
        ],
        responses: { "200": { description: "Paginated custom params" } },
      },
      post: {
        tags: ["Custom Params"],
        summary: "Create custom param",
        security: [{ sessionCookie: [] }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { type: "object", required: ["key", "value"], properties: { key: { type: "string" }, value: { type: "string" } } },
            },
          },
        },
        responses: { "201": { description: "Created" } },
      },
    },
    "/custom-params/{id}": {
      put: {
        tags: ["Custom Params"],
        summary: "Update custom param",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { type: "object", required: ["key", "value"], properties: { key: { type: "string" }, value: { type: "string" } } },
            },
          },
        },
        responses: { "200": { description: "Updated" } },
      },
      delete: {
        tags: ["Custom Params"],
        summary: "Delete custom param",
        security: [{ sessionCookie: [] }],
        parameters: [{ name: "id", in: "path", required: true, schema: { type: "string" } }],
        responses: { "200": { description: "Deleted" } },
      },
    },
  },
};

export const setupSwagger = (app: Express) => {
  app.use("/docs", (req, res, next) => {
    if (req.originalUrl === "/docs") {
      return res.redirect(302, "/docs/");
    }

    next();
  });
  app.use("/docs", swaggerUi.serve, swaggerUi.setup(openApiSpec));

  app.get("/docs.json", (_req, res) => {
    res.json(openApiSpec);
  });
};
