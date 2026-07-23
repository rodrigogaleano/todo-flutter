import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository_local.dart';
import 'package:todo_flutter/data/services/settings_service.dart';

class _FakeSettingsService implements SettingsService {
  _FakeSettingsService([this._code]);

  String? _code;
  final List<String?> setLocaleCodeCalls = [];

  @override
  String? get localeCode => _code;

  @override
  Future<void> setLocaleCode(String? code) async {
    setLocaleCodeCalls.add(code);
    _code = code;
  }
}

void main() {
  test('reads the initial locale from the service', () {
    final repository = SettingsRepositoryLocal(_FakeSettingsService('pt'));
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
}
