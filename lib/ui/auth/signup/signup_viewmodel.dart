import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

typedef SignupRequest = ({String name, String email, String password});

class SignupViewModel {
  SignupViewModel(this._authRepository);

  final AuthRepository _authRepository;

  late final Command1<void, SignupRequest> register = Command1(_register);

  Future<Result<void>> _register(SignupRequest request) {
    return _authRepository.register(
      name: request.name,
      email: request.email,
      password: request.password,
    );
  }

  void dispose() {
    register.dispose();
  }
}
