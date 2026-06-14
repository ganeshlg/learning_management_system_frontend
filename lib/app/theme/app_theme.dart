import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0x0A4D68FF); // Note: Fix color format if needed, #0A4D68
  static const secondaryColor = Color(0x05BFDBFF); // #05BFDB
  static const accentColor = Color(0x00FFCAFF); // #00FFCA
  static const backgroundColor = Color(0xF6F8FBFF); // #F6F8FB
  static const textColor = Color(0x1E293BFF); // #1E293B

  // Correcting HEX to Flutter Color (0xFF + Hex without #)
  static const Color brandPrimary = Color(0xFF0A4D68);
  static const Color brandSecondary = Color(0xFF05BFDB);
  static const Color brandAccent = Color(0xFF00FFCA);
  static const Color brandBackground = Color(0xFFF6F8FB);
  static const Color brandText = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        primary: brandPrimary,
        secondary: brandSecondary,
        tertiary: brandAccent,
        background: brandBackground,
        surface: Colors.white,
        onBackground: brandText,
        onSurface: brandText,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: brandBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: brandText,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: Brightness.dark,
        primary: brandPrimary,
        secondary: brandSecondary,
        tertiary: brandAccent,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
