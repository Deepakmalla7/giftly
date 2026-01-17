import 'package:flutter/material.dart';
import 'package:giftly/features/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D6A5D), Color(0xFFE0E0E6)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/gifts.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration('Enter Your Full Name'),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Mobile Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Valid Mobile Number'),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Enter the Email'),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration('Strong Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4A9C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 255, 255),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
