import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class TetherWalkthroughOverlay extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;

  const TetherWalkthroughOverlay({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      titleTextStyle: theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      descTextStyle: theme.textTheme.bodyMedium!,
      textColor: theme.colorScheme.onSurface,
      overlayColor: Colors.black.withValues(alpha: 0.5),
      child: child,
    );
  }
}
