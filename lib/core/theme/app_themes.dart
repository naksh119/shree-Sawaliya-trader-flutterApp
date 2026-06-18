import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
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

    return ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      canvasColor: colors.card,
      scaffoldBackgroundColor: colors.surface,
      useMaterial3: true,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
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
        filled: true,
        fillColor: colors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.progressTrack),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.progressTrack),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.gold, width: 1.5),
        ),
        hintStyle: GoogleFonts.cormorantGaramond(
          color: colors.textPrimary.withValues(alpha: 0.4),
          fontSize: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: GoogleFonts.cormorantGaramond(
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
    );
  }
}
