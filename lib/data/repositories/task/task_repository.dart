import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/result.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchTasks();

  Future<Result<void>> createTask(String title);

  Future<Result<void>> setTaskDone(String taskId, {required bool isDone});

  Future<Result<void>> deleteTask(String taskId);
}
