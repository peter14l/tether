import 'package:flutter/material.dart';

class BreathingRoomScreen extends StatefulWidget {
  const BreathingRoomScreen({super.key});

  @override
  State<BreathingRoomScreen> createState() => _BreathingRoomScreenState();
}

class _BreathingRoomScreenState extends State<BreathingRoomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _guideText = "Prepare...";

  @override
  void initState() {
    super.initState();
    // Total cycle: 4 (inhale) + 7 (hold) + 8 (exhale) = 19 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 19),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 4.0 / 19.0, curve: Curves.easeInOut),
      ),
    );

    _controller.addListener(() {
      final progress = _controller.value * 19;
      setState(() {
        if (progress < 4) {
          _guideText = "Inhale...";
        } else if (progress < 11) {
          _guideText = "Hold...";
        } else {
          _guideText = "Exhale...";
        }
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Manually handle the 4-7-8 scaling
                double scale = 0.2;
                final progress = _controller.value * 19;
                
                if (progress < 4) {
                  // Inhale (4s): scale from 0.2 to 1.0
                  scale = 0.2 + (progress / 4.0) * 0.8;
                } else if (progress < 11) {
                  // Hold (7s): stay at 1.0
                  scale = 1.0;
                } else {
                  // Exhale (8s): scale from 1.0 to 0.2
                  scale = 1.0 - ((progress - 11.0) / 8.0) * 0.8;
                }

                return Container(
                  width: 300 * scale,
                  height: 300 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 20 * scale,
                        spreadRadius: 10 * scale,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            Text(
              _guideText,
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "4-7-8 Breathing",
              style: TextStyle(letterSpacing: 2, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
