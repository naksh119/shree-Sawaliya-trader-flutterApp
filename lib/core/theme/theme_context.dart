import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_theme_colors.dart';
import 'package:sawaliyatrader/core/theme/theme_scope.dart';

extension ThemeContext on BuildContext {
  AppThemeColors get appColors {
    ThemeScope.maybeOf(this);
    final theme = Theme.of(this);
    return theme.extension<AppThemeColors>() ??
        (theme.brightness == Brightness.dark
            ? AppThemeColors.dark
            : AppThemeColors.light);
  }
}
