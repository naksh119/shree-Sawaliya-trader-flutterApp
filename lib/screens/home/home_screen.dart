import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: Text('Home', style: AppTextStyles.heading),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.push(AppRoutes.profile),
            icon: Icon(Icons.person_outline, color: AppColors.shinyGold),
          ),
        ],
      ),
      body: Center(child: Text('hello', style: AppTextStyles.heading)),
    );
  }
}
