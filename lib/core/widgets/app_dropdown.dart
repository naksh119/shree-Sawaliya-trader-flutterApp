import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';

Future<T?> showAppDropdownMenu<T>({
  required BuildContext context,
  required RenderBox button,
  required List<DropdownMenuItem<T>> items,
}) {
  final offset = button.localToGlobal(Offset.zero);
  final size = button.size;
  final screenSize = MediaQuery.sizeOf(context);

  final menuEntries = <PopupMenuEntry<T>>[];
  for (var index = 0; index < items.length; index++) {
    if (index > 0) {
      menuEntries.add(AppDropdownDecoration.menuDivider(context));
    }
    final item = items[index];
    menuEntries.add(
      PopupMenuItem<T>(
        value: item.value,
        enabled: item.enabled,
        child: item.child,
      ),
    );
  }

  return showMenu<T>(
    context: context,
    color: context.appColors.card,
    shape: AppDropdownDecoration.openMenuShape(context),
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      screenSize.width - offset.dx - size.width,
      screenSize.height - offset.dy - size.height,
    ),
    constraints: BoxConstraints(
      minWidth: size.width,
      maxWidth: size.width,
    ),
    items: menuEntries,
  );
}

class AppInlineDropdown<T> extends StatefulWidget {
  const AppInlineDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.isExpanded = false,
    this.icon,
    this.style,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;
  final Widget? icon;
  final TextStyle? style;

  @override
  State<AppInlineDropdown<T>> createState() => _AppInlineDropdownState<T>();
}

class _AppInlineDropdownState<T> extends State<AppInlineDropdown<T>> {
  final _anchorKey = GlobalKey();

  DropdownMenuItem<T> get _selectedItem => widget.items.firstWhere(
        (item) => item.value == widget.value,
        orElse: () => widget.items.first,
      );

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final selected = await showAppDropdownMenu<T>(
      context: context,
      button: box,
      items: widget.items,
    );
    if (selected != null && selected != widget.value) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _selectedItem.child;
    final textStyle = widget.style ?? DefaultTextStyle.of(context).style;

    return InkWell(
      key: _anchorKey,
      onTap: _openMenu,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          if (widget.isExpanded)
            Expanded(
              child: DefaultTextStyle(style: textStyle, child: child),
            )
          else
            DefaultTextStyle(style: textStyle, child: child),
          widget.icon ??
              Icon(
                Icons.expand_more_rounded,
                color: context.appColors.shinyGold.withValues(alpha: 0.8),
              ),
        ],
      ),
    );
  }
}

class AppDropdownFormField<T> extends FormField<T> {
  AppDropdownFormField({
    required List<DropdownMenuItem<T>> items,
    required InputDecoration decoration,
    super.key,
    T? value,
    ValueChanged<T?>? onChanged,
    TextStyle? style,
    super.validator,
    super.onSaved,
    super.enabled = true,
  }) : super(
          initialValue: value,
          builder: (field) {
            return _AppDropdownFormFieldBody<T>(
              field: field,
              items: items,
              value: value,
              decoration: decoration,
              style: style,
              onChanged: onChanged,
              enabled: enabled,
            );
          },
        );
}

class _AppDropdownFormFieldBody<T> extends StatefulWidget {
  const _AppDropdownFormFieldBody({
    required this.field,
    required this.items,
    required this.value,
    required this.decoration,
    required this.enabled,
    this.style,
    this.onChanged,
  });

  final FormFieldState<T> field;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final InputDecoration decoration;
  final TextStyle? style;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  @override
  State<_AppDropdownFormFieldBody<T>> createState() =>
      _AppDropdownFormFieldBodyState<T>();
}

class _AppDropdownFormFieldBodyState<T> extends State<_AppDropdownFormFieldBody<T>> {
  final _anchorKey = GlobalKey();

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final selected = await showAppDropdownMenu<T>(
      context: context,
      button: box,
      items: widget.items,
    );
    if (selected == null) return;

    widget.field.didChange(selected);
    widget.onChanged?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    final currentValue = widget.value ?? widget.field.value;
    DropdownMenuItem<T>? selectedItem;
    for (final item in widget.items) {
      if (item.value == currentValue) {
        selectedItem = item;
        break;
      }
    }

    return InputDecorator(
      decoration: widget.decoration.copyWith(errorText: widget.field.errorText),
      isEmpty: currentValue == null,
      child: InkWell(
        key: _anchorKey,
        onTap: widget.enabled ? _openMenu : null,
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: widget.style ?? DefaultTextStyle.of(context).style,
                child: selectedItem == null
                    ? const SizedBox.shrink()
                    : selectedItem.child,
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              color: context.appColors.shinyGold.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
