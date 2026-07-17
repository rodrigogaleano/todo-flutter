import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:todo_flutter/ui/auth/login/widgets/login_screen.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

Future<void> _pumpLoginScreen(
  WidgetTester tester,
  LoginViewModel viewModel,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginScreen(viewModel: viewModel),
    ),
  );
}

void main() {
  const loginFailed =
      'Could not sign in. Check your credentials and try again.';

  testWidgets('blocks submit and shows validation on empty fields', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await _pumpLoginScreen(tester, LoginViewModel(repository));

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(repository.loginCallCount, 0);
  });

  testWidgets('executes login with the entered credentials', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpLoginScreen(tester, LoginViewModel(repository));

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.loginCallCount, 1);
    expect(find.text(loginFailed), findsNothing);
  });

  testWidgets('shows a snackbar when login fails', (tester) async {
    final repository = FakeAuthRepository()
      ..loginResult = Result.error(Exception('bad credentials'));
    await _pumpLoginScreen(tester, LoginViewModel(repository));

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(loginFailed), findsOneWidget);
  });
}
