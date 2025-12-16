import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';
import 'profile_screen.dart';
import 'program_schedule_screen.dart';

// Charts
import '../widgets/nutrition_chart.dart';
import '../widgets/macros_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<WorkoutDataService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: data.userName),
              const SizedBox(height: 80),
              HomeStats(data: data),
              const SizedBox(height: 30),
              const HomeQuickActions(),
              const SizedBox(height: 24),
              const TodayPlanSection(),
              const SizedBox(height: 24),
              DailySummarySection(data: data),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
   🔝 HEADER (Greeting + Avatar + Gradient)
-----------------------------------------------------------*/

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient background
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE63946),
                Color(0xFFB71C1C),
              ],
            ),
          ),
        ),

        // Gloss highlight
        Positioned(
          top: -60,
          left: -50,
          child: Container(
            width: 200,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.18),
            ),
          ),
        ),

        // Wave transition bottom
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              height: 100,
              color: const Color(0xFFF8F8F8),
            ),
          ),
        ),

        // Header Text & Avatar
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 45, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $userName! 👋",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getGreetingMessage(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: Color(0xFFE63946),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------
   📊 STATS (Active / Consumed / Workouts)
-----------------------------------------------------------*/

class HomeStats extends StatelessWidget {
  final WorkoutDataService data;

  const HomeStats({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _progressRing(
            title: 'Active',
            value: "${data.totalActiveMinutes}m",
            percent: (data.totalActiveMinutes / 60).clamp(0.0, 1.0),
            color: PaceoTheme.primaryRed,
          ),
          _progressRing(
            title: 'Consumed',
            value: "${data.totalCaloriesConsumed}",
            percent:
                (data.totalCaloriesConsumed / data.calorieGoal).clamp(0.0, 1.0),
            color: data.totalCaloriesConsumed > data.calorieGoal
                ? Colors.red
                : const Color(0xFFFF7A00),
          ),
          _progressRing(
            title: 'Workouts',
            value: "${data.totalWorkouts}",
            percent: (data.totalWorkouts / 10).clamp(0.0, 1.0),
            color: const Color(0xFFD6FF00),
          ),
        ],
      ),
    );
  }

  static Widget _progressRing({
    required String title,
    required String value,
    required double percent,
    required Color color,
  }) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 30,
            lineWidth: 6,
            percent: percent,
            animation: true,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------------------------------------
   ⚡ QUICK ACTIONS (Workout / Meal / Body)
-----------------------------------------------------------*/

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _quickActionCard(
                  Icons.fitness_center_rounded,
                  'Workout',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickActionCard(
                  Icons.restaurant_menu_rounded,
                  'Meal',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickActionCard(
                  Icons.monitor_weight_rounded,
                  'Body',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _quickActionCard(IconData icon, String label) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: PaceoTheme.primaryRed),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
   🌟 TODAY'S PLAN (Skip / Replace / Log / Premium Lock)
-----------------------------------------------------------*/

class TodayPlanSection extends StatefulWidget {
  const TodayPlanSection({super.key});

  @override
  State<TodayPlanSection> createState() => _TodayPlanSectionState();
}

class _TodayPlanSectionState extends State<TodayPlanSection> {
  bool _skippedToday = false;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<WorkoutDataService>();

    final hasProgram =
        data.activeProgramId != null && data.programStartDate != null;
    final todayItems = data.todayPlanItems;

    // free programs: weight_loss + muscle_gain
    final isPremiumPlan = data.activeProgramId != null &&
        !(data.activeProgramId == "weight_loss" ||
            data.activeProgramId == "muscle_gain");

    int currentDay = 0;
    int totalDays = 0;

    if (hasProgram) {
      final start = DateTime(
        data.programStartDate!.year,
        data.programStartDate!.month,
        data.programStartDate!.day,
      );
      currentDay = DateTime.now().difference(start).inDays + 1;
      final prog = kPrograms[data.activeProgramId];
      totalDays = prog?.length ?? 0;
    }

    final double progress =
        totalDays > 0 ? (currentDay / totalDays).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Plan",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasProgram)
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == "skip") {
                      _onSkipToday();
                    } else if (val == "cancel") {
                      _showCancelProgramDialog(data);
                    } else if (val == "schedule") {
                      _openProgramSchedule(data);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: "skip",
                      child: Text("Skip today's plan"),
                    ),
                    PopupMenuItem(
                      value: "schedule",
                      child: Text("View full schedule"),
                    ),
                    PopupMenuItem(
                      value: "cancel",
                      child: Text("Cancel program"),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
            ],
          ),

          const SizedBox(height: 6),

          if (hasProgram && totalDays > 0) ...[
            Text(
              "Day $currentDay of $totalDays",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          PaceoTheme.primaryRed,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Program progress ${(value * 100).toStringAsFixed(0)}%",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],

          const SizedBox(height: 12),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _buildPlanContent(
              context: context,
              data: data,
              hasProgram: hasProgram,
              todayItems: todayItems,
              isPremiumPlan: isPremiumPlan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanContent({
    required BuildContext context,
    required WorkoutDataService data,
    required bool hasProgram,
    required List<Map<String, dynamic>> todayItems,
    required bool isPremiumPlan,
  }) {
    // No program or no items
    if (!hasProgram || todayItems.isEmpty) {
      return Container(
        key: const ValueKey('no_program'),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.07),
            )
          ],
        ),
        child: Text(
          "No active plan.\nStart a fitness goal in your Profile to generate daily tasks.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      );
    }

    // Skipped today
    if (_skippedToday) {
      return Container(
        key: const ValueKey('skipped'),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.07),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's plan skipped ✅",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Rest, recover, and come back stronger tomorrow. 💆‍♀️💪",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _skippedToday = false;
                });
              },
              child: const Text("Undo skip"),
            )
          ],
        ),
      );
    }

    // Premium lock view (if on premium plan but not premium user)
    if (isPremiumPlan && !data.isPremiumUser) {
      return Container(
        key: const ValueKey('premium_locked'),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.07),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Premium Plan Locked 🔒",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "This program is available for Premium users only. Upgrade to unlock structured plans, advanced tracking, and more.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaceoTheme.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: Text(
                  "Go to Profile → Upgrade",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    // Normal visible plan
    return Container(
      key: const ValueKey('normal_plan'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.07),
          )
        ],
      ),
      child: Column(
        children: [
          ...todayItems.map((item) {
            final bool isWorkout =
                (item["type"] ?? "workout") == "workout";

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  // ICON
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isWorkout
                          ? PaceoTheme.primaryRed.withOpacity(0.12)
                          : Colors.green.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWorkout ? Icons.fitness_center : Icons.restaurant,
                      color: isWorkout
                          ? PaceoTheme.primaryRed
                          : Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"] ?? "",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isWorkout
                              ? "${item["minutes"] ?? 20} mins • ${item["calories"] ?? 100} kcal • ${item["category"] ?? "Workout"}"
                              : "${item["calories"] ?? 120} kcal • ${item["category"] ?? "Meal"}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // REPLACE WORKOUT (for workout only)
                  if (isWorkout)
                    IconButton(
                      icon: const Icon(
                        Icons.swap_horiz_rounded,
                        size: 20,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        _showReplaceWorkoutSheet(data, item);
                      },
                    ),

                  // LOG BUTTON
                  TextButton(
                    onPressed: () async {
                      await data.logPlanItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isWorkout
                                ? "Workout logged! 💪"
                                : "Meal logged! 🍽️",
                            style: GoogleFonts.poppins(),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      "LOG",
                      style: TextStyle(
                        color: PaceoTheme.primaryRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 8),

          // LOG ALL (fast mode – no replace prompts)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                for (var item in todayItems) {
                  await data.logPlanItem(item);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "All tasks logged for today! 🔥",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              },
              child: Text(
                "LOG ALL",
                style: TextStyle(
                  color: PaceoTheme.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSkipToday() {
    setState(() {
      _skippedToday = true;
    });
  }

  void _showCancelProgramDialog(WorkoutDataService data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Program"),
        content: const Text(
          "Are you sure you want to cancel your current fitness program? "
          "You can always start a new one later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Program"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await data.clearProgram();
              setState(() {
                _skippedToday = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Program cancelled."),
                ),
              );
            },
            child: const Text(
              "Cancel Program",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _openProgramSchedule(WorkoutDataService data) {
    final id = data.activeProgramId;
    if (id == null) return;
    final prog = kPrograms[id];
    if (prog == null || prog.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No schedule data available.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramScheduleScreen(
          programId: id,
          program: prog,
        ),
      ),
    );
  }

  void _showReplaceWorkoutSheet(
    WorkoutDataService data,
    Map<String, dynamic> originalItem,
  ) {
    final originalCat =
        (originalItem["category"] ?? "").toString().toLowerCase();

    final List<Map<String, dynamic>> pool = [
      {
        "type": "workout",
        "title": "Jump Rope HIIT",
        "description": "High-intensity skipping blocks.",
        "minutes": 15,
        "calories": 150,
        "category": "Cardio / HIIT",
      },
      {
        "type": "workout",
        "title": "Outdoor Run",
        "description": "Steady pace cardio run.",
        "minutes": 20,
        "calories": 170,
        "category": "Cardio",
      },
      {
        "type": "workout",
        "title": "Strength Circuit",
        "description": "Squats, lunges, push-ups, rows.",
        "minutes": 25,
        "calories": 160,
        "category": "Strength",
      },
      {
        "type": "workout",
        "title": "Core Blast",
        "description": "Planks, dead bugs, hollow holds.",
        "minutes": 18,
        "calories": 110,
        "category": "Core / Strength",
      },
    ];

    bool matchCardio(String c) =>
        c.contains('cardio') || c.contains('run') || c.contains('hiit');

    bool matchStrength(String c) =>
        c.contains('strength') ||
        c.contains('weight') ||
        c.contains('resistance');

    bool matchCore(String c) => c.contains('core') || c.contains('abs');

    List<Map<String, dynamic>> filtered = pool.where((alt) {
      final cat = (alt["category"] ?? "").toString().toLowerCase();
      if (matchCardio(originalCat)) return matchCardio(cat);
      if (matchStrength(originalCat)) return matchStrength(cat);
      if (matchCore(originalCat)) return matchCore(cat);
      return true; // fallback
    }).toList();

    if (filtered.isEmpty) {
      filtered = pool;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Replace workout",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Choose an alternative to log instead of '${originalItem["title"]}'.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 14),
              ...filtered.map((alt) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    alt["title"],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    "${alt["minutes"]} mins • ${alt["calories"]} kcal • ${alt["category"]}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () async {
                    await data.logPlanItem(alt);
                    if (mounted) Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Replaced with ${alt["title"]}! 🔁",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/* ----------------------------------------------------------
   📈 DAILY SUMMARY (Charts + KPIs)
-----------------------------------------------------------*/

class DailySummarySection extends StatelessWidget {
  final WorkoutDataService data;

  const DailySummarySection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Daily Summary',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),

          _sectionTitle("Calories Progress"),
          _glassCard(const NutritionChart()),
          const SizedBox(height: 28),

          _sectionTitle("Macros Overview"),
          _glassCard(const MacrosBarChart()),
          const SizedBox(height: 28),

          _summaryCard(
              'Calories Consumed', '${data.totalCaloriesConsumed} kcal'),
          const SizedBox(height: 12),
          _summaryCard(
              'Calories Burned', '${data.totalCaloriesBurned} kcal'),
          const SizedBox(height: 12),
          _summaryCard('Active Time', '${data.totalActiveMinutes} mins'),
          const SizedBox(height: 12),
          _summaryCard('Workouts Done', '${data.totalWorkouts} sessions'),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  static Widget _glassCard(Widget child) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            )
          ],
        ),
        child: child,
      );

  static Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.07),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PaceoTheme.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------------------------------------
   🌊 Wave clipper + greeting helper
-----------------------------------------------------------*/

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 35,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

String _getGreetingMessage() {
  final messages = [
    "Ready to own your progress? 💪",
    "Let’s make today count! 🔥",
    "Small steps, big results! 🚀",
    "You’re stronger than yesterday! ⭐",
    "Your goals are waiting! 🎯",
    "Hydrate and dominate! 💧",
    "Fuel your power today! 🍽️",
  ];
  messages.shuffle();
  return messages.first;
}
