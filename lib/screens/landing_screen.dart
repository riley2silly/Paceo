import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/paceo_primary_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Full Background
          Positioned.fill(
            child: Image.asset(
              'assets/landing_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Buttons overlay
          SafeArea(
            child: Column(
              children: [
                Spacer(),

                // LOGIN Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: PaceoPrimaryButton(
                    label: 'LOGIN',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // SIGN UP Button (transparent / ghost button)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'SIGN UP',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 62, 48, 48).withOpacity(0.75),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.10), // breathing space bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
