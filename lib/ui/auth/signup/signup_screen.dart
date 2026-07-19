import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/signup/signup_viewmodel.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/core/validators.dart';
import 'package:todo_flutter/utils/command.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({required this.viewModel, super.key});

  final SignupViewModel viewModel;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with CommandFeedback {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  List<Command<void>> get feedbackCommands => [widget.viewModel.register];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      widget.viewModel.register.execute((
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                RGText.h2(l10n.signupTitle),
                const SizedBox(height: RGSpacing.xl),
                RGTextField.outlined(
                  controller: _nameController,
                  label: l10n.signupNameLabel,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: Validators.required(l10n.validationNameRequired),
                ),
                const SizedBox(height: RGSpacing.md),
                RGTextField.outlined(
                  controller: _emailController,
                  label: l10n.loginEmailLabel,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email(l10n),
                ),
                const SizedBox(height: RGSpacing.md),
                RGPasswordField.outlined(
                  controller: _passwordController,
                  label: l10n.loginPasswordLabel,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: Validators.password(l10n, minLength: 6),
                ),
                const SizedBox(height: RGSpacing.xl),
                ListenableBuilder(
                  listenable: widget.viewModel.register,
                  builder: (context, _) {
                    final running = widget.viewModel.register.running;
                    return RGButton.filled(
                      l10n.signupSubmit,
                      fullWidth: true,
                      isLoading: running,
                      onPressed: running ? null : _submit,
                    );
                  },
                ),
                const Spacer(),
                Center(
                  child: RGButton.text(
                    l10n.signupHaveAccount,
                    onPressed: () => context.pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
