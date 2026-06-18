import 'package:flutter/material.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

extension LocaleContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
