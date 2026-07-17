import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:todo_flutter/utils/result.dart';

import '../../../utils/fakes.dart';

void main() {
  test('login command completes when the repository succeeds', () async {
    final repository = FakeAuthRepository();
    final viewModel = LoginViewModel(repository);

    await viewModel.login.execute(('a@b.com', 'pw'));

    expect(viewModel.login.completed, isTrue);
    expect(repository.loginCallCount, 1);
  });

  test('login command errors when the repository fails', () async {
    final repository = FakeAuthRepository()
      ..loginResult = Result.error(Exception('bad credentials'));
    final viewModel = LoginViewModel(repository);

    await viewModel.login.execute(('a@b.com', 'pw'));

    expect(viewModel.login.error, isTrue);
  });

  test('loginWithGoogle command completes on success', () async {
    final repository = FakeAuthRepository();
    final viewModel = LoginViewModel(repository);

    await viewModel.loginWithGoogle.execute();

    expect(viewModel.loginWithGoogle.completed, isTrue);
    expect(repository.loginWithGoogleCallCount, 1);
  });

  test('loginWithGoogle command errors when the repository fails', () async {
    final repository = FakeAuthRepository()
      ..loginWithGoogleResult = Result.error(Exception('google failed'));
    final viewModel = LoginViewModel(repository);

    await viewModel.loginWithGoogle.execute();

    expect(viewModel.loginWithGoogle.error, isTrue);
  });
}
