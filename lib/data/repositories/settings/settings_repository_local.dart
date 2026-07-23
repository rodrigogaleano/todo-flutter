import 'package:flutter/widgets.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class SettingsRepositoryLocal extends SettingsRepository {
  SettingsRepositoryLocal(this._service) {
    final code = _service.localeCode;
    _locale = code == null ? null : Locale(code);
  }

  final SettingsService _service;

  Locale? _locale;

  @override
  Locale? get locale => _locale;

  @override
  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    await _service.setLocaleCode(locale?.languageCode);
  }
}
