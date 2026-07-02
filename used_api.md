# Used APIs — SSM Nexus App

This document lists every REST API endpoint **actively used** by the Flutter app.  
Paths are relative to the base URL configured in `.env` (`API_BASE_URL`).

**Default base URL:** `https://api.sawaliyamultitrade.com`

---

## Authentication & session

All protected endpoints require a **Bearer access token** in the `Authorization` header.  
The token is attached automatically by `AuthInterceptor` (`lib/core/api/auth_interceptor.dart`).

Session refresh uses an **HttpOnly `refresh_token` cookie** (managed by Dio cookie jar).

| # | Method | Endpoint | Auth | Service | Purpose |
|---|--------|----------|------|---------|---------|
| 1 | `POST` | `/employees/login/` | Public | `AuthService.login` | Sign in with email and password |
| 2 | `POST` | `/employees/session/refresh/` | Cookie | `AuthService.refreshSession` | Refresh access token using refresh cookie |
| 3 | `POST` | `/employees/session/logout/` | Bearer | `AuthService.logout` | Invalidate session on server |

### POST `/employees/login/`

**Request body (JSON):**
```json
{
  "email": "user@example.com",
  "password": "secret"
}
```

**Response:** `{ "success": true, "access": "...", "employee": { ... } }`  
On failure: `{ "success": false, "error": "..." }`

**Notes:**
- Public endpoint — no Bearer token sent.
- Saves session locally via `AuthStorage`.

---

### POST `/employees/session/refresh/`

**Request body:** none (refresh token sent as HttpOnly cookie)

**Response:** `{ "success": true, "access": "..." }`

**Notes:**
- Called automatically on `401` responses by `AuthInterceptor`.
- On failure, local session and cookies are cleared.

---

### POST `/employees/session/logout/`

**Request body:** none

**Response:** `{ "success": true }`

**Notes:**
- Best-effort call; local session is cleared even if the API fails.

---

## Notifications

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 4 | `GET` | `/employees/api/notifications/` | `NotificationService.fetchNotifications` | List notifications (paginated) |
| 5 | `PATCH` | `/employees/api/notifications/{id}/mark-read/` | `NotificationService.markAsRead` | Mark one notification as read |
| 6 | `PATCH` | `/employees/api/notifications/mark-all-read/` | `NotificationService.markAllAsRead` | Mark all notifications as read |

### GET `/employees/api/notifications/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number (default: `1`) |
| `page_size` | int | No | Items per page (default: `20`) |
| `is_read` | bool | No | Filter unread only when `false` |
| `role` | string | No | Current employee role (auto-sent from session) |
| `branch` | string | No | Current employee branch (auto-sent from session) |

---

### PATCH `/employees/api/notifications/{id}/mark-read/`

**Request body:**
```json
{ "is_read": true }
```

---

### PATCH `/employees/api/notifications/mark-all-read/`

**Request body:**
```json
{ "is_read": true }
```

---

## Employees

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 7 | `GET` | `/employees/api/` | `EmployeeService.fetchEmployees` | List employees (paginated, filterable) |
| 8 | `GET` | `/employees/api/{id}/` | `EmployeeService.fetchEmployee` | Get single employee detail |
| 9 | `PUT` | `/employees/api/{id}/` | `EmployeePutService.putEmployee` | Full update of employee record |
| 10 | `DELETE` | `/employees/api/{id}/` | `EmployeeService.deleteEmployee` | Delete an employee |
| 11 | `POST` | `/employees/register/` | `EmployeeService.registerEmployee` | Register a new employee |
| 12 | `POST` | `/employees/api/employment-history/{employeeId}/` | `EmployeeService.addEmploymentHistory` | Add employment history entry |
| 13 | `GET` | `/employees/api/roles/` | `EmployeeService.fetchRoles` | List available employee roles |

### GET `/employees/api/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number (default: `1`) |
| `page_size` | int | No | Items per page (default: `20`) |
| `search` | string | No | Search by name, code, etc. |
| `is_active` | bool | No | Filter by active status |
| `branch` | string | No | Filter by branch code |
| `role` | int | No | Filter by role ID |
| `role_code` | string | No | Filter by role code |

**Also used by:** `DashboardService` (count only, `page_size=1`).

---

### GET `/employees/api/{id}/`

**Response:** Full employee detail including personal, employment, and contact fields.

---

### PUT `/employees/api/{id}/`

**Content-Type:** `application/json` or `multipart/form-data` (when photo uploaded)

**Request body (JSON fields from `EmployeePutRequest`):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | Yes | Login email |
| `password` | string | Yes | Password |
| `role` | int | Yes | Role ID |
| `branch` | int | Yes | Branch ID |
| `first_name` | string | Yes | First name |
| `last_name` | string | Yes | Last name |
| `father_name` | string | No | Father's name |
| `date_of_birth` | date | No | `YYYY-MM-DD` |
| `place_of_birth` | string | No | Place of birth |
| `gender` | string | No | Gender |
| `marital_status` | string | No | Marital status |
| `nationality` | string | No | Nationality |
| `languages_known` | string | No | Languages |
| `aadhaar_card_no` | string | No | Aadhaar number |
| `pan_card_no` | string | No | PAN number |
| `primary_mobile_number` | string | No | Primary mobile |
| `secondary_mobile_number` | string | No | Secondary mobile |
| `present_address` | string | No | Present address |
| `permanent_address` | string | No | Permanent address |
| `height_cm` | string | No | Height in cm |
| `weight_kg` | string | No | Weight in kg |
| `blood_group` | string | No | Blood group |
| `date_of_appointment` | date | No | Appointment date |
| `date_of_joining` | date | No | Joining date |
| `date_of_confirmation` | date | No | Confirmation date |
| `payable_from_date` | date | No | Payable from date |
| `performance_appraisal` | string | No | Appraisal notes |
| `warning_notes` | string | No | Warning notes |
| `remarks` | string | No | General remarks |
| `educational_qualifications` | string | No | Education |
| `professional_qualifications` | string | No | Professional qualifications |
| `members_in_family` | int | No | Family member count |
| `emergency_contact_name` | string | No | Emergency contact name |
| `emergency_contact_relation` | string | No | Emergency contact relation |
| `emergency_contact_number` | string | No | Emergency contact number |

**Multipart file field:** `employee_photo` (optional)

**Notes:** Full replace — all fields must be sent.

---

### DELETE `/employees/api/{id}/`

**Request body:** none

---

### POST `/employees/register/`

**Content-Type:** `application/json` or `multipart/form-data` (when photo uploaded)

**Request body:** Same fields as PUT above, plus:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `employee_code` | string | Yes | Unique employee code |

**Multipart file field:** `employee_photo` (optional)

---

### POST `/employees/api/employment-history/{employeeId}/`

**Request body:** Dynamic payload (`Map<String, dynamic>`) — employment history fields sent from UI.

---

### GET `/employees/api/roles/`

**Response:** List of role options (`id`, `name`, `code`, etc.)

**Notes:** Falls back to hardcoded roles if the API call fails.

---

### Deprecated (still in code, do not use for new features)

| Method | Endpoint | Service | Notes |
|--------|----------|---------|-------|
| `POST` | `/employees/api/` | `EmployeeService.createEmployee` | Deprecated — use `POST /employees/register/` instead |

---

## Customers

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 14 | `GET` | `/customers/api/` | `CustomerService.fetchCustomers` | List customers (paginated) |
| 15 | `GET` | `/customers/api/{id}/` | `CustomerService.fetchCustomer` | Get single customer detail |
| 16 | `POST` | `/customers/api/` | `CustomerService.createCustomer` | Create a new customer |
| 17 | `PATCH` | `/customers/api/{id}/` | `CustomerService.updateCustomer` | Partial update of customer |
| 18 | `POST` | `/customers/api/{customerId}/family-members/` | `CustomerService.addFamilyMember` | Add a family member |
| 19 | `POST` | `/customers/api/{customerId}/maternal-house/` | `CustomerService.saveMaternalHouse` | Create maternal house record |
| 20 | `PATCH` | `/customers/api/{customerId}/maternal-house/` | `CustomerService.saveMaternalHouse` | Update maternal house record |
| 21 | `POST` | `/customers/api/{customerId}/other-loans/` | `CustomerService.addOtherLoan` | Add other loan entry |
| 22 | `POST` | `/customers/api/{customerId}/guarantors/` | `CustomerService.addGuarantor` | Add a guarantor |
| 23 | `POST` | `/customers/api/{customerId}/documents/` | `CustomerService.uploadDocument` | Upload customer document |

### GET `/customers/api/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number (default: `1`) |
| `page_size` | int | No | Items per page (default: `20`) |
| `search` | string | No | Search text |
| `status` | string | No | Customer status filter (see values below) |
| `branch` | string | No | Branch code filter |

**Customer status values:** `SOURCED`, `APPLIED`, `UNNDER_REVIEW`, `APPROVED`, `REJECTED`, `ACTIVE`, `CLOSED`

**Also used by:** `DashboardService` (count and status breakdown).

---

### GET `/customers/api/{id}/`

**Response:** Full customer detail including family, guarantors, loans, documents, etc.

---

### POST `/customers/api/`

**Content-Type:** `application/json` or `multipart/form-data`

**Request body:** Customer wizard payload (dynamic fields from UI).

**Multipart file fields (optional):**
- `live_photo` — customer live photo
- `house_photo` — house photo

---

### PATCH `/customers/api/{id}/`

**Request body:** Partial customer fields. Used for general updates and status changes.

**Example (status update):**
```json
{ "status": "APPROVED" }
```

---

### POST `/customers/api/{customerId}/family-members/`

**Request body:** Family member fields (dynamic payload from customer wizard).

---

### POST / PATCH `/customers/api/{customerId}/maternal-house/`

**Request body:** Maternal house details (dynamic payload).

**Notes:** `POST` when record does not exist; `PATCH` when updating existing record.

---

### POST `/customers/api/{customerId}/other-loans/`

**Request body:** Other loan details (dynamic payload).

---

### POST `/customers/api/{customerId}/guarantors/`

**Request body:** Guarantor details (dynamic payload).

---

### POST `/customers/api/{customerId}/documents/`

**Content-Type:** `multipart/form-data`

**Form fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_type` | string | Yes | Document type identifier |
| `file` | file | Yes | Document file |

---

### Defined in `ApiConfig` but not yet called by the app

These paths exist in config for future use (update/delete sub-resources):

- `/customers/api/{customerId}/family-members/{memberId}/`
- `/customers/api/{customerId}/guarantors/{guarantorId}/`
- `/customers/api/{customerId}/other-loans/{loanId}/`

---

## Branches

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 24 | `GET` | `/branches/api/` | `BranchService.fetchBranches` | List branches (paginated) |
| 25 | `GET` | `/branches/api/{id}/` | `BranchService.fetchBranch` | Get single branch detail |
| 26 | `POST` | `/branches/api/` | `BranchService.createBranch` | Create a new branch |
| 27 | `PUT` | `/branches/api/{id}/` | `BranchService.updateBranch` | Full update of branch |
| 28 | `PATCH` | `/branches/api/{id}/` | `BranchPatchService.patchBranch` | Partial update of branch |
| 29 | `DELETE` | `/branches/api/{id}/` | `BranchService.deleteBranch` | Delete a branch |

**Also used by:** `EmployeeService.fetchBranches` (dropdown, `page_size=200`) and `DashboardService` (count).

### GET `/branches/api/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number |
| `page_size` | int | No | Items per page (default: `50`) |
| `search` | string | No | Search by name or code |
| `is_active` | string | No | `"true"` or `"false"` |

---

### GET `/branches/api/{id}/`

**Response:** Branch detail (`branch_name`, `branch_code`, `branch_city`, `branch_location`, `payment_qr_code`, `is_active`, etc.)

---

### POST `/branches/api/`

**Content-Type:** `application/json` or `multipart/form-data`

**Request body (JSON):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `branch_name` | string | Yes | Branch name |
| `branch_code` | string | Yes | Branch code (uppercased by client) |
| `branch_city` | string | Yes | City |
| `branch_location` | string | No | Address / location |
| `is_active` | bool | No | Active flag (default: `true`) |

**Multipart file field:** `payment_qr_code` (optional)

---

### PUT `/branches/api/{id}/`

**Content-Type:** `application/json` or `multipart/form-data`

**Request body:** Same as POST, plus:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `is_deleted` | bool | No | Soft-delete flag |

**Multipart file field:** `payment_qr_code` (optional)

**Notes:** Full replace — all branch fields must be sent.

---

### PATCH `/branches/api/{id}/`

**Request body:** Only the fields to change (partial update).

**Example (toggle active status):**
```json
{
  "is_active": true,
  "is_deleted": false
}
```

---

### DELETE `/branches/api/{id}/`

**Request body:** none

---

## Centers (Operations)

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 30 | `GET` | `/operations/api/centers/` | `CenterService.fetchCenters` | List loan centers (paginated) |
| 31 | `GET` | `/operations/api/centers/{id}/` | `CenterService.fetchCenter` | Get single center detail |
| 32 | `POST` | `/operations/api/centers/` | `CenterService.createCenter` | Create a new center |
| 33 | `POST` | `/operations/api/centers/{centerId}/members/` | `CenterService.addMember` | Add customer as center member |
| 34 | `DELETE` | `/operations/api/centers/{centerId}/members/{memberId}/` | `CenterService.removeMember` | Remove member from center |
| 35 | `POST` | `/operations/api/centers/{centerId}/generate-emi/` | `CenterService.generateEmi` | Generate EMI schedule for center |

### GET `/operations/api/centers/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number (default: `1`) |
| `page_size` | int | No | Items per page (default: `20`) |
| `search` | string | No | Search text |
| `status` | string | No | Center status: `PENDING`, `ACTIVE`, `CLOSED` |
| `branch` | string | No | Branch code filter |

**Also used by:** `DashboardService` (count only).

---

### GET `/operations/api/centers/{id}/`

**Response:** Center detail including members, EMI info, loan terms, etc.

---

### POST `/operations/api/centers/`

**Request body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `center_name` | string | Yes | Center name |
| `product_type` | string | Yes | Product type value |
| `loan_amount` | string | Yes | Loan amount (2 decimal places) |
| `interest_rate` | string | Yes | Interest rate (2 decimal places) |
| `tenure_months` | int | Yes | Loan tenure in months |
| `emi_amount` | string | Yes | EMI amount (2 decimal places) |
| `member_ids` | int[] | Yes | Initial member customer IDs |
| `branch` | string | No | Branch code |
| `purity` | string | No | Gold purity (for gold products) |
| `start_date` | date | No | Center start date (`YYYY-MM-DD`) |
| `remarks` | string | No | Notes |

**Notes:** Weight field key depends on product type (`productType.weightFieldKey`).

---

### POST `/operations/api/centers/{centerId}/members/`

**Request body:**
```json
{ "customer_id": 123 }
```

---

### DELETE `/operations/api/centers/{centerId}/members/{memberId}/`

**Request body:** none

---

### POST `/operations/api/centers/{centerId}/generate-emi/`

**Request body:** none

**Response:** Updated center detail with generated EMI schedule.

---

## EMIs (Dashboard only)

| # | Method | Endpoint | Service | Purpose |
|---|--------|----------|---------|---------|
| 36 | `GET` | `/operations/api/emis/` | `DashboardService.fetchStats` | EMI counts by status and collection stats |

**Note:** This path is **not** defined in `ApiConfig` — it is hardcoded in `DashboardService`.

### GET `/operations/api/emis/`

**Query parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `page` | int | No | Page number |
| `page_size` | int | No | Items per page (`1` for counts, `100` for collection trend) |
| `branch` | string | No | Branch code (from session) |
| `status` | string | No | EMI status filter |

**EMI status values:** `PENDING`, `PARTIAL`, `PAID`, `OVERDUE`, `CANCELLED`

**Usage in dashboard:**
- Count EMIs per status for chart segments
- Sum `amount_paid` / `paid_amount` / `amount` for paid EMIs
- Build monthly collection trend from `paid_at` / `payment_date` / `updated_at`

---

## Common response format

Most API responses follow this shape:

```json
{
  "success": true,
  "data": { ... },
  "count": 100,
  "page": 1,
  "page_size": 20
}
```

**Error response:**
```json
{
  "success": false,
  "error": "Human-readable error message"
}
```

Services call `_ensureSuccess()` and throw `ApiException` when `success != true`.

---

## HTTP client details

| Item | Location | Description |
|------|----------|-------------|
| Base URL | `lib/core/constants/env_config.dart` | Loaded from `API_BASE_URL` in `.env` |
| Path constants | `lib/core/constants/api_config.dart` | All endpoint paths |
| HTTP client | `lib/core/api/api_client.dart` | Dio wrapper (GET, POST, PUT, PATCH, DELETE, multipart) |
| Auth interceptor | `lib/core/api/auth_interceptor.dart` | Bearer token + auto-refresh on 401 |
| Trailing slashes | `ApiClient._normalizePath` | All paths normalized to end with `/` (Django `APPEND_SLASH`) |

---

## Summary

| Module | Endpoints used |
|--------|----------------|
| Auth & session | 3 |
| Notifications | 3 |
| Employees | 7 (+ 1 deprecated) |
| Customers | 10 |
| Branches | 6 |
| Centers | 6 |
| EMIs (dashboard) | 1 |
| **Total active** | **36** |

---

*Generated from codebase analysis. Source of truth: `lib/core/constants/api_config.dart` and service files under `lib/core/`.*
