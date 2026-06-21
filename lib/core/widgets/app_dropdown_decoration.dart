import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

abstract final class AppDropdownMetrics {
  static const filterPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
  static const containerPadding = EdgeInsets.symmetric(horizontal: 14);
  static const formPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const iconSize = 18.0;
  static const menuExtraWidth = 44.0;
  static const menuItemHeight = 36.0;
  static const visibleMenuItems = 4;
  static const menuDividerHeight = 1.0;
  static const menuItemPadding = EdgeInsets.symmetric(horizontal: 12);
  static const filterIconButtonSize = 48.0;

  static TextStyle filterTextStyle(BuildContext context) =>
      AppTextStyles.body(context).copyWith(fontSize: 13);

  static TextStyle formTextStyle(BuildContext context) => AppTextStyles.body(context);

  static double scrollableMenuMaxHeight(
    int itemCount, {
    double itemHeight = menuItemHeight,
    double dividerHeight = menuDividerHeight,
  }) {
    final visibleCount = itemCount.clamp(0, visibleMenuItems);
    if (visibleCount <= 0) return itemHeight;

    final dividerCount = visibleCount > 1 ? visibleCount - 1 : 0;
    return visibleCount * itemHeight + dividerCount * dividerHeight;
  }

  static double formScrollableMenuMaxHeight(int itemCount) =>
      scrollableMenuMaxHeight(
        itemCount,
        itemHeight: kMinInteractiveDimension,
      );

  static Widget expandIcon(BuildContext context) => Icon(
        Icons.expand_more_rounded,
        size: iconSize,
        color: context.appColors.shinyGold.withValues(alpha: 0.8),
      );
}

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

  static Color menuBackground(BuildContext context) {
    final colors = context.appColors;
    // Soft golden tint — lighter than progressTrack, still on-theme.
    return Color.lerp(
      colors.card,
      colors.progressTrack,
      isDark(context) ? 0.38 : 0.22,
    )!;
  }

  static BoxDecoration container(BuildContext context) {
    final colors = context.appColors;
    return BoxDecoration(
      color: colors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colors.border),
    );
  }

  static Color menuBorderColor(BuildContext context) {
    final colors = context.appColors;
    return isDark(context)
        ? colors.gold
        : colors.gold.withValues(alpha: 0.65);
  }

  static Color menuDividerColor(BuildContext context) {
    final colors = context.appColors;
    return isDark(context)
        ? colors.gold.withValues(alpha: 0.85)
        : colors.gold.withValues(alpha: 0.45);
  }

  static ShapeBorder openMenuShape(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: menuBorderColor(context),
        width: 1,
      ),
    );
  }

  static PopupMenuDivider menuDivider(BuildContext context) {
    return PopupMenuDivider(
      height: 1,
      thickness: 1,
      color: menuDividerColor(context),
    );
  }

  static BoxDecoration filterIconButton(
    BuildContext context, {
    required bool isActive,
  }) {
    final colors = context.appColors;
    return BoxDecoration(
      color: colors.inputFill,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isActive
            ? colors.gold.withValues(alpha: 0.5)
            : colors.border,
      ),
    );
  }
}
