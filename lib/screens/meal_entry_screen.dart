import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';
import '../data/food_data_api.dart'; // 👈 USE API

class MealEntryScreen extends StatefulWidget {
  final String mealType;

  const MealEntryScreen({super.key, required this.mealType});

  @override
  State<MealEntryScreen> createState() => _MealEntryScreenState();
}

class _MealEntryScreenState extends State<MealEntryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  bool isSearching = false;

  void _searchCalories() async {
    final query = nameController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter food name first")),
      );
      return;
    }

    setState(() => isSearching = true);

    final result = await FoodDataApi.searchFood(query);

    setState(() => isSearching = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No nutrition data found for \"$query\"")),
      );
      return;
    }

    caloriesController.text = result["calories"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Add ${widget.mealType}",
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
            // 🍽 Meal Name
            Text(
              "Meal Name",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: _inputDecoration("e.g. Chicken Rice, Banana"),
            ),

            const SizedBox(height: 20),

            // 🔍 Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isSearching
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.search, color: Colors.white),
                label: Text(
                  isSearching ? "Searching..." : "SEARCH CALORIES",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                onPressed: isSearching ? null : _searchCalories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Calories field auto-filled
            Text(
              "Calories (kcal)",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Auto-filled"),
            ),

            const Spacer(),

            // SAVE MEAL BUTTON
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
                  if (nameController.text.isEmpty ||
                      caloriesController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    "name": nameController.text,
                    "calories": int.parse(caloriesController.text),
                    "category": widget.mealType,
                  });
                },
                child: Text(
                  "SAVE MEAL",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }
}
