import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class BentoGridIllustration extends StatelessWidget {
  const BentoGridIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBentoCell(
                    '📸 Shared Memories',
                    LinenEmberTheme.accentSunsetOrange,
                  ).animate().scale(delay: 0.ms, duration: 300.ms, curve: Curves.easeOutBack),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildBentoCell(
                    '🏆 Win',
                    LinenEmberTheme.accentGoldenAmber,
                  ).animate().scale(delay: 80.ms, duration: 300.ms, curve: Curves.easeOutBack),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildBentoCell(
                    '✅ Check In',
                    LinenEmberTheme.accentRoseViolet,
                  ).animate().scale(delay: 160.ms, duration: 300.ms, curve: Curves.easeOutBack),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildBentoCell(
                    '🎙️ Voice Note',
                    LinenEmberTheme.accentSoftCoral,
                  ).animate().scale(delay: 240.ms, duration: 300.ms, curve: Curves.easeOutBack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCell(String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LinenEmberTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(LinenEmberTheme.radiusMd),
        border: Border.all(color: LinenEmberTheme.borderSubtle),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: LinenEmberTheme.body(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LinenEmberTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
