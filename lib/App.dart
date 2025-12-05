import 'package:flutter/material.dart';
import 'package:giftly/screens/home_screen.dart';
import 'package:giftly/screens/login_screen.dart';
import 'package:giftly/screens/signup_screen.dart';
import 'package:giftly/screens/splash_screen.dart';
import 'package:giftly/screens/on_boarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(primaryColor: Color(0xFF0A2463)),
    );
  }
}
