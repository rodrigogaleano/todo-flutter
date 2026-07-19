import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/data/services/auth_service.dart';
import 'package:todo_flutter/domain/auth/auth_failure.dart';
import 'package:todo_flutter/utils/result.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static const _cancelCodes = {'canceled', 'web-context-canceled'};

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  Future<Result<void>> signIn({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _auth.signInWithEmailAndPassword(email: email, password: password),
    );
  }

  @override
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
    });
  }

  @override
  Future<Result<void>> signInWithGoogle() {
    return _guard(
      () => _auth.signInWithProvider(GoogleAuthProvider()),
      ignoreCodes: _cancelCodes,
    );
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) {
    return _guard(() => _auth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<Result<void>> signOut() => _guard(_auth.signOut);

  Future<Result<void>> _guard(
    Future<void> Function() action, {
    Set<String> ignoreCodes = const {},
  }) async {
    try {
      await action();
      return const Result.ok(null);
    } on FirebaseAuthException catch (error) {
      if (ignoreCodes.contains(error.code)) return const Result.ok(null);
      return Result.error(AuthException(_mapCode(error.code)));
    } on Exception {
      return const Result.error(AuthException(AuthFailure.unknown));
    }
  }

  AuthFailure _mapCode(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
        return AuthFailure.invalidCredentials;
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse;
      case 'invalid-email':
        return AuthFailure.invalidEmail;
      case 'weak-password':
        return AuthFailure.weakPassword;
      case 'user-not-found':
        return AuthFailure.userNotFound;
      case 'user-disabled':
        return AuthFailure.userDisabled;
      case 'network-request-failed':
        return AuthFailure.networkError;
      case 'too-many-requests':
        return AuthFailure.tooManyRequests;
      default:
        return AuthFailure.unknown;
    }
  }
}
