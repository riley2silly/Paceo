import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/paceo_primary_button.dart';
import '../widgets/paceo_text_field.dart';
import '../theme/paceo_theme.dart';
import 'verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final cpassCtrl = TextEditingController();
  bool loading = false;

  Future<void> registerUser() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (nameCtrl.text.isEmpty ||
        email.isEmpty ||
        passCtrl.text.isEmpty ||
        cpassCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: "All fields required!");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail|googlemail)\.com$")
        .hasMatch(email.toLowerCase())) {
      Fluttertoast.showToast(msg: "Only valid Gmail accounts are allowed!");
      return;
    }

    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{8,}$')
        .hasMatch(pass)) {
      Fluttertoast.showToast(
        msg: "Password must be 8+ chars, include 1 uppercase & 1 number!");
      return;
    }

    if (passCtrl.text != cpassCtrl.text) {
      Fluttertoast.showToast(msg: "Passwords do not match!");
      return;
    }

    try {
      setState(() => loading = true);

      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await cred.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": nameCtrl.text.trim(),
        "email": email,
        "gender": "Not set",
        "age": 0,
        "height": 0,
        "weight": 0,
        "isPremium": false,
        "createdAt": DateTime.now(),
      });

      Fluttertoast.showToast(
        msg: "Verify email first before logging in! 📩");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
            child: Center(child: Image.asset('assets/logo.png', height: 80)),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Create an account',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 30),

                  PaceoTextField(label: 'Full Name', controller: nameCtrl),
                  const SizedBox(height: 20),
                  PaceoTextField(label: 'Phone or Gmail', controller: emailCtrl),
                  const SizedBox(height: 20),
                  PaceoTextField(label: 'Password', obscureText: true, controller: passCtrl),
                  const SizedBox(height: 20),
                  PaceoTextField(label: 'Confirm Password', obscureText: true, controller: cpassCtrl),

                  const Spacer(),

                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : PaceoPrimaryButton(label: 'SIGN UP', onPressed: registerUser),

                  const SizedBox(height: 14),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Already have an Account? Login",
                          style: TextStyle(
                              fontSize: 13, color: PaceoTheme.primaryRed)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
