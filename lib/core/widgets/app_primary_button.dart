import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/theme/app_font.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 52,
    this.fontSize = 18,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;

  static const _borderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;
    final effectiveGradient = isDisabled
        ? _fadeGradient(AppColors.brandGradient, 0.6)
        : AppColors.brandGradient;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          gradient: effectiveGradient,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: _borderRadius,
            child: Center(
              child: isLoading
                  ? const AppLoader(size: AppLoaderSize.small)
                  : Text(
                      label,
                      style: AppFont.style(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: textColor,
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
