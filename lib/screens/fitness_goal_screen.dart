import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  State<FitnessGoalScreen> createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController calorieCtrl;
  late TextEditingController proteinCtrl;
  late TextEditingController carbsCtrl;
  late TextEditingController fatsCtrl;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<WorkoutDataService>(context, listen: false);
    calorieCtrl = TextEditingController(text: user.calorieGoal.toString());
    proteinCtrl = TextEditingController(text: user.proteinGoal.toString());
    carbsCtrl = TextEditingController(text: user.carbsGoal.toString());
    fatsCtrl = TextEditingController(text: user.fatsGoal.toString());
  }

  @override
  void dispose() {
    calorieCtrl.dispose();
    proteinCtrl.dispose();
    carbsCtrl.dispose();
    fatsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svc = Provider.of<WorkoutDataService>(context);

    // 💡 Program metadata
    final List<Map<String, dynamic>> programs = [
      {
        "id": "weight_loss",
        "title": "Weight Loss",
        "subtitle": "Light cardio & bodyweight strength",
        "premium": false,
      },
      {
        "id": "muscle_gain",
        "title": "Muscle Gain",
        "subtitle": "Progressive strength-focused routine",
        "premium": false,
      },
      {
        "id": "fat_loss_extreme",
        "title": "Extreme Fat Loss",
        "subtitle": "Aggressive HIIT & cardio blocks",
        "premium": true,
      },
      {
        "id": "toning_program",
        "title": "Toning & Sculpting",
        "subtitle": "Lean muscle definition & shaping",
        "premium": true,
      },
      {
        "id": "cardio_boost",
        "title": "Cardio Booster",
        "subtitle": "Endurance & stamina-focused",
        "premium": true,
      },
    ];

    final currentProgramId = svc.activeProgramId;

    final currentProgramMeta = programs.firstWhere(
      (p) => p["id"] == currentProgramId,
      orElse: () => {"title": "None"},
    );

    final String currentProgramTitle =
        (currentProgramMeta["title"] as String?) ?? "None";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Fitness Goals",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ============================================================
            // CURRENT PROGRAM
            // ============================================================
            Text(
              "Current Program",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                    color: Colors.black.withOpacity(0.04),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    currentProgramId == null
                        ? Icons.flag_outlined
                        : Icons.flag_rounded,
                    color: PaceoTheme.primaryRed,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentProgramId == null
                          ? "No active program"
                          : currentProgramTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (currentProgramId != null)
                    TextButton(
                      onPressed: () => _showCancelProgramDialog(svc),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ============================================================
            // PROGRAM SELECTION
            // ============================================================
            Text(
              "Choose a Program",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Programs auto-generate a daily plan that appears on your Home screen.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),

            ...programs.map((prog) {
              final String id = prog["id"];
              final String title = prog["title"];
              final String subtitle = prog["subtitle"];
              final bool premium = prog["premium"];

              final isActive = currentProgramId == id;
              final isLocked = premium && !svc.isPremiumUser;

              return _programCard(
                title: title,
                subtitle: subtitle,
                isActive: isActive,
                isLocked: isLocked,
                isPremium: premium,
                onTap: () => _onProgramTapped(svc, id, title, isLocked),
              );
            }).toList(),

            const SizedBox(height: 30),

            // ============================================================
            // MACRO GOALS
            // ============================================================
            Text(
              "Nutrition Goals",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "These targets are used to guide your daily calorie and macro tracking.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _goalField("Calorie Goal (kcal)", calorieCtrl),
                  const SizedBox(height: 14),
                  _goalField("Protein Goal (g)", proteinCtrl),
                  const SizedBox(height: 14),
                  _goalField("Carbs Goal (g)", carbsCtrl),
                  const SizedBox(height: 14),
                  _goalField("Fats Goal (g)", fatsCtrl),
                  const SizedBox(height: 25),

                  // SAVE BUTTON
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
                        if (!_formKey.currentState!.validate()) return;

                        svc.updateGoals(
                          newCalories: int.parse(calorieCtrl.text),
                          newProtein: int.parse(proteinCtrl.text),
                          newCarbs: int.parse(carbsCtrl.text),
                          newFats: int.parse(fatsCtrl.text),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Goals Updated! 💪🔥"),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: Text(
                        "SAVE GOALS",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRAM CARD
  // ============================================================
  Widget _programCard({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLocked,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLocked ? _showPremiumLockedMessage : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isActive ? PaceoTheme.primaryRed : Colors.grey.withOpacity(0.2),
            width: isActive ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PaceoTheme.primaryRed.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.flag_rounded, color: PaceoTheme.primaryRed),
            ),
            const SizedBox(width: 12),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + ACTIVE TAG
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Active",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Premium icon
                  if (isLocked || isPremium)
                    Row(
                      children: [
                        Icon(
                          isLocked ? Icons.lock_rounded : Icons.star_rounded,
                          size: 14,
                          color: isLocked
                              ? Colors.orange.shade700
                              : Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isLocked ? "Premium only" : "Premium program",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isLocked
                                ? Colors.orange.shade800
                                : Colors.amber.shade800,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            if (!isLocked)
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRAM LOGIC
  // ============================================================
  Future<void> _onProgramTapped(
    WorkoutDataService svc,
    String id,
    String title,
    bool isLocked,
  ) async {
    if (isLocked) {
      _showPremiumLockedMessage();
      return;
    }

    final currentId = svc.activeProgramId;

    if (currentId == id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$title is already your active program.",
              style: GoogleFonts.poppins()),
        ),
      );
      return;
    }

    final isSwitching = currentId != null;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isSwitching ? "Switch Program" : "Start Program",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          isSwitching
              ? "Switch from your current program to $title? It will restart at Day 1."
              : "Start the $title program and generate daily plans from today?",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Confirm",
              style: TextStyle(color: PaceoTheme.primaryRed),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await svc.startProgram(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSwitching
              ? "Switched to $title program! 🎯"
              : "$title program started! 🎯",
          style: GoogleFonts.poppins(),
        ),
      ),
    );

    setState(() {});
  }

  // ============================================================
  // CANCEL PROGRAM DIALOG
  // ============================================================
  void _showCancelProgramDialog(WorkoutDataService svc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Cancel Program",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Are you sure you want to cancel your fitness program?",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await svc.clearProgram();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Program cancelled.")),
              );
              setState(() {});
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

  // ============================================================
  // PREMIUM LOCK MESSAGE
  // ============================================================
  void _showPremiumLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Premium only program. Upgrade in Profile to unlock. 👑"),
      ),
    );
  }

  // ============================================================
  // GOAL FIELD WIDGET
  // ============================================================
  Widget _goalField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
