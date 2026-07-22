import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/core/validators.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('required', () {
    final validate = Validators.required('required');

    test('rejects null, empty, and whitespace', () {
      expect(validate(null), 'required');
      expect(validate(''), 'required');
      expect(validate('   '), 'required');
    });

    test('accepts non-empty', () {
      expect(validate('Rodrigo'), isNull);
    });
  });

  group('email', () {
    late Validator validate;
    setUp(() => validate = Validators.email(l10n));

    test('rejects empty', () {
      expect(validate(''), l10n.validationEmailRequired);
    });

    test('rejects malformed', () {
      expect(validate('nope'), l10n.validationEmailInvalid);
      expect(validate('a@b'), l10n.validationEmailInvalid);
    });

    test('accepts a valid email', () {
      expect(validate('a@b.com'), isNull);
    });
  });

  group('password', () {
    test('rejects empty', () {
      expect(
        Validators.password(l10n)(''),
        l10n.validationPasswordRequired,
      );
    });

    test('enforces the minimum length when given', () {
      final validate = Validators.password(l10n, minLength: 6);
      expect(validate('12345'), l10n.validationPasswordMin);
      expect(validate('123456'), isNull);
    });

    test('ignores length when no minimum is given', () {
      expect(Validators.password(l10n)('1'), isNull);
    });
  });
}
