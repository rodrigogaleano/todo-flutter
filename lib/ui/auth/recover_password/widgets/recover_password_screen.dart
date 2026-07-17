import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/recover_password/view_models/recover_password_viewmodel.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({required this.viewModel, super.key});

  final RecoverPasswordViewModel viewModel;

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.sendReset.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant RecoverPasswordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.sendReset != widget.viewModel.sendReset) {
      oldWidget.viewModel.sendReset.removeListener(_onResult);
      widget.viewModel.sendReset.addListener(_onResult);
    }
  }

  @override
  void dispose() {
    widget.viewModel.sendReset.removeListener(_onResult);
    _emailController.dispose();
    super.dispose();
  }

  void _onResult() {
    final command = widget.viewModel.sendReset;
    final l10n = AppLocalizations.of(context);
    if (command.error) {
      command.clearResult();
      _showSnackBar(l10n.recoverFailed);
    } else if (command.completed) {
      command.clearResult();
      _showSnackBar(l10n.recoverSuccess);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(widget.viewModel.sendReset.execute(_emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RGSpacing.lg),
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
                  validator: _validateEmail,
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
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context);
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.validationEmailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }
}
