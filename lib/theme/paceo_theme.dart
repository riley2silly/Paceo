import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaceoTheme {
  static const Color primaryRed = Color(0xFFE53935);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color softPink = Color(0xFFFFE6E6);
  static const Color textMuted = Color(0xFF757575);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: darkRed,
      ),
    );
  }
}
