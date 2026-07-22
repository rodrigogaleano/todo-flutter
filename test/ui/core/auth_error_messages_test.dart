import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/domain/auth/auth_failure.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/core/auth_error_messages.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  test('maps each AuthFailure to a distinct message', () {
    final messages = {
      for (final failure in AuthFailure.values)
        authErrorMessage(l10n, AuthException(failure)),
    };
    expect(messages.length, AuthFailure.values.length);
  });

  test('maps a known failure to its message', () {
    expect(
      authErrorMessage(l10n, const AuthException(AuthFailure.userNotFound)),
      l10n.authErrorUserNotFound,
    );
  });

  test('falls back to the generic message for non-AuthException', () {
    expect(
      authErrorMessage(l10n, Exception('raw')),
      l10n.authErrorUnknown,
    );
  });
}
