import 'package:flutter/material.dart';

class SquircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double? borderWidth;
  final Color? borderColor;

  const SquircleAvatar({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.35),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
        boxShadow: [
          if (borderColor != null)
            BoxShadow(
              color: borderColor!.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.35),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
