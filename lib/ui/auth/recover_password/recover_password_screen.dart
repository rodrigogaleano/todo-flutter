import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/recover_password/recover_password_viewmodel.dart';
import 'package:todo_flutter/ui/core/app_scaffold.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/core/validators.dart';
import 'package:todo_flutter/utils/command.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({required this.viewModel, super.key});

  final RecoverPasswordViewModel viewModel;

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen>
    with CommandFeedback {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  List<Command<void>> get feedbackCommands => [widget.viewModel.sendReset];

  @override
  void onCommandSuccess(Command<void> command) {
    showSnackBar(context, AppLocalizations.of(context).recoverSuccess);
  }

  @override
  void dispose() {
    _emailController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(widget.viewModel.sendReset.execute(_emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return AppScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RGButton.icon(
                icon: Icons.arrow_back,
                tooltip: MaterialLocalizations.of(
                  context,
                ).backButtonTooltip,
                variant: RGButtonVariant.text,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: RGSpacing.lg),
            RGText.h2(l10n.recoverTitle),
            const SizedBox(height: RGSpacing.sm),
            RGText.body(
              l10n.recoverDescription,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: RGSpacing.xl),
            RGTextField.outlined(
              controller: _emailController,
              label: l10n.loginEmailLabel,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: Validators.email(l10n),
            ),
            const SizedBox(height: RGSpacing.xl),
            ListenableBuilder(
              listenable: widget.viewModel.sendReset,
              builder: (context, _) {
                final running = widget.viewModel.sendReset.running;
                return RGButton.filled(
                  l10n.recoverSubmit,
                  fullWidth: true,
                  isLoading: running,
                  onPressed: running ? null : _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
