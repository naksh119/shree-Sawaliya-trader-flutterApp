import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';

export 'app_dropdown_decoration.dart';

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

  const edgePadding = 16.0;
  const gap = 4.0;

  final totalContentHeight = items.length * itemHeight +
      (items.length > 1 ? (items.length - 1) * dividerHeight : 0);

  final openBelowTop = offset.dy + buttonSize.height + gap;
  final spaceBelow = screenSize.height - openBelowTop - edgePadding;
  final spaceAbove = offset.dy - edgePadding;
  final openBelow = spaceBelow >= spaceAbove || spaceBelow >= itemHeight * 2;
  final availableHeight = math.max(
    openBelow ? spaceBelow : spaceAbove,
    itemHeight,
  );

  final cappedMaxHeight = math.min(menuMaxHeight, availableHeight);
  final menuHeight = math.min(totalContentHeight, cappedMaxHeight);
  final canScroll = totalContentHeight > menuHeight;
  final menuTop = openBelow
      ? openBelowTop
      : offset.dy - gap - menuHeight;

  var left = offset.dx;
  if (left + menuWidth > screenSize.width - edgePadding) {
    left = screenSize.width - edgePadding - menuWidth;
  }
  if (left < edgePadding) left = edgePadding;

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
            top: menuTop,
            width: menuWidth,
            child: Material(
              color: AppDropdownDecoration.menuBackground(overlayContext),
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
                        color: AppDropdownDecoration.menuDividerColor(
                          overlayContext,
                        ),
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
  double? menuWidth,
  double? menuMinWidth,
  double? menuMaxWidth,
  double? menuMaxHeight,
  double menuItemHeight = AppDropdownMetrics.menuItemHeight,
  EdgeInsetsGeometry menuItemPadding = AppDropdownMetrics.menuItemPadding,
}) {
  if (items.isEmpty) return Future.value();

  final size = button.size;
  final resolvedMinWidth = menuMinWidth ?? size.width;
  final resolvedMaxWidth = menuMaxWidth ?? size.width;
  final resolvedMenuWidth = menuWidth ??
      resolvedMaxWidth.clamp(resolvedMinWidth, double.infinity);
  final resolvedMenuMaxHeight = menuMaxHeight ??
      AppDropdownMetrics.scrollableMenuMaxHeight(
        items.length,
        itemHeight: menuItemHeight,
      );

  final menuItems = items
      .map(
        (item) => DropdownMenuItem<T>(
          value: item.value,
          enabled: item.enabled,
          child: Padding(
            padding: menuItemPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: item.child,
            ),
          ),
        ),
      )
      .toList();

  return showAppScrollableDropdownMenu<T>(
    context: context,
    button: button,
    items: menuItems,
    menuWidth: resolvedMenuWidth,
    menuMaxHeight: resolvedMenuMaxHeight,
    itemHeight: menuItemHeight,
    dividerHeight: AppDropdownMetrics.menuDividerHeight,
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
    this.menuWidth,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;
  final Widget? icon;
  final TextStyle? style;
  final double? menuMinWidth;
  final double? menuMaxWidth;
  final double? menuWidth;

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
      menuWidth: widget.menuWidth,
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
              AppDropdownMetrics.expandIcon(context),
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
      menuItemHeight: kMinInteractiveDimension,
      menuItemPadding: const EdgeInsets.symmetric(horizontal: 16),
      menuMaxHeight: AppDropdownMetrics.formScrollableMenuMaxHeight(
        widget.items.length,
      ),
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
            AppDropdownMetrics.expandIcon(context),
          ],
        ),
      ),
    );
  }
}

String? _dropdownItemLabel(Widget? child) {
  if (child is Text) return child.data ?? child.textSpan?.toPlainText();
  return null;
}

/// Compact filter-bar dropdown for list screens (status, category, etc.).
class AppFilterDropdown<T> extends StatelessWidget {
  const AppFilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.isExpanded = true,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppDropdownMetrics.filterTextStyle(context);

    return Container(
      padding: AppDropdownMetrics.filterPadding,
      decoration: AppDropdownDecoration.container(context),
      child: AppInlineDropdown<T>(
        value: value,
        isExpanded: isExpanded,
        style: textStyle,
        icon: AppDropdownMetrics.expandIcon(context),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

/// Compact filter-bar dropdown with a scrollable menu for long item lists.
class AppScrollableFilterDropdown<T> extends StatefulWidget {
  const AppScrollableFilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.isExpanded = true,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;

  @override
  State<AppScrollableFilterDropdown<T>> createState() =>
      _AppScrollableFilterDropdownState<T>();
}

class _AppScrollableFilterDropdownState<T>
    extends State<AppScrollableFilterDropdown<T>> {
  final _anchorKey = GlobalKey();

  DropdownMenuItem<T>? get _selectedItem {
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return widget.items.isEmpty ? null : widget.items.first;
  }

  List<String> get _allLabels => widget.items
      .map((item) => _dropdownItemLabel(item.child) ?? '')
      .where((label) => label.isNotEmpty)
      .toList();

  List<DropdownMenuItem<T>> get _menuItems {
    final textStyle = AppDropdownMetrics.filterTextStyle(context);
    Widget menuLabel(String text) => Padding(
          padding: AppDropdownMetrics.menuItemPadding,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(text, style: textStyle, maxLines: 2),
          ),
        );

    return [
      for (final item in widget.items)
        DropdownMenuItem(
          value: item.value,
          enabled: item.enabled,
          child: menuLabel(_dropdownItemLabel(item.child) ?? ''),
        ),
    ];
  }

  double _menuWidthFor(BuildContext context, RenderBox button) {
    final style = AppDropdownMetrics.filterTextStyle(context);
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );

    var maxTextWidth = 0.0;
    for (final label in _allLabels) {
      painter.text = TextSpan(text: label, style: style);
      painter.layout();
      maxTextWidth = math.max(maxTextWidth, painter.width);
    }

    final contentWidth = maxTextWidth + AppDropdownMetrics.menuExtraWidth;
    return contentWidth.clamp(
      button.size.width,
      MediaQuery.sizeOf(context).width * 0.72,
    );
  }

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || widget.items.isEmpty) return;

    final menuItems = _menuItems;
    final menuWidth = _menuWidthFor(context, box);
    final menuMaxHeight = AppDropdownMetrics.scrollableMenuMaxHeight(
      menuItems.length,
    );
    final selected = await showAppScrollableDropdownMenu<T>(
      context: context,
      button: box,
      items: menuItems,
      menuWidth: menuWidth,
      menuMaxHeight: menuMaxHeight,
      itemHeight: AppDropdownMetrics.menuItemHeight,
      dividerHeight: AppDropdownMetrics.menuDividerHeight,
    );
    if (selected != null && selected != widget.value) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppDropdownMetrics.filterTextStyle(context);
    final selected = _selectedItem;

    return Container(
      padding: AppDropdownMetrics.filterPadding,
      decoration: AppDropdownDecoration.container(context),
      child: InkWell(
        key: _anchorKey,
        onTap: _openMenu,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            if (widget.isExpanded)
              Expanded(
                child: selected == null
                    ? const SizedBox.shrink()
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: textStyle,
                          child: selected.child,
                        ),
                      ),
              )
            else if (selected != null)
              DefaultTextStyle(style: textStyle, child: selected.child),
            AppDropdownMetrics.expandIcon(context),
          ],
        ),
      ),
    );
  }
}

/// Icon button that opens a styled popup filter menu.
class AppFilterIconButton<T> extends StatefulWidget {
  const AppFilterIconButton({
    required this.value,
    required this.items,
    required this.onSelected,
    required this.icon,
    super.key,
    this.tooltip,
    this.isActive,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onSelected;
  final IconData icon;
  final String? tooltip;
  final bool? isActive;

  @override
  State<AppFilterIconButton<T>> createState() => _AppFilterIconButtonState<T>();
}

class _AppFilterIconButtonState<T> extends State<AppFilterIconButton<T>> {
  final _anchorKey = GlobalKey();

  List<String> get _allLabels => widget.items
      .map((item) => _dropdownItemLabel(item.child) ?? '')
      .where((label) => label.isNotEmpty)
      .toList();

  double _menuWidthFor(BuildContext context, RenderBox button) {
    final style = AppDropdownMetrics.filterTextStyle(context);
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );

    var maxTextWidth = 0.0;
    for (final label in _allLabels) {
      painter.text = TextSpan(text: label, style: style);
      painter.layout();
      maxTextWidth = math.max(maxTextWidth, painter.width);
    }

    final contentWidth = maxTextWidth + AppDropdownMetrics.menuExtraWidth;
    return contentWidth.clamp(
      button.size.width,
      MediaQuery.sizeOf(context).width * 0.72,
    );
  }

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || widget.items.isEmpty) return;

    final selected = await showAppDropdownMenu<T>(
      context: context,
      button: box,
      items: widget.items,
      menuWidth: _menuWidthFor(context, box),
      menuMaxHeight: AppDropdownMetrics.scrollableMenuMaxHeight(
        widget.items.length,
      ),
    );
    if (selected != null) {
      widget.onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive ??
        (widget.items.isNotEmpty && widget.items.first.value != widget.value);
    final iconColor = active
        ? context.appColors.gold
        : context.appColors.shinyGold.withValues(alpha: 0.7);

    final button = InkWell(
      key: _anchorKey,
      onTap: _openMenu,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: AppDropdownMetrics.filterIconButtonSize,
        height: AppDropdownMetrics.filterIconButtonSize,
        decoration: AppDropdownDecoration.filterIconButton(
          context,
          isActive: active,
        ),
        child: Icon(widget.icon, color: iconColor),
      ),
    );

    if (widget.tooltip == null) return button;
    return Tooltip(message: widget.tooltip!, child: button);
  }
}

/// Dropdown inside the standard bordered container (inline forms, settings).
class AppContainerDropdown<T> extends StatelessWidget {
  const AppContainerDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.label,
    this.isExpanded = true,
    this.padding = AppDropdownMetrics.containerPadding,
  });

  final String? label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      padding: padding,
      decoration: AppDropdownDecoration.container(context),
      child: AppInlineDropdown<T>(
        value: value,
        isExpanded: isExpanded,
        style: AppDropdownMetrics.formTextStyle(context),
        icon: AppDropdownMetrics.expandIcon(context),
        items: items,
        onChanged: onChanged,
      ),
    );

    if (label == null) return dropdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: AppTextStyles.subtitle(context)),
        const SizedBox(height: 8),
        dropdown,
      ],
    );
  }
}
