import 'package:flutter/foundation.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/result.dart';

class FakeAuthRepository extends ChangeNotifier implements AuthRepository {
  Result<void> loginResult = const Result.ok(null);
  int loginCallCount = 0;
  bool _isAuthenticated = false;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    loginCallCount++;
    if (loginResult is Ok) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return loginResult;
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> sendPasswordReset({required String email}) async =>
      const Result.ok(null);

  @override
  Future<Result<void>> logout() async => const Result.ok(null);
}
