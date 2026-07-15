import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/utils/result.dart';

void main() {
  group('Result', () {
    test('Result.ok wraps a value and matches Ok', () {
      const result = Result<int>.ok(42);

      expect(result, isA<Ok<int>>());
      switch (result) {
        case Ok<int>(:final value):
          expect(value, 42);
        case Error<int>():
          fail('Expected Ok, got Error');
      }
    });

    test('Result.error wraps an exception and matches Error', () {
      final exception = Exception('boom');
      final result = Result<int>.error(exception);

      expect(result, isA<Error<int>>());
      switch (result) {
        case Ok<int>():
          fail('Expected Error, got Ok');
        case Error<int>(:final error):
          expect(error, exception);
      }
    });

    test('toString describes the outcome', () {
      expect(const Result<int>.ok(1).toString(), 'Result<int>.ok(1)');
      expect(
        Result<int>.error(Exception('x')).toString(),
        'Result<int>.error(Exception: x)',
      );
    });
  });
}
