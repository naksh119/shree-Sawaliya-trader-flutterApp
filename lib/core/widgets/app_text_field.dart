import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_input_decoration.dart';

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
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
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
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalError != oldWidget.externalError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fieldKey.currentState?.validate();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final error = widget.validator?.call(value) ?? widget.externalError;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fieldState = _fieldKey.currentState;
    final hasError = fieldState?.hasError ?? false;
    final errorText = fieldState?.errorText;

    final field = TextFormField(
      key: _fieldKey,
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: _validate,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      style: AppTextStyles.body(context),
      cursorColor: colors.gold,
      scrollPadding: const EdgeInsets.only(bottom: 120),
      decoration: AppInputDecoration.borderless(
        context,
        hintText: widget.hint,
        suffixIcon: widget.suffixIcon,
        showInlineError: false,
      ),
      onChanged: (_) => setState(() {}),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        AppDropdownDecoration.fieldBorder(
          context,
          hasError: hasError,
          isFocused: _focusNode.hasFocus,
          child: field,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText,
            style: AppTextStyles.body(context).copyWith(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
