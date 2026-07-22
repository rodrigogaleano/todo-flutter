import 'package:todo_flutter/l10n/generated/app_localizations.dart';

typedef Validator = String? Function(String?);

abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static Validator required(String message) {
    return (value) => (value == null || value.trim().isEmpty) ? message : null;
  }

  static Validator email(AppLocalizations l10n) {
    return (value) {
      final email = value?.trim() ?? '';
      if (email.isEmpty) return l10n.validationEmailRequired;
      if (!_emailPattern.hasMatch(email)) return l10n.validationEmailInvalid;
      return null;
    };
  }

  static Validator password(AppLocalizations l10n, {int? minLength}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return l10n.validationPasswordRequired;
      }
      if (minLength != null && value.length < minLength) {
        return l10n.validationPasswordMin;
      }
      return null;
    };
  }
}
