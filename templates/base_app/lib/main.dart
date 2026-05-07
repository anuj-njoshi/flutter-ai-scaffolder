import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base App',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // 👈 show login first
    );
  }
}