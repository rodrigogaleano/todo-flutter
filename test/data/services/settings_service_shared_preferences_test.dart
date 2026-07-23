import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/data/services/settings_service_shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns null when no locale is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = SettingsServiceSharedPreferences(prefs);

    expect(service.localeCode, isNull);
  });

  test('persists and reads back the locale code', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = SettingsServiceSharedPreferences(prefs);

    await service.setLocaleCode('es');
    expect(service.localeCode, 'es');

    await service.setLocaleCode(null);
    expect(service.localeCode, isNull);
  });

  test('persists and reads back the theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = SettingsServiceSharedPreferences(prefs);

    expect(service.themeMode, isNull);

    await service.setThemeMode('dark');
    expect(service.themeMode, 'dark');

    await service.setThemeMode(null);
    expect(service.themeMode, isNull);
  });
}
