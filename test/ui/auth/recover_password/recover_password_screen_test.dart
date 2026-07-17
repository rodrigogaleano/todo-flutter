import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/recover_password/view_models/recover_password_viewmodel.dart';
import 'package:todo_flutter/ui/auth/recover_password/widgets/recover_password_screen.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

Future<void> _pumpScreen(
  WidgetTester tester,
  RecoverPasswordViewModel viewModel,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: RecoverPasswordScreen(viewModel: viewModel),
    ),
  );
}

void main() {
  const success = 'We sent a link to reset your password.';
  const failure = 'Could not send the reset email. Please try again.';

  testWidgets('blocks submit and shows validation on empty email', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await _pumpScreen(tester, RecoverPasswordViewModel(repository));

    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(repository.sendPasswordResetCallCount, 0);
  });

  testWidgets('shows a confirmation snackbar on success', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpScreen(tester, RecoverPasswordViewModel(repository));

    await tester.enterText(find.byType(TextFormField), 'a@b.com');
    await tester.tap(find.text('Send'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.sendPasswordResetCallCount, 1);
    expect(find.text(success), findsOneWidget);
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    final repository = FakeAuthRepository()
      ..sendPasswordResetResult = Result.error(Exception('no such user'));
    await _pumpScreen(tester, RecoverPasswordViewModel(repository));

    await tester.enterText(find.byType(TextFormField), 'a@b.com');
    await tester.tap(find.text('Send'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(failure), findsOneWidget);
  });
}
