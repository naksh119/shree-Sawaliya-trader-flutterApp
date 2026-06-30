import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/dashboard/dashboard_service.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/permission_widgets.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_charts.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_kpi_row.dart';
import 'package:sawaliyatrader/core/widgets/language_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardService = DashboardService();

  DashboardStats? _stats;
  bool _statsLoading = false;
  bool _statsStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_statsStarted) return;

    final session = SessionScope.maybeOf(context)?.session;
    if (session == null) return;

    _statsStarted = true;
    appNotificationNotifier?.bindSession(session);
    unawaited(_loadStats(session));
  }

  Future<void> _loadStats(LoginResponse session) async {
    if (!mounted) return;
    setState(() => _statsLoading = true);

    try {
      final stats = await _dashboardService.fetchStats(session: session);
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _statsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _statsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.maybeOf(context)?.session;
    if (session == null) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    final userDisplay = UserDisplay.fromSession(session);
    final stats = _stats;

    return Scaffold(
      appBar: ThemedAppBar(
        title: context.l10n.home,
        showThemeToggle: true,
        actions: [
          if (appNotificationNotifier != null)
            PermissionWidget(
              permission: AppPermission.notificationView,
              service: permissions,
              child: ListenableBuilder(
                listenable: appNotificationNotifier!,
                builder: (context, _) {
                  final unread = appNotificationNotifier?.unreadCount ?? 0;
                  return IconButton(
                    tooltip: context.l10n.notifications,
                    onPressed: () => context.push(AppRoutes.notifications),
                    icon: Badge(
                      isLabelVisible: unread > 0,
                      label: Text('$unread'),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: context.appColors.shinyGold,
                      ),
                    ),
                  );
                },
              ),
            ),
          UserHeaderBadge(
            initials: userDisplay.initials,
            onTap: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: _statsLoading || stats == null
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 72),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.overview,
                        style: AppTextStyles.label(context),
                      ),
                      const SizedBox(height: 12),
                      DashboardKpiRow(
                        stats: stats,
                        permissions: permissions,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        context.l10n.analytics,
                        style: AppTextStyles.label(context),
                      ),
                      const SizedBox(height: 12),
                      _AnalyticsSection(
                        stats: stats,
                        permissions: permissions,
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  right: 16,
                  bottom: 16,
                  child: LanguageGlobeButton(),
                ),
              ],
            ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection({
    required this.stats,
    required this.permissions,
  });

  final DashboardStats stats;
  final PermissionService permissions;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (_showModuleOverview(permissions)) {
      children.add(
        ModuleOverviewChart(
          stats: stats,
          showCustomers: permissions.canViewCustomers,
          showCenters: permissions.canViewCenters,
          showEmployees: permissions.canViewEmployees,
          showBranches: permissions.canManageBranches,
        ),
      );
      children.add(const SizedBox(height: 16));
    }

    if (permissions.canViewCustomers) {
      children.add(CustomerStatusPieChart(segments: stats.customerByStatus));
      children.add(const SizedBox(height: 16));
    }

    if (permissions.canCollectEmi) {
      children.add(EmiStatusBarChart(segments: stats.emiByStatus));
      children.add(const SizedBox(height: 16));
      children.add(CollectionTrendChart(points: stats.collectionTrend));
    }

    if (children.isEmpty) {
      return Text(
        context.l10n.analyticsUnavailable,
        style: AppTextStyles.subtitle(context),
      );
    }

    if (children.last is SizedBox) {
      children.removeLast();
    }

    return Column(children: children);
  }

  bool _showModuleOverview(PermissionService permissions) =>
      permissions.canViewCustomers ||
      permissions.canViewCenters ||
      permissions.canViewEmployees ||
      permissions.canManageBranches;
}
