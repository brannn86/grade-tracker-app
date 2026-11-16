import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:grade_app/data/session.dart';
import 'package:grade_app/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Local data stays on the device and is offered for upload after sign-in
  Future<void> _signInToSync() async {
    await Session.end();
    NavigationService.replaceAllWith("/loginpage");
  }

  Future<void> _logOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      await Session.end();
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
          _SettingsTile(
            icon: Icons.calendar_month,
            title: "Semesters",
            onTap: () => NavigationService.navigateTo("/semesterspage"),
          ),
          if (!Session.isLocal)
            _SettingsTile(
              icon: Icons.person,
              title: "Profile",
              onTap: () => NavigationService.navigateTo("/profilepage"),
            ),
          if (Session.isLocal)
            _SettingsTile(
              icon: Icons.cloud_upload_outlined,
              title: "Sign in to sync",
              onTap: _signInToSync,
            )
          else
            _SettingsTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: _logOut,
            ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          tileColor: Colors.black12,
          visualDensity: const VisualDensity(vertical: 3),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          leading: Icon(
            icon,
            size: 32,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          onTap: onTap),
    );
  }
}
