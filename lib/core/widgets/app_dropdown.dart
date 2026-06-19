import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';

Future<T?> showAppScrollableDropdownMenu<T>({
  required BuildContext context,
  required RenderBox button,
  required List<DropdownMenuItem<T>> items,
  required double menuWidth,
  required double menuMaxHeight,
  required double itemHeight,
  double dividerHeight = 1,
}) async {
  if (items.isEmpty) return null;

  final overlay = Overlay.of(context);
  final offset = button.localToGlobal(Offset.zero);
  final buttonSize = button.size;
  final screenSize = MediaQuery.sizeOf(context);
  final completer = Completer<T?>();
  final scrollController = ScrollController();

  final totalContentHeight = items.length * itemHeight +
      (items.length > 1 ? (items.length - 1) * dividerHeight : 0);
  final menuHeight = math.min(totalContentHeight, menuMaxHeight);
  final canScroll = totalContentHeight > menuMaxHeight;

  var left = offset.dx;
  if (left + menuWidth > screenSize.width - 16) {
    left = screenSize.width - 16 - menuWidth;
  }
  if (left < 16) left = 16;

  late OverlayEntry entry;

  void close([T? value]) {
    if (!completer.isCompleted) {
      completer.complete(value);
    }
    entry.remove();
    scrollController.dispose();
  }

  entry = OverlayEntry(
    builder: (overlayContext) {
      final colors = overlayContext.appColors;

      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => close(),
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            left: left,
            top: offset.dy + buttonSize.height + 4,
            width: menuWidth,
            child: Material(
              color: colors.card,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              shape: AppDropdownDecoration.openMenuShape(overlayContext),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: menuHeight,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(
                      colors.gold.withValues(alpha: 0.85),
                    ),
                    trackColor: WidgetStateProperty.all(
                      colors.border.withValues(alpha: 0.35),
                    ),
                    trackBorderColor: WidgetStateProperty.all(
                      colors.border.withValues(alpha: 0.2),
                    ),
                    thickness: WidgetStateProperty.all(5),
                    radius: const Radius.circular(6),
                    crossAxisMargin: 2,
                    mainAxisMargin: 4,
                    interactive: true,
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: canScroll,
                    trackVisibility: canScroll,
                    interactive: true,
                    child: ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      physics: canScroll
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => Divider(
                        height: dividerHeight,
                        thickness: dividerHeight,
                        color: AppDropdownDecoration.isDark(overlayContext)
                            ? colors.gold
                            : colors.gold.withValues(alpha: 0.35),
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InkWell(
                          onTap: item.enabled ? () => close(item.value) : null,
                          child: SizedBox(
                            height: itemHeight,
                            width: menuWidth,
                            child: item.child,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(entry);
  return completer.future;
}

Future<T?> showAppDropdownMenu<T>({
  required BuildContext context,
  required RenderBox button,
  required List<DropdownMenuItem<T>> items,
  double? menuMinWidth,
  double? menuMaxWidth,
  double? menuMaxHeight,
  double menuItemHeight = kMinInteractiveDimension,
}) {
  final offset = button.localToGlobal(Offset.zero);
  final size = button.size;
  final screenSize = MediaQuery.sizeOf(context);
  final resolvedMinWidth = menuMinWidth ?? size.width;
  final resolvedMaxWidth = menuMaxWidth ?? size.width;

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
        height: menuItemHeight,
        padding: menuItemHeight < kMinInteractiveDimension
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16),
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
      minWidth: resolvedMinWidth,
      maxWidth: resolvedMaxWidth,
      maxHeight: menuMaxHeight ?? double.infinity,
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
    this.menuMinWidth,
    this.menuMaxWidth,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;
  final Widget? icon;
  final TextStyle? style;
  final double? menuMinWidth;
  final double? menuMaxWidth;

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
      menuMinWidth: widget.menuMinWidth,
      menuMaxWidth: widget.menuMaxWidth,
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
