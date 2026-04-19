import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class CouplesIllustration extends StatefulWidget {
  const CouplesIllustration({super.key});

  @override
  State<CouplesIllustration> createState() => _CouplesIllustrationState();
}

class _CouplesIllustrationState extends State<CouplesIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 360),
    )..repeat();
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
          size: const Size(double.infinity, 200),
          painter: CouplesPainter(rotation: _controller.value),
        );
      },
    );
  }
}

class CouplesPainter extends CustomPainter {
  final double rotation;

  CouplesPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 70.0;
    const offset = 30.0;

    final leftCenter = center - const Offset(offset, 0);
    final rightCenter = center + const Offset(offset, 0);

    // Draw left ring
    _drawRing(canvas, leftCenter, radius, rotation * 2 * math.pi, LinenEmberTheme.accentSunsetOrange);
    
    // Draw right ring
    _drawRing(canvas, rightCenter, radius, -rotation * 0.8 * 2 * math.pi, LinenEmberTheme.accentRoseViolet);

    // Draw intersection ellipse
    final intersectionPaint = Paint()..color = LinenEmberTheme.accentSoftCoral;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 40, height: 40),
      intersectionPaint,
    );
  }

  void _drawRing(Canvas canvas, Offset center, double radius, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CouplesPainter oldDelegate) => true;
}
