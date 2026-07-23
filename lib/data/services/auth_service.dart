import 'package:todo_flutter/utils/result.dart';

abstract interface class AuthService {
  Stream<bool> get authStateChanges;

  String? get currentUserId;

  String? get currentUserDisplayName;

  Future<Result<void>> signIn({
    required String email,
    required String password,
  });

  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> signInWithGoogle();

  Future<Result<void>> sendPasswordResetEmail({required String email});

  Future<Result<void>> signOut();
}
