import 'package:flutter/material.dart';

class DigitalHugAnimation extends StatelessWidget {
  const DigitalHugAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Container(
          width: 200 * value,
          height: 200 * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(1.0 - value),
          ),
        );
      },
    );
  }
}

class HeartbeatAnimation extends StatelessWidget {
  const HeartbeatAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: const Icon(Icons.favorite, color: Colors.red, size: 100),
        );
      },
    );
  }
}
