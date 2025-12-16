import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/paceo_theme.dart';
import '../data/workout_data_service.dart';

import 'landing_screen.dart';
import 'main_wrapper.dart';
import 'verify_email_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _startupFlow();
  }

  Future<void> _startupFlow() async {
    await Future.delayed(const Duration(seconds: 2));

    final authUser = FirebaseAuth.instance.currentUser;

    // 👉 NOT LOGGED IN
    if (authUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LandingScreen()),
      );
      return;
    }

    // 👉 LOGGED IN — Load Firebase Data First!
    final data = Provider.of<WorkoutDataService>(context, listen: false);
    await data.loadAllData();

    // 👉 NOT VERIFIED EMAIL
    if (!authUser.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
      );
      return;
    }

    // 👉 VERIFIED & DATA LOADED
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaceoTheme.primaryRed,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 110),
            const SizedBox(height: 22),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 10),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
