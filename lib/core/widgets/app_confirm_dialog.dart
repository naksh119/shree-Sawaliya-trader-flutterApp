import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_dialog_shell.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_filled_button.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_outline_button.dart';

/// Shows a branded confirmation dialog with a gradient border.
///
/// Returns `true` when confirmed, `false` when cancelled, or `null` if dismissed.
Future<bool?> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) {
  final colors = context.appColors;

  return showDialog<bool>(
    context: context,
    barrierColor: colors.overlay,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      return _AppConfirmDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel ?? l10n.cancel,
        confirmLabel: confirmLabel,
        destructive: destructive,
      );
    },
  );
}

class _AppConfirmDialog extends StatelessWidget {
  const _AppConfirmDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.destructive,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppGradientDialogShell(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.heading(context).copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTextStyles.body(context).copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppGradientOutlineButton(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: destructive
                    ? AppGradientFilledButton(
                        label: confirmLabel,
                        onPressed: () => Navigator.of(context).pop(true),
                      )
                    : AppGradientOutlineButton(
                        label: confirmLabel,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
