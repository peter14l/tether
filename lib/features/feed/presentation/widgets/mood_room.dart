import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_panel.dart';

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
                Text(
                  'YOUR SANCTUARY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.labelSmall?.color?.withOpacity(0.6),
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mood Room',
                  style: theme.textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
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
                  Text(
                    'Feed is chronological ✓',
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                  ),
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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
    final colorScheme = theme.colorScheme;

    return GlassPanel(
      opacity: isSelected ? 0.4 : 0.2,
      border: isSelected ? Border.all(color: color, width: 2) : null,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
