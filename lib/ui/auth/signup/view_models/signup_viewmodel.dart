import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

class SignupViewModel {
  SignupViewModel(this._authRepository);

  final AuthRepository _authRepository;

  late final Command1<void, (String, String, String)> register = Command1(
    _register,
  );

  Future<Result<void>> _register((String, String, String) fields) {
    final (name, email, password) = fields;
    return _authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
