import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _ConfirmDeleteDialog(),
  );
}

class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
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
              RGText.h4(l10n.settingsDeleteAccountConfirmTitle),
              const SizedBox(height: RGSpacing.md),
              RGText.body(
                l10n.settingsDeleteAccountWarning,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: RGSpacing.lg),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: RGSpacing.sm,
                runSpacing: RGSpacing.sm,
                children: [
                  RGButton.text(
                    l10n.settingsDeleteAccountCancel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  RGButton.filled(
                    l10n.settingsDeleteAccount,
                    isDestructive: true,
                    onPressed: () => Navigator.of(context).pop(true),
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
