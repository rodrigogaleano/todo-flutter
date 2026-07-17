import 'dart:async';

import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/services/auth_service.dart';
import 'package:todo_flutter/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote(this._authService) {
    _subscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  final AuthService _authService;
  late final StreamSubscription<bool> _subscription;

  bool _isAuthenticated = false;

  @override
  bool get isAuthenticated => _isAuthenticated;

  void _onAuthStateChanged(bool isAuthenticated) {
    if (isAuthenticated == _isAuthenticated) return;
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) {
    return _authService.register(email: email, password: password);
  }

  @override
  Future<Result<void>> sendPasswordReset({required String email}) {
    return _authService.sendPasswordResetEmail(email: email);
  }

  @override
  Future<Result<void>> logout() {
    return _authService.signOut();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
