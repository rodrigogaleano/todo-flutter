import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/repositories/task/task_repository_remote.dart';
import 'package:todo_flutter/data/services/task_service.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

class FakeTaskService implements TaskService {
  String? lastUserId;
  Stream<List<Task>> stream = Stream<List<Task>>.value(const <Task>[]);

  final List<(String, String)> createCalls = [];
  final List<(String, String, bool)> setDoneCalls = [];
  final List<(String, String)> deleteCalls = [];
  Exception? throwError;

  @override
  Stream<List<Task>> watchTasks(String userId) {
    lastUserId = userId;
    return stream;
  }

  @override
  Future<void> createTask(String userId, String title) async {
    if (throwError != null) throw throwError!;
    createCalls.add((userId, title));
  }

  @override
  Future<void> setTaskDone(
    String userId,
    String taskId, {
    required bool isDone,
  }) async {
    if (throwError != null) throw throwError!;
    setDoneCalls.add((userId, taskId, isDone));
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    if (throwError != null) throw throwError!;
    deleteCalls.add((userId, taskId));
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

  group('createTask', () {
    test('forwards the title scoped to the current user', () async {
      authRepository.currentUserIdValue = 'user-42';

      final result = await repository.createTask('Buy milk');

      expect(result, isA<Ok<void>>());
      expect(taskService.createCalls, [('user-42', 'Buy milk')]);
    });

    test('returns an error when there is no signed-in user', () async {
      authRepository.currentUserIdValue = null;

      final result = await repository.createTask('Buy milk');

      expect(result, isA<Error<void>>());
      expect(taskService.createCalls, isEmpty);
    });

    test('returns an error when the service throws', () async {
      authRepository.currentUserIdValue = 'user-42';
      taskService.throwError = Exception('boom');

      final result = await repository.createTask('Buy milk');

      expect(result, isA<Error<void>>());
    });
  });

  group('setTaskDone', () {
    test('forwards the id and flag scoped to the current user', () async {
      authRepository.currentUserIdValue = 'user-42';

      final result = await repository.setTaskDone('task-1', isDone: true);

      expect(result, isA<Ok<void>>());
      expect(taskService.setDoneCalls, [('user-42', 'task-1', true)]);
    });

    test('returns an error when there is no signed-in user', () async {
      authRepository.currentUserIdValue = null;

      final result = await repository.setTaskDone('task-1', isDone: true);

      expect(result, isA<Error<void>>());
      expect(taskService.setDoneCalls, isEmpty);
    });
  });

  group('deleteTask', () {
    test('forwards the id scoped to the current user', () async {
      authRepository.currentUserIdValue = 'user-42';

      final result = await repository.deleteTask('task-1');

      expect(result, isA<Ok<void>>());
      expect(taskService.deleteCalls, [('user-42', 'task-1')]);
    });

    test('returns an error when there is no signed-in user', () async {
      authRepository.currentUserIdValue = null;

      final result = await repository.deleteTask('task-1');

      expect(result, isA<Error<void>>());
      expect(taskService.deleteCalls, isEmpty);
    });
  });
}
