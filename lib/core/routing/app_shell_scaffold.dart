import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/routing/bottom_nav_config.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class AppShellScaffold extends StatefulWidget {
  const AppShellScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShellScaffold> createState() => _AppShellScaffoldState();
}

class _AppShellScaffoldState extends State<AppShellScaffold> {
  final _authService = AuthService();
  LoginResponse? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
    appSessionNotifier?.addListener(_loadSession);
  }

  @override
  void dispose() {
    appSessionNotifier?.removeListener(_loadSession);
    super.dispose();
  }

  Future<void> _loadSession() async {
    final session = await _authService.getSession();
    if (!mounted) return;
    setState(() {
      _session = session;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final session = _session;
    if (session == null) {
      return const Scaffold();
    }

    final permissions = PermissionService(session);
    final visibleItems = BottomNavItem.visibleFor(permissions);
    final currentBranch = widget.navigationShell.currentIndex;

    return SessionScope(
      session: session,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: _IconBottomBar(
          items: visibleItems,
          currentBranchIndex: currentBranch,
          onTap: (branchIndex) {
            widget.navigationShell.goBranch(
              branchIndex,
              initialLocation: branchIndex == widget.navigationShell.currentIndex,
            );
          },
        ),
      ),
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
        color: context.appColors.bottomBar,
        border: Border(
          top: BorderSide(color: context.appColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.textPrimary.withValues(alpha: 0.06),
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
            children: [
              for (final item in items)
                Expanded(
                  child: _NavIconButton(
                    item: item,
                    isSelected: item.branchIndex == currentBranchIndex,
                    iconSize: _iconSizeFor(items.length),
                    onTap: () => onTap(item.branchIndex),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static double _iconSizeFor(int itemCount) {
    if (itemCount >= 6) return 22;
    if (itemCount >= 5) return 24;
    return 26;
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.item,
    required this.isSelected,
    required this.iconSize,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool isSelected;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.localizedTooltip(context.l10n),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? context.appColors.gold.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            isSelected ? item.selectedIcon : item.icon,
            size: iconSize,
            color: isSelected
                ? context.appColors.shinyGold
                : context.appColors.shinyGold.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
