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
    this.blur = 24.0,
    this.opacity = 0.6,
    this.borderRadius,
    this.color,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? Theme.of(context).colorScheme.surface).withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(18),
            border: border ?? Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ),
    );
  }
}
