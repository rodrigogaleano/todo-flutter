import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

class LoginViewModel {
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  late final Command1<void, (String, String)> login = Command1(_login);

  late final Command0<void> loginWithGoogle = Command0(_loginWithGoogle);

  Future<Result<void>> _login((String, String) credentials) {
    final (email, password) = credentials;
    return _authRepository.login(email: email, password: password);
  }

  Future<Result<void>> _loginWithGoogle() {
    return _authRepository.loginWithGoogle();
  }
}
