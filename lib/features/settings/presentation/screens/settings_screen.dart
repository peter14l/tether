import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tether/core/theme/time_theme_cubit.dart';
import 'package:tether/core/theme/time_theme_state.dart';
import 'package:tether/core/widgets/squircle_avatar.dart';
import 'package:tether/core/widgets/whisper_text.dart';
import 'package:tether/core/widgets/glass_panel.dart';
import 'package:tether/core/widgets/tether_button.dart';
import 'package:tether/core/widgets/tether_card.dart';
import 'package:tether/core/security/biometric_service.dart';
import 'package:tether/injection_container.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tether/features/monetization/domain/repositories/billing_repository.dart';
import 'package:tether/features/monetization/domain/repositories/billing_method.dart';
import 'package:tether/core/error/failures.dart';
import 'package:fpdart/fpdart.dart' hide State;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;
  bool _isViewingSection = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;

    return PopScope(
      canPop: !isMobile || !_isViewingSection,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isMobile && _isViewingSection) {
          setState(() => _isViewingSection = false);
        }
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: colorScheme.surface.withOpacity(0.01),
              surfaceTintColor: Colors.transparent,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ColorFilter.mode(colorScheme.surface.withOpacity(0.8), BlendMode.srcOver),
                  child: Container(color: Colors.transparent),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  isMobile && _isViewingSection ? Icons.arrow_back : Icons.close,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  if (isMobile && _isViewingSection) {
                    setState(() => _isViewingSection = false);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                isMobile && _isViewingSection
                    ? _categories[_selectedIndex].label
                    : 'Settings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: SquircleAvatar(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAcJfry8HNWQrKeOk3f7p1H6nXJVmr1ZuBaPuuQXb6xi1iWm--PQLHvBqYu-wupO1_AaoL5WuZnYmsB8fgR5PQyJTHRhZExAB3lAs8SWp-7Y_1Ee5KH_9IgoW8VJzA1YhE2We0IiZEnGfpX5gMr79hJEEW5epeymvaojqgoWJjSJS1ppFbgwsYzb1tC-LwTioHI2Zp2QLm94SLFGcZO0gVUbbbc8YRlcgIHnrowbrHheLQNhzTlF6kbD49F-skJeOgfb9LTP6ISQxGJ',
                    size: 36,
                    borderColor: colorScheme.primary.withOpacity(0.2),
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
          ],
          body: isMobile ? _buildMobileBody(context) : _buildDesktopBody(context),
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TetherButton(
        onPressed: () => context.push('/subscription'),
        isHighPriority: true,
        isFullWidth: true,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.star_rounded, color: cs.onPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Oasis Pro',
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Unlock unlimited circles & more',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.onPrimary),
          ],
        ),
      ),
    );
  }

  Future<void> _onCategorySelected(int index) async {
    // Index 4 is "Subscription"
    if (index == 4) {
      context.push('/subscription');
      return;
    }

    // Index 3 is "Safe Space"
    if (index == 3) {
      final biometricService = getIt<IBiometricService>();
      final isAvailable = await biometricService.isAvailable();
      if (isAvailable) {
        final authenticated = await biometricService.authenticate(
          localizedReason: 'Please authenticate to access your private Safe Space.',
        );
        if (!authenticated) return;
      }
    }

    setState(() {
      _selectedIndex = index;
      _isViewingSection = true;
    });
  }

  Widget _buildMobileBody(BuildContext context) {
    if (_isViewingSection) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            _buildSelectedSection(),
            const SizedBox(height: 64),
            const _ReferenceSheet(),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            'Sanctuary Settings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 32,
              letterSpacing: -1,
            ),
          ),
        ),
        _buildUpgradeCard(context),
        const SizedBox(height: 32),
        ...List.generate(_categories.length, (index) {
          final cat = _categories[index];
          return _MobileCategoryTile(
            icon: cat.icon,
            label: cat.label,
            onTap: () => _onCategorySelected(index),
          );
        }),
      ],
    );
  }

  Widget _buildDesktopBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.18),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 32),
                child: Text(
                  'Sanctuary',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildUpgradeCard(context),
              const SizedBox(height: 48),
              ...List.generate(_categories.length, (index) {
                final cat = _categories[index];
                return _SidebarItem(
                  icon: cat.icon,
                  label: cat.label,
                  isSelected: _selectedIndex == index,
                  onTap: () => _onCategorySelected(index),
                );
              }),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(64),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectedSection(),
                  const SizedBox(height: 80),
                  const _ReferenceSheet(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSection() {
    switch (_selectedIndex) {
      case 0:
        return const _PrivacySection();
      case 1:
        return const _NotificationsSection();
      case 2:
        return const _WellnessSection();
      case 3:
        return const _SafeSpaceSection();
      case 4:
        return const _SubscriptionSection();
      default:
        return const SizedBox.shrink();
    }
  }

  final List<({IconData icon, String label})> _categories = const [
    (icon: Icons.security_outlined, label: 'Privacy Vault'),
    (icon: Icons.notifications_none_outlined, label: 'Notifications'),
    (icon: Icons.favorite_border_outlined, label: 'Wellness'),
    (icon: Icons.lock_outline, label: 'Safe Space'),
    (icon: Icons.card_membership_outlined, label: 'Subscription'),
  ];
}


class _MobileCategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MobileCategoryTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: GlassPanel(
          padding: const EdgeInsets.all(20),
          opacity: 0.05,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surfaceContainer.withOpacity(0.5) : Colors.transparent,
          border: isSelected
              ? Border(
                  left: BorderSide(color: colorScheme.primary, width: 3),
                )
              : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(-8, 0),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.visibility_outlined, color: colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Text(
              'What We Store',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        const _SettingsCard(
          title: 'Your Journal Entries',
          description:
              'Encrypted end-to-end. We\'d never betray that. Only you hold the key to these reflections.',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 24),
        const _SettingsCard(
          title: 'Mood Patterns',
          description:
              'Local processing only. We use this to adapt the interface theme to your emotional state.',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const _SettingsCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              Icon(icon, color: iconColor),
            ],
          ),
          const SizedBox(height: 16),
          WhisperText(description),
        ],
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.notifications_active_outlined, color: colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Text(
              'Quiet Presence',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        const _SwitchRow(label: 'Reflection Reminders', value: true),
        const SizedBox(height: 16),
        const _SwitchRow(label: 'Gratitude Prompts', value: false),
        const SizedBox(height: 48),
        TetherCard(
          padding: const EdgeInsets.all(32),
          backgroundColor: colorScheme.error.withOpacity(0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Never silenced (SOS only)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
              const WhisperText(
                'When enabled, these alerts bypass Do Not Disturb for critical safety check-ins.',
              ),
              const SizedBox(height: 32),
              _SwitchRow(
                label: 'Emergency Contact Alerts',
                value: true,
                isCritical: true,
                useCard: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final bool isCritical;
  final bool useCard;

  const _SwitchRow({
    required this.label,
    required this.value,
    this.isCritical = false,
    this.useCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Switch(
          value: value,
          onChanged: (v) {},
          activeColor: isCritical ? colorScheme.error : colorScheme.primary,
        ),
      ],
    );

    if (!useCard) return content;

    return TetherCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      backgroundColor: colorScheme.surfaceContainerHigh.withOpacity(0.3),
      child: content,
    );
  }
}

class _WellnessSection extends StatelessWidget {
  const _WellnessSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.spa_outlined, color: colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Text(
              'Atmospheric Healing',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        if (isMobile) ...[
          const _WellnessCard(
            icon: Icons.air_outlined,
            title: 'Guided Breathing',
            subtitle: 'Haptic pulses for inhalations.',
            progress: 0.75,
          ),
          const SizedBox(height: 24),
          const _DarkModeCard(),
        ] else
          Row(
            children: [
              const Expanded(
                child: _WellnessCard(
                  icon: Icons.air_outlined,
                  title: 'Guided Breathing',
                  subtitle: 'Haptic pulses for inhalations.',
                  progress: 0.75,
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(child: _DarkModeCard()),
            ],
          ),
      ],
    );
  }
}


class _DarkModeCard extends StatelessWidget {
  const _DarkModeCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;
        return TetherCard(
          padding: const EdgeInsets.all(32),
          backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.nights_stay_outlined, color: colorScheme.primary, size: 32),
              const SizedBox(height: 24),
              const Text(
                'Night Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              WhisperText(isDark ? 'Override enabled' : 'Auto (time-based)'),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isDark ? 'On' : 'Off',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (enabled) {
                      context.read<TimeThemeCubit>().toggleDarkMode(
                        enabled: enabled,
                      );
                    },
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WellnessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double? progress;
  final bool hasSwatches;

  const _WellnessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.progress,
    this.hasSwatches = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 32),
          const SizedBox(height: 24),
          Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          WhisperText(subtitle),
          const SizedBox(height: 32),
          if (progress != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: colorScheme.outlineVariant.withOpacity(0.1),
                color: colorScheme.primary,
              ),
            ),
          if (hasSwatches)
            Row(
              children: [
                for (final color in [
                  const Color(0xFFF5F0E8),
                  const Color(0xFFFF7B3A),
                  const Color(0xFF0E0C14),
                ])
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SafeSpaceSection extends StatelessWidget {
  const _SafeSpaceSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shield_outlined, color: colorScheme.primary, size: 64),
          ),
          const SizedBox(height: 32),
          Text(
            'Your Private Sanctum',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          const WhisperText(
            'Double-layer protection for your most intimate thoughts.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 24 : 48,
            runSpacing: 24,
            children: const [
              _FrostedCircle(
                icon: Icons.face_outlined,
                label: 'Face ID',
                isSelected: true,
              ),
              _FrostedCircle(
                icon: Icons.dialpad_outlined,
                label: 'Fallback',
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrostedCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _FrostedCircle({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.4)
                  : Colors.white.withOpacity(0.05),
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.1),
                blurRadius: 30,
              ),
            ] : null,
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Center(
                child: Icon(
                  icon, 
                  size: 36, 
                  color: isSelected ? colorScheme.primary : Colors.white30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        WhisperText(
          label, 
          fontSize: 11, 
          color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.3),
        ),
      ],
    );
  }
}

class _ReferenceSheet extends StatelessWidget {
  const _ReferenceSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;

    return GlassPanel(
      padding: EdgeInsets.all(isMobile ? 32 : 48),
      opacity: 0.05,
      child: Column(
        children: [
          Text(
            'System Reference Library',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(height: 48),
          const WhisperText('INTERACTIVE ELEMENTS'),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              TetherButton(
                onPressed: () {},
                isHighPriority: true,
                child: const Text('Primary Pulse'),
              ),
              TetherButton(
                onPressed: () {},
                style: TetherButtonStyle.secondary,
                child: const Text('Ghost Action'),
              ),
              const WhisperText('Text Whisper'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.card_membership_outlined, color: colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Text(
              'Oasis Pro',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        StreamBuilder<CustomerInfo>(
          stream: getIt<IBillingRepository>().customerInfoStream,
          builder: (context, snapshot) {
            final isPro = snapshot.data?.entitlements.all['Oasis Pro']?.isActive ?? false;
            
            return Column(
              children: [
                _SettingsCard(
                  title: isPro ? 'Premium Active' : 'Basic Member',
                  description: isPro 
                    ? 'You have full access to all Sanctuary features. Thank you for your support!'
                    : 'Upgrade to Oasis Pro to unlock unlimited circles, advanced wellness insights, and more.',
                  icon: isPro ? Icons.verified_rounded : Icons.info_outline,
                  iconColor: isPro ? Colors.amber : colorScheme.primary,
                ),
                const SizedBox(height: 32),
                if (isPro) ...[
                  TetherButton(
                    style: TetherButtonStyle.secondary,
                    isFullWidth: true,
                    onPressed: () => getIt<IBillingRepository>().showCustomerCenter(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.settings_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Manage Subscription'),
                      ],
                    ),
                  ),
                ] else ...[
                  TetherButton(
                    isFullWidth: true,
                    onPressed: () => getIt<IBillingRepository>().showPaywall(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Upgrade to Pro'),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () async {
                    try {
                      await Purchases.restorePurchases();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchases restored successfully')),
                        );
                      }
                    } catch (e) {
                       if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to restore purchases')),
                        );
                      }
                    }
                  },
                  child: const WhisperText('Restore Purchases'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
