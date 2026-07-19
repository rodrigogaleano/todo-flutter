import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/routing/router.dart';
import 'package:todo_flutter/routing/routes.dart';

void main() {
  group('authRedirect (signed out)', () {
    test('sends a protected route to login', () {
      expect(
        authRedirect(isAuthenticated: false, location: Routes.home),
        Routes.login,
      );
    });

    test('stays on the auth screens', () {
      for (final location in [
        Routes.login,
        Routes.signup,
        Routes.recoverPassword,
      ]) {
        expect(
          authRedirect(isAuthenticated: false, location: location),
          isNull,
        );
      }
    });
  });

  group('authRedirect (signed in)', () {
    test('sends the auth screens back home', () {
      for (final location in [
        Routes.login,
        Routes.signup,
        Routes.recoverPassword,
      ]) {
        expect(
          authRedirect(isAuthenticated: true, location: location),
          Routes.home,
        );
      }
    });

    test('stays on a protected route', () {
      expect(
        authRedirect(isAuthenticated: true, location: Routes.home),
        isNull,
      );
    });
  });
}
