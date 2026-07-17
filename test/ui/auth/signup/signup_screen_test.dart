import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/signup/view_models/signup_viewmodel.dart';
import 'package:todo_flutter/ui/auth/signup/widgets/signup_screen.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

Future<void> _pumpSignupScreen(
  WidgetTester tester,
  SignupViewModel viewModel,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SignupScreen(viewModel: viewModel),
    ),
  );
}

void main() {
  const signupFailed = 'Could not create your account. Please try again.';

  testWidgets('blocks submit and shows validation on empty fields', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await _pumpSignupScreen(tester, SignupViewModel(repository));

    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(find.text('Enter your name'), findsOneWidget);
    expect(repository.registerCallCount, 0);
  });

  testWidgets('executes register with the entered fields', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpSignupScreen(tester, SignupViewModel(repository));

    await tester.enterText(find.byType(TextFormField).at(0), 'Rodrigo');
    await tester.enterText(find.byType(TextFormField).at(1), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.tap(find.text('Create account'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.registerCallCount, 1);
    expect(find.text(signupFailed), findsNothing);
  });

  testWidgets('shows a snackbar when sign-up fails', (tester) async {
    final repository = FakeAuthRepository()
      ..registerResult = Result.error(Exception('email in use'));
    await _pumpSignupScreen(tester, SignupViewModel(repository));

    await tester.enterText(find.byType(TextFormField).at(0), 'Rodrigo');
    await tester.enterText(find.byType(TextFormField).at(1), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.tap(find.text('Create account'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(signupFailed), findsOneWidget);
  });
}
