import 'package:todo_flutter/domain/auth/auth_failure.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

String authErrorMessage(AppLocalizations l10n, Object? error) {
  final failure = error is AuthException ? error.failure : AuthFailure.unknown;
  return switch (failure) {
    AuthFailure.invalidCredentials => l10n.authErrorInvalidCredentials,
    AuthFailure.emailAlreadyInUse => l10n.authErrorEmailInUse,
    AuthFailure.invalidEmail => l10n.authErrorInvalidEmail,
    AuthFailure.weakPassword => l10n.authErrorWeakPassword,
    AuthFailure.userNotFound => l10n.authErrorUserNotFound,
    AuthFailure.userDisabled => l10n.authErrorUserDisabled,
    AuthFailure.networkError => l10n.authErrorNetwork,
    AuthFailure.tooManyRequests => l10n.authErrorTooManyRequests,
    AuthFailure.unknown => l10n.authErrorUnknown,
  };
}
