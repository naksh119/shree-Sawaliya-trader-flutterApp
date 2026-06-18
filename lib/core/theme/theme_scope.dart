import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_notifier.dart';

/// Rebuilds [context.appColors] dependents when [ThemeNotifier] changes.
class ThemeScope extends InheritedNotifier<ThemeNotifier> {
  const ThemeScope({
    required ThemeNotifier super.notifier,
    required super.child,
    super.key,
  });

  static ThemeNotifier? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeScope>()
        ?.notifier;
  }
}
