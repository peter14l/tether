import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class TetherBottomNavBar extends StatelessWidget {
  const TetherBottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/' || location.startsWith('/messaging')) {
      return 0;
    }
    if (location.startsWith('/circles')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/circles');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.4),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.chat_24_regular),
            activeIcon: Icon(FluentIcons.chat_24_filled),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.people_24_regular),
            activeIcon: Icon(FluentIcons.people_24_filled),
            label: 'Circles',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.settings_24_regular),
            activeIcon: Icon(FluentIcons.settings_24_filled),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
