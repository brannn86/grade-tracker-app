import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/pages/add.dart';
import 'package:grade_app/pages/auth/login.dart';
import 'package:grade_app/pages/auth/register.dart';
import 'package:grade_app/pages/graph.dart';
import 'package:grade_app/pages/home.dart';
import 'package:grade_app/pages/main_navigation.dart';
import 'package:grade_app/pages/list.dart';
import 'package:grade_app/pages/profile.dart';
import 'package:grade_app/pages/semesters.dart';
import 'package:grade_app/pages/settings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

// Navigator without build context
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateTo(String routeName) async {
    await navigatorKey.currentState?.pushNamed(routeName);
  }

  // Clears the back stack so the user can't navigate back past auth changes
  static Future<void> replaceAllWith(String routeName) async {
    await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});
  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    // Wait for Firebase to restore any saved session before deciding
    User? user = await _auth.authStateChanges().first;

    if (user != null) {
      await Session.startCloud(user);
      NavigationService.replaceAllWith("/main");
    } else if (await Session.isLocalModeChosen()) {
      await Session.startLocal();
      NavigationService.replaceAllWith("/main");
    } else {
      NavigationService.replaceAllWith("/loginpage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const CheckUser(),
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
        '/semesterspage': (context) => const SemestersPage(),
      },
    );
  }
}
