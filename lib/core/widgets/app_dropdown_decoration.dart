import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_border.dart';
import 'package:sawaliyatrader/core/widgets/app_input_decoration.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';

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

  static Widget expandIcon(BuildContext context) => BrandGradientIcon(
        Icons.expand_more_rounded,
        size: iconSize,
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
    return AppInputDecoration.borderless(
      context,
      labelText: labelText,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  /// Branded gradient outline shared by text fields, dropdowns, and date pickers.
  static Widget fieldBorder(
    BuildContext context, {
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool hasError = false,
    bool isFocused = false,
    double borderRadius = AppInputMetrics.borderRadius,
  }) {
    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding, child: child);
    }

    return AppGradientBorder(
      backgroundColor: context.appColors.card,
      hasError: hasError,
      isFocused: isFocused,
      borderRadius: borderRadius,
      child: content,
    );
  }

  static const double menuBorderRadius = 12;

  static Color menuBackground(BuildContext context) {
    final colors = context.appColors;
    return Color.lerp(
      colors.card,
      AppColors.teal500,
      isDark(context) ? 0.1 : 0.05,
    )!;
  }

  static Color menuDividerColor(BuildContext context) {
    return AppColors.teal500.withValues(
      alpha: isDark(context) ? 0.4 : 0.22,
    );
  }

  /// Branded gradient outline for open dropdown / popup menus.
  static Widget menuBorder(
    BuildContext context, {
    required Widget child,
  }) {
    return AppGradientBorder(
      backgroundColor: menuBackground(context),
      borderRadius: menuBorderRadius,
      child: child,
    );
  }
}
