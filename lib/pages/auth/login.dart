import 'package:flutter/material.dart';
import 'package:grade_app/pages/auth/register.dart';
import 'package:grade_app/pages/home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Home Page"),
              onPressed: () {
                Navigator.pushNamed(context, '/homepage');
              },
            ),
            ElevatedButton(
              child: Text("Register"),
              onPressed: () {
                Navigator.pushNamed(context, '/registerpage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
