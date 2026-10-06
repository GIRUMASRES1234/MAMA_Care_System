import 'package:flutter/material.dart';

import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MamaCareApp());
}

class MamaCareApp extends StatelessWidget {
  const MamaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MamaCare',

      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),

      home: const SplashScreen(),
    );
  }
}
