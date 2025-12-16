import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';
import 'main_wrapper.dart';

class WorkoutCompleteScreen extends StatelessWidget {
  final String exerciseName;
  final Duration totalTime;
  final String calories;

  const WorkoutCompleteScreen({
    super.key,
    required this.exerciseName,
    required this.totalTime,
    required this.calories,
  });

  String _formatTime() {
    String m = totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    String s = totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🎉 Check Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: PaceoTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Exercise Complete!",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                exerciseName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 35),

              // 📊 Stats Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                      color: Colors.black.withOpacity(0.07),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem("Time", _formatTime()),
                    _statItem("Calories", calories),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              // 🔙 Return Home
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaceoTheme.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainWrapper(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "DONE",
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
      ),
    );
  }

  Widget _statItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: PaceoTheme.primaryRed,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
