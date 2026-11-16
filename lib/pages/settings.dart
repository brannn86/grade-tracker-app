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
      NavigationService.replaceAllWith("/loginpage");
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
