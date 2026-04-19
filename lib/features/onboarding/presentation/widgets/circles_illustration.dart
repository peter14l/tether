import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class CirclesIllustration extends StatefulWidget {
  const CirclesIllustration({super.key});

  @override
  State<CirclesIllustration> createState() => _CirclesIllustrationState();
}

class _CirclesIllustrationState extends State<CirclesIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _parallaxOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!mounted) return;
      setState(() {
        // Simple parallax: map accelerometer to ±4px
        _parallaxOffset = Offset(
          event.x.clamp(-10, 10) * 0.4,
          event.y.clamp(-10, 10) * 0.4,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 300),
          painter: CirclesPainter(
            rotation: _controller.value,
            parallax: _parallaxOffset,
          ),
        );
      },
    );
  }
}

class CirclesPainter extends CustomPainter {
  final double rotation;
  final Offset parallax;

  CirclesPainter({required this.rotation, required this.parallax});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ring 3 (Family) - Deepest
    _drawRing(
      canvas,
      center + parallax * 0.4 + const Offset(10, 10),
      120, // radius
      rotation * 2 * math.pi * 0.2,
      LinenEmberTheme.accentGoldenAmber,
      1.5,
      "Family",
    );

    // Ring 2 (Best Friends) - Mid
    _drawRing(
      canvas,
      center + parallax * 0.7 - const Offset(20, 10),
      90, // radius
      -rotation * 2 * math.pi * 0.3,
      LinenEmberTheme.accentSunsetOrange,
      2.0,
      "Best Friends",
    );

    // Ring 1 (Partner) - Top
    _drawRing(
      canvas,
      center + parallax * 1.0 + const Offset(-10, 20),
      60, // radius
      rotation * 2 * math.pi * 0.5,
      LinenEmberTheme.accentRoseViolet,
      2.0,
      "Partner",
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    Color color,
    double strokeWidth,
    String label,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, paint);

    // Draw label inside
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: LinenEmberTheme.caption(color: color).copyWith(fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Position text inside ring, slightly offset based on angle
    final labelOffset = Offset(
      center.dx - textPainter.width / 2 + math.cos(angle) * (radius * 0.3),
      center.dy - textPainter.height / 2 + math.sin(angle) * (radius * 0.3),
    );
    textPainter.paint(canvas, labelOffset);
  }

  @override
  bool shouldRepaint(covariant CirclesPainter oldDelegate) => true;
}
