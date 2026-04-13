import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../circles/presentation/bloc/circle_member_cubit.dart';
import '../../../circles/presentation/bloc/circle_member_state.dart';
import '../bloc/couple_bubble_cubit.dart';
import '../bloc/couple_bubble_state.dart';

class OurBubbleScreen extends StatefulWidget {
  final String circleId;
  const OurBubbleScreen({super.key, required this.circleId});

  @override
  State<OurBubbleScreen> createState() => _OurBubbleScreenState();
}

class _OurBubbleScreenState extends State<OurBubbleScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CoupleBubbleCubit>()..loadBubble(widget.circleId)),
        BlocProvider(create: (context) => getIt<CircleMemberCubit>()..loadMembers(widget.circleId)),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                borderColor: colorScheme.primary,
                borderWidth: 2,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Circadian Glows
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 100),
              child: Column(
                children: [
                  _PartnerConnectionHeader(),
                  const SizedBox(height: 48),
                  _BentoGrid(),
                  const SizedBox(height: 48),
                  _HeartbeatSection(),
                  const SizedBox(height: 48),
                  _AnniversaryCountdown(),
                  const SizedBox(height: 48),
                  _PromiseRings(),
                  const SizedBox(height: 48),
                  _SpaceToBreathe(),
                  const SizedBox(height: 48),
                  _PrivateJokesVault(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerConnectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -0.1,
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDNgpfU_NMOMmoBikuoBGqUIZQePbPJaRyNzSTT5VK1IiYmrS8PnDxnu1rtdhEu942lMY1fcaTb22cbrNDZvVNrteX-JYntQz1z4wFyVEQvKg3UH7gRVuBZvzyQbeC9wc0a2e1HU3iea8vO0amD7vpgJJkiyrY3VYXZ7JoxXCT0wzGq4HNuAdxzrK2n3Zs1FTcgvcRpqldx95ZHLUMJRpA_MHJltnjv0DkPodeKWtf8okpFDG8-sDgTRVC_-LzZusZV_7UfSM8UJ2Ns',
                size: 80,
                borderColor: colorScheme.primary.withOpacity(0.3),
                borderWidth: 2,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Transform.rotate(
              angle: 0.1,
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBavUan9U-uHAG1PIbJIvhFCIqyfwKQ7eIuwCH9FmEASLiFpd6C3AN7BZeJegVcbQBNyx0qpqD7fzDWUeNQb5q0P7SUCzlhd7fmjMjy7xIYJbs8kv_Yl_bcCW9wLORo3FArCM2cgw4FOJeMj8QBnNsI6ndkSKXmy4Ou2qiDBwslCjyzfAie1VKpfvCG3hJO67_tsejc1fYUS4AN9n9v4KTeivWpxHvnWZk54VjfM-P64raD2q4KAcwksDacqA_8-7c8uyjn181sl_Um',
                size: 80,
                borderColor: colorScheme.secondary.withOpacity(0.3),
                borderWidth: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
          ).createShader(bounds),
          child: Text(
            'Our Bubble Home',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
      ],
    );
  }
}

class _BentoGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _BentoCard(icon: Icons.photo_library, label: 'Gallery', color: Colors.orange),
        _BentoCard(icon: Icons.music_note, label: 'Song', color: Colors.pink),
        _BentoCard(icon: Icons.auto_awesome, label: 'Memories', color: Colors.amber, isDouble: true),
        _BentoCard(icon: Icons.mail, label: 'Letters', color: Colors.orangeAccent),
        _BentoCard(icon: Icons.event_upcoming, label: 'Date Planner', color: Colors.pinkAccent),
        _BentoCard(icon: Icons.verified, label: 'Promises', color: Colors.amberAccent),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDouble;

  const _BentoCard({required this.icon, required this.label, required this.color, this.isDouble = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassPanel(
      opacity: 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isDouble ? 40 : 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _HeartbeatSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text('Pulse of us', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          WhisperText('SEND A HEARTBEAT 💓', uppercase: true),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite, color: colorScheme.secondary, size: 60),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('Touch to Connect'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnniversaryCountdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          WhisperText('UNTIL OUR FOREVER', uppercase: true),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '124',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 72,
                  color: colorScheme.primary,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('days left', style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 2; i++)
                Transform.translate(
                  offset: Offset(i * -16.0, 0),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.surface,
                    child: const CircleAvatar(radius: 26, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromiseRings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.tertiary.withOpacity(0.6), width: 3),
              ),
            ),
            Transform.translate(
              offset: const Offset(-24, 0),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.tertiary.withOpacity(0.6), width: 3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('I choose you today 💍', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        WhisperText('DISSOLVE GENTLY', uppercase: true),
      ],
    );
  }
}

class _SpaceToBreathe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3129),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.nature_people, color: Color(0xFFA8C5A0)),
              SizedBox(width: 12),
              Text('Space to Breathe', style: TextStyle(color: Color(0xFFA8C5A0), fontSize: 20, fontStyle: FontStyle.italic)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('"I need space, but I love you"', style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _SpaceChip(label: '30 mins'),
                _SpaceChip(label: '2 hours', isSelected: true),
                _SpaceChip(label: 'Full Day'),
                _SpaceChip(label: 'Custom'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpaceChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _SpaceChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFA8C5A0).withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFA8C5A0).withOpacity(isSelected ? 0.4 : 0.2)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class _PrivateJokesVault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Just between us.', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
                const SizedBox(height: 4),
                const WhisperText('Our private joke sanctuary'),
              ],
            ),
            CircleAvatar(
              backgroundColor: colorScheme.surfaceContainerHigh,
              child: Icon(Icons.emoji_emotions, color: colorScheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/300'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: const Text("The 'Wait for it' dog...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  '"Remember the 4am toast catastrophe of 2023?"',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.pinkAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

