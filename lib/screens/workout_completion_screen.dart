import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';

class WorkoutCompletionScreen extends StatefulWidget {
  final String exerciseName;
  final int calories;
  final int minutes;

  const WorkoutCompletionScreen({
    super.key,
    required this.exerciseName,
    required this.calories,
    required this.minutes,
  });

  @override
  State<WorkoutCompletionScreen> createState() =>
      _WorkoutCompletionScreenState();
}

class _WorkoutCompletionScreenState extends State<WorkoutCompletionScreen> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 🎉 Confetti layer
          ConfettiWidget(
  confettiController: _confetti,
  blastDirectionality: BlastDirectionality.explosive,
  emissionFrequency: 0.15,     // 🔽 fewer confetti per second (0.6 → 0.15)
  numberOfParticles: 12,       // 🔽 lower particle count (25 → 12)
  maxBlastForce: 18,           // 🔽 weaker blast (30 → 18)
  minBlastForce: 6,            // 🔽 lower minimum force (8 → 6)
  gravity: 0.15,               // 🔽 falls slower (optional)
),


          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Trophy icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 70,
                      color: PaceoTheme.primaryRed,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    "Workout Complete!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.exerciseName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Stats cards
                  _statBox(
                    title: "Calories burned",
                    value: "${widget.calories} kcal",
                  ),
                  const SizedBox(height: 12),
                  _statBox(
                    title: "Active time",
                    value: "${widget.minutes} min",
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Nice work! Keep your streak alive and\nstay consistent with your pace.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  const Spacer(),

                  // Primary button
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
                        Navigator.pop(context); // back to Activity / previous
                      },
                      child: Text(
                        "Back to Activity",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary: Back to Home if the nav stack allows
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // completion screen
                      Navigator.pop(context); // detail screen → back further
                    },
                    child: Text(
                      "Return to Home",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PaceoTheme.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}
