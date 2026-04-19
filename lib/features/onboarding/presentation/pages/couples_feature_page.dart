import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/couples_illustration.dart';

class CouplesFeaturePage extends StatelessWidget {
  const CouplesFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const CouplesIllustration(),
            const SizedBox(height: 40),
            Text(
              'A space for just the two of you.',
              style: LinenEmberTheme.headingItalic(fontSize: 36),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
            Text(
              'A fully private, encrypted world built for couples. Share milestones, plan your future together, and go deeper than day-to-day logistics.',
              style: LinenEmberTheme.body(),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    Icons.calendar_today_rounded,
                    'Shared Calendar',
                    'Plan life, celebrate history.',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    Icons.lock_outline_rounded,
                    'Private Vault',
                    'Encrypted. Only yours.',
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LinenEmberTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(LinenEmberTheme.radiusLg),
        border: Border.all(color: LinenEmberTheme.borderSubtle),
        boxShadow: const [LinenEmberTheme.shadowMd],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: LinenEmberTheme.accentSunsetOrange, size: 24),
          const SizedBox(height: 16),
          Text(
            title,
            style: LinenEmberTheme.body(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LinenEmberTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: LinenEmberTheme.body(
              fontSize: 13,
              color: LinenEmberTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
