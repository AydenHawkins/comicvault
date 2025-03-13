import 'package:comicvault/search_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: "Testing", home: SearchScreen()));
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
