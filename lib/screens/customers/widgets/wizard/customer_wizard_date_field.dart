import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/widgets/app_date_form_field.dart';

class CustomerWizardDateField extends StatelessWidget {
  const CustomerWizardDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
    this.errorText,
    this.validator,
    this.compact = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;
  final FormFieldValidator<DateTime?>? validator;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppDateFormField(
      label: label,
      value: value,
      onTap: onTap,
      onClear: onClear,
      errorText: errorText,
      validator: validator,
      compact: compact,
    );
  }
}
