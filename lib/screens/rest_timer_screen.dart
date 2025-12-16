import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';
import 'exercise_detail_screen.dart';

class RestTimerScreen extends StatefulWidget {
  final String exerciseName;
  final String sets;
  final int nextSet;
  final String category;

  const RestTimerScreen({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.nextSet,
    required this.category,
  });

  @override
  State<RestTimerScreen> createState() => _RestTimerScreenState();
}

class _RestTimerScreenState extends State<RestTimerScreen> {
  int restSeconds = 30; // default 30 sec rest

  @override
  void initState() {
    super.initState();
    _startRestCountdown();
  }

  void _startRestCountdown() async {
    while (restSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        restSeconds--;
      });
    }
    _finishRest();
  }

  void _finishRest() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ExerciseDetailScreen(
          name: widget.exerciseName,
          sets: widget.sets,
          category: widget.category,
          startFromSet: widget.nextSet, // restart screen at next set
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0.2, 0), // starts from the right
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuad,
            ),
          );

          final scale = Tween<double>(
            begin: 0.92,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
          );

          return SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rest Time 😌",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Next: Set ${widget.nextSet} of ${widget.sets}",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "$restSeconds",
              style: GoogleFonts.poppins(
                fontSize: 70,
                fontWeight: FontWeight.w900,
                color: PaceoTheme.primaryRed,
              ),
            ),
            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finishRest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaceoTheme.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  "SKIP REST",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
