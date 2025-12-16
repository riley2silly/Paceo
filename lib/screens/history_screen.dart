import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/paceo_theme.dart';
import '../data/workout_data_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  DateTime? _parseTimestamp(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<WorkoutDataService>(context);

    String dateKey(DateTime d) =>
        "${d.year}-${d.month}-${d.day}";
    final key = dateKey(_selectedDay!);

    // 🥗 Meals for the day
    final meals = data.mealHistory[key] ?? [];

    // 🏋 Workouts — fix timestamp parsing
    final workouts = data.todayLogs.where((w) {
      final t = _parseTimestamp(w["timestamp"]);
      if (t == null) return false;
      return dateKey(t) == key;
    }).toList();

    // ⚖ Body Logs — fix timestamp parsing
    final body = data.bodyLogs.where((b) {
      final t = _parseTimestamp(b["timestamp"]);
      if (t == null) return false;
      return dateKey(t) == key;
    }).toList();

    // 🔢 Daily totals
    int caloriesIn = meals.fold<int>(0, (s, e) => s + (e["calories"] as num).toInt());
    int caloriesOut = workouts.fold<int>(0, (s, e) => s + (e["calories"] as num).toInt());
    int net = caloriesIn - caloriesOut;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "History",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // CALENDAR
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              availableGestures: AvailableGestures.horizontalSwipe,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                todayDecoration: BoxDecoration(
                  color: PaceoTheme.primaryRed.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: PaceoTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
            ),

            const SizedBox(height: 12),

            // BODY CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _summaryCard("Calories Consumed", "$caloriesIn kcal",
                        Icons.restaurant, Colors.orange),
                    const SizedBox(height: 10),
                    _summaryCard("Calories Burned", "$caloriesOut kcal",
                        Icons.local_fire_department, PaceoTheme.primaryRed),
                    const SizedBox(height: 10),
                    _summaryCard("Net Calories", "$net kcal",
                        Icons.calculate_rounded,
                        net >= 0 ? Colors.amber : Colors.green),

                    const SizedBox(height: 20),

                    // 🍽 Meals
                    if (meals.isNotEmpty) ...[
                      _sectionTitle("Meals"),
                      ...meals.map((m) => _logTile(
                        title: m["name"],
                        subtitle:
                            "${m["protein"]}P • ${m["carbs"]}C • ${m["fats"]}F",
                        trailing: "${m["calories"]} kcal",
                        icon: Icons.restaurant_menu_rounded,
                      )),
                    ],

                    const SizedBox(height: 20),

                    // 💪 Workouts
                    if (workouts.isNotEmpty) ...[
                      _sectionTitle("Workouts"),
                      ...workouts.map((w) => _logTile(
                        title: w["name"],
                        subtitle:
                            "${w["minutes"]} mins • ${w["category"]}",
                        trailing: "-${w["calories"]} kcal",
                        icon: Icons.fitness_center_rounded,
                      )),
                    ],

                    const SizedBox(height: 20),

                    // ⚖ Body Logs
                    if (body.isNotEmpty) ...[
                      _sectionTitle("Body Logs"),
                      ...body.map((b) {
                        final t = _parseTimestamp(b["timestamp"]);
                        final timeLabel = t != null
                            ? DateFormat("hh:mm a").format(t)
                            : "";
                        return _logTile(
                          title: "${b["weight"]} kg",
                          subtitle: "BMI: ${b["bmi"]}",
                          trailing: timeLabel,
                          icon: Icons.monitor_weight_rounded,
                        );
                      }),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI COMPONENTS -----------------------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: PaceoTheme.primaryRed,
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
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
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logTile({
    required String title,
    required String subtitle,
    required String trailing,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: PaceoTheme.primaryRed),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
