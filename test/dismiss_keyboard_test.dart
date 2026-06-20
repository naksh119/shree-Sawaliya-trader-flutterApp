import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sawaliyatrader/core/widgets/dismiss_keyboard.dart';

void main() {
  testWidgets('DismissKeyboard unfocuses when tapping outside focused field',
      (WidgetTester tester) async {
    final focusNode = FocusNode();

    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DismissKeyboard(
          child: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextField(
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 400),
                const Text('Tap here to dismiss'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Tap here to dismiss'));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });

  testWidgets('DismissKeyboard keeps focus when tapping inside focused field',
      (WidgetTester tester) async {
    final focusNode = FocusNode();

    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DismissKeyboard(
          child: Scaffold(
            body: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(tester.getCenter(find.byType(TextField)));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);
  });
}
