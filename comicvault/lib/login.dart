import 'package:comicvault/collection_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool firebaseReady = false;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => setState(() => firebaseReady = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!firebaseReady) return const Center(child: CircularProgressIndicator());

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return const CollectionScreen();
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Enter your email'),
                maxLength: 64,
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Enter a password"),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Your password must contain at least 8 characters.';
                  }
                  return null; // Returning null means "no issues"
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tryLogin();
                  }
                },
              ),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void tryLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print("Logged in ${credential.user}");
      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CollectionScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      setState(() {});
    }
  }
}
