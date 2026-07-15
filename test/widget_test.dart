import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  testWidgets('design system theme and text render', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: RGTheme.light,
        home: Scaffold(body: RGText.h1('RG Todo')),
      ),
    );

    expect(find.text('RG Todo'), findsOneWidget);
  });
}
