import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
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
        BlocProvider(
          create: (context) =>
              getIt<CoupleBubbleCubit>()..loadBubble(widget.circleId),
        ),
        BlocProvider(
          create: (context) =>
              getIt<CircleMemberCubit>()..loadMembers(widget.circleId),
        ),
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
                      child: BlocBuilder<CircleMemberCubit, CircleMemberState>(
                        builder: (context, state) {
                          String? avatarUrl;
                          if (state is CircleMemberLoaded) {
                            final currentUser = Supabase.instance.client.auth.currentUser;
                            final member = state.members.firstWhere(
                              (m) => m['user_id'] == currentUser?.id,
                              orElse: () => {},
                            );
                            avatarUrl = member['avatar_url'];
                          }
                          return SquircleAvatar(
                            imageUrl: avatarUrl ?? '',
                            size: 40,
                            borderColor: colorScheme.primary.withOpacity(0.2),
                            borderWidth: 2,
                          );
                        },
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

    return BlocBuilder<CircleMemberCubit, CircleMemberState>(
      builder: (context, state) {
        String? avatar1;
        String? avatar2;

        if (state is CircleMemberLoaded && state.members.length >= 2) {
          avatar1 = state.members[0]['avatar_url'];
          avatar2 = state.members[1]['avatar_url'];
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -0.1, // ~ -6 degrees
                  child: SquircleAvatar(
                    imageUrl: avatar1 ?? '',
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
                        boxShadow: [BoxShadow(color: Colors.white, blurRadius: 8)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Transform.rotate(
                  angle: 0.1, // ~ 6 degrees
                  child: SquircleAvatar(
                    imageUrl: avatar2 ?? '',
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
      },
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
        const _BentoCard(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          color: Colors.orange,
        ),
        const _BentoCard(
          icon: Icons.music_note_outlined,
          label: 'Song',
          color: Colors.pink,
        ),
        const _BentoCard(
          icon: Icons.auto_awesome_outlined,
          label: 'Memories',
          color: Colors.amber,
          isDouble: true,
        ),
        const _BentoCard(
          icon: Icons.mail_outline,
          label: 'Letters',
          color: Colors.orangeAccent,
        ),
        const _BentoCard(
          icon: Icons.calendar_today_outlined,
          label: 'Planner',
          color: Colors.pinkAccent,
        ),
        const _BentoCard(
          icon: Icons.verified_outlined,
          label: 'Promises',
          color: Colors.amberAccent,
        ),
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
            Icon(icon, color: color.withOpacity(0.8), size: isDouble ? 36 : 28),
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
