enum AuthFailure {
  invalidCredentials,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  userNotFound,
  userDisabled,
  networkError,
  tooManyRequests,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure);

  final AuthFailure failure;

  @override
  String toString() => 'AuthException(${failure.name})';
}
