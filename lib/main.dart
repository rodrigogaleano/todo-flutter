import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/config/dependencies.dart';
import 'package:todo_flutter/data/repositories/settings/settings_repository.dart';
import 'package:todo_flutter/firebase_options.dart';
import 'package:todo_flutter/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: providers(prefs),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsRepository>();
    return MaterialApp.router(
      theme: RGTheme.light,
      darkTheme: RGTheme.dark,
      themeMode: settings.themeMode,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: context.read<GoRouter>(),
    );
  }
}
