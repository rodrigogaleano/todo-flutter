import 'package:flutter/material.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/domain/auth/reauth_outcome.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/ui/core/user_display.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(
    this._authRepository,
    this._settingsRepository,
    this._taskRepository,
  ) {
    logout = Command0(_authRepository.logout);
    deleteAccount = Command0(_deleteAccount);
    _settingsRepository.addListener(notifyListeners);
  }

  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;

  late final Command0<void> logout;
  late final Command0<void> deleteAccount;

  Locale? get locale => _settingsRepository.locale;

  Future<void> setLocale(Locale locale) =>
      _settingsRepository.setLocale(locale);

  ThemeMode get themeMode => _settingsRepository.themeMode;

  Future<void> setThemeMode(ThemeMode mode) =>
      _settingsRepository.setThemeMode(mode);

  SignInMethod get signInMethod => _authRepository.signInMethod;

  Future<Result<ReauthOutcome>> reauthenticateWithPassword(String password) =>
      _authRepository.reauthenticateWithPassword(password);

  Future<Result<ReauthOutcome>> reauthenticateWithGoogle() =>
      _authRepository.reauthenticateWithGoogle();

  Future<Result<void>> _deleteAccount() async {
    final tasks = await _taskRepository.deleteAllTasks();
    if (tasks is Error<void>) return tasks;
    return _authRepository.deleteAccount();
  }

  String get avatarInitials => UserDisplay.initials(
    _authRepository.currentUserDisplayName,
    _authRepository.currentUserEmail,
  );

  String get userName => UserDisplay.name(
    _authRepository.currentUserDisplayName,
    _authRepository.currentUserEmail,
  );

  String get userEmail => UserDisplay.email(_authRepository.currentUserEmail);

  @override
  void dispose() {
    _settingsRepository.removeListener(notifyListeners);
    logout.dispose();
    deleteAccount.dispose();
    super.dispose();
  }
}
