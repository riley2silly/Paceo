import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⭐ ADD THIS

import '../widgets/paceo_primary_button.dart';
import '../widgets/paceo_text_field.dart';
import '../theme/paceo_theme.dart';
import 'register_screen.dart';
import 'verify_email_screen.dart';
import 'main_wrapper.dart';
import '../data/workout_data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> loginUser() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(msg: "Email and password required!");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail|googlemail)\.com$")
        .hasMatch(email.toLowerCase())) {
      Fluttertoast.showToast(msg: "Only valid Gmail accounts allowed! ❌");
      return;
    }

    try {
      setState(() => loading = true);

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = cred.user!;

      // 🔐 email verification check
      if (!user.emailVerified) {
        Fluttertoast.showToast(msg: "Verify your email first! 📩");
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
        );
        return;
      }

      // ⭐ TEST FIRESTORE CONNECTION HERE
      try {
        await FirebaseFirestore.instance.collection("debugTest").add({
          "ok": true,
          "uid": user.uid,
          "time": DateTime.now().toIso8601String(),
        });
        print("🔥 FIRESTORE WORKING");
      } catch (e) {
        print("❌ FIRESTORE FAILED: $e");
      }

      // ⭐ Load Everything
      final service =
          Provider.of<WorkoutDataService>(context, listen: false);

      await service.loadAllData();
      service.checkForNewDay(); // 🔥 auto-reset daily

      Fluttertoast.showToast(msg: "Welcome back! 🎉");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainWrapper()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Login failed!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong 🥲");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔺 Top gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [PaceoTheme.primaryRed, PaceoTheme.darkRed],
              ),
            ),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 80),
              ],
            ),
          ),

          // 🔻 Form Container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  PaceoTextField(
                    label: 'Email',
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  PaceoTextField(
                    label: 'Password',
                    obscureText: true,
                    controller: passCtrl,
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 13,
                        color: PaceoTheme.textMuted,
                      ),
                    ),
                  ),

                  const Spacer(),

                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : PaceoPrimaryButton(
                          label: 'LOGIN',
                          onPressed: loginUser,
                        ),

                  const SizedBox(height: 14),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Don’t have an Account? Sign Up',
                        style: TextStyle(
                          fontSize: 13,
                          color: PaceoTheme.primaryRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
