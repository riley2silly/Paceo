import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/food_data_api.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class MealSuggestionsScreen extends StatefulWidget {
  const MealSuggestionsScreen({super.key});

  @override
  State<MealSuggestionsScreen> createState() => _MealSuggestionsScreenState();
}

class _MealSuggestionsScreenState extends State<MealSuggestionsScreen> {
  late List<Map<String, dynamic>> suggestions;

  @override
  void initState() {
    super.initState();
    _generateSuggestions();
  }

  void _generateSuggestions() {
    final mealService = Provider.of<WorkoutDataService>(context, listen: false);
    final remaining = mealService.caloriesLeft;

    suggestions = [
      {
        "name": "Tuna Wrap",
        "calories": 350,
        "category": "Snacks",
        "protein": 25,
        "carbs": 28,
        "fats": 12,
        "desc": "Healthy Pinoy twist sa classic tuna sandwich 🐟"
      },
      {
        "name": "Chicken Tinola",
        "calories": 320,
        "category": "Dinner",
        "protein": 29,
        "carbs": 8,
        "fats": 10,
        "desc": "High protein, low calories 🇵🇭"
      },
      {
        "name": "Pandesal + Peanut Butter",
        "calories": 280,
        "category": "Breakfast",
        "protein": 10,
        "carbs": 40,
        "fats": 12,
        "desc": "Quick carbs for energy 🥜"
      },
      {
        "name": "Beef Tapa Rice Bowl",
        "calories": 460,
        "category": "Lunch",
        "protein": 30,
        "carbs": 50,
        "fats": 20,
        "desc": "Strong classic meal 💪"
      },
      {
        "name": "Fruit Yogurt Cup",
        "calories": 180,
        "category": "Snacks",
        "protein": 5,
        "carbs": 28,
        "fats": 4,
        "desc": "Light pangontra over-eating 🍓"
      },
    ];

    suggestions = suggestions
        .where((s) => s["calories"] <= remaining * 1.3 || remaining <= 200)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mealService = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Recommended Meals",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            "${mealService.caloriesLeft} kcal left today",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PaceoTheme.primaryRed,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            mealService.suggestionMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () => _showSearchDialog(context),
            child: Text(
              "SMART AI SEARCH 🔍",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: PaceoTheme.primaryRed,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) =>
                  _suggestionCard(suggestions[index], mealService),
            ),
          ),

          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget _suggestionCard(Map<String, dynamic> meal, WorkoutDataService svc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.08),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              meal["name"],
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              meal["desc"],
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "${meal["calories"]} kcal",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: PaceoTheme.primaryRed,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "${meal["protein"]}P • ${meal["carbs"]}C • ${meal["fats"]}F",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  svc.addMeal(
                    name: meal["name"],
                    calories: meal["calories"],
                    category: meal["category"],
                    protein: meal["protein"],
                    carbs: meal["carbs"],
                    fats: meal["fats"],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${meal["name"]} added!"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaceoTheme.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  "ADD TO MEALS",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔍 SMART SEARCH DIALOG + API
  void _showSearchDialog(BuildContext context) {
    final TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Search Food"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: "Try: Pork Adobo, Lumpia, Halo-Halo...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final result = await FoodDataApi.searchFood(ctrl.text);

              if (result == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No food found 😅")),
                );
                return;
              }

              Provider.of<WorkoutDataService>(context, listen: false).addMeal(
                name: result["name"],
                category: "Snacks",
                calories: result["calories"],
                protein: result["protein"],
                carbs: result["carbs"],
                fats: result["fats"],
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added ${result["name"]} (${result["calories"]} kcal)",
                  ),
                ),
              );
            },
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }
}
