import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/slow_photo.dart';
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
        body: Stack(
          children: [
            // Background Ambient Glows
            Positioned(
              top: -150,
              left: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 150,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
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
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAcJfry8HNWQrKeOk3f7p1H6nXJVmr1ZuBaPuuQXb6xi1iWm--PQLHvBqYu-wupO1_AaoL5WuZnYmsB8fgR5PQyJTHRhZExAB3lAs8SWp-7Y_1Ee5KH_9IgoW8VJzA1YhE2We0IiZEnGfpX5gMr79hJEEW5epeymvaojqgoWJjSJS1ppFbgwsYzb1tC-LwTioHI2Zp2QLm94SLFGcZO0gVUbbbc8YRlcgIHnrowbrHheLQNhzTlF6kbD49F-skJeOgfb9LTP6ISQxGJ',
                        size: 40,
                        borderColor: colorScheme.primary.withOpacity(0.2),
                        borderWidth: 2,
                      ),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 32, 100),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _PartnerConnectionHeader(),
                        const SizedBox(height: 64),
                        _BentoGrid(),
                        const SizedBox(height: 64),
                        const _HeartbeatSection(),
                        const SizedBox(height: 64),
                        const _AnniversaryCountdown(),
                        const SizedBox(height: 64),
                        const _PromiseRings(),
                        const SizedBox(height: 64),
                        const _SpaceToBreathe(),
                        const SizedBox(height: 64),
                        const _PrivateJokesVault(),
                      ],
                    ),
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
              angle: -0.1, // ~ -6 degrees
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDNgpfU_NMOMmoBikuoBGqUIZQePbPJaRyNzSTT5VK1IiYmrS8PnDxnu1rtdhEu942lMY1fcaTb22cbrNDZvVNrteX-JYntQz1z4wFyVEQvKg3UH7gRVuBZvzyQbeC9wc0a2e1HU3iea8vO0amD7vpgJJkiyrY3VYXZ7JoxXCT0wzGq4HNuAdxzrK2n3Zs1FTcgvcRpqldx95ZHLUMJRpA_MHJltnjv0DkPodeKWtf8okpFDG8-sDgTRVC_-LzZusZV_7UfSM8UJ2Ns',
                size: 80,
                borderColor: colorScheme.primary.withOpacity(0.3),
                borderWidth: 3,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.white, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Transform.rotate(
              angle: 0.1, // ~ 6 degrees
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBavUan9U-uHAG1PIbJIvhFCIqyfwKQ7eIuwCH9FmEASLiFpd6C3AN7BZeJegVcbQBNyx0qpqD7fzDWUeNQb5q0P7SUCzlhd7fmjMjy7xIYJbs8kv_Yl_bcCW9wLORo3FArCM2cgw4FOJeMj8QBnNsI6ndkSKXmy4Ou2qiDBwslCjyzfAie1VKpfvCG3hJO67_tsejc1fYUS4AN9n9v4KTeivWpxHvnWZk54VjfM-P64raD2q4KAcwksDacqA_8-7c8uyjn181sl_Um',
                size: 80,
                borderColor: colorScheme.secondary.withOpacity(0.3),
                borderWidth: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
          ).createShader(bounds),
          child: Text(
            'Our Bubble Home',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              letterSpacing: -1,
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
        const _BentoCard(icon: Icons.photo_library_outlined, label: 'Gallery', color: Colors.orange),
        const _BentoCard(icon: Icons.music_note_outlined, label: 'Song', color: Colors.pink),
        const _BentoCard(icon: Icons.auto_awesome_outlined, label: 'Memories', color: Colors.amber, isDouble: true),
        const _BentoCard(icon: Icons.mail_outline, label: 'Letters', color: Colors.orangeAccent),
        const _BentoCard(icon: Icons.calendar_today_outlined, label: 'Planner', color: Colors.pinkAccent),
        const _BentoCard(icon: Icons.verified_outlined, label: 'Promises', color: Colors.amberAccent),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDouble;

  const _BentoCard({
    required this.icon, 
    required this.label, 
    required this.color, 
    this.isDouble = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      opacity: 0.08,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: color.withOpacity(0.8), 
              size: isDouble ? 36 : 28,
            ),
            const SizedBox(height: 12),
            Text(
              label, 
              style: const TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ), 
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartbeatSection extends StatelessWidget {
  const _HeartbeatSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.4),
      child: Column(
        children: [
          Text(
            'Pulse of us', 
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          const WhisperText('SEND A HEARTBEAT 💓'),
          const SizedBox(height: 48),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.secondary.withOpacity(0.1),
                      blurRadius: 40,
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_outlined, 
                  color: colorScheme.secondary, 
                  size: 56,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          TetherButton(
            onPressed: () {},
            isFullWidth: true,
            backgroundColor: colorScheme.secondary,
            child: const Text('Touch to Connect'),
          ),
        ],
      ),
    );
  }
}

class _AnniversaryCountdown extends StatelessWidget {
  const _AnniversaryCountdown();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(32),
      opacity: 0.1,
      child: Column(
        children: [
          const WhisperText('UNTIL OUR FOREVER'),
          const SizedBox(height: 24),
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
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'days left', 
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 2; i++)
                Transform.translate(
                  offset: Offset(i * -16.0, 0),
                  child: SquircleAvatar(
                    imageUrl: 'https://via.placeholder.com/150',
                    size: 56,
                    borderColor: colorScheme.surface,
                    borderWidth: 3,
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
  const _PromiseRings();

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
                border: Border.all(
                  color: colorScheme.tertiary.withOpacity(0.3), 
                  width: 4,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(-24, 0),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.tertiary.withOpacity(0.3), 
                    width: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'I choose you today 💍', 
          style: theme.textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        const WhisperText('DISSOLVE GENTLY'),
      ],
    );
  }
}

class _SpaceToBreathe extends StatelessWidget {
  const _SpaceToBreathe();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: const Color(0xFF1A2319).withOpacity(0.6), // Dark sage
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.nature_people_outlined, color: Color(0xFFA8C5A0)),
              SizedBox(width: 12),
              Text(
                'Space to Breathe', 
                style: TextStyle(
                  color: Color(0xFFA8C5A0), 
                  fontSize: 20, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const WhisperText(
            '"I need space, but I love you"', 
            fontSize: 14,
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
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
        color: isSelected ? const Color(0xFFA8C5A0).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFA8C5A0).withOpacity(isSelected ? 0.4 : 0.15),
          width: 1,
        ),
      ),
      child: Text(
        label, 
        style: const TextStyle(
          color: Colors.white70, 
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PrivateJokesVault extends StatelessWidget {
  const _PrivateJokesVault();

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
                Text(
                  'Just between us.', 
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                const WhisperText('Our private joke sanctuary'),
              ],
            ),
            GlassPanel(
              padding: const EdgeInsets.all(8),
              opacity: 0.1,
              borderRadius: BorderRadius.circular(32),
              child: Icon(Icons.emoji_emotions_outlined, color: colorScheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: 32),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            TetherCard(
              padding: EdgeInsets.zero,
              backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.3),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const SlowPhoto(
                    imageUrl: 'https://via.placeholder.com/300', 
                    opacity: 0.4,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      "The 'Wait for it' dog...", 
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            TetherCard(
              padding: const EdgeInsets.all(24),
              backgroundColor: colorScheme.surfaceContainerLow.withOpacity(0.3),
              child: const Center(
                child: Text(
                  '"Remember the 4am toast catastrophe of 2023?"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic, 
                    fontSize: 14, 
                    color: Colors.pinkAccent,
                    height: 1.5,
                  ),
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

