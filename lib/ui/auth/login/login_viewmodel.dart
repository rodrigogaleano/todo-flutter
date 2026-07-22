import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

typedef LoginRequest = ({String email, String password});

class LoginViewModel {
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  late final Command1<void, LoginRequest> login = Command1(_login);

  late final Command0<void> loginWithGoogle = Command0(_loginWithGoogle);

  Future<Result<void>> _login(LoginRequest request) {
    return _authRepository.login(
      email: request.email,
      password: request.password,
    );
  }

  Future<Result<void>> _loginWithGoogle() {
    return _authRepository.loginWithGoogle();
  }

  void dispose() {
    login.dispose();
    loginWithGoogle.dispose();
  }
}
