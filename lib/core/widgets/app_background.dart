import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Full-screen background matching the splash screen aesthetic.
class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.showOverlay = true,
    this.imageUrl,
    super.key,
  });

  final Widget child;
  final bool showOverlay;
  final String? imageUrl;

  Widget _assetBackground() {
    return Image.asset(
      AppAssets.splashBackground,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
    );
  }

  Widget _remotePlaceholder() {
    return const ColoredBox(color: AppColors.cream);
  }

  Widget _networkBackground() {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _remotePlaceholder();
      },
      errorBuilder: (_, __, ___) => _remotePlaceholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null)
          _networkBackground()
        else
          _assetBackground(),
        if (showOverlay) ColoredBox(color: context.appColors.overlay),
        child,
      ],
    );
  }
}
