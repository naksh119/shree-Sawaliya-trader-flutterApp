import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';

/// Compact primary action for wizard steps and multi-step flows.
class AppNextButton extends StatelessWidget {
  const AppNextButton({
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isLastStep = false,
    this.label,
  });

  static const double width = 110;
  static const double height = 40;

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isLastStep;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppPrimaryButton(
      label: label ?? (isLastStep ? l10n.finish : l10n.next),
      isLoading: isLoading,
      onPressed: onPressed,
      width: width,
      height: height,
      fontSize: 16,
    );
  }
}
