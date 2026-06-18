import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:sawaliyatrader/core/auth/auth_service.dart';

import 'package:sawaliyatrader/core/auth/models/login_response.dart';

import 'package:sawaliyatrader/core/loading/app_loading.dart';

import 'package:sawaliyatrader/core/permissions/permission_service.dart';

import 'package:sawaliyatrader/core/permissions/session_scope.dart';

import 'package:sawaliyatrader/core/routing/app_routes.dart';

import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';

import 'package:sawaliyatrader/core/theme/theme_context.dart';



class MoreScreen extends StatefulWidget {

  const MoreScreen({super.key});



  @override

  State<MoreScreen> createState() => _MoreScreenState();

}



class _MoreScreenState extends State<MoreScreen> {

  late final Future<LoginResponse?> _sessionFuture;



  @override

  void initState() {

    super.initState();

    _sessionFuture = awaitWithMinPageLoaderDuration(AuthService().getSession());

  }



  @override

  Widget build(BuildContext context) {

    return FutureBuilder<LoginResponse?>(

      future: _sessionFuture,

      builder: (context, snapshot) {

        final session = snapshot.data;

        if (session == null) {

          return const Scaffold(

            body: Center(child: AppLoader(size: kAppPageLoaderSize)),

          );

        }



        final permissions = PermissionService(session);

        final items =

            _moreMenuItems.where((item) => item.isVisible(permissions)).toList();



        return SessionScope(

          session: session,

          child: Scaffold(

            appBar: ThemedAppBar(title: 'More',

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

  final bool Function(PermissionService service) isVisible;

}



const _moreMenuItems = [

  _MoreMenuItem(

    label: 'EMI Collection',

    route: AppRoutes.emis,

    icon: Icons.payments_outlined,

    isVisible: _canCollectEmi,

  ),

  _MoreMenuItem(

    label: 'Branches',

    route: AppRoutes.branches,

    icon: Icons.store_outlined,

    isVisible: _canManageBranches,

  ),

  _MoreMenuItem(

    label: 'Reports',

    route: AppRoutes.reports,

    icon: Icons.bar_chart_outlined,

    isVisible: _canViewReports,

  ),

  _MoreMenuItem(

    label: 'Profile',

    route: AppRoutes.profile,

    icon: Icons.person_outline,

    isVisible: _always,

  ),

];



bool _canCollectEmi(PermissionService s) => s.canCollectEmi;

bool _canManageBranches(PermissionService s) => s.canManageBranches;

bool _canViewReports(PermissionService s) => s.canViewReports;

bool _always(PermissionService s) => true;



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

      color: context.appColors.card,

      borderRadius: BorderRadius.circular(12),

      child: InkWell(

        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),

            border: Border.all(color: context.appColors.border),

          ),

          child: Row(

            children: [

              Icon(icon, color: context.appColors.shinyGold, size: 24),

              const SizedBox(width: 14),

              Expanded(child: Text(label, style: AppTextStyles.body(context))),

              Icon(

                Icons.chevron_right_rounded,

                color: context.appColors.shinyGold.withValues(alpha: 0.45),

              ),

            ],

          ),

        ),

      ),

    );

  }

}


