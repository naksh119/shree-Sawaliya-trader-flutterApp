import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Dismisses the soft keyboard when the user taps outside a focused input.
///
/// Uses [Listener] with a bounds check so taps on scroll views (e.g. [ListView])
/// still dismiss the keyboard—ancestor [GestureDetector] taps are often blocked
/// by scrollable hit targets.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      child: child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || !focus.hasFocus) return;

    final focusContext = focus.context;
    if (focusContext == null || !focusContext.mounted) return;

    final renderObject = focusContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final focusRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    if (!focusRect.contains(event.position)) {
      focus.unfocus();
    }
  }
}
