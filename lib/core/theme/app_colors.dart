import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color cream = Color(0xFFFDFBF6);
  static const Color gold = Color(0xFFD4A62A);
  static const Color brown = Color(0xFF6D5732);
  static const Color navy = Color(0xFF0B2A8F);
  static const Color progressTrack = Color(0xFFEADFC7);

  /// Brand gradient start — matches web `--ssm-teal-500`.
  static const Color teal500 = Color(0xFF05958C);

  /// Teal → blue gradient — end stop matches web `--ssm-blue-900`.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [teal500, Color(0xFF002178)],
  );
}
