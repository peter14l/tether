import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tether/core/theme/time_theme_cubit.dart';
import 'package:tether/core/theme/time_theme_state.dart';
import 'package:tether/core/widgets/squircle_avatar.dart';
import 'package:tether/core/widgets/whisper_text.dart';
import 'package:tether/core/widgets/glass_panel.dart';
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
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
          elevation: 0,
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SquircleAvatar(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAcJfry8HNWQrKeOk3f7p1H6nXJVmr1ZuBaPuuQXb6xi1iWm--PQLHvBqYu-wupO1_AaoL5WuZnYmsB8fgR5PQyJTHRhZExAB3lAs8SWp-7Y_1Ee5KH_9IgoW8VJzA1YhE2We0IiZEnGfpX5gMr79hJEEW5epeymvaojqgoWJjSJS1ppFbgwsYzb1tC-LwTioHI2Zp2QLm94SLFGcZO0gVUbbbc8YRlcgIHnrowbrHheLQNhzTlF6kbD49F-skJeOgfb9LTP6ISQxGJ',
                size: 36,
                borderColor: colorScheme.primary.withValues(alpha: 0.2),
                borderWidth: 2,
              ),
            ),
          ],
        ),
        body: isMobile ? _buildMobileBody(context) : _buildDesktopBody(context),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: cs.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => getIt<IBillingRepository>().showPaywall(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.2),
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
        ),
      ),
    );
  }

  Future<void> _onCategorySelected(int index) async {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _buildSelectedSection(),
            const SizedBox(height: 48),
            const _ReferenceSheet(),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            'Sanctuary Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        _buildUpgradeCard(context),
        const SizedBox(height: 24),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sanctuary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              _buildUpgradeCard(context),
              const SizedBox(height: 32),
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
            padding: const EdgeInsets.all(48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectedSection(),
                  const SizedBox(height: 64),
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
    (icon: Icons.security, label: 'Privacy Vault'),
    (icon: Icons.notifications, label: 'Notifications'),
    (icon: Icons.favorite, label: 'Wellness'),
    (icon: Icons.lock, label: 'Safe Space'),
    (icon: Icons.card_membership, label: 'Subscription'),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surfaceContainer : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: colorScheme.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.6),
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
            Icon(Icons.visibility, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'What We Store',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SettingsCard(
          title: 'Your Journal Entries',
          description:
              'Encrypted end-to-end. We\'d never betray that. Only you hold the key to these reflections.',
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 16),
        _SettingsCard(
          title: 'Mood Patterns',
          description:
              'Local processing only. We use this to adapt the interface theme to your emotional state.',
          icon: Icons.check_circle,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
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
                ),
              ),
              Icon(icon, color: iconColor),
            ],
          ),
          const SizedBox(height: 12),
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
            Icon(Icons.notifications_active, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Quiet Presence',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SwitchRow(label: 'Reflection Reminders', value: true),
        const SizedBox(height: 12),
        _SwitchRow(label: 'Gratitude Prompts', value: false),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Never silenced (SOS only)',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              const WhisperText(
                'When enabled, these alerts bypass Do Not Disturb for critical safety check-ins.',
              ),
              const SizedBox(height: 24),
              _SwitchRow(
                label: 'Emergency Contact Alerts',
                value: true,
                isCritical: true,
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

  const _SwitchRow({
    required this.label,
    required this.value,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: (v) {},
            activeThumbColor: isCritical ? colorScheme.error : colorScheme.primary,
          ),
        ],
      ),
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
            Icon(Icons.fitness_center, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Atmospheric Healing',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 32),
        if (isMobile) ...[
          _WellnessCard(
            icon: Icons.air,
            title: 'Guided Breathing',
            subtitle: 'Haptic pulses for inhalations.',
            progress: 0.75,
          ),
          const SizedBox(height: 16),
          _DarkModeCard(),
        ] else
          Row(
            children: [
              Expanded(
                child: _WellnessCard(
                  icon: Icons.air,
                  title: 'Guided Breathing',
                  subtitle: 'Haptic pulses for inhalations.',
                  progress: 0.75,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _DarkModeCard()),
            ],
          ),
      ],
    );
  }
}


class _DarkModeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.dark_mode, color: colorScheme.primary, size: 32),
              const SizedBox(height: 16),
              const Text(
                'Night Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              WhisperText(isDark ? 'Override enabled' : 'Auto (time-based)'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isDark ? 'On' : 'Off',
                    style: TextStyle(fontWeight: FontWeight.w500),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: hasSwatches
            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.2))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          WhisperText(subtitle),
          const SizedBox(height: 16),
          if (progress != null)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.outlineVariant,
              color: colorScheme.primary,
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
                    margin: const EdgeInsets.only(right: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
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
          Icon(Icons.verified_user, color: colorScheme.primary, size: 64),
          const SizedBox(height: 24),
          Text(
            'Your Private Sanctum',
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          const WhisperText(
            'Double-layer protection for your most intimate thoughts.',
          ),
          const SizedBox(height: 48),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 16 : 32,
            runSpacing: 16,
            children: [
              _FrostedCircle(
                icon: Icons.face,
                label: 'Face ID',
                isSelected: true,
              ),
              _FrostedCircle(
                icon: Icons.pin,
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
    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.4)
                : Colors.white10,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            WhisperText(label, uppercase: true, fontSize: 10),
          ],
        ),
      ),
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

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            'System Reference Library',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(height: 48),
          const WhisperText('INTERACTIVE ELEMENTS', uppercase: true),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Primary Pulse'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Ghost Action'),
              ),
              TextButton(
                onPressed: () {},
                child: const WhisperText('Text Whisper'),
              ),
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
            Icon(Icons.card_membership, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Oasis Pro',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 32),
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
                const SizedBox(height: 24),
                if (isPro) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    onPressed: () => getIt<IBillingRepository>().showCustomerCenter(),
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Manage Subscription'),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    onPressed: () => getIt<IBillingRepository>().showPaywall(),
                    icon: const Icon(Icons.star_rounded),
                    label: const Text('Upgrade to Pro'),
                  ),
                ],
                const SizedBox(height: 16),
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
