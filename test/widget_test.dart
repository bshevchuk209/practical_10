import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical_10/main.dart';

void main() {
  testWidgets(
    'Preview receives text and size, all return results are distinct',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byKey(const ValueKey('text')), 'Перевірка');
      await tester.enterText(find.byKey(const ValueKey('size')), '32');
      for (final action in ['Ok', 'Cancel', 'Back']) {
        await tester.tap(find.byKey(const ValueKey('open')));
        await tester.pumpAndSettle();
        final text = tester.widget<Text>(
          find.byKey(const ValueKey('previewText')),
        );
        expect(text.data, 'Перевірка');
        expect(text.style!.fontSize, 32);
        if (action == 'Back') {
          await tester.pageBack();
        } else {
          await tester.tap(find.text(action));
        }
        await tester.pumpAndSettle();
        expect(
          find.text(
            action == 'Ok'
                ? 'Cool!'
                : action == 'Cancel'
                ? 'Let’s try something else.'
                : "Don't know what to say.",
          ),
          findsOneWidget,
        );
        await tester.tap(find.text('Закрити'));
        await tester.pumpAndSettle();
      }
    },
  );
  testWidgets('Invalid font sizes and empty text cannot navigate', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    for (final size in ['abc', 'NaN', 'Infinity', '0', '97']) {
      await tester.enterText(find.byKey(const ValueKey('size')), size);
      await tester.tap(find.byKey(const ValueKey('open')));
      await tester.pumpAndSettle();
      expect(find.text('Введіть число від 8 до 96'), findsOneWidget);
    }
    await tester.enterText(find.byKey(const ValueKey('text')), ' ');
    await tester.tap(find.byKey(const ValueKey('open')));
    await tester.pumpAndSettle();
    expect(find.text('Введіть текст'), findsOneWidget);
  });
}
