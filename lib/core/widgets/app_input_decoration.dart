import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Borderless [InputDecoration] for fields wrapped in [AppGradientBorder].
abstract final class AppInputDecoration {
  static const TextStyle _hiddenErrorStyle = TextStyle(height: 0, fontSize: 0);

  static InputDecoration borderless(
    BuildContext context, {
    String? hintText,
    String? labelText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
    String? errorText,
    bool showInlineError = true,
  }) {
    final colors = context.appColors;

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      labelStyle: labelText != null ? AppTextStyles.label(context) : null,
      hintStyle: AppTextStyles.body(context).copyWith(
        color: colors.textSecondary,
      ),
      filled: false,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorText: showInlineError ? errorText : null,
      errorStyle: showInlineError
          ? AppTextStyles.subtitle(context).copyWith(
              color: Colors.red.shade700,
            )
          : _hiddenErrorStyle,
      errorMaxLines: showInlineError ? 3 : 1,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }
}
