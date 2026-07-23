import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

Future<void> _pumpHomeWithRouter(
  WidgetTester tester,
  HomeViewModel viewModel,
) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(viewModel: viewModel),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) =>
            const Scaffold(body: Text('SETTINGS PLACEHOLDER')),
      ),
    ],
  );
  return tester.pumpWidget(
    MaterialApp.router(
      theme: RGTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
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

  testWidgets('opens settings when the avatar is tapped', (tester) async {
    final taskRepository = FakeTaskRepository();
    final authRepository = FakeAuthRepository()
      ..currentUserDisplayNameValue = 'Rodrigo Galeano';
    final viewModel = HomeViewModel(taskRepository, authRepository);
    await _pumpHomeWithRouter(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    await tester.tap(find.byType(RGAvatar));
    await tester.pumpAndSettle();

    expect(find.text('SETTINGS PLACEHOLDER'), findsOneWidget);
  });

  testWidgets('toggles a task when its checkbox is tapped', (tester) async {
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

    await tester.tap(find.byType(RGCheckbox));
    await tester.pump();

    expect(taskRepository.setDoneCalls, [('1', true)]);
  });

  testWidgets('deletes a task when the trash button is tapped', (tester) async {
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

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(taskRepository.deletedIds, ['1']);
  });

  testWidgets('creates a task from the bottom sheet on narrow screens', (
    tester,
  ) async {
    final taskRepository = FakeTaskRepository();
    final viewModel = HomeViewModel(taskRepository, FakeAuthRepository());
    await _pumpHome(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(taskRepository.createdTitles, ['Buy milk']);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('creates a task from the inline dialog on wide screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final taskRepository = FakeTaskRepository();
    final viewModel = HomeViewModel(taskRepository, FakeAuthRepository());
    await _pumpHome(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    await tester.tap(
      find.ancestor(
        of: find.text('Add a task'),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    final dialogField = find.descendant(
      of: find.byType(Dialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogField, 'Ship it');
    await tester.pump();
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Add')),
    );
    await tester.pumpAndSettle();

    expect(taskRepository.createdTitles, ['Ship it']);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('shows the sidebar and opens settings from it on wide screens', (
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
    await _pumpHomeWithRouter(tester, viewModel);

    taskRepository.emit(const []);
    await tester.pump();

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Rodrigo Galeano'), findsOneWidget);
    expect(find.text('rodrigo@example.com'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('SETTINGS PLACEHOLDER'), findsOneWidget);
  });
}
