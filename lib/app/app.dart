import 'package:flutter/material.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import 'theme.dart';

class MamaCareApp extends StatelessWidget {
  const MamaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MamaCare Ethiopia",
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
