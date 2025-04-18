import 'package:comicvault/collection_screen.dart';
import 'package:comicvault/home_screen.dart';
import 'package:comicvault/screens/login_screen.dart';
//import 'package:comicvault/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(
    MaterialApp(
      title: "Testing",
      home: HomeScreen(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
