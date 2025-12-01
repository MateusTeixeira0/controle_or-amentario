import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart'; 

void main() {
  runApp(const PrismatikApp());
}

class PrismatikApp extends StatelessWidget {
  const PrismatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prismatik Finance App',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
    
      home: const LoginScreen(),
    );
  }
}
