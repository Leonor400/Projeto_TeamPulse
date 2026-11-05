import 'package:flutter/material.dart';
import 'package:teampulsefinal1/screens/Welcome_screen.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const TeamPulseApp());
}

class TeamPulseApp extends StatelessWidget {
  const TeamPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeamPulse',
      theme: ThemeData(
        primaryColor: const Color(0xFFD71932),
        scaffoldBackgroundColor: const Color(0xFF200607),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}