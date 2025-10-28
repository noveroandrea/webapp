import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const OpinionsApp());
}

class OpinionsApp extends StatelessWidget {
  const OpinionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opinions',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
