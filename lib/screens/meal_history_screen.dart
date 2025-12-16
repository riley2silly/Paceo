import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<WorkoutDataService>(context);
    final history = data.mealHistory;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Meal History",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: history.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: history.entries.map((entry) {
                final date = entry.key;
                final logs = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      _formatDate(date),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: PaceoTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...logs.map((meal) => _mealItem(meal)).toList(),
                  ],
                );
              }).toList(),
            ),
    );
  }

  Widget _mealItem(Map<String, dynamic> meal) {
    final isWorkout = meal["isWorkout"] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  isWorkout ? Icons.fitness_center_rounded : Icons.restaurant_rounded,
                  color: isWorkout ? Colors.blue : PaceoTheme.primaryRed,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal["name"],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal["category"] ?? "Meal",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${meal["calories"]} kcal",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        "No logs yet. Add your first meal! 🍽✨",
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  String _formatDate(String key) {
    final parts = key.split("-");
    return "${parts[1]}/${parts[2]}/${parts[0]}"; // MM/DD/YYYY
  }
}
