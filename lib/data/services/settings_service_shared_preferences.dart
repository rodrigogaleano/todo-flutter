import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class SettingsServiceSharedPreferences implements SettingsService {
  SettingsServiceSharedPreferences(this._prefs);

  static const _localeKey = 'settings.locale';

  final SharedPreferences _prefs;

  @override
  String? get localeCode => _prefs.getString(_localeKey);

  @override
  Future<void> setLocaleCode(String? code) async {
    if (code == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, code);
    }
  }
}
