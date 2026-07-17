import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/auth/signup/view_models/signup_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({required this.viewModel, super.key});

  final SignupViewModel viewModel;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.register.addListener(_onRegisterResult);
  }

  @override
  void didUpdateWidget(covariant SignupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.register != widget.viewModel.register) {
      oldWidget.viewModel.register.removeListener(_onRegisterResult);
      widget.viewModel.register.addListener(_onRegisterResult);
    }
  }

  @override
  void dispose() {
    widget.viewModel.register.removeListener(_onRegisterResult);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Navigation on success is left to the router redirect, which reacts to the
  // auth-state stream. Navigating here would race that state flipping to true.
  void _onRegisterResult() {
    final command = widget.viewModel.register;
    if (command.error) {
      command.clearResult();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).signupFailed)),
        );
    } else if (command.completed) {
      command.clearResult();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      widget.viewModel.register.execute((
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
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
                  validator: _validateName,
                ),
                const SizedBox(height: RGSpacing.md),
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).validationNameRequired;
    }
    return null;
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
    if (value == null || value.isEmpty) return l10n.validationPasswordRequired;
    if (value.length < 6) return l10n.validationPasswordMin;
    return null;
  }
}
