import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/locale/locale_notifier.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

const _englishFlag = '🇺🇸';
const _hindiFlag = '🇮🇳';

Widget _languageMenuItem(
  String flag,
  String label, {
  bool selected = false,
}) {
  return Row(
    children: [
      Text(
        flag,
        style: const TextStyle(fontSize: 16, height: 1),
        maxLines: 1,
        softWrap: false,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(
        width: 16,
        height: 16,
        child: selected
            ? const BrandGradientIcon(Icons.check, size: 16)
            : null,
      ),
    ],
  );
}

List<DropdownMenuItem<Locale>> _languageDropdownItems(
  AppLocalizations l10n,
  Locale current,
) {
  return [
    DropdownMenuItem(
      value: const Locale('en'),
      child: _languageMenuItem(
        _englishFlag,
        l10n.languageEnglish,
        selected: current.languageCode == 'en',
      ),
    ),
    DropdownMenuItem(
      value: const Locale('hi'),
      child: _languageMenuItem(
        _hindiFlag,
        l10n.languageHindi,
        selected: current.languageCode == 'hi',
      ),
    ),
  ];
}

/// Legacy name — renders the compact [LanguageDropdown].
class LanguageGlobeButton extends StatelessWidget {
  const LanguageGlobeButton({super.key});

  @override
  Widget build(BuildContext context) => const LanguageDropdown();
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  static const _buttonWidth = 46.0;
  static const _buttonHeight = 26.0;
  static const _menuWidth = 112.0;

  static String _flagFor(Locale locale) =>
      locale.languageCode == 'hi' ? _hindiFlag : _englishFlag;

  static String _codeFor(Locale locale) =>
      locale.languageCode == 'hi' ? 'HI' : 'EN';

  @override
  Widget build(BuildContext context) {
    final notifier = appLocaleNotifier;
    if (notifier == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        final l10n = context.l10n;
        final locale = notifier.locale;

        return Tooltip(
          message: l10n.selectLanguage,
          child: SizedBox(
            width: _buttonWidth,
            height: _buttonHeight,
            child: AppDropdownDecoration.fieldBorder(
              context,
              padding: EdgeInsets.zero,
              borderRadius: 10,
              child: AppInlineDropdown<Locale>(
                value: locale,
                expandHitTarget: true,
                menuWidth: _menuWidth,
                selectedChild: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _flagFor(locale),
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(fontSize: 14, height: 1),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _codeFor(locale),
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                icon: const SizedBox.shrink(),
                items: _languageDropdownItems(l10n, locale),
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
