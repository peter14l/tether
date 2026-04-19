import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/circles_illustration.dart';

class CirclesFeaturePage extends StatelessWidget {
  const CirclesFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Column(
        children: [
          // Top illustration zone
          const Expanded(
            flex: 45,
            child: CirclesIllustration(),
          ),
          
          // Content zone
          Expanded(
            flex: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your world, in circles.',
                    style: LinenEmberTheme.headingItalic(fontSize: 36),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  Text(
                    "Share with exactly the right people. A share to your 'Best Friends' circle stays there. No oversharing. No context collapse. Just intentional closeness.",
                    style: LinenEmberTheme.body(),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 32),
                  
                  _buildBullet('🔒', 'Private micro-networks'),
                  const SizedBox(height: 12),
                  _buildBullet('📅', 'Strictly chronological — no AI curation'),
                  const SizedBox(height: 12),
                  _buildBullet('👁', 'You control who sees everything'),
                ].animate(interval: 100.ms).fadeIn(delay: 400.ms),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String icon, String text) {
    return Row(
      children: [
        Container(
          width: 2,
          height: 36,
          decoration: BoxDecoration(
            color: LinenEmberTheme.accentSunsetOrange.withOpacity(0.4),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 16),
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: LinenEmberTheme.body(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: LinenEmberTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
