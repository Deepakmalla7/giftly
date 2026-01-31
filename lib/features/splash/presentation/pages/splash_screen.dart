import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:giftly/features/onboarding/presentation/pages/on_boarding_screen.dart';
import 'package:giftly/features/screens/home_screen.dart';
import 'package:giftly/core/api/api_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash screen to show
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check if user has authentication token
    final token = await _apiClient.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    final nextScreen = isLoggedIn
        ? const HomeScreen()
        : const OnboardingScreen();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5A8F9B), Color(0xFF3D5A66), Color(0xFF3D2A36)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Giftly',
                style: GoogleFonts.dancingScript(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Smart gifting for every moment',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
