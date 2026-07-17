import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:todo_flutter/ui/auth/login/widgets/login_screen.dart';
import 'package:todo_flutter/ui/auth/signup/view_models/signup_viewmodel.dart';
import 'package:todo_flutter/ui/auth/signup/widgets/signup_screen.dart';

/// Rebuilds when [authRepository] notifies so the redirect stays in sync with
/// auth state. Signup and recover-password are placeholders until their screens
/// land; `/` is the temporary authenticated home.
GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: authRepository,
    redirect: (context, state) {
      final loggedIn = authRepository.isAuthenticated;
      final inAuthArea = {
        Routes.login,
        Routes.signup,
        Routes.recoverPassword,
      }.contains(state.matchedLocation);

      if (!loggedIn) return inAuthArea ? null : Routes.login;
      if (inAuthArea) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) =>
            LoginScreen(viewModel: LoginViewModel(context.read())),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) =>
            SignupScreen(viewModel: SignupViewModel(context.read())),
      ),
      GoRoute(
        path: Routes.recoverPassword,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}
