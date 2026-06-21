import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: ThemedAppBar(
        title: l10n.home,
        actions: [
          IconButton(
            tooltip: l10n.profile,
            onPressed: () => context.push(AppRoutes.profile),
            icon: Icon(Icons.person_outline, color: context.appColors.shinyGold),
          ),
        ],
      ),
      body: Center(child: Text(l10n.hello, style: AppTextStyles.heading(context))),
    );
  }
}
