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
    required this.shinyGold,
    required this.navy,
    required this.progressTrack,
    required this.border,
    required this.overlay,
    required this.inputFill,
  });

  final Color surface;
  final Color card;
  final Color bottomBar;
  final Color textPrimary;
  final Color textSecondary;
  final Color gold;
  final Color shinyGold;
  final Color navy;
  final Color progressTrack;
  final Color border;
  final Color overlay;
  final Color inputFill;

  static const light = AppThemeColors(
    surface: AppColors.cream,
    card: Colors.white,
    bottomBar: Colors.white,
    textPrimary: AppColors.brown,
    textSecondary: Color(0xBF6D5732),
    gold: AppColors.gold,
    shinyGold: AppColors.shinyGold,
    navy: AppColors.navy,
    progressTrack: AppColors.progressTrack,
    border: Color(0x1F6D5732),
    overlay: Color(0xB8FDFBF6),
    inputFill: Color(0xD9FFFFFF),
  );

  static const dark = AppThemeColors(
    surface: Color(0xFF12100D),
    card: Color(0xFF1E1A14),
    bottomBar: Color(0xFF1A1612),
    textPrimary: Color(0xFFE8DFD0),
    textSecondary: Color(0xBFC4B8A5),
    gold: AppColors.gold,
    shinyGold: AppColors.shinyGold,
    navy: Color(0xFF9DB4FF),
    progressTrack: Color(0xFF3D3528),
    border: Color(0x33E8DFD0),
    overlay: Color(0xCC12100D),
    inputFill: Color(0xCC1E1A14),
  );

  @override
  AppThemeColors copyWith({
    Color? surface,
    Color? card,
    Color? bottomBar,
    Color? textPrimary,
    Color? textSecondary,
    Color? gold,
    Color? shinyGold,
    Color? navy,
    Color? progressTrack,
    Color? border,
    Color? overlay,
    Color? inputFill,
  }) {
    return AppThemeColors(
      surface: surface ?? this.surface,
      card: card ?? this.card,
      bottomBar: bottomBar ?? this.bottomBar,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      gold: gold ?? this.gold,
      shinyGold: shinyGold ?? this.shinyGold,
      navy: navy ?? this.navy,
      progressTrack: progressTrack ?? this.progressTrack,
      border: border ?? this.border,
      overlay: overlay ?? this.overlay,
      inputFill: inputFill ?? this.inputFill,
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
      shinyGold: Color.lerp(shinyGold, other.shinyGold, t)!,
      navy: Color.lerp(navy, other.navy, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      border: Color.lerp(border, other.border, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
    );
  }
}
