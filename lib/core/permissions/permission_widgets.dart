import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Shows [child] only when the signed-in user has the required permission(s).
class PermissionWidget extends StatelessWidget {
  const PermissionWidget({
    required this.permission,
    required this.child,
    super.key,
    this.fallback,
    this.requireAll = false,
    this.permissions,
    this.service,
  });

  final AppPermission permission;
  final List<AppPermission>? permissions;
  final bool requireAll;
  final Widget child;
  final Widget? fallback;
  final PermissionService? service;

  @override
  Widget build(BuildContext context) {
    final checker = service ?? SessionScope.permissionsOf(context);
    final allowed = permissions == null
        ? checker.has(permission)
        : requireAll
            ? checker.hasAll(permissions!)
            : checker.hasAny(permissions!);

    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

/// A button visible only when the user has the required permission.
class PermissionButton extends StatelessWidget {
  const PermissionButton({
    required this.label,
    required this.onPressed,
    super.key,
    required this.permission,
    this.icon,
    this.service,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppPermission permission;
  final IconData? icon;
  final PermissionService? service;

  @override
  Widget build(BuildContext context) {
    final checker = service ?? SessionScope.permissionsOf(context);
    if (!checker.has(permission)) return const SizedBox.shrink();

    final colors = context.appColors;
    final style = FilledButton.styleFrom(
      backgroundColor: colors.gold,
      foregroundColor: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: BrandGradientIcon(icon!, size: 20),
        label: Text(label),
        style: style,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}
