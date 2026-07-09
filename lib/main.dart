import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:todo_flutter/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: RGTheme.light,
      darkTheme: RGTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const Placeholder(),
    );
  }
}
