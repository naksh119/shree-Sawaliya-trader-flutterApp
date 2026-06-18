import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_type.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';

/// Client-side rules for which notifications a signed-in employee may see.
///
/// Backend should enforce the same rules; this layer filters cached/offline
/// items and guards UI before APIs are live.
abstract final class NotificationRolePolicy {
  static bool canAccessNotifications(LoginResponse session) {
    return PermissionService(session).canViewNotifications;
  }

  static bool canView(LoginResponse session, NotificationDto notification) {
    if (!canAccessNotifications(session)) return false;

    final checker = PermissionService(session);
    if (checker.hasFullAccess) return true;

    if (!_matchesBranch(session, notification)) return false;
    if (!_matchesExplicitAudience(session, checker, notification)) {
      return false;
    }

    return _matchesTypePolicy(session, checker, notification.type);
  }

  static bool _matchesBranch(
    LoginResponse session,
    NotificationDto notification,
  ) {
    final branch = notification.branch;
    if (branch == null || branch.isEmpty) return true;
    final employee = session.employee;
    if (employee == null) return true;
    return branch == employee.branch;
  }

  static bool _matchesExplicitAudience(
    LoginResponse session,
    PermissionService checker,
    NotificationDto notification,
  ) {
    final hasRoleFilter = notification.targetRoles.isNotEmpty;
    final hasPermissionFilter = notification.targetPermissions.isNotEmpty;

    if (!hasRoleFilter && !hasPermissionFilter) return true;

    final role = session.employee?.role;
    final roleMatch =
        hasRoleFilter && role != null && notification.targetRoles.contains(role);
    final permissionMatch = hasPermissionFilter &&
        checker.hasAnyPermission(notification.targetPermissions);

    return roleMatch || permissionMatch;
  }

  /// Default visibility when the API omits explicit audience fields.
  static bool _matchesTypePolicy(
    LoginResponse session,
    PermissionService checker,
    String type,
  ) {
    switch (type) {
      case NotificationType.customerSourced:
        return checker.canViewCustomers;
      case NotificationType.customerPendingApproval:
        return checker.canApproveCustomer ||
            checker.hasAnyRole([
              EmployeeRole.bm,
              EmployeeRole.abm,
              EmployeeRole.am,
              EmployeeRole.ao,
              EmployeeRole.admin,
            ]);
      case NotificationType.customerApproved:
      case NotificationType.customerRejected:
        return checker.hasAny([
          AppPermission.customerView,
          AppPermission.customerCreate,
        ]);
      case NotificationType.centerCreated:
        return checker.canViewCenters;
      case NotificationType.emiDue:
      case NotificationType.emiOverdue:
      case NotificationType.emiCollected:
        return checker.canCollectEmi;
      case NotificationType.employeeAssigned:
        return checker.canViewEmployees ||
            checker.hasAnyRole([EmployeeRole.hrm, EmployeeRole.admin]);
      case NotificationType.branchAnnouncement:
        return true;
      case NotificationType.system:
        return true;
      default:
        return true;
    }
  }
}
