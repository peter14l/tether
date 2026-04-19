import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';

class BreathingRoomScreen extends StatefulWidget {
  const BreathingRoomScreen({super.key});

  @override
  State<BreathingRoomScreen> createState() => _BreathingRoomScreenState();
}

class _BreathingRoomScreenState extends State<BreathingRoomScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: const Cubic(0.4, 0, 0.6, 1),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface.withOpacity(0.01),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ColorFilter.mode(
                  colorScheme.surface.withOpacity(0.8),
                  BlendMode.srcOver,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Tether',
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
                  imageUrl: '',
                  size: 40,
                  borderColor: colorScheme.primary.withOpacity(0.2),
                  borderWidth: 2,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _BreathingSection(
                  animation: _breathingAnimation,
                  opacityAnimation: _opacityAnimation,
                ),
                const SizedBox(height: 64),
                const _DigitalHugSection(),
                const SizedBox(height: 64),
                const _GratitudeJournal(),
                const SizedBox(height: 64),
                const _ReflectionAndMemories(),
                const SizedBox(height: 64),
                const _MemoryReveal(),
                const SizedBox(height: 64),
                const _KindnessBadges(),
                const SizedBox(height: 64),
                const _QuietHours(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingSection extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> opacityAnimation;

  const _BreathingSection({
    required this.animation,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 700,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHighest.withOpacity(0.2),
            colorScheme.surface,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glowing Halos
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: opacityAnimation.value,
                    child: Container(
                      width: 300 * animation.value,
                      height: 300 * animation.value,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacityAnimation.value * 0.8,
                    child: Container(
                      width: 200 * animation.value,
                      height: 200 * animation.value,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.25),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primaryContainer.withOpacity(
                              0.3,
                            ),
                            blurRadius: 60,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wellness',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: colorScheme.primary,
                  fontStyle: FontStyle.italic,
                  fontSize: 48,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              const WhisperText(
                'Mindfulness',
                fontSize: 14,
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _SoundChip(label: 'Sound 1'),
                  const SizedBox(width: 16),
                  const _SoundChip(label: 'Sound 2', isSelected: true),
                  const SizedBox(width: 16),
                  const _SoundChip(label: 'Sound 3'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoundChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _SoundChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      opacity: isSelected ? 0.2 : 0.05,
      borderRadius: BorderRadius.circular(32),
      border: isSelected
          ? Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1.5)
          : null,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _DigitalHugSection extends StatelessWidget {
  const _DigitalHugSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 40,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.volunteer_activism_outlined,
              color: colorScheme.primary,
              size: 56,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Digital Hug',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const WhisperText('Connecting...'),
      ],
    );
  }
}

class _GratitudeJournal extends StatelessWidget {
  const _GratitudeJournal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(32),
            opacity: 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WhisperText('PROMPT'),
                const SizedBox(height: 12),
                Text(
                  'Reflect on your day',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // No entries to show
        ],
      ),
    );
  }
}

class _GratitudeEntry extends StatelessWidget {
  final String text;
  final String date;
  const _GratitudeEntry({required this.text, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TetherCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhisperText(date),
              Icon(
                Icons.lock_outline,
                size: 16,
                color: colorScheme.onSurfaceVariant.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReflectionAndMemories extends StatelessWidget {
  const _ReflectionAndMemories();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WhisperText('REFLECTION WALL'),
          const SizedBox(height: 16),
          Text(
            'Journal',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          TetherCard(
            height: 300,
            padding: const EdgeInsets.all(24),
            backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.3),
            child: const TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Type your quiet thoughts here...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
          const SizedBox(height: 64),
          const WhisperText('MEMORIES LANE'),
          const SizedBox(height: 32),
          // No memories to show
        ],
      ),
    );
  }
}

class _MemoryReveal extends StatelessWidget {
  const _MemoryReveal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: GlassPanel(
        padding: const EdgeInsets.all(32),
        opacity: 0.15,
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              const WhisperText('MEMORY'),
              const SizedBox(height: 24),
              Text(
                '[No memory to show]',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TetherButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TetherButton(
                      onPressed: () {},
                      style: TetherButtonStyle.secondary,
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindnessBadges extends StatelessWidget {
  const _KindnessBadges();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GlassPanel(
              padding: const EdgeInsets.all(24),
              opacity: 0.05,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const WhisperText('Badge'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GlassPanel(
              padding: const EdgeInsets.all(24),
              opacity: 0.05,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const WhisperText('Badge'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietHours extends StatelessWidget {
  const _QuietHours();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(
          Icons.nights_stay_outlined,
          color: colorScheme.onSurfaceVariant.withOpacity(0.4),
          size: 32,
        ),
        const SizedBox(height: 16),
        const WhisperText(
          'Quiet Hours',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: Text(
            'SETTINGS',
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
