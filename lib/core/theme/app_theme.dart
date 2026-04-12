import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_tokens.dart';

class AppTheme {
  static ThemeData getTheme(TimeSlot slot) {
    final tokens = ThemeTokens.getTokens(slot);
    final isDark = slot == TimeSlot.dusk || slot == TimeSlot.night;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: tokens.accentPrimary,
        onPrimary: isDark ? Colors.white : Colors.black,
        secondary: tokens.accentSecondary,
        onSecondary: isDark ? Colors.white : Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: tokens.backgroundElevated,
        onSurface: tokens.textPrimary,
        surfaceContainerLowest: tokens.backgroundPrimary, // Using surfaceContainerLowest for primary background
      ),
      scaffoldBackgroundColor: tokens.backgroundPrimary,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        titleLarge: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: tokens.textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: tokens.textSecondary,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: tokens.textSecondary,
        ),
      ),
      cardTheme: CardTheme(
        color: tokens.backgroundElevated,
        elevation: isDark ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: tokens.borderDefault),
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
