<<<<<<< HEAD
import 'package:comicvault/login.dart';
//import 'package:comicvault/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MaterialApp(title: "Testing", home: StartScreen()));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
=======
import 'package:flutter/material.dart';
import 'package:comicvault/search_screen.dart';
import 'package:comicvault/screens/search_screen_v2.dart';
import 'package:comicvault/screens/user_collection_screen.dart';

void main() {
  runApp(const MaterialApp(title: "Testing", home: SearchScreenv2()));
>>>>>>> feature/comic-search
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
