import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/routing/routes.dart';

/// Rebuilds when [authRepository] notifies, so the auth redirect (added later)
/// stays in sync. For now the single route renders a placeholder.
GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: authRepository,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}
