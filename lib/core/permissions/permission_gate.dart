import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    required this.session,
    required this.permission,
    required this.child,
    super.key,
    this.fallback,
    this.requireAll = false,
    this.permissions,
  });

  final LoginResponse session;
  final String permission;
  final List<String>? permissions;
  final bool requireAll;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final checker = PermissionChecker(session);
    final allowed = permissions == null
        ? checker.hasPermission(permission)
        : requireAll
            ? checker.hasAllPermissions(permissions!)
            : checker.hasAnyPermission(permissions!);

    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
