import 'package:flutter/material.dart';

class ReactionBar extends StatelessWidget {
  final String postId;
  final Function(String) onReactionTap;

  const ReactionBar({
    super.key,
    required this.postId,
    required this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ReactionChip(
          emoji: '🌸',
          label: 'Warm',
          count: 12,
          onTap: () => onReactionTap('warm'),
        ),
        _ReactionChip(
          emoji: '👁️',
          label: 'I See You',
          count: 5,
          isSelected: true,
          onTap: () => onReactionTap('i_see_you'),
        ),
        _ReactionChip(
          emoji: '🫂',
          label: 'Comforting',
          count: 3,
          onTap: () => onReactionTap('comforting'),
        ),
      ],
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReactionChip({
    required this.emoji,
    required this.label,
    required this.count,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondaryContainer.withOpacity(0.3) : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.secondary.withOpacity(0.2) : colorScheme.outlineVariant.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$label $emoji', style: theme.textTheme.labelSmall?.copyWith(
              color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            )),
            const SizedBox(width: 8),
            Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: (isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant).withOpacity(isSelected ? 0.6 : 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
