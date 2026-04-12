import 'package:flutter/material.dart';

enum TimeSlot { morning, afternoon, dusk, night }

class ThemeTokens {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundElevated;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderDefault;
  final Color borderGlowColor;

  const ThemeTokens({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundElevated,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderDefault,
    required this.borderGlowColor,
  });

  static const morning = ThemeTokens(
    backgroundPrimary: Color(0xFFF5F0E8),
    backgroundSecondary: Color(0xFFEDE5D8),
    backgroundElevated: Color(0xFFFFFFFF),
    accentPrimary: Color(0xFFE8956D),
    accentSecondary: Color(0xFFA8C5A0),
    textPrimary: Color(0xFF2C2416),
    textSecondary: Color(0xFF6B5B47),
    borderDefault: Color(0x33A88C6E),
    borderGlowColor: Color(0x59E8956D),
  );

  static const afternoon = ThemeTokens(
    backgroundPrimary: Color(0xFFF8F3EC),
    backgroundSecondary: Color(0xFFF0E8DC),
    backgroundElevated: Color(0xFFFFFFFF),
    accentPrimary: Color(0xFFC4813A),
    accentSecondary: Color(0xFF88B4A8),
    textPrimary: Color(0xFF1E1810),
    textSecondary: Color(0xFF5C4A35),
    borderDefault: Color(0x2E967850),
    borderGlowColor: Color(0x66C4813A),
  );

  static const dusk = ThemeTokens(
    backgroundPrimary: Color(0xFF1A1018),
    backgroundSecondary: Color(0xFF231520),
    backgroundElevated: Color(0xFF2D1E28),
    accentPrimary: Color(0xFFFF7B3A),
    accentSecondary: Color(0xFFC45BAA),
    textPrimary: Color(0xFFFFF0E6),
    textSecondary: Color(0xFFD4A89A),
    borderDefault: Color(0x2EFF7B3A),
    borderGlowColor: Color(0x8CFF7B3A),
  );

  static const night = ThemeTokens(
    backgroundPrimary: Color(0xFF0E0C14),
    backgroundSecondary: Color(0xFF141220),
    backgroundElevated: Color(0xFF1C1A2A),
    accentPrimary: Color(0xFF6B7FD4),
    accentSecondary: Color(0xFF4A5FA8),
    textPrimary: Color(0xFFE8E6F0),
    textSecondary: Color(0xFF9898C0),
    borderDefault: Color(0x266B7FD4),
    borderGlowColor: Color(0x596B7FD4),
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
