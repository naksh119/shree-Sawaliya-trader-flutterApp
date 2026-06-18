import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/locale/locale_notifier.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

const _englishFlag = '🇺🇸';
const _hindiFlag = '🇮🇳';

Widget _languageMenuItem(String flag, String label, {bool selected = false}) {
  return Row(
    children: [
      Text(flag, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(label)),
      if (selected) const Icon(Icons.check, size: 18),
    ],
  );
}

List<PopupMenuEntry<Locale>> _languageMenuItems(
  AppLocalizations l10n,
  Locale current,
) {
  return [
    PopupMenuItem(
      value: const Locale('en'),
      child: _languageMenuItem(
        _englishFlag,
        l10n.languageEnglish,
        selected: current.languageCode == 'en',
      ),
    ),
    PopupMenuItem(
      value: const Locale('hi'),
      child: _languageMenuItem(
        _hindiFlag,
        l10n.languageHindi,
        selected: current.languageCode == 'hi',
      ),
    ),
  ];
}

/// Globe icon language picker for the dashboard bottom corner.
class LanguageGlobeButton extends StatelessWidget {
  const LanguageGlobeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = appLocaleNotifier;
    if (notifier == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        final l10n = context.l10n;
        final colors = context.appColors;

        return PopupMenuButton<Locale>(
          tooltip: l10n.selectLanguage,
          position: PopupMenuPosition.over,
          offset: const Offset(0, -8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).colorScheme.surface,
          onSelected: notifier.setLocale,
          itemBuilder: (context) =>
              _languageMenuItems(l10n, notifier.locale),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: colors.shinyGold, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.language, color: colors.navy, size: 24),
            ),
          ),
        );
      },
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  static Widget _languageItem(String flag, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(flag, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

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
                    child: _languageItem(_englishFlag, l10n.languageEnglish),
                  ),
                  DropdownMenuItem(
                    value: const Locale('hi'),
                    child: _languageItem(_hindiFlag, l10n.languageHindi),
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
