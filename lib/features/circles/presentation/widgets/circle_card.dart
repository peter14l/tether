import 'package:flutter/material.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/slow_photo.dart';
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
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: TetherCard(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (circle.avatarUrl != null)
                  SlowPhoto(
                    imageUrl: circle.avatarUrl!,
                    width: 56,
                    height: 56,
                    borderRadius: BorderRadius.circular(14),
                  )
                else
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _getIconForType(circle.circleType),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        circle.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _capitalize(circle.circleType),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
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
