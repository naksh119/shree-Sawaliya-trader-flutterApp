import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Full-screen background matching the splash screen aesthetic.
class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.showOverlay = true,
    super.key,
  });

  final Widget child;
  final bool showOverlay;

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
        if (showOverlay) ColoredBox(color: context.appColors.overlay),
        child,
      ],
    );
  }
}
