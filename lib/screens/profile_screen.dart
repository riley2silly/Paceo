import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

import 'edit_profile_screen.dart';
import 'body_screen.dart';
import 'meal_history_screen.dart';
import 'fitness_goal_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 Profile with REAL image + upload on tap
            GestureDetector(
              onTap: () async {
                await user.uploadProfileImage();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Profile photo updated! 📸✨")),
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : null,
                    child: user.imageUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 55, color: Colors.grey)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: PaceoTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              user.userName,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: user.isPremiumUser
                    ? Colors.amber.shade400
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                user.isPremiumUser ? "⭐ Premium User" : "Regular User",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: user.isPremiumUser ? Colors.black87 : Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Stats
            _profileStat("Weight", "${user.currentWeight} kg"),
            _profileStat("Height", "${user.height} cm"),
            _profileStat("Age", "${user.age} yrs"),
            _profileStat("Gender", user.gender),

            const SizedBox(height: 25),

            _item(
              context,
              Icons.flag_rounded,
              "Fitness Goals",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FitnessGoalScreen()),
                );
              },
            ),

            _item(
              context,
              Icons.monitor_weight_rounded,
              "Body Tracking",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BodyScreen()),
                );
              },
            ),

            _item(
              context,
              Icons.history_rounded,
              "Meal & Workout Logs",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MealHistoryScreen()),
                );
              },
            ),

            _item(
              context,
              Icons.star_rounded,
              user.isPremiumUser
                  ? "Premium Active"
                  : "Upgrade to Premium",
              onTap: () {
                if (user.isPremiumUser) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You are already Premium 👑")),
                  );
                } else {
                  user.setPremium(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Welcome to Premium! 🎉")),
                  );
                }
              },
            ),

            _item(
              context,
              Icons.logout_rounded,
              "Logout",
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                        "Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("Logout"),
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.black54)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _item(BuildContext ctx, IconData icon, String label,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
            Icon(icon, size: 26, color: PaceoTheme.primaryRed),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
