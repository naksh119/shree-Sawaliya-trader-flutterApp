import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/permissions/route_access.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/routing/lazy_shell_tab.dart';
import 'package:sawaliyatrader/core/routing/route_session.dart';
import 'package:sawaliyatrader/core/routing/app_shell_scaffold.dart';
import 'package:sawaliyatrader/screens/access_denied/access_denied_screen.dart';
import 'package:sawaliyatrader/screens/auth/login_screen.dart';
import 'package:sawaliyatrader/screens/dashboard/dashboard_screen.dart';
import 'package:sawaliyatrader/screens/more/more_screen.dart';
import 'package:sawaliyatrader/screens/notifications/notifications_screen.dart';
import 'package:sawaliyatrader/screens/branches/branch_create_screen.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/screens/branches/branch_detail_screen.dart';
import 'package:sawaliyatrader/screens/branches/branch_patch_screen.dart';
import 'package:sawaliyatrader/screens/branches/branches_list_screen.dart';
import 'package:sawaliyatrader/screens/centers/center_create_screen.dart';
import 'package:sawaliyatrader/screens/centers/center_detail_screen.dart';
import 'package:sawaliyatrader/screens/centers/centers_list_screen.dart';
import 'package:sawaliyatrader/screens/customers/customer_detail_screen.dart';
import 'package:sawaliyatrader/screens/customers/customer_wizard_screen.dart';
import 'package:sawaliyatrader/screens/customers/customers_list_screen.dart';
import 'package:sawaliyatrader/screens/employees/employee_create_screen.dart';
import 'package:sawaliyatrader/screens/employees/employee_detail_screen.dart';
import 'package:sawaliyatrader/screens/employees/employee_patch_screen.dart';
import 'package:sawaliyatrader/screens/employees/employees_list_screen.dart';
import 'package:sawaliyatrader/screens/placeholder/module_placeholder_screen.dart';
import 'package:sawaliyatrader/screens/profile/profile_screen.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';
import 'package:sawaliyatrader/screens/splash/splash_screen.dart';

GoRouter createAppRouter(SessionNotifier sessionNotifier) {
  final authService = AuthService();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionNotifier,
    redirect: (context, state) async {
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      final loggedIn = await authService.isLoggedIn();
      final isLogin = location == AppRoutes.login;

      if (!loggedIn) {
        return isLogin ? null : AppRoutes.login;
      }

      if (isLogin) return AppRoutes.dashboard;

      final session = await authService.getSession();
      if (session == null) return AppRoutes.login;

      if (!RouteAccess.canAccess(session, location)) {
        return '${AppRoutes.accessDenied}?from=${Uri.encodeComponent(location)}';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.accessDenied,
        builder: (context, state) => AccessDeniedScreen(
          attemptedRoute: state.uri.queryParameters['from'],
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const LazyShellTab(
                  branchIndex: 0,
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customers,
                builder: (context, state) => const LazyShellTab(
                  branchIndex: 1,
                  child: CustomersListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.centers,
                builder: (context, state) => const LazyShellTab(
                  branchIndex: 2,
                  child: CentersListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.employees,
                builder: (context, state) => const LazyShellTab(
                  branchIndex: 3,
                  child: EmployeesListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reports,
                builder: (context, state) {
                  final l10n = AppLocalizations.of(context)!;
                  return LazyShellTab(
                    branchIndex: 4,
                    child: ModulePlaceholderScreen(
                      title: l10n.reports,
                      description: l10n.reportsDescription,
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const LazyShellTab(
                  branchIndex: 5,
                  child: MoreScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.branches,
        builder: (context, state) => const BranchesListScreen(),
      ),
      GoRoute(
        path: AppRoutes.branchNew,
        builder: (context, state) => BranchCreateScreen(
          initialSession: loginResponseFromRouteExtra(state),
        ),
      ),
      GoRoute(
        path: '/branches/:id/patch',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.editBranch,
              description: l10n.invalidBranchId,
            );
          }
          final initialBranch =
              state.extra is BranchDto ? state.extra! as BranchDto : null;
          return BranchPatchScreen(
            branchId: id,
            initialBranch: initialBranch,
          );
        },
      ),
      GoRoute(
        path: '/branches/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.branch,
              description: l10n.invalidBranchId,
            );
          }
          final initialBranch =
              state.extra is BranchDto ? state.extra! as BranchDto : null;
          return BranchDetailScreen(
            branchId: id,
            initialBranch: initialBranch,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerNew,
        builder: (context, state) => CustomerWizardScreen(
          initialSession: loginResponseFromRouteExtra(state),
        ),
      ),
      GoRoute(
        path: AppRoutes.employeeNew,
        builder: (context, state) => EmployeeCreateScreen(
          initialSession: loginResponseFromRouteExtra(state),
        ),
      ),
      GoRoute(
        path: '/employees/:id/patch',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.editEmployeePatch,
              description: l10n.invalidEmployeeId,
            );
          }
          final initialEmployee = state.extra is EmployeeDetail
              ? state.extra! as EmployeeDetail
              : null;
          return EmployeePatchScreen(
            employeeId: id,
            initialEmployee: initialEmployee,
          );
        },
      ),
      GoRoute(
        path: '/employees/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.employee,
              description: l10n.invalidEmployeeId,
            );
          }
          return EmployeeDetailScreen(employeeId: id);
        },
      ),
      GoRoute(
        path: '/customers/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.customer,
              description: l10n.invalidCustomerId,
            );
          }
          return CustomerDetailScreen(customerId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.centerNew,
        builder: (context, state) => CenterCreateScreen(
          initialSession: loginResponseFromRouteExtra(state),
        ),
      ),
      GoRoute(
        path: '/centers/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            final l10n = AppLocalizations.of(context)!;
            return ModulePlaceholderScreen(
              title: l10n.center,
              description: l10n.invalidCenterId,
            );
          }
          return CenterDetailScreen(centerId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.emis,
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          return ModulePlaceholderScreen(
            title: l10n.emiCollection,
            description: l10n.emiCollectionDescription,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
