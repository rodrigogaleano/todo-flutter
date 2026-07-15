import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

void main() {
  group('Command0', () {
    test('starts idle with no result', () {
      final command = Command0<int>(() async => const Result.ok(1));

      expect(command.running, isFalse);
      expect(command.completed, isFalse);
      expect(command.error, isFalse);
      expect(command.result, isNull);
    });

    test('completes successfully and exposes the Ok result', () async {
      final command = Command0<int>(() async => const Result.ok(1));

      await command.execute();

      expect(command.running, isFalse);
      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect(command.result, isA<Ok<int>>());
    });

    test('captures errors and exposes the Error result', () async {
      final command = Command0<int>(
        () async => Result.error(Exception('boom')),
      );

      await command.execute();

      expect(command.completed, isFalse);
      expect(command.error, isTrue);
      expect(command.result, isA<Error<int>>());
    });

    test('notifies listeners on start and on completion', () async {
      final command = Command0<int>(() async => const Result.ok(1));
      var notifications = 0;
      command.addListener(() => notifications++);

      await command.execute();

      expect(notifications, 2);
    });

    test('is running while the action is in flight', () async {
      final completer = Completer<Result<int>>();
      final command = Command0<int>(() => completer.future);

      final future = command.execute();
      expect(command.running, isTrue);

      completer.complete(const Result.ok(1));
      await future;
      expect(command.running, isFalse);
    });

    test('ignores a second execute while already running', () async {
      final completer = Completer<Result<int>>();
      var calls = 0;
      final command = Command0<int>(() {
        calls++;
        return completer.future;
      });

      final first = command.execute();
      await command.execute();

      completer.complete(const Result.ok(1));
      await first;

      expect(calls, 1);
    });

    test('clearResult resets the stored result', () async {
      final command = Command0<int>(() async => const Result.ok(1));
      await command.execute();
      expect(command.result, isNotNull);

      command.clearResult();

      expect(command.result, isNull);
      expect(command.completed, isFalse);
    });
  });

  group('Command1', () {
    test('passes the argument to the action', () async {
      final command = Command1<int, int>((value) async => Result.ok(value * 2));

      await command.execute(21);

      expect(command.result, isA<Ok<int>>());
      final result = command.result! as Ok<int>;
      expect(result.value, 42);
    });
  });
}
