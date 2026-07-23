import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/domain/models/task/task.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';
import 'package:todo_flutter/ui/home/home_screen.dart';
import 'package:todo_flutter/ui/home/home_viewmodel.dart';

import '../../utils/fakes.dart';

Future<void> _pumpHome(WidgetTester tester, HomeViewModel viewModel) {
  return tester.pumpWidget(
    MaterialApp(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(viewModel: viewModel),
    ),
  );
}

void main() {
  testWidgets('shows the empty state when there are no tasks', (tester) async {
    final taskRepository = FakeTaskRepository();
    final viewModel = HomeViewModel(taskRepository, FakeAuthRepository());
    await _pumpHome(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    expect(find.text('No tasks.'), findsOneWidget);
  });

  testWidgets('lists the tasks from the view model', (tester) async {
    final taskRepository = FakeTaskRepository();
    final viewModel = HomeViewModel(taskRepository, FakeAuthRepository());
    await _pumpHome(tester, viewModel);

    taskRepository.emit([
      Task(
        id: '1',
        title: 'Buy milk',
        isDone: false,
        createdAt: DateTime(2026),
      ),
    ]);
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('logs out when the avatar is tapped', (tester) async {
    final taskRepository = FakeTaskRepository();
    final authRepository = FakeAuthRepository()
      ..currentUserDisplayNameValue = 'Rodrigo Galeano';
    final viewModel = HomeViewModel(taskRepository, authRepository);
    await _pumpHome(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    await tester.tap(find.byType(RGAvatar));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(authRepository.logoutCallCount, 1);
  });

  testWidgets('shows the sidebar and logs out from it on wide screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final taskRepository = FakeTaskRepository();
    final authRepository = FakeAuthRepository()
      ..currentUserDisplayNameValue = 'Rodrigo Galeano'
      ..currentUserEmailValue = 'rodrigo@example.com';
    final viewModel = HomeViewModel(taskRepository, authRepository);
    await _pumpHome(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Rodrigo Galeano'), findsOneWidget);
    expect(find.text('rodrigo@example.com'), findsOneWidget);

    await tester.tap(find.byType(RGAvatar));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(authRepository.logoutCallCount, 1);
  });
}
