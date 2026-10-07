import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const QuizMateApp());
}

class QuizMateApp extends StatelessWidget {
  const QuizMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315C8A)),
      ),
      home: const HomeScreen(),
    );
  }
}
