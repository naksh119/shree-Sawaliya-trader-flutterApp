import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_dialog_shell.dart';

enum AppMessageType { success, error }

const Duration kAppMessageDuration = Duration(seconds: 2);

/// Shows a centered popup for success or error feedback.
Future<void> showAppMessage(
  BuildContext context, {
  required AppMessageType type,
  required String message,
  String? title,
  Duration duration = kAppMessageDuration,
}) {
  final colors = context.appColors;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: colors.overlay,
    builder: (dialogContext) {
      return _AppMessageDialog(
        type: type,
        title: title,
        message: message,
        duration: duration,
      );
    },
  );
}

Future<void> showAppSuccessMessage(
  BuildContext context, {
  required String message,
  String? title,
  Duration duration = kAppMessageDuration,
}) {
  return showAppMessage(
    context,
    type: AppMessageType.success,
    message: message,
    title: title,
    duration: duration,
  );
}

Future<void> showAppErrorMessage(
  BuildContext context, {
  required String message,
  String? title,
  Duration duration = kAppMessageDuration,
}) {
  return showAppMessage(
    context,
    type: AppMessageType.error,
    message: message,
    title: title,
    duration: duration,
  );
}

class _AppMessageDialog extends StatefulWidget {
  const _AppMessageDialog({
    required this.type,
    required this.message,
    required this.duration,
    this.title,
  });

  final AppMessageType type;
  final String message;
  final Duration duration;
  final String? title;

  @override
  State<_AppMessageDialog> createState() => _AppMessageDialogState();
}

class _AppMessageDialogState extends State<_AppMessageDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isSuccess => widget.type == AppMessageType.success;

  String _title(BuildContext context) =>
      widget.title ??
      (_isSuccess ? context.l10n.success : context.l10n.error);

  IconData get _icon =>
      _isSuccess ? Icons.check_rounded : Icons.error_outline_rounded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = _isSuccess ? colors.gold : colors.error;

    return AppGradientDialogShell(
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              color: accent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _title(context),
            style: AppTextStyles.label(context).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.message,
            style: AppTextStyles.body(context).copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
