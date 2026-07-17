import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/auth/login/view_models/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onLoginResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.login != widget.viewModel.login) {
      oldWidget.viewModel.login.removeListener(_onLoginResult);
      widget.viewModel.login.addListener(_onLoginResult);
    }
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onLoginResult);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Navigation on success is left to the router redirect, which reacts to the
  // auth-state stream. Navigating here would race that state flipping to true.
  void _onLoginResult() {
    final command = widget.viewModel.login;
    if (command.error) {
      command.clearResult();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).loginFailed)),
        );
    } else if (command.completed) {
      command.clearResult();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      widget.viewModel.login.execute(
        (_emailController.text.trim(), _passwordController.text),
      ),
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
                RGText.h1('Todo'),
                const Spacer(),
                RGTextField.outlined(
                  controller: _emailController,
                  label: l10n.loginEmailLabel,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: RGSpacing.md),
                RGPasswordField.outlined(
                  controller: _passwordController,
                  label: l10n.loginPasswordLabel,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validatePassword,
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

  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context);
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.validationEmailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    return null;
  }
}
