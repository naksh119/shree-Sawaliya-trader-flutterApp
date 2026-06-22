import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

/// Gender dropdown items (Male, Female).
List<DropdownMenuItem<String>> genderDropdownItems(
  BuildContext context, {
  TextStyle? textStyle,
}) {
  final l10n = context.l10n;
  final style = textStyle ?? AppTextStyles.body(context);
  return kGenderOptions
      .map(
        (value) => DropdownMenuItem(
          value: value,
          child: Text(
            localizedGenderLabel(l10n, value),
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
      .toList();
}

/// Marital status dropdown items (Single, Married).
List<DropdownMenuItem<String>> maritalStatusDropdownItems(
  BuildContext context, {
  TextStyle? textStyle,
}) {
  final l10n = context.l10n;
  final style = textStyle ?? AppTextStyles.body(context);
  return kMaritalStatusOptions
      .map(
        (value) => DropdownMenuItem(
          value: value,
          child: Text(
            localizedMaritalStatusLabel(l10n, value),
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
      .toList();
}