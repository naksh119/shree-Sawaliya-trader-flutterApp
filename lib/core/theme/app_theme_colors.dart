import 'package:flutter/material.dart';

import 'package:sawaliyatrader/core/theme/app_colors.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.surface,
    required this.card,
    required this.bottomBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.gold,
    required this.navy,
    required this.progressTrack,
    required this.border,
    required this.overlay,
    required this.inputFill,
    required this.error,
    required this.errorText,
    required this.errorBorder,
    required this.warningBackground,
    required this.warningBorder,
    required this.warningText,
  });

  final Color surface;
  final Color card;
  final Color bottomBar;
  final Color textPrimary;
  final Color textSecondary;
  final Color gold;
  final Color navy;
  final Color progressTrack;
  final Color border;
  final Color overlay;
  final Color inputFill;
  final Color error;
  final Color errorText;
  final Color errorBorder;
  final Color warningBackground;
  final Color warningBorder;
  final Color warningText;

  // Gold tints — derived from [gold] for consistent alpha steps.
  Color get goldSubtle => gold.withValues(alpha: 0.08);
  Color get goldHighlight => gold.withValues(alpha: 0.12);
  Color get goldSurface => gold.withValues(alpha: 0.16);
  Color get goldTint => gold.withValues(alpha: 0.18);
  Color get goldAvatar => gold.withValues(alpha: 0.22);
  Color get goldMuted => gold.withValues(alpha: 0.25);
  Color get goldBorder => gold.withValues(alpha: 0.35);
  Color get goldBorderStrong => gold.withValues(alpha: 0.42);
  Color get goldSelected => gold.withValues(alpha: 0.5);
  Color get goldDisabled => gold.withValues(alpha: 0.6);

  LinearGradient get brandGradient => AppColors.brandGradient;

  static const light = AppThemeColors(
    surface: AppColors.cream,
    card: Colors.white,
    bottomBar: Colors.white,
    textPrimary: AppColors.brown,
    textSecondary: Color(0xBF6D5732),
    gold: AppColors.gold,
    navy: AppColors.navy,
    progressTrack: AppColors.progressTrack,
    border: Color(0x1F6D5732),
    overlay: Color(0xB8FDFBF6),
    inputFill: Color(0xD9FFFFFF),
    error: AppColors.error,
    errorText: AppColors.errorText,
    errorBorder: AppColors.errorBorder,
    warningBackground: AppColors.warningBackground,
    warningBorder: AppColors.warningBorder,
    warningText: AppColors.warningText,
  );

  static const dark = AppThemeColors(
    surface: Color(0xFF12100D),
    card: Color(0xFF1E1A14),
    bottomBar: Color(0xFF1A1612),
    textPrimary: Color(0xFFE8DFD0),
    textSecondary: Color(0xBFC4B8A5),
    gold: AppColors.gold,
    navy: Color(0xFF9DB4FF),
    progressTrack: Color(0xFF3D3528),
    border: Color(0x33E8DFD0),
    overlay: Color(0xCC12100D),
    inputFill: Color(0xCC1E1A14),
    error: AppColors.error,
    errorText: AppColors.errorText,
    errorBorder: AppColors.errorBorder,
    warningBackground: Color(0xFF2E1F0A),
    warningBorder: Color(0xFF6D4C1A),
    warningText: Color(0xFFFFB74D),
  );

  @override
  AppThemeColors copyWith({
    Color? surface,
    Color? card,
    Color? bottomBar,
    Color? textPrimary,
    Color? textSecondary,
    Color? gold,
    Color? navy,
    Color? progressTrack,
    Color? border,
    Color? overlay,
    Color? inputFill,
    Color? error,
    Color? errorText,
    Color? errorBorder,
    Color? warningBackground,
    Color? warningBorder,
    Color? warningText,
  }) {
    return AppThemeColors(
      surface: surface ?? this.surface,
      card: card ?? this.card,
      bottomBar: bottomBar ?? this.bottomBar,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      gold: gold ?? this.gold,
      navy: navy ?? this.navy,
      progressTrack: progressTrack ?? this.progressTrack,
      border: border ?? this.border,
      overlay: overlay ?? this.overlay,
      inputFill: inputFill ?? this.inputFill,
      error: error ?? this.error,
      errorText: errorText ?? this.errorText,
      errorBorder: errorBorder ?? this.errorBorder,
      warningBackground: warningBackground ?? this.warningBackground,
      warningBorder: warningBorder ?? this.warningBorder,
      warningText: warningText ?? this.warningText,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      bottomBar: Color.lerp(bottomBar, other.bottomBar, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      navy: Color.lerp(navy, other.navy, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      border: Color.lerp(border, other.border, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      warningBackground:
          Color.lerp(warningBackground, other.warningBackground, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
    );
  }
}
