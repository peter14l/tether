import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';

class BreathingRoomScreen extends StatefulWidget {
  const BreathingRoomScreen({super.key});

  @override
  State<BreathingRoomScreen> createState() => _BreathingRoomScreenState();
}

class _BreathingRoomScreenState extends State<BreathingRoomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _BreathingSection(animation: _breathingAnimation),
            const SizedBox(height: 48),
            const _DigitalHugSection(),
            const SizedBox(height: 48),
            const _GratitudeJournal(),
            const SizedBox(height: 48),
            const _ReflectionAndMemories(),
            const SizedBox(height: 48),
            const _MemoryReveal(),
            const SizedBox(height: 48),
            const _KindnessBadges(),
            const SizedBox(height: 48),
            const _QuietHours(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _BreathingSection extends StatelessWidget {
  final Animation<double> animation;
  const _BreathingSection({required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorScheme.surface, colorScheme.surfaceContainerLow, colorScheme.surfaceContainerLowest],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 240 * animation.value,
                    height: 240 * animation.value,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 180 * animation.value,
                    height: 180 * animation.value,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Take a breath.', style: theme.textTheme.displayLarge?.copyWith(color: colorScheme.primary, fontSize: 40)),
              const SizedBox(height: 12),
              const WhisperText('Inhale the stillness of the dusk.'),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SoundChip(label: 'Rain'),
                  const SizedBox(width: 12),
                  _SoundChip(label: 'White Noise', isSelected: true),
                  const SizedBox(width: 12),
                  _SoundChip(label: 'Silence'),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primaryContainer.withOpacity(0.2) : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isSelected ? colorScheme.primary.withOpacity(0.3) : colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
            ),
            Icon(Icons.handshake, color: colorScheme.primary, size: 64),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Your hug is on its way.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const WhisperText('A warm radial pulse sent to your Circle.'),
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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: colorScheme.tertiary, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WhisperText('TODAY\'S PROMPT', uppercase: true, color: Colors.amber),
                const SizedBox(height: 8),
                Text('What made you smile today?', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _GratitudeEntry(
            text: 'The way the light hit the kitchen table at breakfast...',
            date: 'October 24',
          ),
          const SizedBox(height: 12),
          _GratitudeEntry(
            text: 'Hearing the distant sound of the rain against the attic window...',
            date: 'October 22',
          ),
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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhisperText(date, uppercase: true, fontSize: 10),
              Icon(Icons.lock, size: 14, color: colorScheme.onSurfaceVariant.withOpacity(0.4)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WhisperText('REFLECTION WALL', uppercase: true),
                const SizedBox(height: 16),
                Text('This is just for you.', style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.primaryFixed)),
                const SizedBox(height: 24),
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: const Text('Type your quiet thoughts here...', style: TextStyle(color: Colors.white24, fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Container(
            width: 2,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colorScheme.tertiary, colorScheme.tertiary.withOpacity(0)],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WhisperText('MEMORIES LANE', uppercase: true),
                const SizedBox(height: 32),
                const WhisperText('OCTOBER', color: Colors.amber),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network('https://via.placeholder.com/200', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
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
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 40)],
        ),
        child: Column(
          children: [
            const WhisperText('A YEAR AGO TODAY', uppercase: true, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              '"Finally felt the crisp autumn air on the ridge. Peace."',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primaryContainer),
                    child: const Text('Keep'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
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
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.volunteer_activism, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 12),
                  const WhisperText('HEART LISTENER', uppercase: true),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.secondary.withOpacity(0.1),
                    child: Icon(Icons.sunny, color: colorScheme.secondary.withOpacity(0.4)),
                  ),
                  const SizedBox(height: 12),
                  const WhisperText('WARM PRESENCE', uppercase: true, color: Colors.white24),
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
    return Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          Icon(Icons.nights_stay, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          const WhisperText('Winding down in 20 mins. The sanctuary is preparing for rest.', textAlign: TextAlign.center),
          TextButton(
            onPressed: () {},
            child: const WhisperText('Stay a little longer', color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
