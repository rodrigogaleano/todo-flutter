import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository_local.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class _FakeSettingsService implements SettingsService {
  _FakeSettingsService([this._code, this._themeMode]);

  String? _code;
  String? _themeMode;
  final List<String?> setLocaleCodeCalls = [];
  final List<String?> setThemeModeCalls = [];

  @override
  String? get localeCode => _code;

  @override
  Future<void> setLocaleCode(String? code) async {
    setLocaleCodeCalls.add(code);
    _code = code;
  }

  @override
  String? get themeMode => _themeMode;

  @override
  Future<void> setThemeMode(String? mode) async {
    setThemeModeCalls.add(mode);
    _themeMode = mode;
  }
}

void main() {
  test('reads the initial locale from the service', () {
    final repository = SettingsRepositoryLocal(
      _FakeSettingsService('pt'),
    );
    expect(repository.locale, const Locale('pt'));
  });

  test('has no explicit locale when nothing is stored', () {
    final repository = SettingsRepositoryLocal(_FakeSettingsService());
    expect(repository.locale, isNull);
  });

  test('setLocale updates, persists and notifies', () async {
    final service = _FakeSettingsService();
    final repository = SettingsRepositoryLocal(service);
    var notified = 0;
    repository.addListener(() => notified++);

    await repository.setLocale(const Locale('de'));

    expect(repository.locale, const Locale('de'));
    expect(service.setLocaleCodeCalls, ['de']);
    expect(notified, 1);
  });

  test('setLocale(null) clears the stored code', () async {
    final service = _FakeSettingsService('es');
    final repository = SettingsRepositoryLocal(service);

    await repository.setLocale(null);

    expect(repository.locale, isNull);
    expect(service.setLocaleCodeCalls, [null]);
  });

  test('setLocale is a no-op when the locale is unchanged', () async {
    final service = _FakeSettingsService('pt');
    final repository = SettingsRepositoryLocal(service);
    var notified = 0;
    repository.addListener(() => notified++);

    await repository.setLocale(const Locale('pt'));

    expect(service.setLocaleCodeCalls, isEmpty);
    expect(notified, 0);
  });

  test('defaults to system theme when nothing is stored', () {
    final repository = SettingsRepositoryLocal(_FakeSettingsService());
    expect(repository.themeMode, ThemeMode.system);
  });

  test('reads the initial theme mode from the service', () {
    final repository = SettingsRepositoryLocal(
      _FakeSettingsService(null, 'dark'),
    );
    expect(repository.themeMode, ThemeMode.dark);
  });

  test('setThemeMode updates, persists and notifies', () async {
    final service = _FakeSettingsService();
    final repository = SettingsRepositoryLocal(service);
    var notified = 0;
    repository.addListener(() => notified++);

    await repository.setThemeMode(ThemeMode.dark);

    expect(repository.themeMode, ThemeMode.dark);
    expect(service.setThemeModeCalls, ['dark']);
    expect(notified, 1);
  });

  test('setThemeMode(system) clears the stored value', () async {
    final service = _FakeSettingsService(null, 'light');
    final repository = SettingsRepositoryLocal(service);

    await repository.setThemeMode(ThemeMode.system);

    expect(repository.themeMode, ThemeMode.system);
    expect(service.setThemeModeCalls, [null]);
  });
}
