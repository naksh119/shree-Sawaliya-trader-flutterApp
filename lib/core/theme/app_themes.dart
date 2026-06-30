import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_font.dart';
import 'package:sawaliyatrader/core/theme/app_theme_colors.dart';

abstract final class AppThemes {
  static ThemeData light() => _build(AppThemeColors.light, Brightness.light);

  static ThemeData dark() => _build(AppThemeColors.dark, Brightness.dark);

  static ThemeData _build(AppThemeColors colors, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.gold,
      brightness: brightness,
      surface: colors.surface,
    ).copyWith(
      surfaceContainerHighest: colors.inputFill,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
    );

    final base = ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      fontFamily: AppFont.family,
      canvasColor: colors.card,
      scaffoldBackgroundColor: colors.surface,
      useMaterial3: true,
      extensions: [colors],
    );

    return base.copyWith(
      textTheme: AppFont.textTheme(base.textTheme),
      primaryTextTheme: AppFont.textTheme(base.primaryTextTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppFont.style(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerColor: colors.border,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.gold,
        circularTrackColor: colors.progressTrack,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle: AppFont.style(
          color: colors.textPrimary.withValues(alpha: 0.4),
          fontSize: 16,
        ),
        errorStyle: AppFont.style(
          color: Colors.red.shade700,
          fontSize: 12,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.card,
        headerBackgroundColor: colors.card,
        headerForegroundColor: colors.textPrimary,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.card,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: AppFont.style(
          color: colors.surface,
          fontSize: 16,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.gold,
        foregroundColor: AppColors.navy,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.textSecondary.withValues(alpha: 0.5);
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.navy;
          }
          return colors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.progressTrack.withValues(alpha: 0.5);
          }
          if (states.contains(WidgetState.selected)) {
            return colors.gold;
          }
          return colors.progressTrack;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colors.border;
        }),
      ),
    );
  }
}
