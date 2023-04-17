import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phara/screens/splash_screen.dart';
import 'package:wakelock/wakelock.dart';
import 'firebase_options.dart';

void main() async {
  Wakelock.enable();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'project-phara',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PHara',
      home: SplashScreen(),
    );
  }
}
