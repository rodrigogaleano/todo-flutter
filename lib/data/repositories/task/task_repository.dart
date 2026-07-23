import 'package:todo_flutter/domain/models/task/task.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchTasks();
}
