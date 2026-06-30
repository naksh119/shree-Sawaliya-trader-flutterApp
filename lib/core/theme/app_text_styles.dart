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

  /// Fixed light-theme styles for chart labels and static assets.
  static TextStyle get headingLight => headingFor(AppThemeColors.light);

  static TextStyle get bodyLight => bodyFor(AppThemeColors.light);
}
