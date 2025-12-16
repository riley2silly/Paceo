import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class MealsListScreen extends StatelessWidget {
  const MealsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Today's Meals",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: workout.mealsToday.isEmpty
          ? _emptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: workout.mealsToday.length,
              itemBuilder: (context, index) {
                final meal = workout.mealsToday[index];
                return _mealTile(meal);
              },
            ),
    );
  }

  Widget _mealTile(Map<String, dynamic> meal) {
    IconData icon = _getIcon(meal["category"]);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: Colors.black87),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal["name"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${meal['calories']} kcal • ${meal['protein']}P • ${meal['carbs']}C • ${meal['fats']}F",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 140),
          child: Column(
            children: [
              Icon(Icons.no_meals_rounded, size: 75, color: Colors.black26),
              const SizedBox(height: 18),
              Text(
                "No meals logged yet\nLet’s fuel your day 🍽️",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );

  IconData _getIcon(String category) {
    switch (category) {
      case "Breakfast": return Icons.wb_sunny_outlined;
      case "Lunch":     return Icons.lunch_dining_outlined;
      case "Dinner":    return Icons.nightlight_round_outlined;
      case "Snacks":    return Icons.cookie_outlined;
      default:          return Icons.fastfood_outlined;
    }
  }
}
