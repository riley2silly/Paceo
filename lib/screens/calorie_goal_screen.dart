import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class CalorieGoalScreen extends StatefulWidget {
  const CalorieGoalScreen({super.key});

  @override
  State<CalorieGoalScreen> createState() => _CalorieGoalScreenState();
}

class _CalorieGoalScreenState extends State<CalorieGoalScreen> {
  late TextEditingController goalController;

  @override
  void initState() {
    super.initState();
    final service = Provider.of<WorkoutDataService>(context, listen: false);
    goalController = TextEditingController(text: service.calorieGoal.toString());
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Calorie Goal",
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
              "Set your daily calorie limit",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "kcal  ",
                filled: true,
                fillColor: Colors.white,
                hintText: "2000",
                hintStyle: GoogleFonts.poppins(color: Colors.black26),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
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
                onPressed: () {
                  int newGoal = int.tryParse(goalController.text) ?? 0;

                  if (newGoal <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid goal"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  service.updateGoals(
                    newCalories: newGoal,
                    newProtein: service.proteinGoal,
                    newCarbs: service.carbsGoal,
                    newFats: service.fatsGoal,
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "SAVE GOAL",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
