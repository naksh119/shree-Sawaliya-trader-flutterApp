import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key, this.attemptedRoute});

  final String? attemptedRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: 'Access Denied',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline,
              size: 48,
              color: context.appColors.shinyGold.withValues(alpha: 0.75),
            ),
            const SizedBox(height: 16),
            Text(
              'You do not have permission to open this screen.',
              style: AppTextStyles.body(context).copyWith(fontSize: 18),
            ),
            if (attemptedRoute != null && attemptedRoute!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Requested: $attemptedRoute', style: AppTextStyles.subtitle(context)),
            ],
            const SizedBox(height: 8),
            Text(
              'Your role only includes access to assigned modules. Contact an administrator if you believe this is a mistake.',
              style: AppTextStyles.subtitle(context),
            ),
            const Spacer(),
            AppPrimaryButton(
              label: 'Back to Dashboard',
              textColor: AppColors.navy,
              onPressed: () => context.go(AppRoutes.dashboard),
            ),
          ],
        ),
      ),
    );
  }
}
