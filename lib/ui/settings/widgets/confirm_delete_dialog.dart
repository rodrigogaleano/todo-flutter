import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showRGDialog<bool>(
    context,
    dialog: RGDialog.confirm(
      title: l10n.settingsDeleteAccountConfirmTitle,
      message: l10n.settingsDeleteAccountWarning,
      confirmLabel: l10n.settingsDeleteAccount,
      cancelLabel: l10n.settingsDeleteAccountCancel,
      isDestructive: true,
    ),
  );
}
