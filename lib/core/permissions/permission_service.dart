import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';

/// Thrown when an API action is attempted without the required permission.
class PermissionDeniedException implements Exception {
  const PermissionDeniedException(this.permission);

  final AppPermission permission;

  @override
  String toString() =>
      'PermissionDeniedException: missing ${permission.value}';
}

/// Centralized RBAC — permission and role checks from the login session.
class PermissionService {
  PermissionService(this._session)
      : _permissions = AppPermission.fromValues(_session.permissions);

  final LoginResponse _session;
  final Set<AppPermission> _permissions;

  LoginResponse get session => _session;

  EmployeeRole? get role => EmployeeRole.fromCode(_session.employee?.role);

  bool get isSuperuser => _session.isSuperuser;

  bool get hasFullAccess =>
      isSuperuser || _permissions.contains(AppPermission.all);

  bool has(AppPermission permission) {
    if (hasFullAccess) return true;
    return _permissions.contains(permission);
  }

  bool hasAny(Iterable<AppPermission> permissions) {
    if (hasFullAccess) return true;
    return permissions.any(_permissions.contains);
  }

  bool hasAll(Iterable<AppPermission> permissions) {
    if (hasFullAccess) return true;
    return permissions.every(_permissions.contains);
  }

  bool hasRole(EmployeeRole role) => this.role == role;

  bool hasAnyRole(Iterable<EmployeeRole> roles) {
    final current = role;
    return current != null && roles.contains(current);
  }

  void require(AppPermission permission) {
    if (!has(permission)) throw PermissionDeniedException(permission);
  }

  bool get _hasAdminPrivileges =>
      isSuperuser || hasRole(EmployeeRole.admin) || hasFullAccess;

  bool get canManageBranches => _hasAdminPrivileges;

  bool get canEditBranch => canManageBranches;

  bool get canDeleteBranch => canManageBranches;

  bool get canViewCustomers => has(AppPermission.customerView);

  bool get canCreateCustomer => has(AppPermission.customerCreate);

  bool get canEditCustomer =>
      has(AppPermission.customerEdit) || _hasAdminPrivileges;

  bool get canDeleteCustomer => canEditCustomer;

  bool get canApproveCustomer => has(AppPermission.customerApprove);

  bool get canViewCenters => has(AppPermission.centerView);

  bool get canCreateCenter => has(AppPermission.centerCreate);

  bool get canEditCenter =>
      has(AppPermission.centerCreate) || _hasAdminPrivileges;

  bool get canDeleteCenter => canEditCenter;

  bool get canCollectEmi => has(AppPermission.emiCollect);

  bool get canViewEmployees =>
      has(AppPermission.employeeView) ||
      isSuperuser ||
      hasRole(EmployeeRole.admin) ||
      hasRole(EmployeeRole.hrm);

  bool get canCreateEmployee =>
      has(AppPermission.employeeCreate) ||
      isSuperuser ||
      hasRole(EmployeeRole.admin) ||
      hasRole(EmployeeRole.hrm);

  bool get canEditEmployee =>
      has(AppPermission.employeeEdit) ||
      _hasAdminPrivileges ||
      hasRole(EmployeeRole.hrm);

  bool get canDeleteEmployee => canEditEmployee;

  bool get canViewNotifications =>
      hasFullAccess || has(AppPermission.notificationView);

  bool get canViewReports =>
      hasFullAccess ||
      has(AppPermission.reportView) ||
      hasAnyRole(EmployeeRole.monitoringRoles);

  /// For notification audience filters that arrive as raw backend strings.
  bool hasAnyPermission(Iterable<String> permissions) {
    if (hasFullAccess) return true;
    return permissions.any((value) {
      final parsed = AppPermission.fromValue(value);
      return parsed != null && _permissions.contains(parsed);
    });
  }
}
