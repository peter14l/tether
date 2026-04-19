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
      height: 70,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.06),
                  blurRadius: 40,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  isSelected: location == '/' || location.startsWith('/feed'),
                  onTap: () => context.go('/'),
                ),
                _NavBarItem(
                  icon: Icons.spa_outlined,
                  activeIcon: Icons.spa_rounded,
                  isSelected: location == '/breathing',
                  onTap: () => context.go('/breathing'),
                ),
                _NavBarItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  isSelected: location.startsWith('/messaging'),
                  onTap: () => context.go('/messaging'),
                ),
                _NavBarItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
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
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.12),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ] : null,
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4),
          size: 24,
        ),
      ),
    );
  }
}
