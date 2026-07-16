import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystic Soul Tarot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE5C158),
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Color(0xFFE5C158)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE5C158), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}