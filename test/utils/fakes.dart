import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/result.dart';

class FakeAuthRepository extends ChangeNotifier implements AuthRepository {
  Result<void> loginResult = const Result.ok(null);
  Result<void> registerResult = const Result.ok(null);
  Result<void> loginWithGoogleResult = const Result.ok(null);
  Result<void> sendPasswordResetResult = const Result.ok(null);
  int loginCallCount = 0;
  int registerCallCount = 0;
  int loginWithGoogleCallCount = 0;
  int sendPasswordResetCallCount = 0;
  int logoutCallCount = 0;
  bool _isAuthenticated = false;
  String? currentUserIdValue = 'user-1';
  String? currentUserDisplayNameValue;
  String? currentUserEmailValue;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get currentUserId => currentUserIdValue;

  @override
  String? get currentUserDisplayName => currentUserDisplayNameValue;

  @override
  String? get currentUserEmail => currentUserEmailValue;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    loginCallCount++;
    if (loginResult is Ok) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return loginResult;
  }

  @override
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    registerCallCount++;
    if (registerResult is Ok) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return registerResult;
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    loginWithGoogleCallCount++;
    if (loginWithGoogleResult is Ok) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return loginWithGoogleResult;
  }

  @override
  Future<Result<void>> sendPasswordReset({required String email}) async {
    sendPasswordResetCallCount++;
    return sendPasswordResetResult;
  }

  @override
  Future<Result<void>> logout() async {
    logoutCallCount++;
    return const Result.ok(null);
  }
}

class FakeTaskRepository implements TaskRepository {
  final StreamController<List<Task>> _controller =
      StreamController<List<Task>>.broadcast();

  Result<void> createTaskResult = const Result.ok(null);
  Result<void> setTaskDoneResult = const Result.ok(null);
  Result<void> deleteTaskResult = const Result.ok(null);

  final List<String> createdTitles = [];
  final List<(String, bool)> setDoneCalls = [];
  final List<String> deletedIds = [];

  void emit(List<Task> tasks) => _controller.add(tasks);

  void emitError(Object error) => _controller.addError(error);

  @override
  Stream<List<Task>> watchTasks() => _controller.stream;

  @override
  Future<Result<void>> createTask(String title) async {
    createdTitles.add(title);
    return createTaskResult;
  }

  @override
  Future<Result<void>> setTaskDone(
    String taskId, {
    required bool isDone,
  }) async {
    setDoneCalls.add((taskId, isDone));
    return setTaskDoneResult;
  }

  @override
  Future<Result<void>> deleteTask(String taskId) async {
    deletedIds.add(taskId);
    return deleteTaskResult;
  }

  Future<void> dispose() => _controller.close();
}
