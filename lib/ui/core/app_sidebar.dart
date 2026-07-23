import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

const double _kSidebarWidth = 240;

enum AppSidebarSection { tasks, settings }

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.initials,
    required this.userName,
    required this.userEmail,
    required this.active,
    required this.onSelectTasks,
    required this.onSelectSettings,
    super.key,
  });

  final String initials;
  final String userName;
  final String userEmail;
  final AppSidebarSection active;
  final VoidCallback onSelectTasks;
  final VoidCallback onSelectSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: _kSidebarWidth,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.outline)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: RGSpacing.lg,
        vertical: RGSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RGText.h3(l10n.homeTitle),
          const SizedBox(height: RGSpacing.xxl),
          _NavItem(
            label: l10n.homeNavTasks,
            active: active == AppSidebarSection.tasks,
            onTap: onSelectTasks,
          ),
          const SizedBox(height: RGSpacing.xs),
          _NavItem(
            label: l10n.settingsNavSettings,
            active: active == AppSidebarSection.settings,
            onTap: onSelectSettings,
          ),
          const Spacer(),
          const RGDivider(),
          const SizedBox(height: RGSpacing.md),
          Row(
            children: [
              RGAvatar(initials, size: 36),
              const SizedBox(width: RGSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RGText.body(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (userEmail.isNotEmpty)
                      RGText.caption(
                        userEmail,
                        color: colors.onSurfaceVariant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RGSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              color: active ? colors.onSurface : Colors.transparent,
            ),
            const SizedBox(width: RGSpacing.sm),
            RGText.body(
              label,
              color: active ? null : colors.onSurfaceVariant,
              style: active
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
