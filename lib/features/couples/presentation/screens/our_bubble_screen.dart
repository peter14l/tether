import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/onboarding_overlay.dart';
import '../../../circles/presentation/bloc/circle_member_cubit.dart';
import '../../../circles/presentation/bloc/circle_member_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/couple_bubble_cubit.dart';
import '../bloc/couple_bubble_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class OurBubbleScreen extends StatefulWidget {
  final String circleId;
  const OurBubbleScreen({super.key, required this.circleId});

  @override
  State<OurBubbleScreen> createState() => _OurBubbleScreenState();
}

class _OurBubbleScreenState extends State<OurBubbleScreen> {
  final GlobalKey _sharedCanvasKey = GlobalKey();
  final GlobalKey _sharedCalendarKey = GlobalKey();
  final GlobalKey _intimacyCheckInKey = GlobalKey();
  final GlobalKey _privateVaultKey = GlobalKey();
  final GlobalKey _sharedMemoryStreamKey = GlobalKey();

  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_couples_onboarding') ?? false;
    if (!hasSeen && mounted) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_couples_onboarding', true);
    if (mounted) {
      setState(() {
        _showOverlay = false;
      });
    }
  }

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
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String? imageUrl;
                          if (state is Authenticated) {
                            imageUrl = state.user.avatarUrl;
                          }
                          return SquircleAvatar(
                            imageUrl: imageUrl ?? '',
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
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _PartnerConnectionHeader(key: _sharedCanvasKey),
                        const SizedBox(height: 64),
                        _BentoGrid(
                          calendarKey: _sharedCalendarKey,
                          checkInKey: _intimacyCheckInKey,
                          vaultKey: _privateVaultKey,
                          memoryKey: _sharedMemoryStreamKey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showOverlay)
              FeatureOnboardingOverlay(
                steps: [
                  OnboardingStep(
                    targetKey: _sharedCanvasKey,
                    title: 'Your Shared Space',
                    body: "This space is visible only to you and your partner. Think of it as a living digital home you've built together — private from everyone else, always.",
                  ),
                  OnboardingStep(
                    targetKey: _sharedCalendarKey,
                    title: 'Plan Together',
                    body: "Add dates, events, and countdowns. Tether remembers your milestones — anniversaries, first dates, trips — so you never have to dig through old messages.",
                  ),
                  OnboardingStep(
                    targetKey: _intimacyCheckInKey,
                    title: 'How Are We Doing?',
                    body: "A gentle, periodic nudge to check in on the relationship itself — not logistics, not schedules. Just: how are we, as us? Prompted softly, never intrusively.",
                  ),
                  OnboardingStep(
                    targetKey: _privateVaultKey,
                    title: 'The Private Vault',
                    body: "End-to-end encrypted storage for your most sensitive documents, photos, and notes. Only the two of you can ever open it. Even Tether cannot access what's inside.",
                  ),
                  OnboardingStep(
                    targetKey: _sharedMemoryStreamKey,
                    title: 'Your Story, In Order',
                    body: "A private, chronological stream of everything you've shared with each other. Your relationship's history — unfiltered, unranked, always yours.",
                  ),
                ],
                onComplete: _markOnboardingComplete,
                onSkip: _markOnboardingComplete,
              ),
          ],
        ),
      ),
    );
  }
}

class _PartnerConnectionHeader extends StatelessWidget {
  const _PartnerConnectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<CircleMemberCubit, CircleMemberState>(
      builder: (context, state) {
        String? avatar1;
        String? avatar2;
        String partnerName = 'Partner';

        if (state is CircleMemberLoaded && state.members.length >= 2) {
          final currentUser = Supabase.instance.client.auth.currentUser;
          final userMember = state.members.firstWhere(
            (m) => m['user_id'] == currentUser?.id,
            orElse: () => state.members[0],
          );
          final partnerMember = state.members.firstWhere(
            (m) => m['user_id'] != currentUser?.id,
            orElse: () => state.members[1],
          );

          avatar1 = userMember['profiles']?['avatar_url'];
          avatar2 = partnerMember['profiles']?['avatar_url'];
          partnerName = partnerMember['profiles']?['display_name'] ?? 'Partner';
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -0.1,
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
                        boxShadow: [
                          BoxShadow(color: Colors.white, blurRadius: 8)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Transform.rotate(
                  angle: 0.1,
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
                'Us & $partnerName',
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
  final GlobalKey? calendarKey;
  final GlobalKey? checkInKey;
  final GlobalKey? vaultKey;
  final GlobalKey? memoryKey;

  const _BentoGrid({
    this.calendarKey,
    this.checkInKey,
    this.vaultKey,
    this.memoryKey,
  });

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
          icon: FluentIcons.image_24_regular,
          label: 'Gallery',
          color: Colors.orange,
        ),
        _BentoCard(
          key: memoryKey,
          icon: FluentIcons.sparkle_24_regular,
          label: 'Memories',
          color: Colors.amber,
          isDouble: true,
        ),
        const _BentoCard(
          icon: FluentIcons.music_note_2_24_regular,
          label: 'Song',
          color: Colors.pink,
        ),
        _BentoCard(
          key: vaultKey,
          icon: FluentIcons.lock_closed_24_regular,
          label: 'Vault',
          color: Colors.blue,
        ),
        _BentoCard(
          key: calendarKey,
          icon: FluentIcons.calendar_ltr_24_regular,
          label: 'Planner',
          color: Colors.pinkAccent,
        ),
        _BentoCard(
          key: checkInKey,
          icon: FluentIcons.heart_pulse_24_regular,
          label: 'Check-In',
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
    super.key,
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
