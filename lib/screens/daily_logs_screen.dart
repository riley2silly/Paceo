import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/workout_data_service.dart';

class DailyLogsScreen extends StatelessWidget {
  const DailyLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Today Logs", style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text("Meals", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...data.mealsToday.map((m) => _logTile(
                m["name"],
                "${m["calories"]} kcal",
                Colors.red,
              )),
          const SizedBox(height: 20),

          Text("Workouts", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...data.todayLogs.map((w) => _logTile(
                w["name"],
                "${w["minutes"]} mins",
                Colors.orange,
              )),
        ],
      ),
    );
  }

  Widget _logTile(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: GoogleFonts.poppins(color: color)),
      ),
    );
  }
}
