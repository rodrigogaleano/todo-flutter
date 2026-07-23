abstract interface class SettingsService {
  String? get localeCode;

  Future<void> setLocaleCode(String? code);

  String? get themeMode;

  Future<void> setThemeMode(String? mode);
}
