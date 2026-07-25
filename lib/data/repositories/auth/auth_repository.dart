import 'package:flutter/foundation.dart';
import 'package:todo_flutter/domain/auth/reauth_outcome.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  bool get isAuthenticated;

  String? get currentUserId;

  String? get currentUserDisplayName;

  String? get currentUserEmail;

  SignInMethod get signInMethod;

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

  Future<Result<ReauthOutcome>> reauthenticateWithPassword(String password);

  Future<Result<ReauthOutcome>> reauthenticateWithGoogle();

  Future<Result<void>> deleteAccount();
}
