import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';

/// Route-level access rules evaluated by [GoRouter] redirect.
class RouteAccess {
  const RouteAccess._();

  static bool canAccess(LoginResponse session, String location) {
    final permissions = PermissionService(session);
    final path = _normalize(location);

    if (_isPublic(path)) return true;
    if (path == AppRoutes.dashboard) return true;
    if (path == AppRoutes.accessDenied) return true;
    if (path == AppRoutes.more) return true;
    if (path == AppRoutes.profile) return true;

    if (path == AppRoutes.branches) return permissions.canManageBranches;
    if (path == AppRoutes.branchNew) return permissions.canManageBranches;
    if (_isBranchDetail(path)) return permissions.canManageBranches;
    if (path == AppRoutes.customers) return permissions.canViewCustomers;
    if (path == AppRoutes.customerNew) return permissions.canCreateCustomer;
    if (_isCustomerDetail(path)) return permissions.canViewCustomers;
    if (path == AppRoutes.centers) return permissions.canViewCenters;
    if (path == AppRoutes.centerNew) return permissions.canCreateCenter;
    if (_isCenterDetail(path)) return permissions.canViewCenters;
    if (path == AppRoutes.emis) return permissions.canCollectEmi;
    if (path == AppRoutes.employees) return permissions.canViewEmployees;
    if (path == AppRoutes.employeeNew) return permissions.canCreateEmployee;
    if (_isEmployeeDetail(path)) return permissions.canViewEmployees;
    if (path == AppRoutes.reports) return permissions.canViewReports;
    if (path == AppRoutes.notifications) {
      return permissions.canViewNotifications;
    }

    return true;
  }

  static String _normalize(String location) {
    final uri = Uri.parse(location);
    return uri.path.endsWith('/') && uri.path.length > 1
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
  }

  static bool _isPublic(String path) =>
      path == AppRoutes.splash || path == AppRoutes.login;

  static bool _isCustomerDetail(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.length == 2 &&
        segments[0] == 'customers' &&
        segments[1] != 'new';
  }

  static bool _isEmployeeDetail(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.length == 2 &&
        segments[0] == 'employees' &&
        segments[1] != 'new';
  }

  static bool _isBranchDetail(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.length == 2 &&
        segments[0] == 'branches' &&
        segments[1] != 'new';
  }

  static bool _isCenterDetail(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.length == 2 &&
        segments[0] == 'centers' &&
        segments[1] != 'new';
  }
}
