import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/ui/home/home_viewmodel.dart';

import '../../utils/fakes.dart';

Task _task(String id, {bool isDone = false}) =>
    Task(id: id, title: 'Task $id', isDone: isDone, createdAt: DateTime(2026));

void main() {
  late FakeTaskRepository taskRepository;
  late FakeAuthRepository authRepository;
  late HomeViewModel viewModel;

  setUp(() {
    taskRepository = FakeTaskRepository();
    authRepository = FakeAuthRepository();
    viewModel = HomeViewModel(taskRepository, authRepository);
  });

  tearDown(() async {
    viewModel.dispose();
    await taskRepository.dispose();
  });

  test('starts loading with no tasks', () {
    expect(viewModel.isLoading, isTrue);
    expect(viewModel.tasks, isEmpty);
    expect(viewModel.hasError, isFalse);
  });

  test('exposes the tasks emitted by the repository', () async {
    final tasks = [_task('1'), _task('2', isDone: true)];
    taskRepository.emit(tasks);
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.tasks, tasks);
    expect(viewModel.openTaskCount, 1);
  });

  test('flags an error when the stream fails', () async {
    taskRepository.emitError(Exception('boom'));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.hasError, isTrue);
  });

  test('derives the avatar initials from the display name', () {
    authRepository.currentUserDisplayNameValue = 'Rodrigo Galeano';
    expect(viewModel.avatarInitials, 'RG');
  });

  test('falls back to the email initial when there is no display name', () {
    authRepository
      ..currentUserDisplayNameValue = null
      ..currentUserEmailValue = 'rodrigo@example.com';
    expect(viewModel.avatarInitials, 'R');
  });

  test('user name uses the display name, then the email local part', () {
    authRepository
      ..currentUserDisplayNameValue = 'Rodrigo Galeano'
      ..currentUserEmailValue = 'rodrigo1galeano@example.com';
    expect(viewModel.userName, 'Rodrigo Galeano');

    authRepository.currentUserDisplayNameValue = null;
    expect(viewModel.userName, 'rodrigo1galeano');
  });

  test('logout forwards to the auth repository', () async {
    await viewModel.logout.execute();
    expect(authRepository.logoutCallCount, 1);
  });
}
