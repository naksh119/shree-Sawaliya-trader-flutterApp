import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: 'Home',
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.push(AppRoutes.profile),
            icon: Icon(Icons.person_outline, color: context.appColors.shinyGold),
          ),
        ],
      ),
      body: Center(child: Text('hello', style: AppTextStyles.heading(context))),
    );
  }
}
