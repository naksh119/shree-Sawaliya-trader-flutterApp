import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get heading => GoogleFonts.cormorantGaramond(
        color: AppColors.brown,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get subtitle => GoogleFonts.cormorantGaramond(
        color: AppColors.brown.withValues(alpha: 0.75),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get label => GoogleFonts.cormorantGaramond(
        color: AppColors.brown,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get body => GoogleFonts.cormorantGaramond(
        color: AppColors.brown,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get link => GoogleFonts.cormorantGaramond(
        color: AppColors.gold,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
