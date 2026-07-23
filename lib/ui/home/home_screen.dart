import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/home/home_viewmodel.dart';
import 'package:todo_flutter/ui/home/widgets/create_task_form.dart';
import 'package:todo_flutter/utils/command.dart';

const double _kHomeDesktopBreakpoint = 840;
const double _kHomeContentMaxWidth = 720;
const double _kSidebarWidth = 240;

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CommandFeedback {
  @override
  List<Command<void>> get feedbackCommands => [
    widget.viewModel.logout,
    widget.viewModel.toggleTask,
    widget.viewModel.deleteTask,
  ];

  @override
  String commandErrorMessage(Command<void> command, Object error) {
    final l10n = AppLocalizations.of(context);
    if (command == widget.viewModel.toggleTask) return l10n.taskToggleFailed;
    if (command == widget.viewModel.deleteTask) return l10n.taskDeleteFailed;
    return super.commandErrorMessage(command, error);
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  void _logout() => unawaited(widget.viewModel.logout.execute());

  void _toggle(Task task) =>
      unawaited(widget.viewModel.toggleTask.execute(task));

  void _delete(Task task) =>
      unawaited(widget.viewModel.deleteTask.execute(task));

  void _openCreateTask() {
    final isWide = MediaQuery.sizeOf(context).width >= _kHomeDesktopBreakpoint;
    if (isWide) {
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => CreateTaskForm(
            createTask: widget.viewModel.createTask,
            layout: CreateTaskLayout.dialog,
          ),
        ),
      );
    } else {
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(),
          builder: (_) => CreateTaskForm(
            createTask: widget.viewModel.createTask,
            layout: CreateTaskLayout.sheet,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= _kHomeDesktopBreakpoint;
    return Scaffold(
      floatingActionButton: isWide
          ? null
          : FloatingActionButton(
              onPressed: _openCreateTask,
              shape: const RoundedRectangleBorder(),
              backgroundColor: colors.onSurface,
              foregroundColor: colors.surface,
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) =>
              isWide ? _buildDesktop(context) : _buildMobile(context),
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RGText.h3(l10n.homeTitle),
              InkWell(
                onTap: _logout,
                customBorder: const CircleBorder(),
                child: RGAvatar(widget.viewModel.avatarInitials),
              ),
            ],
          ),
          const SizedBox(height: RGSpacing.lg),
          Expanded(child: _taskContent(context)),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _Sidebar(viewModel: widget.viewModel, onLogout: _logout),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: RGSpacing.xxl,
              vertical: RGSpacing.xxxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _kHomeContentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RGText.h2(l10n.homeListTitle),
                    const SizedBox(height: RGSpacing.xl),
                    _CreateTaskTrigger(onTap: _openCreateTask),
                    const SizedBox(height: RGSpacing.lg),
                    Expanded(child: _taskContent(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final viewModel = widget.viewModel;
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.hasError) {
      return Center(
        child: RGText.body(l10n.homeLoadError, textAlign: TextAlign.center),
      );
    }
    if (viewModel.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RGText.display(l10n.homeEmptyTitle, textAlign: TextAlign.center),
            const SizedBox(height: RGSpacing.md),
            RGText.body(
              l10n.homeEmptyDescription,
              textAlign: TextAlign.center,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RGText.overline(l10n.homeTaskCount(viewModel.openTaskCount)),
        const SizedBox(height: RGSpacing.sm),
        Expanded(
          child: ListView.separated(
            itemCount: viewModel.tasks.length,
            separatorBuilder: (context, index) => const RGDivider(),
            itemBuilder: (context, index) => _TaskRow(
              task: viewModel.tasks[index],
              onToggle: _toggle,
              onDelete: _delete,
            ),
          ),
        ),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.viewModel, required this.onLogout});

  final HomeViewModel viewModel;
  final VoidCallback onLogout;

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
          _NavItem(label: l10n.homeNavTasks, active: true),
          const Spacer(),
          const RGDivider(),
          const SizedBox(height: RGSpacing.md),
          InkWell(
            onTap: onLogout,
            child: Row(
              children: [
                RGAvatar(viewModel.avatarInitials, size: 36),
                const SizedBox(width: RGSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RGText.body(
                        viewModel.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (viewModel.userEmail.isNotEmpty)
                        RGText.caption(
                          viewModel.userEmail,
                          color: colors.onSurfaceVariant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
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
          style: active ? const TextStyle(fontWeight: FontWeight.w700) : null,
        ),
      ],
    );
  }
}

class _CreateTaskTrigger extends StatelessWidget {
  const _CreateTaskTrigger({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: IgnorePointer(
        child: RGTextField.outlined(hint: l10n.createTaskInlineTrigger),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RGSpacing.md),
      child: Row(
        children: [
          RGCheckbox(value: task.isDone, onChanged: (_) => onToggle(task)),
          const SizedBox(width: RGSpacing.md),
          Expanded(
            child: RGText.body(
              task.title,
              maxLines: 1,
              color: task.isDone ? colors.onSurfaceVariant : null,
              style: task.isDone
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
          ),
          RGButton.icon(
            icon: Icons.delete_outline,
            tooltip: l10n.taskDeleteLabel,
            variant: RGButtonVariant.text,
            onPressed: () => onDelete(task),
          ),
        ],
      ),
    );
  }
}
