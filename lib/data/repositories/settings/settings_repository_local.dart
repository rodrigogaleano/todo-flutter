import 'package:flutter/material.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class SettingsRepositoryLocal extends SettingsRepository {
  SettingsRepositoryLocal(this._service) {
    final code = _service.localeCode;
    _locale = code == null ? null : Locale(code);
    _themeMode = _parseThemeMode(_service.themeMode);
  }

  final SettingsService _service;

  Locale? _locale;
  late ThemeMode _themeMode;

  @override
  Locale? get locale => _locale;

  @override
  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    await _service.setLocaleCode(locale?.languageCode);
  }

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _service.setThemeMode(mode == ThemeMode.system ? null : mode.name);
  }

  ThemeMode _parseThemeMode(String? name) {
    return switch (name) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
