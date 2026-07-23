import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/domain/auth/reauth_outcome.dart';
import 'package:todo_flutter/domain/auth/sign_in_method.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/result.dart';

class FakeAuthRepository extends ChangeNotifier implements AuthRepository {
  Result<void> loginResult = const Result.ok(null);
  Result<void> registerResult = const Result.ok(null);
  Result<void> loginWithGoogleResult = const Result.ok(null);
  Result<void> sendPasswordResetResult = const Result.ok(null);
  Result<ReauthOutcome> reauthenticateWithPasswordResult = const Result.ok(
    ReauthOutcome.reauthenticated,
  );
  Result<ReauthOutcome> reauthenticateWithGoogleResult = const Result.ok(
    ReauthOutcome.reauthenticated,
  );
  Result<void> deleteAccountResult = const Result.ok(null);
  int loginCallCount = 0;
  int registerCallCount = 0;
  int loginWithGoogleCallCount = 0;
  int sendPasswordResetCallCount = 0;
  int logoutCallCount = 0;
  int reauthenticateWithGoogleCallCount = 0;
  int deleteAccountCallCount = 0;
  final List<String> reauthenticateWithPasswordCalls = [];
  bool _isAuthenticated = false;
  String? currentUserIdValue = 'user-1';
  String? currentUserDisplayNameValue;
  String? currentUserEmailValue;
  SignInMethod signInMethodValue = SignInMethod.password;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get currentUserId => currentUserIdValue;

  @override
  String? get currentUserDisplayName => currentUserDisplayNameValue;

  @override
  String? get currentUserEmail => currentUserEmailValue;

  @override
  SignInMethod get signInMethod => signInMethodValue;

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

  @override
  Future<Result<ReauthOutcome>> reauthenticateWithPassword(
    String password,
  ) async {
    reauthenticateWithPasswordCalls.add(password);
    return reauthenticateWithPasswordResult;
  }

  @override
  Future<Result<ReauthOutcome>> reauthenticateWithGoogle() async {
    reauthenticateWithGoogleCallCount++;
    return reauthenticateWithGoogleResult;
  }

  @override
  Future<Result<void>> deleteAccount() async {
    deleteAccountCallCount++;
    return deleteAccountResult;
  }
}

class FakeTaskRepository implements TaskRepository {
  final StreamController<List<Task>> _controller =
      StreamController<List<Task>>.broadcast();

  Result<void> createTaskResult = const Result.ok(null);
  Result<void> setTaskDoneResult = const Result.ok(null);
  Result<void> deleteTaskResult = const Result.ok(null);
  Result<void> deleteAllTasksResult = const Result.ok(null);

  final List<String> createdTitles = [];
  final List<(String, bool)> setDoneCalls = [];
  final List<String> deletedIds = [];
  int deleteAllTasksCallCount = 0;

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

  @override
  Future<Result<void>> deleteAllTasks() async {
    deleteAllTasksCallCount++;
    return deleteAllTasksResult;
  }

  Future<void> dispose() => _controller.close();
}

class FakeSettingsRepository extends ChangeNotifier
    implements SettingsRepository {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  final List<Locale?> setLocaleCalls = [];
  final List<ThemeMode> setThemeModeCalls = [];

  @override
  Locale? get locale => _locale;

  @override
  Future<void> setLocale(Locale? locale) async {
    setLocaleCalls.add(locale);
    _locale = locale;
    notifyListeners();
  }

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    setThemeModeCalls.add(mode);
    _themeMode = mode;
    notifyListeners();
  }
}
