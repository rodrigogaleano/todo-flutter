import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/command.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._taskRepository, this._authRepository) {
    logout = Command0(_authRepository.logout);
    _subscription = _taskRepository.watchTasks().listen(
      _onTasks,
      onError: _onError,
    );
  }

  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  late final Command0<void> logout;
  late final StreamSubscription<List<Task>> _subscription;

  List<Task> _tasks = const [];
  List<Task> get tasks => _tasks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  int get openTaskCount => _tasks.where((task) => !task.isDone).length;

  String get avatarInitials {
    final name = _authRepository.currentUserDisplayName?.trim() ?? '';
    if (name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      final first = parts.first[0];
      final last = parts.length > 1 ? parts.last[0] : '';
      return (first + last).toUpperCase();
    }
    final email = _authRepository.currentUserEmail?.trim() ?? '';
    if (email.isNotEmpty) return email[0].toUpperCase();
    return '?';
  }

  void _onTasks(List<Task> tasks) {
    _tasks = tasks;
    _isLoading = false;
    _hasError = false;
    notifyListeners();
  }

  void _onError(Object error, StackTrace stackTrace) {
    _isLoading = false;
    _hasError = true;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    logout.dispose();
    super.dispose();
  }
}
