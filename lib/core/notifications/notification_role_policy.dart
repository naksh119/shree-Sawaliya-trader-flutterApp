import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_type.dart';
import 'package:sawaliyatrader/core/permissions/app_permissions.dart';
import 'package:sawaliyatrader/core/permissions/employee_roles.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';

/// Client-side rules for which notifications a signed-in employee may see.
///
/// Backend should enforce the same rules; this layer filters cached/offline
/// items and guards UI before APIs are live.
abstract final class NotificationRolePolicy {
  static bool canAccessNotifications(LoginResponse session) {
    final checker = PermissionChecker(session);
    return checker.hasPermission(AppPermissions.notificationView);
  }

  static bool canView(LoginResponse session, NotificationDto notification) {
    if (!canAccessNotifications(session)) return false;

    final checker = PermissionChecker(session);
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
    PermissionChecker checker,
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
    PermissionChecker checker,
    String type,
  ) {
    switch (type) {
      case NotificationType.customerSourced:
        return checker.hasPermission(AppPermissions.customerView);
      case NotificationType.customerPendingApproval:
        return checker.hasPermission(AppPermissions.customerApprove) ||
            _hasAnyRole(session, [
              EmployeeRoles.bm,
              EmployeeRoles.abm,
              EmployeeRoles.am,
              EmployeeRoles.ao,
              EmployeeRoles.admin,
            ]);
      case NotificationType.customerApproved:
      case NotificationType.customerRejected:
        return checker.hasAnyPermission([
          AppPermissions.customerView,
          AppPermissions.customerCreate,
        ]);
      case NotificationType.centerCreated:
        return checker.hasPermission(AppPermissions.centerView);
      case NotificationType.emiDue:
      case NotificationType.emiOverdue:
      case NotificationType.emiCollected:
        return checker.hasPermission(AppPermissions.emiCollect);
      case NotificationType.employeeAssigned:
        return checker.hasPermission(AppPermissions.employeeView) ||
            _hasAnyRole(session, [EmployeeRoles.hrm, EmployeeRoles.admin]);
      case NotificationType.branchAnnouncement:
        return true;
      case NotificationType.system:
        return true;
      default:
        return true;
    }
  }

  static bool _hasAnyRole(LoginResponse session, List<String> roles) {
    final role = session.employee?.role;
    return role != null && roles.contains(role);
  }
}
