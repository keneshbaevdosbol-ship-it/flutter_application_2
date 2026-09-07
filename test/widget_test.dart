import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_fkutter/main.dart';

void main() {
  testWidgets('Cat app shows a button to load a new cat',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CatApp());

    // Кнопка "Новый котик" должна быть на экране.
    expect(find.text('Новый котик'), findsOneWidget);
  });
}
