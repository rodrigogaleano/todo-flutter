import 'package:todo_flutter/domain/models/task/task.dart';

abstract interface class TaskService {
  Stream<List<Task>> watchTasks(String userId);
}
