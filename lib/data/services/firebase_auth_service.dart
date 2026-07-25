import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_flutter/data/services/auth_service.dart';
import 'package:todo_flutter/domain/auth/auth_failure.dart';
import 'package:todo_flutter/domain/auth/reauth_outcome.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/utils/result.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<void>? _googleInitialization;

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  String? get currentUserDisplayName => _auth.currentUser?.displayName;

  @override
  String? get currentUserEmail => _auth.currentUser?.email;

  @override
  SignInMethod get signInMethod {
    final providers = _auth.currentUser?.providerData ?? const [];
    final isGoogle = providers.any((info) => info.providerId == 'google.com');
    return isGoogle ? SignInMethod.google : SignInMethod.password;
  }

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
  Future<Result<void>> signInWithGoogle() async {
    try {
      final credential = await _googleCredential();
      await _auth.signInWithCredential(credential);
      return const Result.ok(null);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const Result.ok(null);
      }
      return const Result.error(AuthException(AuthFailure.unknown));
    } on FirebaseAuthException catch (error) {
      return Result.error(AuthException(_mapCode(error.code)));
    } on Exception {
      return const Result.error(AuthException(AuthFailure.unknown));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) {
    return _guard(() => _auth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<Result<void>> signOut() => _guard(_auth.signOut);

  @override
  Future<Result<ReauthOutcome>> reauthenticateWithPassword(
    String password,
  ) async {
    try {
      final user = _auth.currentUser;
      final email = user?.email;
      if (user == null || email == null) {
        return const Result.error(AuthException(AuthFailure.userNotFound));
      }
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return const Result.ok(ReauthOutcome.reauthenticated);
    } on FirebaseAuthException catch (error) {
      return Result.error(AuthException(_mapCode(error.code)));
    } on Exception {
      return const Result.error(AuthException(AuthFailure.unknown));
    }
  }

  @override
  Future<Result<ReauthOutcome>> reauthenticateWithGoogle() async {
    try {
      final credential = await _googleCredential();
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      return const Result.ok(ReauthOutcome.reauthenticated);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const Result.ok(ReauthOutcome.cancelled);
      }
      return const Result.error(AuthException(AuthFailure.unknown));
    } on FirebaseAuthException catch (error) {
      return Result.error(AuthException(_mapCode(error.code)));
    } on Exception {
      return const Result.error(AuthException(AuthFailure.unknown));
    }
  }

  @override
  Future<Result<void>> deleteAccount() {
    return _guard(() async {
      final user = _auth.currentUser;
      if (user == null) throw FirebaseAuthException(code: 'user-not-found');
      await user.delete();
    });
  }

  Future<AuthCredential> _googleCredential() async {
    await (_googleInitialization ??= GoogleSignIn.instance.initialize());
    final account = await GoogleSignIn.instance.authenticate();
    return GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
  }

  Future<Result<void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Result.ok(null);
    } on FirebaseAuthException catch (error) {
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
      case 'requires-recent-login':
        return AuthFailure.requiresRecentLogin;
      default:
        return AuthFailure.unknown;
    }
  }
}
