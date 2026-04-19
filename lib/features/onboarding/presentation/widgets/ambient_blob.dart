import 'dart:ui';
import 'package:flutter/material.dart';

class AmbientBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Offset position;
  final double blur;

  const AmbientBlob({
    super.key,
    required this.color,
    this.size = 400.0,
    this.position = const Offset(-80, -100),
    this.blur = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      right: position.dx,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                width: size,
                height: size,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
