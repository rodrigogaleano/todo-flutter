import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/utils/result.dart';

/// Wraps [FirebaseAuth], exposing auth state and turning calls into [Result].
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  Future<Result<void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      await _auth.signInWithProvider(GoogleAuthProvider());
      return const Result.ok(null);
    } on FirebaseAuthException catch (error) {
      // User dismissing the OAuth sheet is not a failure to surface.
      if (error.code == 'canceled' || error.code == 'web-context-canceled') {
        return const Result.ok(null);
      }
      return Result.error(error);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
