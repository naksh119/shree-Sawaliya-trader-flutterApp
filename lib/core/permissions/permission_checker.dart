import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/app_permissions.dart';
import 'package:sawaliyatrader/core/permissions/employee_roles.dart';

class PermissionChecker {
  const PermissionChecker(this._session);

  final LoginResponse _session;

  bool get isSuperuser => _session.isSuperuser;

  bool get hasFullAccess =>
      isSuperuser || _session.permissions.contains(AppPermissions.all);

  bool hasPermission(String permission) {
    if (hasFullAccess) return true;
    return _session.permissions.contains(permission);
  }

  bool hasAnyPermission(Iterable<String> permissions) {
    if (hasFullAccess) return true;
    return permissions.any(_session.permissions.contains);
  }

  bool hasAllPermissions(Iterable<String> permissions) {
    if (hasFullAccess) return true;
    return permissions.every(_session.permissions.contains);
  }

  bool hasRole(String roleCode) => _session.employee?.role == roleCode;

  /// Branch management is restricted to admin users on the backend.
  bool get canManageBranches =>
      isSuperuser || hasRole(EmployeeRoles.admin) || hasFullAccess;

  bool get canViewNotifications =>
      hasFullAccess || hasPermission(AppPermissions.notificationView);
}
