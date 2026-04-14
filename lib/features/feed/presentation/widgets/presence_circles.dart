import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';

class PresenceCircles extends StatelessWidget {
  const PresenceCircles({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Close Circles',
          style: theme.textTheme.displaySmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 24,
            opacity: 0.8,
          ),
        ),
        const SizedBox(height: 24),
        _CircleCard(
          title: 'The Inner Well',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDLCSujWULcaARJ8g69gTIYKoa17noLEssoD7_UbNDN1RANXB030w7wJt8vcLHumA2ZaZyC0wodjattd7xj3dfhv5OUmUKdyDV2ZCZldUhSfhzRhRVS6cZo22VHFi-BBGddgxNAWoDk_Rw4RqJkIgZoE1nyu-rcDw8EA2-2JRlqiIi5hcLrI4jNHS5PO5U8ogjOrS39he_tgXotVaGUorDpvWxis4yRtpngrqbsVD_dORApjpZBm8hi2pma4heMtLaxWbUFN5sOQZod',
          isOnline: true,
          statusColors: [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
          ],
        ),
        const SizedBox(height: 16),
        _CircleCard(
          title: 'Soft Quiet',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAh01RNSSag3G37cbfzbr8WN6pg_qEOBeDRHEkviLxsPEkLd8_WTqB-EazocHW4tWCrJKWc97O1W1N1jY_qiZYvSF8CkDcC3zR2_YRoSGSJ3vaRAADOr0efKkRUvavZnJ1b28hQPWc47Bgs9VDyfnz6C045DATjr2EsSL_Uyy-vmTixe67__5ZxdW45UEZ2E-dbGVaQi9Rg8WLzhAulxtwp_XQyYQC6XrbG5tgu7wPazlSS1BSua0x6PKvYsALi7fHdk7YDinh4OL5P',
          icon: Icons.bedtime,
          statusColors: [
            colorScheme.onSurfaceVariant.withOpacity(0.4),
            colorScheme.onSurfaceVariant.withOpacity(0.4),
          ],
        ),
      ],
    );
  }
}

class _CircleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isOnline;
  final IconData? icon;
  final List<Color> statusColors;

  const _CircleCard({
    required this.title,
    required this.imageUrl,
    this.isOnline = false,
    this.icon,
    required this.statusColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      opacity: 0.1,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SquircleAvatar(
                imageUrl: imageUrl,
                size: 56,
                borderColor: isOnline ? colorScheme.primary.withOpacity(0.2) : null,
                borderWidth: isOnline ? 2 : 0,
              ),
              if (isOnline)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              if (icon != null)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(icon, size: 10, color: colorScheme.tertiary),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: statusColors.map((color) {
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right, 
            color: colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
