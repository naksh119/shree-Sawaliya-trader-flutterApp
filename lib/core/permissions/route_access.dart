import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/app_permissions.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';

class RouteAccess {
  const RouteAccess._();

  static bool canAccess(LoginResponse session, String location) {
    final checker = PermissionChecker(session);
    final path = _normalize(location);

    if (_isPublic(path)) return true;
    if (path == AppRoutes.dashboard) return true;
    if (path == AppRoutes.accessDenied) return true;

    if (path == AppRoutes.branches) return checker.canManageBranches;
    if (path == AppRoutes.customers) {
      return checker.hasPermission(AppPermissions.customerView);
    }
    if (path == AppRoutes.customerNew) {
      return checker.hasPermission(AppPermissions.customerCreate);
    }
    if (_isCustomerDetail(path)) {
      return checker.hasPermission(AppPermissions.customerView);
    }
    if (path == AppRoutes.centers) {
      return checker.hasPermission(AppPermissions.centerView);
    }
    if (path == AppRoutes.emis) {
      return checker.hasPermission(AppPermissions.emiCollect);
    }
    if (path == AppRoutes.employees) {
      return checker.hasPermission(AppPermissions.employeeView);
    }
    if (path == AppRoutes.reports) {
      return checker.hasFullAccess;
    }
    if (path == AppRoutes.more) return true;
    if (path == AppRoutes.notifications) {
      return checker.canViewNotifications;
    }
    if (path == AppRoutes.profile) return true;

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
}
