import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

void main() {
  Widget appForLocale(Locale locale) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Text(AppLocalizations.of(context).appTitle),
      ),
    );
  }

  const expectedTitles = <String, String>{
    'en': 'Todo',
    'pt': 'Tarefas',
    'es': 'Tareas',
    'de': 'Aufgaben',
  };

  testWidgets('supports the four configured locales', (tester) async {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      expectedTitles.keys.toSet(),
    );
  });

  for (final entry in expectedTitles.entries) {
    testWidgets('resolves appTitle for ${entry.key}', (tester) async {
      await tester.pumpWidget(appForLocale(Locale(entry.key)));
      expect(find.text(entry.value), findsOneWidget);
    });
  }
}
