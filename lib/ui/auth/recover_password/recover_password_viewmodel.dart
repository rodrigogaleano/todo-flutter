import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

class RecoverPasswordViewModel {
  RecoverPasswordViewModel(this._authRepository);

  final AuthRepository _authRepository;

  late final Command1<void, String> sendReset = Command1(_sendReset);

  Future<Result<void>> _sendReset(String email) {
    return _authRepository.sendPasswordReset(email: email);
  }

  void dispose() {
    sendReset.dispose();
  }
}
