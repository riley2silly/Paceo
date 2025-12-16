import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/paceo_theme.dart';
import '../data/workout_data_service.dart';
import 'meal_entry_screen.dart';

class MealCategoriesScreen extends StatelessWidget {
  const MealCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"title": "Breakfast", "icon": Icons.free_breakfast_rounded},
      {"title": "Lunch", "icon": Icons.lunch_dining_rounded},
      {"title": "Dinner", "icon": Icons.nightlife_rounded},
      {"title": "Snacks", "icon": Icons.cookie_rounded},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Choose Meal Type",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What meal would you like to log?",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MealEntryScreen(mealType: category["title"]),
                        ),
                      );

                      if (result != null) {
                        Provider.of<WorkoutDataService>(context, listen: false)
                            .addMeal(
                          name: result["name"],
                          calories: result["calories"],
                          category: result["category"],
                          // NEW — Fix: required macros with default fallback
                          protein: result["protein"] ?? 0,
                          carbs: result["carbs"] ?? 0,
                          fats: result["fats"] ?? 0,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Added ${result["name"]} (+${result["calories"]} kcal)",
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                            color: Colors.black.withOpacity(0.08),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category["icon"],
                            size: 42,
                            color: PaceoTheme.primaryRed,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category["title"],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
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
