import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
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

void main() {
  testWidgets('shows the account email and title', (tester) async {
    final authRepository = FakeAuthRepository()
      ..currentUserEmailValue = 'rodrigo@example.com';
    await _pumpSettings(tester, SettingsViewModel(authRepository));

    expect(find.text('Settings.'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('rodrigo@example.com'), findsOneWidget);
  });

  testWidgets('signs out when the sign-out button is tapped', (tester) async {
    final authRepository = FakeAuthRepository()
      ..currentUserEmailValue = 'rodrigo@example.com';
    await _pumpSettings(tester, SettingsViewModel(authRepository));

    await tester.tap(find.text('Sign out'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(authRepository.logoutCallCount, 1);
  });

  testWidgets('navigates back on narrow screens', (tester) async {
    final authRepository = FakeAuthRepository();
    await _pumpSettings(
      tester,
      SettingsViewModel(authRepository),
      initialLocation: '/',
    );

    unawaited(GoRouter.of(tester.element(find.text('HOME'))).push('/settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
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
    await _pumpSettings(tester, SettingsViewModel(authRepository));

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });
}
