import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';
import 'workout_completion_screen.dart';
import 'rest_timer_screen.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String name;
  final String sets;
  final String category;
  final int startFromSet;

  const ExerciseDetailScreen({
    super.key,
    required this.name,
    required this.sets,
    required this.category,
    this.startFromSet = 1,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late int currentSet;
  bool isRunning = false;
  Duration time = Duration.zero;
  late Stopwatch stopwatch;
  int lastSecondNotified = 999;

  @override
  void initState() {
    super.initState();
    currentSet = widget.startFromSet;
    stopwatch = Stopwatch();
  }

  void _startTimer() {
    stopwatch.start();
    isRunning = true;
    lastSecondNotified = 999;
    _ticker();
    setState(() {});
  }

  void _pauseTimer() {
    stopwatch.stop();
    isRunning = false;
    setState(() {});
  }

  void _resetTimer() {
    stopwatch.reset();
    time = Duration.zero;
    isRunning = false;
    lastSecondNotified = 999;
    setState(() {});
  }

  void _ticker() async {
    while (isRunning) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;

      setState(() {
        time = stopwatch.elapsed;
      });
    }
  }

  void _completeSet() {
    int totalSets = int.parse(widget.sets.split(" ")[0]);

    if (currentSet < totalSets) {
      stopwatch.stop();
      final nextSet = currentSet + 1;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RestTimerScreen(
            nextSet: nextSet,
            exerciseName: widget.name,
            sets: widget.sets,
            category: widget.category,
          ),
        ),
      );
    } else {
      stopwatch.stop();

      final minutes = stopwatch.elapsed.inMinutes == 0
          ? 1
          : stopwatch.elapsed.inMinutes;
      final calories = minutes * 8;

      Provider.of<WorkoutDataService>(context, listen: false).addWorkout(
        name: widget.name,
        minutes: minutes,
        calories: calories,
        category: widget.category,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutCompletionScreen(
            exerciseName: widget.name,
            calories: calories,
            minutes: minutes,
          ),
        ),
      );
    }
  }

  String _formatTime() {
    String m = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    String s = time.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          widget.name,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),
              child: const Center(
                child: Icon(Icons.motion_photos_auto_rounded,
                    size: 95, color: Colors.black26),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              widget.category,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PaceoTheme.primaryRed,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Maintain proper posture & breathe steadily 💪",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Set $currentSet of ${widget.sets}",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _formatTime(),
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: PaceoTheme.primaryRed,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timerButton(
                  icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  onPressed: isRunning ? _pauseTimer : _startTimer,
                ),
                const SizedBox(width: 18),
                _timerButton(
                  icon: Icons.restart_alt_rounded,
                  onPressed: _resetTimer,
                ),
              ],
            ),

            const Spacer(),

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
                onPressed: _completeSet,
                child: Text(
                  "COMPLETE SET",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _timerButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 32, color: PaceoTheme.primaryRed),
      ),
    );
  }
}
