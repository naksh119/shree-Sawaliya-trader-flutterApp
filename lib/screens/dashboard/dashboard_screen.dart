import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/permissions/employee_roles.dart';
import 'package:sawaliyatrader/core/permissions/permission_checker.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_charts.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_kpi_row.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _stats = DashboardStats.sample();

  String _employeeLine = 'Home';
  String _roleLine = '';

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = await _authService.getSession();
    if (!mounted || session == null) return;

    final employee = session.employee;
    setState(() {
      if (employee != null) {
        _employeeLine = '${employee.employeeCode} · ${employee.branch}';
        _roleLine = EmployeeRoles.displayName(employee.role);
      } else if (session.isSuperuser) {
        _employeeLine = 'Administrator';
        _roleLine = 'Superuser';
      }
    });

    appNotificationNotifier?.bindSession(session);
  }

  Future<void> _onLogout() async {
    await _authService.logout();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authService.getSession(),
      builder: (context, snapshot) {
        final session = snapshot.data;

        return Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            backgroundColor: AppColors.cream,
            elevation: 0,
            title: Text('Home', style: AppTextStyles.heading),
            actions: [
              if (session != null &&
                  appNotificationNotifier != null &&
                  PermissionChecker(session).canViewNotifications)
                ListenableBuilder(
                  listenable: appNotificationNotifier!,
                  builder: (context, _) {
                    final unread = appNotificationNotifier?.unreadCount ?? 0;
                    return IconButton(
                      tooltip: 'Notifications',
                      onPressed: () => context.push(AppRoutes.notifications),
                      icon: Badge(
                        isLabelVisible: unread > 0,
                        label: Text('$unread'),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.shinyGold,
                        ),
                      ),
                    );
                  },
                ),
              IconButton(
                tooltip: 'Logout',
                onPressed: _onLogout,
                icon: Icon(Icons.logout, color: AppColors.shinyGold),
              ),
            ],
          ),
          body: session == null
              ? const Center(child: AppLoader(size: kAppPageLoaderSize))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Signed in as', style: AppTextStyles.subtitle),
                      const SizedBox(height: 8),
                      Text(_employeeLine, style: AppTextStyles.body),
                      if (_roleLine.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Role: $_roleLine', style: AppTextStyles.subtitle),
                      ],
                      const SizedBox(height: 28),
                      Text('Overview', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      DashboardKpiRow(stats: _stats),
                      const SizedBox(height: 28),
                      Text('Analytics', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _AnalyticsSection(stats: _stats),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModuleOverviewChart(
          stats: stats,
          showCustomers: true,
          showCenters: true,
          showEmployees: true,
          showBranches: true,
        ),
        const SizedBox(height: 16),
        CustomerStatusPieChart(segments: stats.customerByStatus),
        const SizedBox(height: 16),
        EmiStatusBarChart(segments: stats.emiByStatus),
        const SizedBox(height: 16),
        CollectionTrendChart(points: stats.collectionTrend),
      ],
    );
  }
}
