import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository_remote.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository_remote.dart';
import 'package:todo_flutter/data/services/auth_service.dart';
import 'package:todo_flutter/data/services/firebase_auth_service.dart';
import 'package:todo_flutter/data/services/firestore_task_service.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/routing/router.dart';

List<SingleChildWidget> get providers {
  return [
    Provider<AuthService>(create: (context) => FirebaseAuthService()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthRepositoryRemote(context.read()) as AuthRepository,
    ),
    Provider<TaskService>(create: (context) => FirestoreTaskService()),
    Provider<TaskRepository>(
      create: (context) => TaskRepositoryRemote(
        context.read<TaskService>(),
        context.read<AuthRepository>(),
      ),
    ),
    Provider(
      create: (context) => router(context.read<AuthRepository>()),
      dispose: (_, goRouter) => goRouter.dispose(),
    ),
  ];
}
