import 'package:todo_flutter/domain/auth/reauth_outcome.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/utils/result.dart';

abstract interface class AuthService {
  Stream<bool> get authStateChanges;

  String? get currentUserId;

  String? get currentUserDisplayName;

  String? get currentUserEmail;

  SignInMethod get signInMethod;

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

  Future<Result<ReauthOutcome>> reauthenticateWithPassword(String password);

  Future<Result<ReauthOutcome>> reauthenticateWithGoogle();

  Future<Result<void>> deleteAccount();
}
