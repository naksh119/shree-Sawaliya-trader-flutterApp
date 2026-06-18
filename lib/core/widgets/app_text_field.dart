import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    required this.label,
    super.key,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.externalError,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool autocorrect;
  final bool enableSuggestions;
  final String? externalError;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final colors = context.appColors;
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.body(context).copyWith(
        color: colors.textSecondary,
      ),
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.progressTrack),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.progressTrack),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.shade300,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1.5,
        ),
      ),
      suffixIcon: widget.suffixIcon,
    );
  }

  String? _validate(String? value) {
    final localError = widget.validator?.call(value);
    if (localError != null) return localError;
    return widget.externalError;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey(widget.label),
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: _validate,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          style: AppTextStyles.body(context),
          cursorColor: context.appColors.gold,
          scrollPadding: const EdgeInsets.only(bottom: 120),
          decoration: _buildDecoration(context),
        ),
      ],
    );
  }
}
