import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/ui/settings/settings_viewmodel.dart';

import '../../utils/fakes.dart';

void main() {
  late FakeAuthRepository authRepository;
  late SettingsViewModel viewModel;

  setUp(() {
    authRepository = FakeAuthRepository();
    viewModel = SettingsViewModel(authRepository);
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
}
