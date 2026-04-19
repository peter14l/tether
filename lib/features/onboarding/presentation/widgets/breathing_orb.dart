import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class BreathingOrb extends StatefulWidget {
  final bool showLabels;
  const BreathingOrb({super.key, this.showLabels = false});

  @override
  State<BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<BreathingOrb> {
  int _labelIndex = 0;
  final List<String> _labels = ["Breathe in...", "Hold...", "Breathe out..."];
  final List<Duration> _durations = [
    const Duration(milliseconds: 2000),
    const Duration(milliseconds: 800),
    const Duration(milliseconds: 2000),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showLabels) {
      _startLabelCycle();
    }
  }

  void _startLabelCycle() async {
    while (mounted) {
      await Future.delayed(_durations[_labelIndex]);
      if (!mounted) return;
      setState(() {
        _labelIndex = (_labelIndex + 1) % _labels.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            _buildRing(96, const Color(0x1AE8692A)), // 0.10 opacity
            // Middle ring
            _buildRing(64, const Color(0x33E8692A)), // 0.20 opacity
            // Core
            _buildRing(32, LinenEmberTheme.accentSunsetOrange),
          ],
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.15, 1.15),
              duration: 2000.ms,
              curve: Curves.easeInOutSine,
            )
            .fadeIn(begin: 0.7, duration: 2000.ms),
        if (widget.showLabels) ...[
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _labels[_labelIndex],
              key: ValueKey(_labels[_labelIndex]),
              style: LinenEmberTheme.body(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: LinenEmberTheme.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRing(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
