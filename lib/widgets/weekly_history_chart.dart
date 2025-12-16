import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/workout_data_service.dart';

class WeeklyHistoryChart extends StatelessWidget {
  const WeeklyHistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<WorkoutDataService>(context);

    // 🔥 Last 7 days calories history
    final today = DateTime.now();
final values = List.generate(7, (i) {
  final dayKey = "${today.year}-${today.month}-${(today.day - i).toInt()}";
  final logs = data.mealHistory[dayKey] ?? [];
  int total = 0;
  for (var l in logs) {
   total += (l["calories"] as num).toInt();
  }
  return total;
}).reversed.toList();

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 3000,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(7, (i) => FlSpot(i.toDouble(), values[i].toDouble())),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.redAccent.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
