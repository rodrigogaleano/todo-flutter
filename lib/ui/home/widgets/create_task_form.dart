import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/utils/command.dart';

enum CreateTaskLayout { sheet, dialog }

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({
    required this.createTask,
    required this.layout,
    super.key,
  });

  final Command1<void, String> createTask;
  final CreateTaskLayout layout;

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> with CommandFeedback {
  final _controller = TextEditingController();

  @override
  List<Command<void>> get feedbackCommands => [widget.createTask];

  @override
  String commandErrorMessage(Command<void> command, Object error) =>
      AppLocalizations.of(context).createTaskFailed;

  @override
  void onCommandSuccess(Command<void> command) {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    unawaited(widget.createTask.execute(title));
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.layout) {
      CreateTaskLayout.sheet => _buildSheet(context),
      CreateTaskLayout.dialog => _buildDialog(context),
    };
  }

  Widget _field(AppLocalizations l10n) {
    return RGTextField.outlined(
      controller: _controller,
      hint: l10n.createTaskPlaceholder,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
    );
  }

  Widget _submitButton(AppLocalizations l10n, {required bool fullWidth}) {
    return ListenableBuilder(
      listenable: widget.createTask,
      builder: (context, _) {
        final running = widget.createTask.running;
        final enabled = !running && _controller.text.trim().isNotEmpty;
        return RGButton.filled(
          l10n.createTaskSubmit,
          fullWidth: fullWidth,
          isLoading: running,
          onPressed: enabled ? _submit : null,
        );
      },
    );
  }

  Widget _buildSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: RGSpacing.lg,
        right: RGSpacing.lg,
        top: RGSpacing.md,
        bottom: RGSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              color: colors.outline,
            ),
          ),
          const SizedBox(height: RGSpacing.lg),
          RGText.overline(l10n.createTaskTitle, color: colors.onSurfaceVariant),
          const SizedBox(height: RGSpacing.sm),
          _field(l10n),
          const SizedBox(height: RGSpacing.xl),
          _submitButton(l10n, fullWidth: true),
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(RGSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: RGText.h3(l10n.createTaskTitle)),
                  RGButton.icon(
                    icon: Icons.close,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    variant: RGButtonVariant.text,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: RGSpacing.lg),
              _field(l10n),
              const SizedBox(height: RGSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RGButton.text(
                    l10n.createTaskCancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: RGSpacing.sm),
                  _submitButton(l10n, fullWidth: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
