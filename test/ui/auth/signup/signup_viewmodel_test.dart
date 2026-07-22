import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/ui/auth/signup/signup_viewmodel.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

void main() {
  test('register command completes when the repository succeeds', () async {
    final repository = FakeAuthRepository();
    final viewModel = SignupViewModel(repository);

    await viewModel.register.execute((
      name: 'Rodrigo',
      email: 'a@b.com',
      password: 'password',
    ));

    expect(viewModel.register.completed, isTrue);
    expect(repository.registerCallCount, 1);
  });

  test('register command errors when the repository fails', () async {
    final repository = FakeAuthRepository()
      ..registerResult = Result.error(Exception('email in use'));
    final viewModel = SignupViewModel(repository);

    await viewModel.register.execute((
      name: 'Rodrigo',
      email: 'a@b.com',
      password: 'password',
    ));

    expect(viewModel.register.error, isTrue);
  });
}
