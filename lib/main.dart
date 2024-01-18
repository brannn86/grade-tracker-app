import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grade_app/pages/auth/login.dart';
import 'package:grade_app/pages/auth/register.dart';
import 'package:grade_app/pages/home.dart';
import 'package:grade_app/pages/profile.dart';
import 'package:grade_app/pages/settings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/registerpage': (context) => RegisterPage(),
        '/profilepage': (context) => ProfilePage(),
        '/settingspage': (context) => SettingsPage(),
      },
    );
  }
}
