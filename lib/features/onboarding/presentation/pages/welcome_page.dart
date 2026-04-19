import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/ambient_blob.dart';
import '../widgets/breathing_orb.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Stack(
        children: [
          const AmbientBlob(
            color: Color(0x2EC2527A), // rgba(194, 82, 122, 0.18)
            position: Offset(-80, -100),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The internet is loud.',
                      style: LinenEmberTheme.headingItalic(fontSize: 40),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 12),
                    Text(
                      'Tether is quiet.',
                      style: LinenEmberTheme.headingItalic(
                        fontSize: 44,
                        color: LinenEmberTheme.accentSunsetOrange,
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'Tether is a private sanctuary for the people who matter most — your close friends, your partner, your family. No algorithms. No likes. No noise.',
                  style: LinenEmberTheme.body(),
                ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                const Spacer(),
                const Center(
                  child: BreathingOrb(),
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
