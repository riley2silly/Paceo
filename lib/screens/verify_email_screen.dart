import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main_wrapper.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isSending = false;
  bool isChecking = false;

  Future<void> resendEmail() async {
    try {
      setState(() => isSending = true);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Fluttertoast.showToast(msg: "Verification email sent again 📩");
    } catch (e) {
      Fluttertoast.showToast(msg: "Cannot resend email now");
    } finally {
      setState(() => isSending = false);
    }
  }

  Future<void> checkVerified() async {
    setState(() => isChecking = true);
    await FirebaseAuth.instance.currentUser!.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainWrapper()));
    } else {
      Fluttertoast.showToast(msg: "Not verified yet ❌");
    }
    setState(() => isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_rounded,
                size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text("Verify Your Email",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "A verification link has been sent to your email.\nPlease verify to continue!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 40),

            isSending
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: resendEmail,
                    child: const Text("Resend Email"),
                  ),

            const SizedBox(height: 14),

            isChecking
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: checkVerified,
                    child: const Text("I have verified"),
                  ),
          ],
        ),
      ),
    );
  }
}
