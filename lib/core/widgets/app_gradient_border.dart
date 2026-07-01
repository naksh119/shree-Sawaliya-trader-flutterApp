import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Shared metrics for branded input fields (text, date, dropdown, search).
abstract final class AppInputMetrics {
  static const double borderRadius = 26;
  static const double borderWidth = 1.5;
}

/// Teal → blue gradient outline used by all form inputs.
class AppGradientBorder extends StatelessWidget {
  const AppGradientBorder({
    required this.child,
    required this.backgroundColor,
    super.key,
    this.hasError = false,
    this.isFocused = false,
    this.borderRadius = AppInputMetrics.borderRadius,
  });

  final Widget child;
  final Color backgroundColor;
  final bool hasError;
  final bool isFocused;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final borderWidth = AppInputMetrics.borderWidth;
    final outerRadius = BorderRadius.circular(borderRadius);
    final innerRadius = BorderRadius.circular(
      (borderRadius - borderWidth).clamp(0, borderRadius),
    );

    if (hasError) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: outerRadius,
          border: Border.all(
            color: isFocused ? colors.errorText : colors.errorBorder,
            width: borderWidth,
          ),
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: innerRadius,
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: outerRadius,
        gradient: colors.brandGradient,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: ClipRRect(
        borderRadius: innerRadius,
        clipBehavior: Clip.antiAlias,
        child: ColoredBox(
          color: backgroundColor,
          child: child,
        ),
      ),
    );
  }
}
