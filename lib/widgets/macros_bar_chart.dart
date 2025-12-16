import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class MacrosBarChart extends StatelessWidget {
  const MacrosBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<WorkoutDataService>(context);

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  switch (v.toInt()) {
                    case 0:
                      return const Text("Protein", style: TextStyle(fontSize: 10));
                    case 1:
                      return const Text("Carbs", style: TextStyle(fontSize: 10));
                    case 2:
                      return const Text("Fats", style: TextStyle(fontSize: 10));
                  }
                  return const Text("");
                },
              ),
            ),
          ),
          barGroups: [
            makeBar(0, service.totalProtein / service.proteinGoal, PaceoTheme.primaryRed),
            makeBar(1, service.totalCarbs / service.carbsGoal, Colors.blueAccent),
            makeBar(2, service.totalFats / service.fatsGoal, Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeBar(int x, double progress, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: progress.clamp(0.0, 1.0),
          width: 20,
          color: color,
          borderRadius: BorderRadius.circular(4),
        )
      ],
    );
  }
}
