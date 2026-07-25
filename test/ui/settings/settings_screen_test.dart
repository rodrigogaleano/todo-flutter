import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/settings/settings_screen.dart';
import 'package:todo_flutter/ui/settings/settings_viewmodel.dart';

import '../../utils/fakes.dart';

Future<void> _pumpSettings(
  WidgetTester tester,
  SettingsViewModel viewModel, {
  String initialLocation = '/settings',
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Text('HOME')),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(viewModel: viewModel),
      ),
    ],
  );
  return tester.pumpWidget(
    MaterialApp.router(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

SettingsViewModel _viewModel(
  FakeAuthRepository authRepository, [
  FakeSettingsRepository? settingsRepository,
  FakeTaskRepository? taskRepository,
]) => SettingsViewModel(
  authRepository,
  settingsRepository ?? FakeSettingsRepository(),
  taskRepository ?? FakeTaskRepository(),
);

void main() {
  testWidgets('shows the account email and title', (tester) async {
    final authRepository = FakeAuthRepository()
      ..currentUserEmailValue = 'rodrigo@example.com';
    await _pumpSettings(tester, _viewModel(authRepository));

    expect(find.text('Settings.'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('rodrigo@example.com'), findsOneWidget);
  });

  testWidgets('signs out when the sign-out button is tapped', (tester) async {
    final authRepository = FakeAuthRepository()
      ..currentUserEmailValue = 'rodrigo@example.com';
    await _pumpSettings(tester, _viewModel(authRepository));

    await tester.tap(find.text('Sign out'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(authRepository.logoutCallCount, 1);
  });

  testWidgets('toggles the dark theme from the switch', (tester) async {
    final settingsRepository = FakeSettingsRepository();
    await _pumpSettings(
      tester,
      _viewModel(FakeAuthRepository(), settingsRepository),
    );

    await tester.tap(find.byType(RGSwitch));
    await tester.pumpAndSettle();

    expect(settingsRepository.setThemeModeCalls, [ThemeMode.dark]);
  });

  testWidgets('changes the language from the selector', (tester) async {
    final settingsRepository = FakeSettingsRepository();
    await _pumpSettings(
      tester,
      _viewModel(FakeAuthRepository(), settingsRepository),
    );

    await tester.tap(find.byType(RGSelect<Locale>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(settingsRepository.setLocaleCalls, [const Locale('es')]);
  });

  testWidgets('navigates back on narrow screens', (tester) async {
    final authRepository = FakeAuthRepository();
    await _pumpSettings(
      tester,
      _viewModel(authRepository),
      initialLocation: '/',
    );

    unawaited(GoRouter.of(tester.element(find.text('HOME'))).push('/settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('does not delete when confirmation is cancelled', (tester) async {
    final taskRepository = FakeTaskRepository();
    addTearDown(taskRepository.dispose);
    await _pumpSettings(
      tester,
      _viewModel(FakeAuthRepository(), null, taskRepository),
    );

    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(taskRepository.deleteAllTasksCallCount, 0);
  });

  testWidgets('deletes after password reauthentication', (tester) async {
    final authRepository = FakeAuthRepository()
      ..signInMethodValue = SignInMethod.password;
    final taskRepository = FakeTaskRepository();
    addTearDown(taskRepository.dispose);
    await _pumpSettings(
      tester,
      _viewModel(authRepository, null, taskRepository),
    );

    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Delete account'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'my-password');
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Delete account'),
      ),
    );
    await tester.pumpAndSettle();

    expect(authRepository.reauthenticateWithPasswordCalls, ['my-password']);
    expect(taskRepository.deleteAllTasksCallCount, 1);
    expect(authRepository.deleteAccountCallCount, 1);
  });

  testWidgets('deletes via Google reauthentication', (tester) async {
    final authRepository = FakeAuthRepository()
      ..signInMethodValue = SignInMethod.google;
    final taskRepository = FakeTaskRepository();
    addTearDown(taskRepository.dispose);
    await _pumpSettings(
      tester,
      _viewModel(authRepository, null, taskRepository),
    );

    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Delete account'),
      ),
    );
    await tester.pumpAndSettle();

    expect(authRepository.reauthenticateWithGoogleCallCount, 1);
    expect(taskRepository.deleteAllTasksCallCount, 1);
    expect(authRepository.deleteAccountCallCount, 1);
  });

  testWidgets('shows the sidebar with settings active on wide screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authRepository = FakeAuthRepository()
      ..currentUserDisplayNameValue = 'Rodrigo Galeano'
      ..currentUserEmailValue = 'rodrigo@example.com';
    await _pumpSettings(tester, _viewModel(authRepository));

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });
}
