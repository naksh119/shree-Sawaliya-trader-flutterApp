import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: ThemedAppBar(title: l10n.accessDenied),
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
              l10n.accessDeniedMessage,
              style: AppTextStyles.body(context).copyWith(fontSize: 18),
            ),
            if (attemptedRoute != null && attemptedRoute!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.accessDeniedRequested(attemptedRoute!),
                style: AppTextStyles.subtitle(context),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.accessDeniedHint,
              style: AppTextStyles.subtitle(context),
            ),
            const Spacer(),
            AppPrimaryButton(
              label: l10n.backToDashboard,
              textColor: AppColors.navy,
              onPressed: () => context.go(AppRoutes.dashboard),
            ),
          ],
        ),
      ),
    );
  }
}
