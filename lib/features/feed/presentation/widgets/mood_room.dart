import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';

class MoodRoom extends StatelessWidget {
  const MoodRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WhisperText('YOUR SANCTUARY'),
                const SizedBox(height: 8),
                Text(
                  'Mood Room',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 28,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              opacity: 0.1,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const WhisperText('Feed is chronological ✓'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _MoodButton(
              icon: Icons.air,
              label: 'Need Quiet',
              color: colorScheme.primary,
              isSelected: true,
            ),
            _MoodButton(
              icon: Icons.psychology,
              label: 'In My Head',
              color: colorScheme.tertiary,
            ),
            _MoodButton(
              icon: Icons.forum,
              label: 'Just Want to Chat',
              color: colorScheme.secondary,
            ),
            _MoodButton(
              icon: Icons.favorite,
              label: 'Feeling Anxious',
              color: colorScheme.error,
            ),
          ],
        ),
      ],
    );
  }
}

class _MoodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;

  const _MoodButton({
    required this.icon,
    required this.label,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassPanel(
      opacity: isSelected ? 0.15 : 0.05,
      border: isSelected ? Border.all(color: color.withOpacity(0.4), width: 2) : null,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: isSelected ? color : color.withOpacity(0.6), 
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
