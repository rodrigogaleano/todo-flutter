import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

Future<String?> showReauthPasswordDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _ReauthPasswordDialog(),
  );
}

class _ReauthPasswordDialog extends StatefulWidget {
  const _ReauthPasswordDialog();

  @override
  State<_ReauthPasswordDialog> createState() => _ReauthPasswordDialogState();
}

class _ReauthPasswordDialogState extends State<_ReauthPasswordDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _controller.text;
    if (password.isEmpty) return;
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(RGSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RGText.h4(l10n.settingsReauthTitle),
              const SizedBox(height: RGSpacing.md),
              RGPasswordField.outlined(
                controller: _controller,
                label: l10n.loginPasswordLabel,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: RGSpacing.lg),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: RGSpacing.sm,
                runSpacing: RGSpacing.sm,
                children: [
                  RGButton.text(
                    l10n.settingsDeleteAccountCancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  RGButton.filled(
                    l10n.settingsDeleteAccount,
                    isDestructive: true,
                    onPressed: _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
