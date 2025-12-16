import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/paceo_theme.dart';

class ProgramScheduleScreen extends StatefulWidget {
  final String programId;
  final List<List<Map<String, dynamic>>> program;

  const ProgramScheduleScreen({
    super.key,
    required this.programId,
    required this.program,
  });

  @override
  State<ProgramScheduleScreen> createState() => _ProgramScheduleScreenState();
}

class _ProgramScheduleScreenState extends State<ProgramScheduleScreen> {
  static const int kTotalDays = 30; // 📅 Show 30 days in schedule
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    final templateLength = widget.program.length;

    // Guard: if template is empty, just show message
    final List<Map<String, dynamic>> selectedItems;
    if (templateLength == 0) {
      selectedItems = const [];
    } else {
      final selectedIndex = (_selectedDay - 1) % templateLength;
      selectedItems = widget.program[selectedIndex];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Program Schedule",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: widget.program.isEmpty
          ? Center(
              child: Text(
                "No schedule data for this program yet.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // Top info + note about repetition
                // =========================================================
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tap a day to view its plan.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.program.length > 1)
                        Text(
                          "Base template: ${widget.program.length} unique days • Schedule repeats after Day ${widget.program.length}.",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),

                // =========================================================
                // Day selector row (calendar vibes)
                // =========================================================
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: kTotalDays,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final dayNumber = index + 1;
                      final isSelected = _selectedDay == dayNumber;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = dayNumber;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          width: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PaceoTheme.primaryRed
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                color: Colors.black.withOpacity(0.06),
                              ),
                            ],
                            border: Border.all(
                              color: isSelected
                                  ? PaceoTheme.primaryRed
                                  : Colors.grey.withOpacity(0.2),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Day",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "$dayNumber",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // =========================================================
                // Selected day details
                // =========================================================
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    children: [
                      Text(
                        "Day $_selectedDay Plan",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        templateLength > 0
                            ? "Using template Day ${((_selectedDay - 1) % templateLength) + 1} of $templateLength"
                            : "No template for this program.",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (selectedItems.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                                color: Colors.black.withOpacity(0.06),
                              ),
                            ],
                          ),
                          child: Text(
                            "No activities defined for this day.",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      else
                        ...selectedItems.map((item) {
                          final isWorkout =
                              (item["type"] ?? "workout") == "workout";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                  color: Colors.black.withOpacity(0.06),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isWorkout
                                        ? PaceoTheme.primaryRed
                                            .withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    isWorkout
                                        ? Icons.fitness_center
                                        : Icons.restaurant,
                                    size: 18,
                                    color: isWorkout
                                        ? PaceoTheme.primaryRed
                                        : Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"] ?? "",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (item["description"] != null &&
                                          (item["description"] as String)
                                              .isNotEmpty)
                                        Text(
                                          item["description"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isWorkout
                                            ? "${item["minutes"] ?? 20} mins • ${item["calories"] ?? 100} kcal • ${item["category"] ?? "Workout"}"
                                            : "${item["calories"] ?? 120} kcal • ${item["category"] ?? "Meal"}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
