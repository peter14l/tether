import 'package:flutter/material.dart';

enum TimeSlot { morning, afternoon, dusk, night }

class ThemeTokens {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundElevated;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentTertiary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnAccent;
  final Color borderDefault;
  final Color borderGlowColor;
  final List<BoxShadow> glowShadows;

  const ThemeTokens({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundElevated,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnAccent,
    required this.borderDefault,
    required this.borderGlowColor,
    required this.glowShadows,
  });

  static const morning = ThemeTokens(
    backgroundPrimary: Color(0xFFF5F0E8), // Warm Linen
    backgroundSecondary: Color(0xFFEDE5D8),
    backgroundElevated: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF0E8DC),
    surfaceContainer: Color(0xFFEDE5D8),
    surfaceContainerHigh: Color(0xFFE5DBCB),
    surfaceContainerHighest: Color(0xFFDDD2BE),
    accentPrimary: Color(0xFFFB7837), // Terracotta
    accentSecondary: Color(0xFFA8C5A0), // Sage
    accentTertiary: Color(0xFFFEB246), // Golden Amber
    textPrimary: Color(0xFF3A2300),
    textSecondary: Color(0xFF623D00),
    textOnAccent: Color(0xFFFFFFFF),
    borderDefault: Color(0x2E623D00),
    borderGlowColor: Color(0x59FB7837),
    glowShadows: [
      BoxShadow(
        color: Color(0x26FB7837),
        blurRadius: 15,
        offset: Offset(0, 0),
      ),
    ],
  );

  static const afternoon = ThemeTokens(
    backgroundPrimary: Color(0xFFF8F3EC), // Light Cream
    backgroundSecondary: Color(0xFFF0E8DC),
    backgroundElevated: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF3E9DD),
    surfaceContainer: Color(0xFFEEE3D3),
    surfaceContainerHigh: Color(0xFFE9DDC9),
    surfaceContainerHighest: Color(0xFFE4D7BF),
    accentPrimary: Color(0xFFFEB246), // Golden Amber
    accentSecondary: Color(0xFF88B4A8), // Muted Teal
    accentTertiary: Color(0xFFFB7837), // Terracotta
    textPrimary: Color(0xFF3A2300),
    textSecondary: Color(0xFF623D00),
    textOnAccent: Color(0xFFFFFFFF),
    borderDefault: Color(0x2E623D00),
    borderGlowColor: Color(0x66FEB246),
    glowShadows: [
      BoxShadow(
        color: Color(0x33FEB246),
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ],
  );

  static const dusk = ThemeTokens(
    backgroundPrimary: Color(0xFF150B13), // Deep Plum-Black
    backgroundSecondary: Color(0xFF1B1019),
    backgroundElevated: Color(0xFF231520),
    surfaceContainerLow: Color(0xFF1B1019),
    surfaceContainer: Color(0xFF231520),
    surfaceContainerHigh: Color(0xFF2A1A27),
    surfaceContainerHighest: Color(0xFF32202F),
    accentPrimary: Color(0xFFFF7B3A), // Sunset Orange
    accentSecondary: Color(0xFFFFADE5), // Rose-Violet
    accentTertiary: Color(0xFFFFC479), // Amber
    textPrimary: Color(0xFFFBDDF2),
    textSecondary: Color(0xFFBEA3B7),
    textOnAccent: Color(0xFF551C00),
    borderDefault: Color(0x2EBEA3B7),
    borderGlowColor: Color(0x8CFF7B3A),
    glowShadows: [
      BoxShadow(
        color: Color(0x66FF7B3A),
        blurRadius: 32,
        offset: Offset(0, 0),
      ),
      BoxShadow(
        color: Color(0x14FF7B3A),
        blurRadius: 40,
        offset: Offset(0, 0),
      ),
    ],
  );

  static const night = ThemeTokens(
    backgroundPrimary: Color(0xFF0E0C14), // Navy-Black
    backgroundSecondary: Color(0xFF12101A),
    backgroundElevated: Color(0xFF15131C),
    surfaceContainerLow: Color(0xFF12101A),
    surfaceContainer: Color(0xFF15131C),
    surfaceContainerHigh: Color(0xFF1E1B29),
    surfaceContainerHighest: Color(0xFF242131),
    accentPrimary: Color(0xFF6B7FD4), // Periwinkle
    accentSecondary: Color(0xFFFFADE5), // Lavender-ish
    accentTertiary: Color(0xFFFFC479), // Amber
    textPrimary: Color(0xFFFBDDF2),
    textSecondary: Color(0xFFBEA3B7),
    textOnAccent: Color(0xFFFFFFFF),
    borderDefault: Color(0x2EBEA3B7),
    borderGlowColor: Color(0x596B7FD4),
    glowShadows: [
      BoxShadow(
        color: Color(0x666B7FD4),
        blurRadius: 32,
        offset: Offset(0, 0),
      ),
      BoxShadow(
        color: Color(0x146B7FD4),
        blurRadius: 44,
        offset: Offset(0, 0),
      ),
    ],
  );

  static ThemeTokens getTokens(TimeSlot slot) {
    switch (slot) {
      case TimeSlot.morning: return morning;
      case TimeSlot.afternoon: return afternoon;
      case TimeSlot.dusk: return dusk;
      case TimeSlot.night: return night;
    }
  }
}
