import 'package:comicvault/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ),
        Spacer(flex: 8),
        Expanded(
          child: Center(
            child: Center(
              child: Text(
                "Welcome to your Comic Vault!",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        Spacer(flex: 10),
      ],
    );
  }
}
