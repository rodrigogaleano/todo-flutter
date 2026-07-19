import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/auth/login/login_viewmodel.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/core/validators.dart';
import 'package:todo_flutter/utils/command.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with CommandFeedback {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  List<Command<void>> get feedbackCommands => [
    widget.viewModel.login,
    widget.viewModel.loginWithGoogle,
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      widget.viewModel.login.execute((
        email: _emailController.text.trim(),
        password: _passwordController.text,
      )),
    );
  }

  void _loginWithGoogle() {
    unawaited(widget.viewModel.loginWithGoogle.execute());
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
                RGText.h1(l10n.loginTitle),
                const Spacer(),
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
                  validator: Validators.password(l10n),
                ),
                const SizedBox(height: RGSpacing.xl),
                ListenableBuilder(
                  listenable: widget.viewModel.login,
                  builder: (context, _) {
                    final running = widget.viewModel.login.running;
                    return RGButton.filled(
                      l10n.loginSubmit,
                      fullWidth: true,
                      isLoading: running,
                      onPressed: running ? null : _submit,
                    );
                  },
                ),
                const SizedBox(height: RGSpacing.lg),
                RGDivider.labeled(label: l10n.loginDividerOr),
                const SizedBox(height: RGSpacing.lg),
                ListenableBuilder(
                  listenable: widget.viewModel.loginWithGoogle,
                  builder: (context, _) {
                    final running = widget.viewModel.loginWithGoogle.running;
                    return RGSocialButton.google(
                      label: l10n.loginContinueWithGoogle,
                      onPressed: running ? null : _loginWithGoogle,
                    );
                  },
                ),
                const SizedBox(height: RGSpacing.sm),
                RGButton.text(
                  l10n.loginForgotPassword,
                  fullWidth: true,
                  onPressed: () => context.push(Routes.recoverPassword),
                ),
                const Spacer(),
                Center(
                  child: RGButton.text(
                    l10n.loginCreateAccount,
                    onPressed: () => context.push(Routes.signup),
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
