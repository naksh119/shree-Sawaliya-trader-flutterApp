import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_border.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';

/// Compact icon button with the brand teal → navy gradient border.
class AppGradientIconButton extends StatelessWidget {
  const AppGradientIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 34,
    this.iconSize,
    this.borderRadius = 10,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double size;
  final double? iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final innerRadius = (borderRadius - AppInputMetrics.borderWidth)
        .clamp(0, borderRadius)
        .toDouble();

    return Tooltip(
      message: tooltip,
      child: AppGradientBorder(
        backgroundColor: context.appColors.card,
        borderRadius: borderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(innerRadius),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: BrandGradientIcon(
                  icon,
                  size: iconSize ?? size * 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
