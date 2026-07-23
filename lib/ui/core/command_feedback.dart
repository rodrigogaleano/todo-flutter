import 'package:flutter/material.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/core/auth_error_messages.dart';
import 'package:todo_flutter/utils/command.dart';
import 'package:todo_flutter/utils/result.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

mixin CommandFeedback<T extends StatefulWidget> on State<T> {
  List<Command<void>> get feedbackCommands;

  void onCommandSuccess(Command<void> command) {}

  String commandErrorMessage(Command<void> command, Object error) =>
      authErrorMessage(AppLocalizations.of(context), error);

  @override
  void initState() {
    super.initState();
    for (final command in feedbackCommands) {
      command.addListener(_onCommandResult);
    }
  }

  @override
  void dispose() {
    for (final command in feedbackCommands) {
      command.removeListener(_onCommandResult);
    }
    super.dispose();
  }

  void _onCommandResult() {
    for (final command in feedbackCommands) {
      if (command.error) {
        final error = (command.result! as Error<void>).error;
        command.clearResult();
        showSnackBar(context, commandErrorMessage(command, error));
      } else if (command.completed) {
        // Don't navigate on success: the router redirect reacts to the auth
        // stream, and navigating now would race the state flip.
        command.clearResult();
        onCommandSuccess(command);
      }
    }
  }
}
