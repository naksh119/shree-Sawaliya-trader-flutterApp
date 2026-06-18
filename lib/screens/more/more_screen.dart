import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/permissions/app_permissions.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getSession(),
      builder: (context, snapshot) {
        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final checker = PermissionChecker(session);
        final items = _MoreMenuItem.forSession(checker);

        return Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            backgroundColor: AppColors.cream,
            elevation: 0,
            title: Text('More', style: AppTextStyles.heading),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _MoreTile(
                icon: item.icon,
                label: item.label,
                onTap: () => context.push(item.route),
              );
            },
          ),
        );
      },
    );
  }
}

class _MoreMenuItem {
  const _MoreMenuItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.isVisible,
  });

  final String label;
  final String route;
  final IconData icon;
  final bool Function(PermissionChecker checker) isVisible;

  static List<_MoreMenuItem> forSession(PermissionChecker checker) {
    return [
      _MoreMenuItem(
        label: 'EMI Collection',
        route: AppRoutes.emis,
        icon: Icons.payments_outlined,
        isVisible: (c) => c.hasPermission(AppPermissions.emiCollect),
      ),
      _MoreMenuItem(
        label: 'Branches',
        route: AppRoutes.branches,
        icon: Icons.store_outlined,
        isVisible: (c) => c.canManageBranches,
      ),
      _MoreMenuItem(
        label: 'Employees',
        route: AppRoutes.employees,
        icon: Icons.badge_outlined,
        isVisible: (c) => c.hasPermission(AppPermissions.employeeView),
      ),
      _MoreMenuItem(
        label: 'Profile',
        route: AppRoutes.profile,
        icon: Icons.person_outline,
        isVisible: (_) => true,
      ),
    ].where((item) => item.isVisible(checker)).toList();
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.brown.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.shinyGold, size: 24),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppTextStyles.body)),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.shinyGold.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
