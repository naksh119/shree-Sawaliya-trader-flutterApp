import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_font.dart';
import 'package:sawaliyatrader/core/theme/app_theme_colors.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

abstract final class AppTextStyles {
  static TextStyle heading(BuildContext context) =>
      headingFor(context.appColors);

  static TextStyle subtitle(BuildContext context) =>
      subtitleFor(context.appColors);

  static TextStyle label(BuildContext context) => labelFor(context.appColors);

  static TextStyle body(BuildContext context) => bodyFor(context.appColors);

  static TextStyle link(BuildContext context) => linkFor(context.appColors);

  /// Style for brand-highlighted text rendered via [BrandGradientText].
  static TextStyle highlighted(
    BuildContext context, {
    double fontSize = 28,
    double letterSpacing = 0.5,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      highlightedRaw(
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      );

  /// Same as [highlighted] without requiring a [BuildContext].
  static TextStyle highlightedRaw({
    double fontSize = 28,
    double letterSpacing = 0.5,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      AppFont.style(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );

  static TextStyle headingFor(AppThemeColors colors) => AppFont.style(
        color: colors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle subtitleFor(AppThemeColors colors) => AppFont.style(
        color: colors.textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle labelFor(AppThemeColors colors) => AppFont.style(
        color: colors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle bodyFor(AppThemeColors colors) => AppFont.style(
        color: colors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle linkFor(AppThemeColors colors) => AppFont.style(
        color: colors.gold,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
