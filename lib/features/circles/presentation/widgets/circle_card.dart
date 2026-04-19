import 'package:flutter/material.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../domain/entities/circle_entity.dart';

class CircleCard extends StatelessWidget {
  final CircleEntity circle;
  final VoidCallback onTap;

  const CircleCard({
    super.key,
    required this.circle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          final type = circle.circleType.toLowerCase();
          if (type == 'couple') {
            context.push('/bubble/${circle.id}');
          } else if (type == 'family' || type == 'inlaw') {
            context.push('/family/${circle.id}');
          } else {
            context.push('/feed/${circle.id}');
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: GlassPanel(
          padding: EdgeInsets.zero,
          opacity: 0.1,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (circle.avatarUrl != null)
                  SquircleAvatar(
                    imageUrl: circle.avatarUrl!,
                    size: 56,
                    borderColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderWidth: 2,
                  )
                else
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(56 * 0.35),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.18),
                      ),
                    ),
                    child: Icon(
                      _getIconForType(circle.circleType),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        circle.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      WhisperText(
                        _capitalize(circle.circleType),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'couple':
        return Icons.favorite_outline;
      case 'family':
        return Icons.family_restroom_outlined;
      case 'friends':
        return Icons.people_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
