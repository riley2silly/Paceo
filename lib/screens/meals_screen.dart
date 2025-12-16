import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/paceo_theme.dart';
import '../data/workout_data_service.dart';
import 'meal_categories_screen.dart';
import 'meal_suggestions_screen.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealService = Provider.of<WorkoutDataService>(context);

    // Group meals by category
    final Map<String, List<Map<String, dynamic>>> groupedMeals = {
      "Breakfast": [],
      "Lunch": [],
      "Dinner": [],
      "Snacks": [],
    };

    for (var meal in mealService.mealsToday) {
      if (groupedMeals.containsKey(meal["category"])) {
        groupedMeals[meal["category"]]!.add(meal);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ⭐ HEADER
              Text(
                "Meals",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Track your calorie & macros intake",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // ➕ Add Meal Button
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
                      MaterialPageRoute(builder: (_) => const MealCategoriesScreen()),
                    );
                  },
                  child: Text(
                    "ADD MEAL",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 📊 Calories Summary (CONSUMED)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.05),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Calories Consumed Today",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 🔥 FIXED HERE
                    Text(
                      "${mealService.totalCaloriesConsumed} kcal",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: PaceoTheme.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🌈 Progress Bar Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Goal",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),

                      // 🔥 FIXED HERE
                      Text(
                        "${mealService.totalCaloriesConsumed}/${mealService.calorieGoal} kcal",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: LinearProgressIndicator(
                      minHeight: 12,

                      // 🔥 FIXED HERE
                      value: (mealService.totalCaloriesConsumed / mealService.calorieGoal)
                          .clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(
                        _progressColor(
                          mealService.totalCaloriesConsumed,
                          mealService.calorieGoal,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 FIXED HERE
                  Text(
                    _progressMessage(
                      mealService.totalCaloriesConsumed,
                      mealService.calorieGoal,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _progressColor(
                        mealService.totalCaloriesConsumed,
                        mealService.calorieGoal,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MealSuggestionsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "SEE SUGGESTIONS",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: PaceoTheme.primaryRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🍽 Meals per category
              ...groupedMeals.entries.map((entry) {
                final category = entry.key;
                final meals = entry.value;

                if (meals.isEmpty) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: PaceoTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...meals.map((meal) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                              color: Colors.black.withOpacity(0.05),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // ➕ NAME + MACROS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal["name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _macroChip("P", meal["protein"], const Color(0xFF007AFF)),
                                    const SizedBox(width: 6),
                                    _macroChip("C", meal["carbs"], const Color(0xFF34C759)),
                                    const SizedBox(width: 6),
                                    _macroChip("F", meal["fats"], Colors.orange),
                                  ],
                                ),
                              ],
                            ),

                            // 🔥 Calories
                            Text(
                              "${meal["calories"]} kcal",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // 🌈 Helpers for progress bar colors
  Color _progressColor(int calories, int goal) {
    if (calories >= goal) return Colors.redAccent;
    if (calories >= goal * 0.9) return Colors.orangeAccent;
    if (calories >= goal * 0.7) return Colors.amber;
    return Colors.green;
  }

  String _progressMessage(int calories, int goal) {
    if (calories >= goal) return "⚠️ You’ve exceeded your calorie limit!";
    if (calories >= goal * 0.9) return "😬 Almost exceeding your goal!";
    if (calories >= goal * 0.7) return "👍 You're on track!";
    return "🔥 Great! You have room for more!";
  }
}

// 🔹 Macro Chip UI
Widget _macroChip(String label, int value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      "$label: $value",
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}
