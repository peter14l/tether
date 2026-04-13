import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tether',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SquircleAvatar(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAcJfry8HNWQrKeOk3f7p1H6nXJVmr1ZuBaPuuQXb6xi1iWm--PQLHvBqYu-wupO1_AaoL5WuZnYmsB8fgR5PQyJTHRhZExAB3lAs8SWp-7Y_1Ee5KH_9IgoW8VJzA1YhE2We0IiZEnGfpX5gMr79hJEEW5epeymvaojqgoWJjSJS1ppFbgwsYzb1tC-LwTioHI2Zp2QLm94SLFGcZO0gVUbbbc8YRlcgIHnrowbrHheLQNhzTlF6kbD49F-skJeOgfb9LTP6ISQxGJ',
              size: 40,
              borderColor: colorScheme.primary.withOpacity(0.2),
              borderWidth: 2,
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Sanctuary Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),
                _SidebarItem(
                  icon: Icons.shield_person,
                  label: 'Privacy Vault',
                  isSelected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _SidebarItem(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  isSelected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _SidebarItem(
                  icon: Icons.self_care,
                  label: 'Wellness',
                  isSelected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _SidebarItem(
                  icon: Icons.lock,
                  label: 'Safe Space',
                  isSelected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedIndex == 0) _PrivacySection(),
                  if (_selectedIndex == 1) _NotificationsSection(),
                  if (_selectedIndex == 2) _WellnessSection(),
                  if (_selectedIndex == 3) _SafeSpaceSection(),
                  const SizedBox(height: 64),
                  const _ReferenceSheet(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surfaceContainer : Colors.transparent,
          border: isSelected ? Border(left: BorderSide(color: colorScheme.primary, width: 3)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
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
            Text('What We Store', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 32),
        _SettingsCard(
          title: 'Your Journal Entries',
          description: 'Encrypted end-to-end. We\'d never betray that. Only you hold the key to these reflections.',
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 16),
        _SettingsCard(
          title: 'Mood Patterns',
          description: 'Local processing only. We use this to adapt the interface theme to your emotional state.',
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

  const _SettingsCard({required this.title, required this.description, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Text('Quiet Presence', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
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
            color: colorScheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.error.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Never silenced (SOS only)', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, color: colorScheme.error)),
              const SizedBox(height: 8),
              const WhisperText('When enabled, these alerts bypass Do Not Disturb for critical safety check-ins.'),
              const SizedBox(height: 24),
              _SwitchRow(label: 'Emergency Contact Alerts', value: true, isCritical: true),
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

  const _SwitchRow({required this.label, required this.value, this.isCritical = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: (v) {},
            activeColor: isCritical ? colorScheme.error : colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _WellnessSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.exercise, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text('Atmospheric Healing', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 32),
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
            Expanded(
              child: _WellnessCard(
                icon: Icons.palette,
                title: 'Mood-Adaptive UI',
                subtitle: 'Colors shift with your pulse.',
                hasSwatches: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WellnessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double? progress;
  final bool hasSwatches;

  const _WellnessCard({required this.icon, required this.title, required this.subtitle, this.progress, this.hasSwatches = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: hasSwatches ? Border.all(color: colorScheme.primary.withOpacity(0.2)) : null,
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
            LinearProgressIndicator(value: progress, backgroundColor: colorScheme.outlineVariant, color: colorScheme.primary),
          if (hasSwatches)
            Row(
              children: [
                for (final color in [const Color(0xFFF5F0E8), const Color(0xFFFF7B3A), const Color(0xFF0E0C14)])
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SafeSpaceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          Icon(Icons.verified_user, color: colorScheme.primary, size: 64),
          const SizedBox(height: 24),
          Text('Your Private Sanctum', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          const WhisperText('Double-layer protection for your most intimate thoughts.'),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FrostedCircle(icon: Icons.face, label: 'Face ID', isSelected: true),
              const SizedBox(width: 32),
              _FrostedCircle(icon: Icons.pin, label: 'Fallback', isSelected: false),
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

  const _FrostedCircle({required this.icon, required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? colorScheme.primary.withOpacity(0.4) : Colors.white10),
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

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text('System Reference Library', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
          const SizedBox(height: 48),
          const WhisperText('INTERACTIVE ELEMENTS', uppercase: true),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Primary Pulse')),
              OutlinedButton(onPressed: () {}, child: const Text('Ghost Action')),
              TextButton(onPressed: () {}, child: const WhisperText('Text Whisper')),
            ],
          ),
        ],
      ),
    );
  }
}
