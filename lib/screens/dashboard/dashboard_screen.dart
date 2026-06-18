import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/dashboard/dashboard_service.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/permission_widgets.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_charts.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_kpi_row.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardViewModel {
  const _DashboardViewModel({
    required this.session,
    required this.stats,
    required this.employeeLine,
    required this.roleLine,
  });

  final LoginResponse session;
  final DashboardStats stats;
  final String employeeLine;
  final String roleLine;
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _dashboardService = DashboardService();

  late final Future<_DashboardViewModel?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = awaitWithMinPageLoaderDuration(_loadDashboard());
  }

  Future<_DashboardViewModel?> _loadDashboard() async {
    final session = await _authService.getSession();
    if (session == null) return null;

    final stats = await _dashboardService.fetchStats(session: session);
    appNotificationNotifier?.bindSession(session);

    final employee = session.employee;
    final role = EmployeeRole.fromCode(employee?.role);

    var employeeLine = 'Home';
    var roleLine = '';
    if (employee != null) {
      employeeLine = '${employee.employeeCode} · ${employee.branch}';
      roleLine = role?.displayName ?? employee.role;
    } else if (session.isSuperuser) {
      employeeLine = 'Administrator';
      roleLine = 'Superuser';
    }

    return _DashboardViewModel(
      session: session,
      stats: stats,
      employeeLine: employeeLine,
      roleLine: roleLine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardViewModel?>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        final viewModel = snapshot.data;

        if (viewModel == null) {
          return const Scaffold(
            body: Center(child: AppLoader(size: kAppPageLoaderSize)),
          );
        }

        final session = viewModel.session;
        final permissions = PermissionService(session);
        final userDisplay = UserDisplay.fromSession(session);

        return SessionScope(
          session: session,
          child: Scaffold(
            appBar: ThemedAppBar(
              title: context.l10n.home,
              showLanguageDropdown: true,
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
                          onPressed: () =>
                              context.push(AppRoutes.notifications),
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.signedInAs, style: AppTextStyles.subtitle(context)),
                  const SizedBox(height: 8),
                  Text(viewModel.employeeLine, style: AppTextStyles.body(context)),
                  if (viewModel.roleLine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${context.l10n.role}: ${viewModel.roleLine}',
                      style: AppTextStyles.subtitle(context),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(context.l10n.overview, style: AppTextStyles.label(context)),
                  const SizedBox(height: 12),
                  DashboardKpiRow(
                    stats: viewModel.stats,
                    permissions: permissions,
                  ),
                  const SizedBox(height: 28),
                  Text(context.l10n.analytics, style: AppTextStyles.label(context)),
                  const SizedBox(height: 12),
                  _AnalyticsSection(
                    stats: viewModel.stats,
                    permissions: permissions,
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
