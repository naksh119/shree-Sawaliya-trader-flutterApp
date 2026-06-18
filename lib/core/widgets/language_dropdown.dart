import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/locale/locale_notifier.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = appLocaleNotifier;
    if (notifier == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        final l10n = context.l10n;
        final gold = context.appColors.shinyGold;

        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: l10n.selectLanguage,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: notifier.locale,
                icon: Icon(Icons.arrow_drop_down, color: gold, size: 20),
                dropdownColor: Theme.of(context).colorScheme.surface,
                style: TextStyle(
                  color: gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                borderRadius: BorderRadius.circular(12),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(l10n.languageEnglish),
                  ),
                  DropdownMenuItem(
                    value: const Locale('hi'),
                    child: Text(l10n.languageHindi),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) notifier.setLocale(locale);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
