import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/theme/theme_notifier.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = appThemeNotifier;
    if (notifier == null) return const SizedBox.shrink();

    final isDark = notifier.isDark;
    final l10n = context.l10n;

    return IconButton(
      tooltip: isDark ? l10n.switchToLightMode : l10n.switchToDarkMode,
      onPressed: notifier.toggle,
      icon: Icon(
        isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        color: context.appColors.shinyGold,
      ),
    );
  }
}
