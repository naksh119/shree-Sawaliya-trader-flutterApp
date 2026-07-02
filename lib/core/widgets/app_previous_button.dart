import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_wizard_outline_button.dart';

/// Compact outlined action for going back in wizard steps.
class AppPreviousButton extends StatelessWidget {
  const AppPreviousButton({
    required this.onPressed,
    super.key,
    this.label,
  });

  final VoidCallback? onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppWizardOutlineButton(
      label: label ?? l10n.previous,
      onPressed: onPressed,
    );
  }
}
