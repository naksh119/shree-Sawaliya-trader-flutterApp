import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

/// Full-screen background matching the splash screen aesthetic.
class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.splashBackground,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          filterQuality: FilterQuality.high,
        ),
        ColoredBox(color: AppColors.cream.withValues(alpha: 0.2)),
        child,
      ],
    );
  }
}
