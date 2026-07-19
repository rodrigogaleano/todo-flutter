import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/ui/auth/recover_password/recover_password_viewmodel.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

void main() {
  test('sendReset command completes when the repository succeeds', () async {
    final repository = FakeAuthRepository();
    final viewModel = RecoverPasswordViewModel(repository);

    await viewModel.sendReset.execute('a@b.com');

    expect(viewModel.sendReset.completed, isTrue);
    expect(repository.sendPasswordResetCallCount, 1);
  });

  test('sendReset command errors when the repository fails', () async {
    final repository = FakeAuthRepository()
      ..sendPasswordResetResult = Result.error(Exception('no such user'));
    final viewModel = RecoverPasswordViewModel(repository);

    await viewModel.sendReset.execute('a@b.com');

    expect(viewModel.sendReset.error, isTrue);
  });
}
