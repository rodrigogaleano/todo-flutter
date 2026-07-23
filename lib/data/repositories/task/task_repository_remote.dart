import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/data/repositories/task/task_repository.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/domain/models/task/task.dart';

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
}
