import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = Provider.of<WorkoutDataService>(context);

    // Sort logs newest first
    final logs = List<Map<String, dynamic>>.from(svc.bodyLogs);
    logs.sort((a, b) =>
        DateTime.parse(b["timestamp"]).compareTo(DateTime.parse(a["timestamp"])));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Body Tracking",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: PaceoTheme.primaryRed,
        onPressed: () => _showWeightDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ CURRENT STATS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text("Latest BMI",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    logs.isNotEmpty ? "${logs.first["bmi"]}" : "--",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: PaceoTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    logs.isNotEmpty
                        ? "Weight: ${logs.first["weight"]} kg"
                        : "Add a weight entry",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "History",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        "No logs yet 👀",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];

                        // Safe timestamp parsing
                        final time = DateTime.parse(log["timestamp"]);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${log["weight"]} kg",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "BMI: ${log["bmi"]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "${time.year}/${time.month}/${time.day}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  svc.bodyLogs.remove(log);
                                  svc.notifyListeners();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  // 📌 Pop up dialog to add weight
  void _showWeightDialog(BuildContext context) {
    final ctrl = TextEditingController();
    final svc = Provider.of<WorkoutDataService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text("Add Weight", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Weight in kg",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: PaceoTheme.primaryRed),
            onPressed: () {
              final w = double.tryParse(ctrl.text);
              if (w == null) return;

              svc.addBodyLog(weight: w); // ✔ FIXED
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
