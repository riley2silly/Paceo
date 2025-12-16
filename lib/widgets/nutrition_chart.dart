import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class NutritionChart extends StatelessWidget {
  const NutritionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<WorkoutDataService>(context);

    // 🔥 Use consumed calories, not burned
    final progress =
        (service.totalCaloriesConsumed / service.calorieGoal).clamp(0.0, 1.0);

    return SizedBox(
      height: 180,
      width: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 55,
          startDegreeOffset: -90,
          sections: [
            // Consumed calories (progress)
            PieChartSectionData(
              color: PaceoTheme.primaryRed,
              value: progress,
              showTitle: false,
              radius: 18,
            ),
            // Remaining calories
            PieChartSectionData(
              color: Colors.grey.shade300,
              value: 1 - progress,
              showTitle: false,
              radius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
