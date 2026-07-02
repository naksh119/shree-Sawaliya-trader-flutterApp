import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_font.dart';

/// Filled action button with the brand teal → navy gradient background.
class AppGradientFilledButton extends StatelessWidget {
  const AppGradientFilledButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48,
    this.fontSize = 16,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w600,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final FontWeight fontWeight;

  BorderRadius get _shape => BorderRadius.all(Radius.circular(borderRadius));

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;
    final effectiveGradient = isDisabled
        ? _fadeGradient(AppColors.brandGradient, 0.6)
        : AppColors.brandGradient;

    final labelStyle = AppFont.style(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.3,
      color: textColor,
    );

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: _shape,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: _shape,
            gradient: effectiveGradient,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onPressed,
              borderRadius: _shape,
              child: Center(
                child: isLoading
                    ? const AppLoader(size: AppLoaderSize.small)
                    : icon == null
                        ? Text(label, style: labelStyle)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 18, color: textColor),
                              const SizedBox(width: 8),
                              Text(label, style: labelStyle),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Gradient _fadeGradient(Gradient gradient, double opacity) {
    if (gradient is LinearGradient) {
      return LinearGradient(
        begin: gradient.begin,
        end: gradient.end,
        colors: gradient.colors
            .map((color) => color.withValues(alpha: opacity))
            .toList(),
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
      );
    }

    return gradient;
  }
}
