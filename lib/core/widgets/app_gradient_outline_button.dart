import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_border.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';

/// Outlined action button with the brand teal → navy gradient border.
class AppGradientOutlineButton extends StatelessWidget {
  const AppGradientOutlineButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.destructive = false,
    this.borderRadius = 8,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final innerRadius = (borderRadius - AppInputMetrics.borderWidth)
        .clamp(0, borderRadius)
        .toDouble();

    return AppGradientBorder(
      backgroundColor: colors.card,
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(innerRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: destructive
                  ? Text(
                      label,
                      style: AppTextStyles.label(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.errorText,
                      ),
                    )
                  : BrandGradientText(
                      text: label,
                      style: AppTextStyles.link(context),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
