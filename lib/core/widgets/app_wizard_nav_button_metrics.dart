import 'package:flutter/material.dart';

/// Shared size and shape for wizard step navigation buttons.
abstract final class AppWizardNavButtonMetrics {
  static const double width = 110;
  static const double height = 40;
  static const double borderRadius = height / 2;

  static BorderRadius get shape =>
      BorderRadius.all(Radius.circular(borderRadius));
}
