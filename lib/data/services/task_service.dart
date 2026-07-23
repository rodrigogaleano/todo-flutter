import 'package:todo_flutter/domain/models/task/task.dart';

abstract interface class TaskService {
  Stream<List<Task>> watchTasks(String userId);

  Future<void> createTask(String userId, String title);

  Future<void> setTaskDone(
    String userId,
    String taskId, {
    required bool isDone,
  });

  Future<void> deleteTask(String userId, String taskId);
}
