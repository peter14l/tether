import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/ambient_blob.dart';
import '../widgets/breathing_orb.dart';
import '../widgets/mood_orb_row.dart';

class WellnessFeaturePage extends StatelessWidget {
  const WellnessFeaturePage({super.key});

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
          Column(
            children: [
              // Top zone
              Expanded(
                flex: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const MoodOrbRow(),
                    const SizedBox(height: 60),
                    const BreathingOrb(showLabels: true),
                  ],
                ),
              ),
              
              // Bottom zone
              Expanded(
                flex: 45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your feelings live here too.',
                        style: LinenEmberTheme.headingItalic(fontSize: 34),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Log your emotional state and share your vibe with your circles — on your terms. Friends can show up for you without you having to explain yourself.',
                        style: LinenEmberTheme.body(),
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
