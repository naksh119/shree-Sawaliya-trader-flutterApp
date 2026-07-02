# Admin Rights — SSM Nexus

Simple guide to what an **Admin** can do in the app.

---

## Who is Admin?

A user is treated as Admin when **any** of these is true after login:

| Check | Meaning |
|-------|---------|
| Role = `ADMIN` | Employee role is Admin |
| Permission = `permission.all` | Full access to all modules |
| `is_superuser = true` | Django superuser account |

Admin is the **highest role**. They can access every screen and every action in the system.

---

## All Permissions Admin Has

Admin bypasses normal permission checks and gets **everything**:

| Permission | What it allows |
|------------|----------------|
| `permission.all` | Full access to all modules |
| `permission.manage` | Manage roles and permissions for other staff |
| `customer.view` | View customer list and details |
| `customer.create` | Add new customers (wizard) |
| `customer.edit` | Edit customer information |
| `customer.approve` | Approve or reject customers |
| `center.view` | View centers |
| `center.create` | Create centers and add members |
| `emi.collect` | Record EMI payments |
| `employee.view` | View and manage employees |
| `notification.view` | View notifications |

---

## What Admin Can Do (By Module)

### 1. Branches (Admin only)

> Only Admin can see and manage the full branch list.

| Action | Allowed |
|--------|---------|
| View all branches | Yes |
| Create branch | Yes |
| Edit branch | Yes |
| Delete branch | Yes |
| Upload payment QR code | Yes |

**API base:** `/branches/api/`

---

### 2. Employees

| Action | Allowed |
|--------|---------|
| View employee list | Yes |
| Add new employee | Yes |
| Edit employee | Yes |
| Delete employee | Yes |
| Assign roles (FO, BM, HRM, etc.) | Yes |
| Set permissions | Yes |
| Upload documents | Yes |
| View employment history | Yes |
| Change email / password | Yes |

**API base:** `/employees/api/`

---

### 3. Customers

| Action | Allowed |
|--------|---------|
| View customer list | Yes |
| Search and filter customers | Yes |
| Create customer (6-step wizard) | Yes |
| Edit customer details | Yes |
| Approve / reject customers | Yes |
| Add family members | Yes |
| Add guarantors | Yes |
| Add maternal house info | Yes |
| Add other loans | Yes |
| Upload KYC documents | Yes |

**Customer statuses Admin can change:**

```text
SOURCED → APPLIED → UNNDER_REVIEW → APPROVED / REJECTED → ACTIVE → CLOSED
```

**API base:** `/customers/api/`

---

### 4. Centers

| Action | Allowed |
|--------|---------|
| View center list | Yes |
| Create center | Yes |
| Add / remove center members | Yes |
| Generate EMI schedule | Yes |

**API base:** `/operations/api/`

---

### 5. EMI Collection

| Action | Allowed |
|--------|---------|
| View due EMIs | Yes |
| Record cash payment | Yes |
| Record online payment | Yes |
| Record partial payment | Yes |
| Track payment status | Yes |

**EMI statuses:**

```text
PENDING → PARTIAL → PAID / OVERDUE / CANCELLED
```

---

### 6. Reports

| Action | Allowed |
|--------|---------|
| View reports | Yes (Admin / full access only) |

> Note: Reports API is not fully ready on the backend yet.

---

### 7. Notifications

| Action | Allowed |
|--------|---------|
| View notifications | Yes |
| Mark as read | Yes |

---

## Screens Admin Sees in the App

### Bottom bar (icons)

| Icon | Screen | Admin access |
|------|--------|--------------|
| Home | Dashboard | Yes |
| People | Customers | Yes |
| Hub | Centers | Yes |
| Chart | Reports | Yes |
| Grid | More | Yes |

### More menu

| Item | Admin access |
|------|--------------|
| EMI Collection | Yes |
| Branches | Yes |
| Employees | Yes |
| Profile | Yes |

### Other screens (opened from dashboard or links)

| Screen | Admin access |
|--------|--------------|
| New Customer (wizard) | Yes |
| Customer Detail | Yes |
| Notifications | Yes |
| Logout | Yes |

---

## What Other Roles Cannot Do (Admin only)

| Feature | Admin | Other roles |
|---------|-------|-------------|
| Manage branches (full list) | Yes | No |
| `permission.manage` | Yes | Only if granted |
| Reports tab | Yes | Only with `permission.all` |
| Full access without individual permissions | Yes | No |

---

## Admin Daily Workflow (Simple)

```text
1. Login
2. Dashboard — see quick actions and notifications
3. Review customers → approve / reject
4. Create centers for approved customers
5. Generate EMI
6. Collect EMI payments (or assign to field staff)
7. Manage branches and employees when needed
8. Check reports
```

---

## Setup Workflow (One time)

```text
1. Create branches
2. Add employees
3. Assign roles and permissions to each employee
4. Upload branch QR codes for payments
```

---

## Quick Reference

| I want to… | Admin can? | Where in app |
|------------|------------|--------------|
| Add a branch | Yes | More → Branches |
| Add staff | Yes | More → Employees |
| Add customer | Yes | Customers → New |
| Approve customer | Yes | Customer Detail |
| Create center | Yes | Centers |
| Collect payment | Yes | More → EMI Collection |
| See reports | Yes | Reports tab |
| Change who can do what | Yes | Employees → Permissions |
| Logout | Yes | Profile |

---

## Source References

- Backend spec: `bakend-flow.md`
- Flutter permissions: `lib/core/permissions/`
- Route access rules: `lib/core/permissions/route_access.dart`
- Bottom bar config: `lib/core/routing/bottom_nav_config.dart`
