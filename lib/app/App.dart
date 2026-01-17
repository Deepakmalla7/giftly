import 'package:flutter/material.dart';
import 'package:giftly/features/screens/home_screen.dart';
import 'package:giftly/features/dashboard/presentation/pages/login_screen.dart';
import 'package:giftly/features/dashboard/presentation/pages/signup_screen.dart';
import 'package:giftly/features/splash/presentation/pages/splash_screen.dart';
import 'package:giftly/features/onboarding/presentation/pages/on_boarding_screen.dart';

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
