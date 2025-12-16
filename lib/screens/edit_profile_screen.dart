import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/workout_data_service.dart';
import '../theme/paceo_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;

  String genderValue = "Not set";

  @override
  void initState() {
    super.initState();
    final user = Provider.of<WorkoutDataService>(context, listen: false);

    nameCtrl = TextEditingController(text: user.userName);
    ageCtrl = TextEditingController(text: user.age.toString());
    heightCtrl = TextEditingController(text: user.height.toString());
    weightCtrl = TextEditingController(text: user.currentWeight.toString());

    // 👌 If invalid, fallback to "Not set"
    if (["Male", "Female", "Other", "Not set"].contains(user.gender)) {
      genderValue = user.gender;
    } else {
      genderValue = "Not set";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WorkoutDataService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _textField("Name", nameCtrl, TextInputType.name),
              const SizedBox(height: 14),
              _textField("Age", ageCtrl, TextInputType.number),
              const SizedBox(height: 14),
              _textField("Height (cm)", heightCtrl, TextInputType.number),
              const SizedBox(height: 14),
              _textField("Weight (kg)", weightCtrl, TextInputType.number),
              const SizedBox(height: 18),

              // 👩 Gender Dropdown
              Text(
                "Gender",
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: genderValue,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: const [
                    DropdownMenuItem(value: "Not set", child: Text("Select gender")),
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (val) {
                    setState(() => genderValue = val ?? "Not set");
                  },
                ),
              ),

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

                    user.updateUserProfile(
                      newName: nameCtrl.text.trim().isEmpty ? "User" : nameCtrl.text.trim(),
                      newGender: genderValue,
                      newHeight: double.tryParse(heightCtrl.text) ?? user.height,
                      newWeight: double.tryParse(weightCtrl.text) ?? user.currentWeight,
                      newAge: int.tryParse(ageCtrl.text) ?? user.age,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile Updated! 🎉"),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    "SAVE CHANGES",
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
      ),
    );
  }

  Widget _textField(String label, TextEditingController ctrl, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
