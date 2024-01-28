import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grade_app/pages/add.dart';
import 'package:grade_app/pages/auth/login.dart';
import 'package:grade_app/pages/auth/register.dart';
import 'package:grade_app/pages/graph.dart';
import 'package:grade_app/pages/home.dart';
import 'package:grade_app/pages/main_navigation.dart';
import 'package:grade_app/pages/list.dart';
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

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateTo(String routeName) async {
    await navigatorKey.currentState?.pushNamed(routeName);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/main': (context) => const MainNavigation(),
        '/homepage': (context) => const HomePage(),
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/profilepage': (context) => const ProfilePage(),
        '/graphpage': (context) => const GraphPage(),
        '/addpage': (context) => const AddPage(),
        '/listpage': (context) => const ListPage(),
        '/settingspage': (context) => const SettingsPage(),
      },
    );
  }
}
