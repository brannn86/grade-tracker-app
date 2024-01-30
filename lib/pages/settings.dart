import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:grade_app/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      log("Logout Success!");
      NavigationService.navigateTo("/loginpage");
    } on FirebaseAuthException catch (e) {
      log("Logout Failed!: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
        children: [
          ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              tileColor: Colors.black12,
              visualDensity: const VisualDensity(vertical: 3),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              leading: const Icon(
                Icons.person,
                size: 32,
              ),
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                NavigationService.navigateTo("/profilepage");
              }),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              tileColor: Colors.black12,
              visualDensity: const VisualDensity(vertical: 3),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              leading: const Icon(
                Icons.logout,
                size: 32,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _logOut();
              }),
        ],
      ),
    );
  }
}

class ButtonListColumn extends StatelessWidget {
  const ButtonListColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
        ),
        CustomButtonContainer(
            onTap: () {
              Navigator.pushNamed(context, '/profilepage');
            },
            color: Colors.black12,
            child: Center(
              child: Row(
                children: const [
                  Icon(
                    Icons.person,
                    size: 40,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            )),
        CustomButtonContainer(
            onTap: () {
              Navigator.pushNamed(context, '/loginpage');
            },
            color: Colors.black12,
            child: Center(
              child: Row(
                children: const [
                  Icon(
                    Icons.logout,
                    size: 40,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            )),
      ],
    );
  }
}

class CustomButtonContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color color;

  const CustomButtonContainer({
    super.key,
    required this.onTap,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 60,
        margin: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
      ),
    );
  }
}
