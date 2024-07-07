import 'package:flutter/material.dart';
import 'package:nami_task/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe43e3a)),
        useMaterial3: true,
        textTheme: 
      ),
      home: SplashScreen(),
    );
  }
}
