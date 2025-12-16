import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';
import 'exercise_list_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 Main Title
              Text(
                "Activity",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "Track your workout progress",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // 🧮 Summary Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _summaryStat("42m", "Active"),
                  _summaryStat("834", "Calories"),
                  _summaryStat("5,230", "Steps"),
                ],
              ),

              const SizedBox(height: 25),

              // 💪 Start Workout Button
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExerciseListScreen(category: "Full Body"),
                      ),
                    );
                  },
                  child: Text(
                    "Start Workout",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Workout Categories Header
              Text(
                "Categories",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),

              // 🧱 Category Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  _categoryCard(context, "Full Body", Icons.fitness_center_rounded),
                  _categoryCard(context, "Upper Body", Icons.accessibility_new_rounded),
                  _categoryCard(context, "Lower Body", Icons.directions_run_rounded),
                  _categoryCard(context, "Abs & Core", Icons.sports_martial_arts_rounded),
                  _categoryCard(context, "Cardio", Icons.favorite_rounded),
                  _categoryCard(context, "Flexibility", Icons.self_improvement_rounded),
                ],
              ),

              const SizedBox(height: 28),

              // 📅 Today Activity Header
              Text(
                "Today Activity",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Temporary static logs (we will make dynamic later)
              _activityLog("Push Ups", "3 sets • 145 kcal"),
              const SizedBox(height: 10),
              _activityLog("Jogging", "15 min • 186 kcal"),
              const SizedBox(height: 10),
              _activityLog("Squats", "2 sets • 97 kcal"),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Reusable Widgets

  Widget _summaryStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PaceoTheme.primaryRed,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseListScreen(category: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 5),
              color: Colors.black.withOpacity(0.07),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: PaceoTheme.primaryRed),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityLog(String name, String details) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            details,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: PaceoTheme.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}
