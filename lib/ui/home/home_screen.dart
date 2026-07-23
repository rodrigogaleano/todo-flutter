import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/routing/routes.dart';
import 'package:todo_flutter/ui/core/command_feedback.dart';
import 'package:todo_flutter/ui/home/home_viewmodel.dart';
import 'package:todo_flutter/utils/command.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CommandFeedback {
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
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.createTask),
        shape: const RoundedRectangleBorder(),
        backgroundColor: colors.onSurface,
        foregroundColor: colors.surface,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
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
              Expanded(
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) => _content(l10n, colors),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(AppLocalizations l10n, ColorScheme colors) {
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
            itemBuilder: (context, index) =>
                _TaskRow(task: viewModel.tasks[index]),
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RGSpacing.md),
      child: Row(
        children: [
          RGCheckbox(value: task.isDone, onChanged: null),
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
        ],
      ),
    );
  }
}
