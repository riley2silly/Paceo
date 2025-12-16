import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Workout",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose a routine to begin",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 22),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  _categoryCard(
                    context,
                    title: "Full Body",
                    icon: Icons.fitness_center_rounded,
                  ),
                  _categoryCard(
                    context,
                    title: "Upper Body",
                    icon: Icons.accessibility_new_rounded,
                  ),
                  _categoryCard(
                    context,
                    title: "Lower Body",
                    icon: Icons.directions_run_rounded,
                  ),
                  _categoryCard(
                    context,
                    title: "Abs & Core",
                    icon: Icons.sports_martial_arts_rounded,
                  ),
                  _categoryCard(
                    context,
                    title: "Cardio",
                    icon: Icons.favorite_rounded,
                  ),
                  _categoryCard(
                    context,
                    title: "Flexibility",
                    icon: Icons.self_improvement_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ Category Card UI
  Widget _categoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to Exercise List screen soon!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening $title soon!"),
            duration: const Duration(milliseconds: 800),
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
            Icon(icon, size: 50, color: PaceoTheme.primaryRed),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
