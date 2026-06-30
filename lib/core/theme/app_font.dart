import 'package:flutter/material.dart';

/// App-wide Times New Roman typography.
abstract final class AppFont {
  static const String family = 'TimesNewRoman';

  static TextStyle style({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: family,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static TextTheme textTheme(TextTheme base) =>
      base.apply(fontFamily: family);
}
