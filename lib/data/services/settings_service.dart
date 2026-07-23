abstract interface class SettingsService {
  String? get localeCode;

  Future<void> setLocaleCode(String? code);
}
