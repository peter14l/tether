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
    return Row(
      children: [
        _ReactionButton(emoji: '🌸', label: 'Warm', onTap: () => onReactionTap('warm')),
        _ReactionButton(emoji: '🫂', label: 'Comforting', onTap: () => onReactionTap('comforting')),
        _ReactionButton(emoji: '👁️', label: 'I See You', onTap: () => onReactionTap('i_see_you')),
        _ReactionButton(emoji: '💙', label: 'Sending Strength', onTap: () => onReactionTap('sending_strength')),
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _ReactionButton({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
