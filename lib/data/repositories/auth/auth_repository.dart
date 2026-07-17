import 'package:flutter/foundation.dart';
import 'package:todo_flutter/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  /// Whether a user is currently signed in.
  bool get isAuthenticated;

  Future<Result<void>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> loginWithGoogle();

  Future<Result<void>> sendPasswordReset({required String email});

  Future<Result<void>> logout();
}
