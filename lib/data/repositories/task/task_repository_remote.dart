import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/result.dart';

class TaskRepositoryRemote implements TaskRepository {
  TaskRepositoryRemote(this._taskService, this._authRepository);

  final TaskService _taskService;
  final AuthRepository _authRepository;

  @override
  Stream<List<Task>> watchTasks() {
    final userId = _authRepository.currentUserId;
    if (userId == null) return Stream.value(const <Task>[]);
    return _taskService.watchTasks(userId);
  }

  @override
  Future<Result<void>> createTask(String title) {
    return _guard((userId) => _taskService.createTask(userId, title));
  }

  @override
  Future<Result<void>> setTaskDone(String taskId, {required bool isDone}) {
    return _guard(
      (userId) => _taskService.setTaskDone(userId, taskId, isDone: isDone),
    );
  }

  @override
  Future<Result<void>> deleteTask(String taskId) {
    return _guard((userId) => _taskService.deleteTask(userId, taskId));
  }

  Future<Result<void>> _guard(
    Future<void> Function(String userId) action,
  ) async {
    final userId = _authRepository.currentUserId;
    if (userId == null) {
      return Result.error(Exception('No authenticated user'));
    }
    try {
      await action(userId);
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
