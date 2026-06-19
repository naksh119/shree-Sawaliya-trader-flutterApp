import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

abstract final class AppDropdownDecoration {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static InputDecoration formField(
    BuildContext context, {
    String? labelText,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final colors = context.appColors;
    final borderRadius = BorderRadius.circular(12);

    return InputDecoration(
      labelText: labelText,
      labelStyle: labelText != null ? AppTextStyles.label(context) : null,
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.progressTrack),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.progressTrack),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    );
  }

  static BoxDecoration container(BuildContext context) {
    final colors = context.appColors;
    return BoxDecoration(
      color: colors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colors.border),
    );
  }

  static ShapeBorder openMenuShape(BuildContext context) {
    final colors = context.appColors;
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: isDark(context)
          ? BorderSide(color: colors.gold)
          : BorderSide.none,
    );
  }

  static PopupMenuDivider menuDivider(BuildContext context) {
    final colors = context.appColors;
    return PopupMenuDivider(
      height: 1,
      thickness: 1,
      color: isDark(context)
          ? colors.gold
          : colors.gold.withValues(alpha: 0.35),
    );
  }
}
