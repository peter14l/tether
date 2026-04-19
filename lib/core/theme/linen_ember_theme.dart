import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinenEmberTheme {
  // Colors
  static const Color backgroundPrimary = Color(0xFF0D0A12);
  static const Color backgroundSecondary = Color(0xFF13101A);
  static const Color surfaceElevated = Color(0xFF1C1726);
  static const Color surfaceMuted = Color(0xFF221D2E);

  static const Color accentSunsetOrange = Color(0xFFE8692A);
  static const Color accentRoseViolet = Color(0xFFC2527A);
  static const Color accentGoldenAmber = Color(0xFFF0A832);
  static const Color accentSoftCoral = Color(0xFFE87B5A);

  static const Color textPrimary = Color(0xFFF5EDE0);
  static const Color textSecondary = Color(0xFFA89880);
  static const Color textTertiary = Color(0xFF6B5F52);

  static const Color divider = Color(0x14F5EDE0); // rgba(245, 237, 224, 0.08)
  static const Color borderSubtle = Color(0xFF2A2338);

  // Shadows
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x59000000), // rgba(0,0,0,0.35)
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x73000000), // rgba(0,0,0,0.45)
    blurRadius: 20,
    offset: Offset(0, 6),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x8C000000), // rgba(0,0,0,0.55)
    blurRadius: 40,
    offset: Offset(0, 12),
  );

  static const BoxShadow shadowGlow = BoxShadow(
    color: Color(0x33E8692A), // rgba(232,105,42,0.20)
    blurRadius: 32,
    offset: Offset(0, 0),
  );

  // Corner Radius
  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double radiusXl = 40.0;
  static const double radiusFull = 9999.0;

  // Typography
  static TextStyle displayHero({double fontSize = 40, Color? color}) => GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: color ?? textPrimary,
      );

  static TextStyle heading({double fontSize = 32, Color? color}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color ?? textPrimary,
      );

  static TextStyle headingItalic({double fontSize = 32, Color? color}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: color ?? textPrimary,
      );

  static TextStyle body({double fontSize = 15, FontWeight? fontWeight, Color? color}) =>
      GoogleFonts.dmSans(
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? textSecondary,
        height: 1.7,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: color ?? textSecondary,
        letterSpacing: 0.08,
      );

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        primary: accentSunsetOrange,
        secondary: accentRoseViolet,
        tertiary: accentGoldenAmber,
        surface: surfaceElevated,
        onSurface: textPrimary,
        background: backgroundPrimary,
        onBackground: textPrimary,
      ),
      dividerColor: divider,
      textTheme: TextTheme(
        displayLarge: displayHero(),
        headlineLarge: heading(),
        bodyLarge: body(fontSize: 16),
        bodyMedium: body(fontSize: 15),
        labelSmall: caption(),
      ),
    );
  }
}
