import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_tokens.dart';

class AppTheme {
  static ThemeData getTheme(TimeSlot slot, {bool? isDarkModeOverride}) {
    final isDark =
        isDarkModeOverride ?? (slot == TimeSlot.dusk || slot == TimeSlot.night);
    final tokens = isDark
        ? (slot == TimeSlot.night ? ThemeTokens.night : ThemeTokens.dusk)
        : ThemeTokens.getTokens(slot);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: tokens.accentPrimary,
        onPrimary: tokens.textOnAccent,
        secondary: tokens.accentSecondary,
        onSecondary: tokens.textOnAccent,
        tertiary: tokens.accentTertiary,
        onTertiary: tokens.textOnAccent,
        error: const Color(0xFFFF716C),
        onError: const Color(0xFF490006),
        surface: tokens.backgroundElevated,
        onSurface: tokens.textPrimary,
        surfaceContainerLowest: tokens.backgroundPrimary,
        surfaceContainerLow: tokens.surfaceContainerLow,
        surfaceContainer: tokens.surfaceContainer,
        surfaceContainerHigh: tokens.surfaceContainerHigh,
        surfaceContainerHighest: tokens.surfaceContainerHighest,
        outline: tokens.borderDefault,
        outlineVariant: tokens.borderDefault.withOpacity(0.18),
      ),
      scaffoldBackgroundColor: tokens.backgroundPrimary,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: tokens.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.notoSerif(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: tokens.textPrimary,
        ),
        headlineMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: tokens.textPrimary,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: tokens.textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: tokens.textSecondary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
          letterSpacing: 0.1,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: tokens.textSecondary.withOpacity(0.85),
          letterSpacing: 0.05,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.backgroundElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.accentPrimary,
          foregroundColor: tokens.textOnAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.accentPrimary,
          side: BorderSide(color: tokens.accentPrimary.withOpacity(0.18)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.borderDefault.withOpacity(0.18)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.borderDefault.withOpacity(0.18)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.accentPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(color: tokens.textSecondary),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: tokens.textSecondary.withOpacity(0.6),
        ),
      ),
    );
  }
}
