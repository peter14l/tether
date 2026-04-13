import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TetherBottomNavBar extends StatelessWidget {
  const TetherBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.08),
                  blurRadius: 40,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home,
                  isSelected: location == '/' || location.startsWith('/feed'),
                  onTap: () => context.go('/'),
                ),
                _NavBarItem(
                  icon: Icons.spa,
                  isSelected: location == '/breathing',
                  onTap: () => context.go('/breathing'),
                ),
                _NavBarItem(
                  icon: Icons.chat_bubble,
                  isSelected: location.startsWith('/messaging'),
                  onTap: () => context.go('/messaging'),
                ),
                _NavBarItem(
                  icon: Icons.settings,
                  isSelected: location == '/settings',
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
            )
          ] : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4),
          size: 28,
        ),
      ),
    );
  }
}
