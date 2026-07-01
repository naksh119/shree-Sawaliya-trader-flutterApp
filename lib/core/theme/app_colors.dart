import 'package:flutter/material.dart';

/// Static brand and semantic colors shared across light and dark themes.
abstract final class AppColors {
  // Brand
  static const Color cream = Color(0xFFFDFBF6);
  static const Color gold = Color(0xFFD4A62A);
  static const Color brown = Color(0xFF6D5732);
  static const Color navy = Color(0xFF0B2A8F);
  static const Color progressTrack = Color(0xFFEADFC7);
  static const Color teal500 = Color(0xFF05958C);
  static const Color blue900 = Color(0xFF002178);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [teal500, blue900],
  );

  // Error
  static const Color error = Color(0xFFE57373);
  static const Color errorText = Color(0xFFD32F2F);
  static const Color errorBorder = Color(0xFFEF9A9A);

  // Warning
  static const Color warningBackground = Color(0xFFFFF3E0);
  static const Color warningBorder = Color(0xFFFFCC80);
  static const Color warningText = Color(0xFFE65100);
}
