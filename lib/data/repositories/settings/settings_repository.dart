import 'package:flutter/widgets.dart';

abstract class SettingsRepository extends ChangeNotifier {
  Locale? get locale;

  Future<void> setLocale(Locale? locale);
}
