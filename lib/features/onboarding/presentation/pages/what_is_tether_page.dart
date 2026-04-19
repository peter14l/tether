import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/ambient_blob.dart';

class WhatIsTetherPage extends StatelessWidget {
  const WhatIsTetherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Stack(
        children: [
          const AmbientBlob(
            color: Color(0x1AF0A832), // rgba(240, 168, 50, 0.10)
            position: Offset(40, 400), // bottom-left approx
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Not social media.',
                  style: LinenEmberTheme.headingItalic(fontSize: 36),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                Text(
                  'A digital sanctuary.',
                  style: LinenEmberTheme.headingItalic(
                    fontSize: 36,
                    color: LinenEmberTheme.accentSunsetOrange,
                  ),
                ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  width: 64,
                  color: LinenEmberTheme.textPrimary.withOpacity(0.12),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 40),
                _buildContrastRow(
                  'Algorithmic noise',
                  'Chronological truth',
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                _buildContrastRow(
                  'Follower counts',
                  'Intimate circles',
                ).animate().fadeIn(delay: 520.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                _buildContrastRow(
                  'Likes & metrics',
                  'Pure connection',
                ).animate().fadeIn(delay: 640.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContrastRow(String left, String right) {
    return Container(
      decoration: BoxDecoration(
        color: LinenEmberTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(LinenEmberTheme.radiusMd),
        border: Border.all(color: LinenEmberTheme.borderSubtle),
        boxShadow: const [LinenEmberTheme.shadowSm],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.close_rounded, color: LinenEmberTheme.accentRoseViolet, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      left,
                      style: LinenEmberTheme.body(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: LinenEmberTheme.borderSubtle,
              thickness: 1,
              width: 32,
            ),
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.check_rounded, color: LinenEmberTheme.accentSunsetOrange, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      right,
                      style: LinenEmberTheme.body(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: LinenEmberTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
