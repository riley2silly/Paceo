import 'package:flutter/material.dart';
import '../theme/paceo_theme.dart';

class PaceoTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const PaceoTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: PaceoTheme.textMuted,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
