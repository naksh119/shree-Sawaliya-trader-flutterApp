import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.textColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final labelColor = textColor ?? AppColors.navy;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.gold,
          foregroundColor: labelColor,
          disabledBackgroundColor: colors.gold.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const AppLoader(size: AppLoaderSize.small)
            : Text(
                label,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: labelColor,
                ),
              ),
      ),
    );
  }
}
