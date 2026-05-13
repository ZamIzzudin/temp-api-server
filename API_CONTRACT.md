# API Contract — revamp/api-server

## Ringkasan
- Base URL (local): `http://localhost:4000`
- Format: JSON request/response
- Auth: Session cookie (via `express-session`)
- Content-Type: `application/json`

## Authentication & Authorization

### Session flow
1. Client login ke `POST /auth/login`
2. Server set cookie session
3. Endpoint protected membaca `req.session.user`

### Permission model
- Endpoint protected memakai middleware `requireAction(menuCode, action)`
- `action` yang didukung: `view | add | edit | delete | approve`
- Jika belum login: `401 { "message": "Unauthorized" }`
- Jika tidak punya akses: `403 { "message": "Forbidden" }`

## Standard Error Responses
- `400` payload/query/path invalid
- `401` unauthorized / session tidak valid
- `403` forbidden
- `404` resource tidak ditemukan
- `409` conflict (duplikasi / data masih direferensikan)
- `500` internal error

---

## Health

### GET `/health`
Health check endpoint.

**Response 200**
```json
{ "ok": true }
```

---

## Auth

### GET `/auth/role-options`
Ambil daftar role untuk kebutuhan login (menampilkan semua role).

**Response 200**
```json
[
  { "id": "1", "code": "role-1", "name": "Super Admin" }
]
```

### POST `/auth/login`
Login berbasis email + password + role.

**Request Body**
```json
{
  "email": "admin@admin.com",
  "password": "admin123",
  "roleId": "1"
}
```

**Response 200**
```json
{
  "id": "1",
  "username": "admin",
  "email": "admin@admin.com"
}
```

**Error**
- `400` `{ "message": "Email valid dan password wajib diisi" }`
- `401` `{ "message": "Email, password, atau role tidak valid" }`

### GET `/auth/me`
Ambil user session aktif.

**Response 200**
```json
{
  "id": "1",
  "username": "admin",
  "email": "admin@admin.com"
}
```

### POST `/auth/logout`
Destroy session dan clear cookie.

**Response 200**
```json
{ "success": true }
```

---

## Registration

### GET `/registrations/role-options`
Ambil role yang boleh dipakai registrasi (external only).

**Response 200**
```json
[
  { "id": "2", "code": "role-2", "name": "External User" }
]
```

### POST `/registrations/register`
Registrasi user baru dengan status menunggu approval.

**Request Body**
```json
{
  "username": "johndoe",
  "email": "john@mail.com",
  "password": "secret123",
  "roleId": "2"
}
```

**Response 201**
```json
{ "message": "Registrasi berhasil, menunggu approval" }
```

### GET `/registrations/pending`
List registrasi pending.

**Permission**: `requireAction("approve-registration", "view")`

**Query Params**
- `page` (default `1`)
- `perPage` (default `15`, max `15`)
- `q` (search email)

**Response 200**
```json
{
  "items": [
    {
      "id": "12",
      "username": "john",
      "email": "john@mail.com",
      "role": { "id": "2", "code": "role-2", "name": "External User" },
      "createdAt": "2026-05-13T02:00:00.000Z"
    }
  ],
  "total": 1,
  "page": 1,
  "perPage": 15,
  "totalPages": 1
}
```

### POST `/registrations/approve`
Approve registrasi pending.

**Permission**: `requireAction("approve-registration", "approve")`

**Request Body**
```json
{ "registrationId": "12" }
```

**Response 200**
```json
{ "success": true }
```

### POST `/registrations/reject`
Reject registrasi.

**Permission**: `requireAction("approve-registration", "approve")`

**Request Body**
```json
{ "registrationId": "12" }
```

**Response 200**
```json
{ "success": true }
```

---

## Privileges

### GET `/privileges/roles`
List role options untuk halaman mapping privilege.

**Permission**: `requireAction("privilege", "view")`

**Response 200**
```json
[
  { "id": "1", "code": "role-1", "name": "Super Admin" }
]
```

### GET `/privileges/role-matrix?roleCode=role-1`
Ambil matrix menu-action dari role tertentu.

**Permission**: `requireAction("privilege", "view")`

**Response 200**
```json
{
  "role": { "id": "1", "code": "role-1", "name": "Super Admin" },
  "actions": [
    { "id": "1", "code": "view", "name": "View" }
  ],
  "rows": [
    {
      "menuId": "1",
      "menuCode": "dashboard",
      "menuName": "Dashboard",
      "parentMenuId": null,
      "path": "/dashboard",
      "checkedActionIds": ["1"],
      "availableActionIds": ["1", "2"]
    }
  ]
}
```

### PUT `/privileges/role-mappings`
Replace mapping action suatu role.

**Permission**: `requireAction("privilege", "approve")`

**Request Body**
```json
{
  "roleCode": "role-1",
  "mappings": [
    {
      "menuCode": "dashboard",
      "actionCodes": ["view", "add"]
    }
  ]
}
```

**Response 200**
```json
{ "success": true }
```

### GET `/privileges/me`
Ambil privilege milik user login.

**Response 200**
```json
{
  "userId": "1",
  "username": "admin",
  "email": "admin@admin.com",
  "roles": ["role-1"],
  "menus": [
    {
      "id": "1",
      "code": "dashboard",
      "name": "Dashboard",
      "path": "/dashboard",
      "icon": "SquareMenu",
      "actions": ["view"],
      "subMenus": []
    }
  ]
}
```

---

## Actions

### GET `/actions/options`
Ambil options action untuk kebutuhan form menu.

**Permission**: `requireAction("menu", "view")`

### GET `/actions`
List actions.

**Permission**: `requireAction("action", "view")`

**Query Params**: `page`, `perPage`, `q`

**Response shape**
```json
{
  "items": [
    { "id": "1", "code": "view", "name": "View", "createdAt": "2026-05-13T02:00:00.000Z" }
  ],
  "total": 1,
  "page": 1,
  "perPage": 15,
  "totalPages": 1
}
```

### POST `/actions`
Create action.

**Permission**: `requireAction("action", "add")`

**Request Body**
```json
{ "code": "export", "name": "Export" }
```

### PUT `/actions/:id`
Update action.

**Permission**: `requireAction("action", "edit")`

**Request Body**
```json
{ "code": "export", "name": "Export Data" }
```

### DELETE `/actions/:id`
Delete action.

**Permission**: `requireAction("action", "delete")`

**Response 200**
```json
{ "success": true, "message": "Action berhasil dihapus" }
```

---

## Roles

### GET `/roles`
List roles.

**Permission**: `requireAction("role", "view")`

**Query Params**: `page`, `perPage`, `q`

### POST `/roles`
Create role.

**Permission**: `requireAction("role", "add")`

**Request Body**
```json
{ "code": "role-new", "name": "Role Baru", "category": "external" }
```

### PUT `/roles/:id`
Update role.

**Permission**: `requireAction("role", "edit")`

### DELETE `/roles/:id`
Delete role.

**Permission**: `requireAction("role", "delete")`

**Response 200**
```json
{ "success": true, "message": "Role berhasil dihapus" }
```

---

## Menus

### GET `/menus`
List menus.

**Permission**: `requireAction("menu", "view")`

### POST `/menus`
Create menu + assign action ids.

**Permission**: `requireAction("menu", "add")`

**Request Body**
```json
{
  "code": "dashboard",
  "name": "Dashboard",
  "path": "/dashboard",
  "icon": "SquareMenu",
  "sortOrder": 1,
  "parentMenuId": null,
  "actionIds": ["1", "2"]
}
```

### PUT `/menus/:id`
Update menu + optional replace action ids.

**Permission**: `requireAction("menu", "edit")`

### DELETE `/menus/:id`
Delete menu.

**Permission**: `requireAction("menu", "delete")`

**Response 200**
```json
{ "success": true, "message": "Menu berhasil dihapus" }
```

---

## Users

### GET `/users`
List users aktif (`status = 1`).

**Permission**: `requireAction("user", "view")`

### GET `/users/role-options`
Role options untuk create user internal.

**Permission**: `requireAction("user", "add")`

### POST `/users`
Create user (status approved).

**Permission**: `requireAction("user", "add")`

**Request Body**
```json
{
  "username": "internal1",
  "email": "internal1@mail.com",
  "password": "secret123",
  "roleId": "1"
}
```

### PUT `/users/:id`
Update user.

**Permission**: `requireAction("user", "edit")`

**Request Body**
```json
{
  "username": "internal1",
  "email": "internal1@mail.com",
  "roleId": "1",
  "password": "optional-new-password"
}
```

### DELETE `/users/:id`
Soft delete user (`status = 0`).

**Permission**: `requireAction("user", "delete")`

**Response 200**
```json
{ "success": true, "message": "User berhasil dihapus" }
```

---

## Custom Params

### GET `/custom-params`
List custom params.

**Permission**: `requireAction("custom-param", "view")`

### POST `/custom-params`
Create custom param.

**Permission**: `requireAction("custom-param", "add")`

**Request Body**
```json
{ "key": "support_email", "value": "support@example.com" }
```

### PUT `/custom-params/:id`
Update custom param.

**Permission**: `requireAction("custom-param", "edit")`

**Request Body**
```json
{ "key": "support_email", "value": "helpdesk@example.com" }
```

### DELETE `/custom-params/:id`
Delete custom param.

**Permission**: `requireAction("custom-param", "delete")`

**Response 200**
```json
{ "success": true, "message": "Custom param berhasil dihapus" }
```

---

## Query Pagination Contract (Reusable)
Untuk endpoint list yang mendukung pagination:
- Query: `page`, `perPage`, `q`
- Response:
```json
{
  "items": [],
  "total": 0,
  "page": 1,
  "perPage": 15,
  "totalPages": 1
}
```

## Catatan Integrasi Team
- Selalu kirim cookie (`withCredentials: true`) dari frontend/client HTTP.
- Role format konsisten: `id` string numeric, `code` format `role-{id}`.
- Sebagian endpoint menampilkan message bahasa Indonesia; gunakan `status code` sebagai sumber kebenaran flow UI.
- Untuk test end-to-end, urutan umum:
  1. `POST /auth/login`
  2. `GET /privileges/me`
  3. Akses endpoint protected sesuai permission user.
