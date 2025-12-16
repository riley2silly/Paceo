import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatelessWidget {
  final String category;

  const ExerciseListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // 🏋 Category-Specific Exercises
    final Map<String, List<Map<String, dynamic>>> categoryExercises = {
      "Full Body": [
        {"name": "Burpees", "icon": Icons.flash_on_rounded, "sets": "3 x 10"},
        {"name": "Mountain Climbers", "icon": Icons.landscape_rounded, "sets": "3 x 30s"},
        {"name": "Jumping Jacks", "icon": Icons.directions_run_rounded, "sets": "3 x 20"},
      ],

      "Upper Body": [
        {"name": "Push Ups", "icon": Icons.fitness_center_rounded, "sets": "3 x 12"},
        {"name": "Shoulder Press", "icon": Icons.accessibility_new_rounded, "sets": "3 x 10"},
        {"name": "Tricep Dips", "icon": Icons.pan_tool_rounded, "sets": "3 x 12"},
      ],

      "Lower Body": [
        {"name": "Squats", "icon": Icons.directions_walk_rounded, "sets": "4 x 10"},
        {"name": "Lunges", "icon": Icons.airline_stops_rounded, "sets": "3 x 10"},
        {"name": "Calf Raises", "icon": Icons.directions_bike_rounded, "sets": "4 x 15"},
      ],

      "Abs & Core": [
        {"name": "Plank", "icon": Icons.self_improvement_rounded, "sets": "3 x 45s"},
        {"name": "Sit Ups", "icon": Icons.chair_alt_rounded, "sets": "3 x 15"},
        {"name": "Leg Raises", "icon": Icons.align_vertical_bottom_rounded, "sets": "3 x 10"},
      ],

      "Cardio": [
        {"name": "Jogging", "icon": Icons.directions_run_rounded, "sets": "10 min"},
        {"name": "Jump Rope", "icon": Icons.sports_kabaddi_rounded, "sets": "3 x 1 min"},
        {"name": "High Knees", "icon": Icons.run_circle_rounded, "sets": "3 x 45s"},
      ],

      "Flexibility": [
        {"name": "Hamstring Stretch", "icon": Icons.accessibility_new_rounded, "sets": "2 x 30s"},
        {"name": "Back Stretch", "icon": Icons.accessible_forward_rounded, "sets": "2 x 45s"},
        {"name": "Hip Mobility", "icon": Icons.sledding_rounded, "sets": "2 x 30s"},
      ],
    };

    // 🔥 Get selected category exercise list
    final List<Map<String, dynamic>> exercises =
        categoryExercises[category] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "$category Workout",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose an exercise",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // 🧱 Exercise Grid
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: exercises.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = exercises[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseDetailScreen(
                            name: item["name"] as String,
                            sets: item["sets"] as String,
                            category: category, // 🔥 Send category forward
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"] as IconData,
                            size: 42,
                            color: PaceoTheme.primaryRed,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item["name"] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["sets"] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
