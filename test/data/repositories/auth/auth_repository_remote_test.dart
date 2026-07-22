import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository_remote.dart';
import 'package:todo_flutter/data/services/auth_service.dart';
import 'package:todo_flutter/utils/result.dart';

class FakeAuthService implements AuthService {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Result<void> result = const Result.ok(null);

  void emitAuthState({required bool value}) => _controller.add(value);

  @override
  Stream<bool> get authStateChanges => _controller.stream;

  @override
  Future<Result<void>> signIn({
    required String email,
    required String password,
  }) async => result;

  @override
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) async => result;

  @override
  Future<Result<void>> signInWithGoogle() async => result;

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async =>
      result;

  @override
  Future<Result<void>> signOut() async => result;

  Future<void> dispose() => _controller.close();
}

void main() {
  late FakeAuthService service;
  late AuthRepositoryRemote repository;

  setUp(() {
    service = FakeAuthService();
    repository = AuthRepositoryRemote(service);
  });

  tearDown(() async {
    repository.dispose();
    await service.dispose();
  });

  group('actions forward the service Result', () {
    test('login returns Ok on success', () async {
      final result = await repository.login(email: 'a@b.com', password: 'pw');
      expect(result, isA<Ok<void>>());
    });

    test('login returns Error when the service fails', () async {
      service.result = Result.error(Exception('bad credentials'));
      final result = await repository.login(email: 'a@b.com', password: 'pw');
      expect(result, isA<Error<void>>());
    });

    test('register returns Error when the service fails', () async {
      service.result = Result.error(Exception('email in use'));
      final result = await repository.register(
        name: 'Rodrigo',
        email: 'a@b.com',
        password: 'pw',
      );
      expect(result, isA<Error<void>>());
    });

    test('sendPasswordReset returns Ok on success', () async {
      final result = await repository.sendPasswordReset(email: 'a@b.com');
      expect(result, isA<Ok<void>>());
    });

    test('logout returns Ok on success', () async {
      final result = await repository.logout();
      expect(result, isA<Ok<void>>());
    });

    test('loginWithGoogle forwards the service result', () async {
      expect(await repository.loginWithGoogle(), isA<Ok<void>>());

      service.result = Result.error(Exception('google failed'));
      expect(await repository.loginWithGoogle(), isA<Error<void>>());
    });
  });

  group('auth state', () {
    test('starts unauthenticated', () {
      expect(repository.isAuthenticated, isFalse);
    });

    test('reflects the service stream and notifies listeners', () async {
      var notifications = 0;
      repository.addListener(() => notifications++);

      service.emitAuthState(value: true);
      await Future<void>.delayed(Duration.zero);

      expect(repository.isAuthenticated, isTrue);
      expect(notifications, 1);
    });

    test('does not notify when the state is unchanged', () async {
      var notifications = 0;
      repository.addListener(() => notifications++);

      service
        ..emitAuthState(value: false)
        ..emitAuthState(value: false);
      await Future<void>.delayed(Duration.zero);

      expect(repository.isAuthenticated, isFalse);
      expect(notifications, 0);
    });
  });
}
