import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class SettingsServiceSharedPreferences implements SettingsService {
  SettingsServiceSharedPreferences(this._prefs);

  static const _localeKey = 'settings.locale';
  static const _themeModeKey = 'settings.themeMode';

  final SharedPreferences _prefs;

  @override
  String? get localeCode => _prefs.getString(_localeKey);

  @override
  Future<void> setLocaleCode(String? code) => _writeOrRemove(_localeKey, code);

  @override
  String? get themeMode => _prefs.getString(_themeModeKey);

  @override
  Future<void> setThemeMode(String? mode) =>
      _writeOrRemove(_themeModeKey, mode);

  Future<void> _writeOrRemove(String key, String? value) async {
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, value);
    }
  }
}
