import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhisperText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final TextAlign? textAlign;
  final bool uppercase;

  const WhisperText(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 12,
    this.textAlign,
    this.uppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      uppercase ? text.toUpperCase() : text,
      textAlign: textAlign,
      style: GoogleFonts.dmSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.05 * (fontSize / 12),
        color: (color ?? Theme.of(context).colorScheme.onSurface).withOpacity(0.85),
      ),
    );
  }
}
