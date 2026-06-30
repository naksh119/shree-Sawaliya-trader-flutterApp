import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Branded [showDatePicker] wrapper — white/card surfaces, teal selection accent.
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    builder: AppDatePickerTheme.wrap,
  );
}

abstract final class AppDatePickerTheme {
  static ThemeData themed(BuildContext context) {
    final colors = context.appColors;
    final base = Theme.of(context);
    final isDark = base.brightness == Brightness.dark;

    final colorScheme = base.colorScheme.copyWith(
      primary: AppColors.teal500,
      onPrimary: Colors.white,
      surface: colors.card,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      primaryContainer: AppColors.teal500.withValues(alpha: isDark ? 0.28 : 0.14),
      onPrimaryContainer: colors.textPrimary,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: colors.card,
      ),
      datePickerTheme: base.datePickerTheme.copyWith(
        backgroundColor: colors.card,
        headerBackgroundColor: colors.card,
        headerForegroundColor: colors.textPrimary,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          if (states.contains(WidgetState.disabled)) {
            return colors.textSecondary.withValues(alpha: 0.45);
          }
          return colors.textPrimary;
        }),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppColors.teal500;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.teal500;
          }
          return Colors.transparent;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.teal500;
          }
          return Colors.transparent;
        }),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          if (states.contains(WidgetState.disabled)) {
            return colors.textSecondary.withValues(alpha: 0.45);
          }
          return colors.textPrimary;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.teal500;
          }
          return Colors.transparent;
        }),
      ),
    );
  }

  static Widget wrap(BuildContext context, Widget? child) {
    return Theme(
      data: themed(context),
      child: child!,
    );
  }
}
