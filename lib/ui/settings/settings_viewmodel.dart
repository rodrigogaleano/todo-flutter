import 'package:flutter/foundation.dart';
import 'package:todo_flutter/data/repositories/auth/auth_repository.dart';
import 'package:todo_flutter/ui/core/user_display.dart';
import 'package:todo_flutter/utils/command.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._authRepository) {
    logout = Command0(_authRepository.logout);
  }

  final AuthRepository _authRepository;

  late final Command0<void> logout;

  String get avatarInitials => UserDisplay.initials(
    _authRepository.currentUserDisplayName,
    _authRepository.currentUserEmail,
  );

  String get userName => UserDisplay.name(
    _authRepository.currentUserDisplayName,
    _authRepository.currentUserEmail,
  );

  String get userEmail => UserDisplay.email(_authRepository.currentUserEmail);

  @override
  void dispose() {
    logout.dispose();
    super.dispose();
  }
}
