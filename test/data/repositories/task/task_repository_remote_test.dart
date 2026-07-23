import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/repositories/task/task_repository_remote.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/domain/models/task/task.dart';

import '../../../utils/fakes.dart';

class FakeTaskService implements TaskService {
  String? lastUserId;
  Stream<List<Task>> stream = Stream<List<Task>>.value(const <Task>[]);

  @override
  Stream<List<Task>> watchTasks(String userId) {
    lastUserId = userId;
    return stream;
  }
}

void main() {
  late FakeTaskService taskService;
  late FakeAuthRepository authRepository;
  late TaskRepositoryRemote repository;

  setUp(() {
    taskService = FakeTaskService();
    authRepository = FakeAuthRepository();
    repository = TaskRepositoryRemote(taskService, authRepository);
  });

  test('scopes the stream to the current user id', () {
    authRepository.currentUserIdValue = 'user-42';

    repository.watchTasks();

    expect(taskService.lastUserId, 'user-42');
  });

  test('emits the tasks coming from the service', () {
    authRepository.currentUserIdValue = 'user-42';
    final tasks = [
      Task(id: '1', title: 'A', isDone: false, createdAt: DateTime(2026)),
    ];
    taskService.stream = Stream<List<Task>>.value(tasks);

    expect(repository.watchTasks(), emits(tasks));
  });

  test('emits an empty list when there is no signed-in user', () {
    authRepository.currentUserIdValue = null;

    expect(repository.watchTasks(), emits(isEmpty));
    expect(taskService.lastUserId, isNull);
  });
}
