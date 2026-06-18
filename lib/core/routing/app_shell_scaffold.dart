import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';
import 'package:sawaliyatrader/core/routing/bottom_nav_config.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginResponse?>(
      future: AuthService().getSession(),
      builder: (context, snapshot) {
        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(child: AppLoader(size: kAppPageLoaderSize)),
          );
        }

        debugPrint('Access token: ${session.access}');

        final checker = PermissionChecker(session);
        final visibleItems = BottomNavItem.visibleFor(checker);
        final currentBranch = navigationShell.currentIndex;

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: navigationShell,
          bottomNavigationBar: _IconBottomBar(
            items: visibleItems,
            currentBranchIndex: currentBranch,
            onTap: (branchIndex) {
              navigationShell.goBranch(
                branchIndex,
                initialLocation: branchIndex == navigationShell.currentIndex,
              );
            },
          ),
        );
      },
    );
  }
}

class _IconBottomBar extends StatelessWidget {
  const _IconBottomBar({
    required this.items,
    required this.currentBranchIndex,
    required this.onTap,
  });

  final List<BottomNavItem> items;
  final int currentBranchIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.brown.withValues(alpha: 0.12)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in items)
                _NavIconButton(
                  item: item,
                  isSelected: item.branchIndex == currentBranchIndex,
                  onTap: () => onTap(item.branchIndex),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 52,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.gold.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isSelected ? item.selectedIcon : item.icon,
            size: 26,
            color: isSelected
                ? AppColors.shinyGold
                : AppColors.shinyGold.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
