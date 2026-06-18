# Shri Sawaliya Multitrade — Flutter Mobile UI Specification

## 1. Product Overview

Shri Sawaliya Multitrade is an internal operations platform for branch-based jewelry-backed lending:

- Branches — physical locations with payment QR codes.
- Employees — role-based staff with JWT login and granular permissions.
- Customers — sourced in the field, reviewed/approved, documented (KYC), then linked to centers.
- Centers — groups of approved customers with gold/silver product details and EMI schedules.
- EMI Collection — field staff record cash/online/partial payments against due installments.

The web app (ShriSawaliyaMultitrade-application) already maps most screens. Flutter should mirror the same flows, permissions, and API contracts.

---

## 2. Tech Stack (Backend)

| Layer | Choice |
|---------|---------|
| Framework | Django 5.2 + Django REST Framework |
| Auth | rest_framework_simplejwt |
| User Model | employees.User |
| Files | AWS S3 via django-storages |
| Database | SQLite (Dev) |
| API Style | JsonResponse `{success,data,error}` |
| Base URLs | `/branches/`, `/customers/`, `/employees/`, `/operations/` |

---

## 3. Authentication & Session

### Login

**POST** `/employees/login/`

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

Success:

```json
{
  "success": true,
  "access": "<JWT>",
  "id": 1,
  "is_superuser": false,
  "employee": {
    "employee_id": 12,
    "employee_code": "JAIPUR-EMP001",
    "role": "FO",
    "branch": "JAIPUR"
  },
  "permissions": []
}
```

### Refresh Token

**POST** `/employees/session/refresh/`

Uses HttpOnly cookie `refresh_token`.

### Logout

**POST** `/employees/session/logout/`

### Flutter Requirements

- Store access token using `flutter_secure_storage`
- Refresh on 401
- Cache employee profile and permissions
- Route to login if refresh fails

---

## 4. Authorization Model

### Permission Examples

- `customer.view`
- `customer.create`
- `customer.edit`
- `customer.approve`
- `center.view`
- `center.create`
- `emi.collect`
- `employee.view`
- `permission.manage`
- `permission.all`

### Roles

| Code | Name |
|--------|--------|
| ADMIN | Admin |
| AO | Administrative Officer |
| HRM | HR Manager |
| AM | Area Manager |
| BM | Branch Manager |
| ABM | Assistant Branch Manager |
| FO | Field Officer |
| CM | Collection Manager |

---

## 5. API Conventions

### Success Response

```json
{
  "success": true,
  "data": {}
}
```

### Error Response

```json
{
  "success": false,
  "error": "Something went wrong"
}
```

### Pagination

Parameters:

- page
- page_size
- search
- status
- branch
- is_active

---

## 6. Modules

### Branches

Base: `/branches/api/`

Operations:

- List
- Create
- Detail
- Update
- Delete
- QR Upload

### Employees

Base: `/employees/api/`

Operations:

- Employee CRUD
- **Employee registration** — `POST /employees/register/`
- Roles
- Permissions
- Documents
- Employment History
- Change Email
- Change Password

#### Employee Registration

**POST** `/employees/register/`

Request body (key fields):

```json
{
  "email": "user@example.com",
  "password": "********",
  "role": 8,
  "branch": 11,
  "first_name": "Arjun",
  "last_name": "Chouhan",
  "father_name": "Raghunath Chouhan",
  "date_of_birth": "1996-06-24",
  "place_of_birth": "Raisen",
  "gender": "MALE",
  "marital_status": "SINGLE",
  "nationality": "Indian",
  "languages_known": "Hindi English",
  "aadhaar_card_no": "764209385127",
  "pan_card_no": "ACHOU6381J",
  "primary_mobile_number": "9000010100",
  "secondary_mobile_number": "9000010101",
  "present_address": "Ayodhya Bypass, Bhopal",
  "permanent_address": "Raisen, Madhya Pradesh",
  "height_cm": "169.00",
  "weight_kg": "65.00",
  "blood_group": "B+",
  "date_of_appointment": "2023-05-05",
  "date_of_joining": "2023-05-10",
  "date_of_confirmation": "2023-11-10",
  "payable_from_date": "2023-05-10",
  "performance_appraisal": "Good",
  "warning_notes": "",
  "remarks": "Responsible for field visits",
  "educational_qualifications": "Graduate",
  "professional_qualifications": "BA",
  "members_in_family": 4,
  "emergency_contact_name": "Sanjay Chouhan",
  "emergency_contact_relation": "Brother",
  "emergency_contact_number": "9000010102"
}
```

Notes:

- `role` and `branch` are numeric IDs (not codes).
- Decimal values (`height_cm`, `weight_kg`) are sent as strings.
- `gender`: `MALE` | `FEMALE` | `OTHER`
- `marital_status`: `SINGLE` | `MARRIED` | `DIVORCED` | `WIDOWED`

Success response wraps the created user and nested `employee` profile with full `role` and `branch` objects.

### Customers

Base: `/customers/api/`

Operations:

- Customer CRUD
- Family Members
- Guarantors
- Maternal House
- Other Loans
- Documents

Statuses:

```text
SOURCED
APPLIED
UNNDER_REVIEW
APPROVED
REJECTED
ACTIVE
CLOSED
```

### Operations

Base: `/operations/api/`

Operations:

- Centers
- Center Members
- EMI Generation
- EMI Collection

EMI Statuses:

```text
PENDING
PARTIAL
PAID
OVERDUE
CANCELLED
```

---

## 7. Flutter Navigation

### Routes

| Route | Screen |
|---------|---------|
| /login | Login |
| / | Dashboard |
| /branches | Branches |
| /customers | Customer List |
| /customers/new | Customer Wizard |
| /customers/:id | Customer Detail |
| /centers | Centers |
| /emis | EMI Collection |
| /employees | Employees |
| /reports | Reports |

---

## 8. Screens

### Login

Fields:

- Email
- Password

### Dashboard

Quick Actions:

- Customers
- Centers
- EMI Collection

### Customers

Features:

- List
- Filters
- Create Wizard
- Detail View
- Status Updates

### Customer Wizard Steps

1. Customer
2. Family
3. Maternal House
4. Other Loans
5. Guarantor
6. Documents

### Centers

- List
- Create
- Members
- Generate EMI

### EMI Collection

- Filters
- Payment Sheet
- Status Tracking

### Employees

- Profile
- Documents
- Permissions
- Employment History

---

## 9. UI Guidelines

### Theme

Primary Highlight:

```css
#FFDB51
```

### Formatting

- Currency Locale: `en_IN`
- Decimal values sent as strings
- Permission-based navigation
- Error handling using API error messages

---

## 10. Flutter Project Structure

```text
lib/
├── main.dart
├── app.dart

├── core/
│   ├── api/
│   ├── auth/
│   ├── permissions/
│   ├── storage/
│   └── theme/

├── features/
│   ├── login/
│   ├── dashboard/
│   ├── branches/
│   ├── customers/
│   ├── centers/
│   ├── emi/
│   └── employees/

├── shared/
│   ├── widgets/
│   └── models/
```

Recommended Packages:

- dio
- flutter_secure_storage
- go_router
- riverpod
- image_picker
- file_picker
- cached_network_image

---

## 11. Implementation Roadmap

| Phase | Scope |
|---------|---------|
| M1 | Login + Customer Wizard |
| M2 | Customer Detail + CGT |
| M3 | Centers |
| M4 | EMI Collection |
| M5 | Employees + Branches |
| M6 | Dashboard + Offline + Push |

---

## 12. Known Backend Notes

- Refresh token currently cookie-only.
- Reports APIs not available.
- Dashboard placeholder.
- Status typo `UNNDER_REVIEW` must remain unchanged.
- Branch list restricted to admin.
- EMI generation logic handled by backend.

---

## 13. Reference Repositories

### ShriSawaliyaMultitrade

Source of truth for:

- Models
- APIs
- Business Logic

### ShriSawaliyaMultitrade-application

Reference for:

- React UI
- Payload structures
- Service layer implementations
