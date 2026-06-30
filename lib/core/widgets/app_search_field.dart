import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_input_decoration.dart';

/// Debounced search field used across list screens.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.hintText,
    required this.onSearch,
    super.key,
    this.debounce = const Duration(milliseconds: 400),
    this.initialQuery = '',
  });

  final String hintText;
  final ValueChanged<String> onSearch;
  final Duration debounce;
  final String initialQuery;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _lastQuery = widget.initialQuery.trim();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _applySearch(String value) {
    final trimmed = value.trim();
    if (trimmed == _lastQuery) return;
    _lastQuery = trimmed;
    widget.onSearch(trimmed);
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () {
      if (!mounted) return;
      _applySearch(value);
    });
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    _applySearch(value);
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    if (_lastQuery.isEmpty) {
      setState(() {});
      return;
    }
    _lastQuery = '';
    widget.onSearch('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppDropdownDecoration.fieldBorder(
      context,
      child: TextField(
        controller: _controller,
        style: AppTextStyles.body(context),
        decoration: AppInputDecoration.borderless(
          context,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: BrandGradientIcon(
            Icons.search,
            opacity: 0.7,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: BrandGradientIcon(
                    Icons.close_rounded,
                    opacity: 0.7,
                  ),
                  onPressed: _clear,
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
      ),
    );
  }
}
