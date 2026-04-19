import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 1.0, // Solid opacity
    this.borderRadius,
    this.color,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: (color ?? theme.colorScheme.surfaceContainerHighest).withOpacity(1.0), // Solid color
        borderRadius: borderRadius ?? BorderRadius.circular(18),
        border: border ?? Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
