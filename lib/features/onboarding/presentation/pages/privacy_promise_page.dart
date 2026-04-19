import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class PrivacyPromisePage extends StatelessWidget {
  const PrivacyPromisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundSecondary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              'Your data is not our product.',
              style: LinenEmberTheme.headingItalic(fontSize: 38),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 12),
            Container(
              height: 1,
              width: 64,
              color: LinenEmberTheme.accentSunsetOrange.withOpacity(0.6),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 48),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPromiseItem(
                    Icons.lock_outline_rounded,
                    'Row Level Security',
                    'Your data is protected at the database level.',
                  ),
                  _buildPromiseItem(
                    Icons.block_rounded,
                    'No Third-Party Trackers',
                    'No pixels. No shadow profiles. Ever.',
                  ),
                  _buildPromiseItem(
                    Icons.money_off_rounded,
                    'No Ads. Ever.',
                    'We earn from subscriptions — not from selling you.',
                  ),
                  _buildPromiseItem(
                    Icons.code_rounded,
                    'Clean Architecture',
                    'Built to be auditable and trustworthy by design.',
                  ),
                ].animate(interval: 100.ms).fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromiseItem(IconData icon, String title, String body) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: LinenEmberTheme.accentSunsetOrange, size: 24),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: LinenEmberTheme.body(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: LinenEmberTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: LinenEmberTheme.body(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: LinenEmberTheme.borderSubtle, height: 1),
      ],
    );
  }
}
