import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/ui/settings/settings_viewmodel.dart';

import '../../utils/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeSettingsRepository settingsRepository;
  late SettingsViewModel viewModel;

  setUp(() {
    authRepository = FakeAuthRepository();
    settingsRepository = FakeSettingsRepository();
    viewModel = SettingsViewModel(authRepository, settingsRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('logout forwards to the auth repository', () async {
    await viewModel.logout.execute();
    expect(authRepository.logoutCallCount, 1);
  });

  test('derives the avatar initials from the display name', () {
    authRepository.currentUserDisplayNameValue = 'Rodrigo Galeano';
    expect(viewModel.avatarInitials, 'RG');
  });

  test('user name falls back to the email local part', () {
    authRepository
      ..currentUserDisplayNameValue = null
      ..currentUserEmailValue = 'rodrigo1galeano@example.com';
    expect(viewModel.userName, 'rodrigo1galeano');
  });

  test('exposes the trimmed email', () {
    authRepository.currentUserEmailValue = '  rodrigo@example.com  ';
    expect(viewModel.userEmail, 'rodrigo@example.com');
  });

  test('locale reflects the settings repository', () async {
    expect(viewModel.locale, isNull);
    await settingsRepository.setLocale(const Locale('es'));
    expect(viewModel.locale, const Locale('es'));
  });

  test('setLocale forwards to the settings repository', () async {
    await viewModel.setLocale(const Locale('de'));
    expect(settingsRepository.setLocaleCalls, [const Locale('de')]);
  });

  test('themeMode reflects the settings repository', () async {
    expect(viewModel.themeMode, ThemeMode.system);
    await settingsRepository.setThemeMode(ThemeMode.dark);
    expect(viewModel.themeMode, ThemeMode.dark);
  });

  test('setThemeMode forwards to the settings repository', () async {
    await viewModel.setThemeMode(ThemeMode.light);
    expect(settingsRepository.setThemeModeCalls, [ThemeMode.light]);
  });

  test('notifies listeners when the settings repository changes', () async {
    var notified = 0;
    viewModel.addListener(() => notified++);
    await settingsRepository.setLocale(const Locale('en'));
    expect(notified, 1);
  });
}
