import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ProfileColumn(),
      ),
    );
  }
}

class ProfileColumn extends StatelessWidget {
  const ProfileColumn({super.key});

  String _getUser() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.email ?? 'No email found';
    } else {
      return 'User not logged in';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _getUser(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
