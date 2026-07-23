import 'package:flutter/material.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/ui/core/user_display.dart';
import 'package:todo_flutter/utils/command.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._authRepository, this._settingsRepository) {
    logout = Command0(_authRepository.logout);
    _settingsRepository.addListener(notifyListeners);
  }

  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;

  late final Command0<void> logout;

  Locale? get locale => _settingsRepository.locale;

  Future<void> setLocale(Locale locale) =>
      _settingsRepository.setLocale(locale);

  ThemeMode get themeMode => _settingsRepository.themeMode;

  Future<void> setThemeMode(ThemeMode mode) =>
      _settingsRepository.setThemeMode(mode);

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
    super.dispose();
  }
}
