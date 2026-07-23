import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/auth/login/login_screen.dart';
import 'package:todo_flutter/ui/auth/login/login_viewmodel.dart';
import 'package:todo_flutter/ui/auth/recover_password/recover_password_screen.dart';
import 'package:todo_flutter/ui/auth/recover_password/recover_password_viewmodel.dart';
import 'package:todo_flutter/ui/auth/signup/signup_screen.dart';
import 'package:todo_flutter/ui/auth/signup/signup_viewmodel.dart';
import 'package:todo_flutter/ui/home/home_screen.dart';
import 'package:todo_flutter/ui/home/home_viewmodel.dart';
import 'package:todo_flutter/ui/settings/settings_screen.dart';
import 'package:todo_flutter/ui/settings/settings_viewmodel.dart';

String? authRedirect({
  required bool isAuthenticated,
  required String location,
}) {
  const authArea = {Routes.login, Routes.signup, Routes.recoverPassword};
  final inAuthArea = authArea.contains(location);

  if (!isAuthenticated) return inAuthArea ? null : Routes.login;
  if (inAuthArea) return Routes.home;
  return null;
}

GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: authRepository,
    redirect: (context, state) => authRedirect(
      isAuthenticated: authRepository.isAuthenticated,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => HomeScreen(
          viewModel: HomeViewModel(context.read(), context.read()),
        ),
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
        builder: (context, state) => RecoverPasswordScreen(
          viewModel: RecoverPasswordViewModel(context.read()),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => SettingsScreen(
          viewModel: SettingsViewModel(context.read(), context.read()),
        ),
      ),
    ],
  );
}
