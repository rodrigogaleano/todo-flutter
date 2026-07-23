import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/core/app_sidebar.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/settings/settings_viewmodel.dart';
import 'package:todo_flutter/utils/command.dart';

const double _kSettingsDesktopBreakpoint = 840;
const double _kSettingsContentMaxWidth = 480;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.viewModel, super.key});

  final SettingsViewModel viewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with CommandFeedback {
  @override
  List<Command<void>> get feedbackCommands => [widget.viewModel.logout];

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  void _logout() => unawaited(widget.viewModel.logout.execute());

  @override
  Widget build(BuildContext context) {
    final isWide =
        MediaQuery.sizeOf(context).width >= _kSettingsDesktopBreakpoint;
    return Scaffold(
      body: SafeArea(
        child: isWide ? _buildDesktop(context) : _buildMobile(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(RGSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RGButton.icon(
              icon: Icons.arrow_back,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              variant: RGButtonVariant.text,
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(height: RGSpacing.md),
          RGText.h2(l10n.settingsTitle),
          const SizedBox(height: RGSpacing.xl),
          Expanded(
            child: SingleChildScrollView(child: _sections(context)),
          ),
          const SizedBox(height: RGSpacing.lg),
          const _VersionFooter(),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        AppSidebar(
          initials: widget.viewModel.avatarInitials,
          userName: widget.viewModel.userName,
          userEmail: widget.viewModel.userEmail,
          active: AppSidebarSection.settings,
          onSelectTasks: () => context.go(Routes.home),
          onSelectSettings: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: RGSpacing.xxl,
              vertical: RGSpacing.xxxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _kSettingsContentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RGText.h2(l10n.settingsTitle),
                    const SizedBox(height: RGSpacing.xl),
                    _sections(context),
                    const SizedBox(height: RGSpacing.xxl),
                    const _VersionFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccountSection(
          email: widget.viewModel.userEmail,
          onLogout: _logout,
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({required this.email, required this.onLogout});

  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RGText.overline(
          l10n.settingsAccountSection,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(height: RGSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: RGSpacing.md),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: colors.outline),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RGText.bodyS(
                l10n.settingsEmailLabel,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: RGSpacing.xs),
              RGText.body(email),
            ],
          ),
        ),
        const SizedBox(height: RGSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: RGButton.text(
            l10n.settingsLogout,
            isDestructive: true,
            onPressed: onLogout,
          ),
        ),
      ],
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: RGText.micro('v1.0.0', color: colors.onSurfaceVariant),
    );
  }
}
