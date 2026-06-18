import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/permissions/app_permissions.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';

class BottomNavItem {
  const BottomNavItem({
    required this.branchIndex,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.tooltip,
    required this.isVisible,
  });

  final int branchIndex;
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String tooltip;
  final bool Function(PermissionChecker checker) isVisible;

  static final List<BottomNavItem> all = [
    BottomNavItem(
      branchIndex: 0,
      route: AppRoutes.dashboard,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      tooltip: 'Home',
      isVisible: _alwaysVisible,
    ),
    BottomNavItem(
      branchIndex: 1,
      route: AppRoutes.customers,
      icon: Icons.people_outline,
      selectedIcon: Icons.people_rounded,
      tooltip: 'Customers',
      isVisible: (c) => c.hasPermission(AppPermissions.customerView),
    ),
    BottomNavItem(
      branchIndex: 2,
      route: AppRoutes.centers,
      icon: Icons.hub_outlined,
      selectedIcon: Icons.hub_rounded,
      tooltip: 'Centers',
      isVisible: (c) => c.hasPermission(AppPermissions.centerView),
    ),
    BottomNavItem(
      branchIndex: 3,
      route: AppRoutes.reports,
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      tooltip: 'Reports',
      isVisible: (c) => c.hasFullAccess,
    ),
    BottomNavItem(
      branchIndex: 4,
      route: AppRoutes.more,
      icon: Icons.apps_rounded,
      selectedIcon: Icons.apps_rounded,
      tooltip: 'More',
      isVisible: _alwaysVisible,
    ),
  ];

  static bool _alwaysVisible(PermissionChecker checker) => true;

  static List<BottomNavItem> visibleFor(PermissionChecker checker) {
    return all.where((item) => item.isVisible(checker)).toList();
  }
}
