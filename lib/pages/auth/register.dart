import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/main.dart';
import 'package:grade_app/pages/auth/local_data_upload.dart';
import 'dart:developer';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // empty field handler
      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter your email and password");
        return;
      }

      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('Register Success!');
      await Session.startCloud(credential.user!);
      if (mounted) await offerLocalDataUpload(context);
      NavigationService.replaceAllWith('/main');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "Password provided is too weak!");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "An account with this email already exists!");
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: "Invalid email address!");
      } else {
        log('Register failed: ${e.code}');
        Fluttertoast.showToast(msg: "Register failed: ${e.message ?? e.code}");
      }
    } catch (e) {
      log('Error!: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                    backgroundColor: Colors.deepOrange),
                onPressed: () {
                  _submitForm();
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
