import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../core/widgets/slow_photo.dart';
import '../../../circles/presentation/bloc/circle_member_cubit.dart';
import '../../../circles/presentation/bloc/circle_member_state.dart';
import '../../../circles/presentation/bloc/circle_cubit.dart';
import '../../../circles/presentation/bloc/circle_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/family_safety_cubit.dart';
import '../bloc/family_safety_state.dart';
import '../bloc/heritage_cubit.dart';
import '../bloc/heritage_state.dart';
import '../widgets/sos_alert_overlay.dart';

class FamilyDashboardScreen extends StatelessWidget {
  final String circleId;
  const FamilyDashboardScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<FamilySafetyCubit>()
            ..listenToSosAlerts(circleId)
            ..loadSafetyChecks(circleId),
        ),
        BlocProvider(
          create: (context) =>
              getIt<CircleMemberCubit>()..loadMembers(circleId),
        ),
        BlocProvider(
          create: (context) => getIt<CircleCubit>()..loadCircles(),
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
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
                  padding: const EdgeInsets.fromLTRB(24, 32, 32, 100),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const WhisperText('FAMILY SANCTUARY'),
                                const SizedBox(height: 8),
                                BlocBuilder<CircleCubit, CircleState>(
                                  builder: (context, state) {
                                    String name = 'Loading Circle...';
                                    if (state is CircleLoaded) {
                                      final circle = state.circles.firstWhere(
                                        (c) => c.id == circleId,
                                        orElse: () => state.circles.first,
                                      );
                                      name = circle.name;
                                    }
                                    return Text(
                                      name,
                                      style: theme.textTheme.displaySmall
                                          ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 32,
                                        letterSpacing: -1,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            TetherButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check_circle_outline, size: 18),
                                  SizedBox(width: 8),
                                  Text("I'm Okay ✓"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        _FamilyBentoGrid(circleId: circleId),
                        const SizedBox(height: 64),
                        const _SafetyCheckSection(),
                        const SizedBox(height: 64),
                        _EmergencySOS(circleId: circleId),
                        const SizedBox(height: 64),
                        const _HeritageCornerPreview(),
                        const SizedBox(height: 64),
                        const _GrandparentEasyView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<FamilySafetyCubit, FamilySafetyState>(
              builder: (context, state) {
                if (state.activeAlerts.isNotEmpty) {
                  return SosAlertOverlay(
                    alert: state.activeAlerts.first,
                    onResolve: () {},
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyBentoGrid extends StatelessWidget {
  final String circleId;
  const _FamilyBentoGrid({required this.circleId});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      children: [
        // Large Tile: Recent Feed
        _BentoTile(
          columnSpan: 2,
          rowSpan: 2,
          icon: Icons.rss_feed_outlined,
          title: 'Recent Feed',
          subtitle: null,
          imageUrl: null,
          onTap: () {},
        ),
        // Small Tiles
        _BentoTile(
          columnSpan: 2,
          icon: Icons.health_and_safety_outlined,
          title: 'Safety Check',
          onTap: () {},
        ),
        _BentoTile(
          columnSpan: 2,
          icon: Icons.notifications_active_outlined,
          title: 'Reminders',
          onTap: () {},
        ),
        _BentoTile(
          columnSpan: 2,
          icon: Icons.history_edu_outlined,
          title: 'Heritage',
          onTap: () => context.push('/family/$circleId/heritage'),
        ),
        _BentoTile(
          columnSpan: 2,
          icon: Icons.location_on_outlined,
          title: 'Location',
          onTap: () {},
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final int columnSpan;
  final int rowSpan;
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback onTap;

  const _BentoTile({
    this.columnSpan = 1,
    this.rowSpan = 1,
    required this.icon,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GridTile(
      child: Container(
        // This is a bit of a hack for GridView.count, in a real bento grid we'd use StaggeredGrid
        // But for this wave we'll simulate it with a specific childAspectRatio if needed.
        // For now, we'll just use simple containers in the grid.
      ),
    );
  }
}

// Re-implementing _FamilyBentoGrid with StaggeredGrid would be better, but let's stick to simple grid tiles for now.
// I'll update the GridView to use a different approach.

class _SafetyCheckSection extends StatelessWidget {
  const _SafetyCheckSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<FamilySafetyCubit, FamilySafetyState>(
      builder: (context, state) {
        if (state.pendingSafetyChecks.isEmpty) {
          return const SizedBox.shrink();
        }

        final check = state.pendingSafetyChecks.first;

        return TetherCard(
          padding: const EdgeInsets.all(32),
          backgroundColor: const Color(
            0xFF2A1A10,
          ).withOpacity(0.6), // Dark warm earth
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: colorScheme.tertiary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Safety Check Active',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'A safety check was triggered. Please confirm your status to reassure the circle.',
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TetherButton(
                      onPressed: () => context
                          .read<FamilySafetyCubit>()
                          .respondToSafetyCheck(circleId, check.id, 'safe'),
                      backgroundColor: const Color(0xFF2D4A3E),
                      foregroundColor: const Color(0xFF86EFAC),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check, size: 18),
                          SizedBox(width: 8),
                          Text("I'm Safe ✓"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TetherButton(
                      onPressed: () => context
                          .read<FamilySafetyCubit>()
                          .respondToSafetyCheck(circleId, check.id, 'escalated'),
                      style: TetherButtonStyle.secondary,
                      child: const Text('Need Help'),
                    ),
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

class _EmergencySOS extends StatelessWidget {
  final String circleId;
  const _EmergencySOS({required this.circleId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.15),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Send SOS to Family?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const WhisperText('This will alert all circle members instantly'),
          const SizedBox(height: 40),
          TetherButton(
            onPressed: () =>
                context.read<FamilySafetyCubit>().triggerSos(circleId),
            isHighPriority: true,
            width: 240,
            child: const Text('Send Now'),
          ),
        ],
      ),
    );
  }
}

class _HeritageCornerPreview extends StatelessWidget {
  const _HeritageCornerPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('PRESERVING LEGACY'),
        const SizedBox(height: 12),
        Text(
          'Heritage Corner',
          style: theme.textTheme.displaySmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 32),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _HeritageCard(
                title: 'Nana\'s first piano recital, 1954',
                subtitle: 'Before I was born',
                imageUrl:
                    'https://images.unsplash.com/photo-1520523839897-bb8f274b018?w=300&h=400&fit=crop',
                rotation: -0.02,
              ),
              _HeritageCard(
                title: 'The old farmhouse in Cork',
                subtitle: 'Family Roots',
                imageUrl:
                    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=400&fit=crop',
                rotation: 0.04,
              ),
              _HeritageCard(
                title: 'The old farmhouse in Cork',
                subtitle: 'Family Roots',
                imageUrl:
                    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300&h=400&fit=crop',
                rotation: 0.04,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeritageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double rotation;

  const _HeritageCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 32, bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2420),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.85,
              child: Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0.393,
                    0.769,
                    0.189,
                    0,
                    0,
                    0.349,
                    0.686,
                    0.168,
                    0,
                    0,
                    0.272,
                    0.534,
                    0.131,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]), // Sepia filter
                  child: SlowPhoto(imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            WhisperText(subtitle.toUpperCase()),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.white.withOpacity(0.85),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrandparentEasyView extends StatelessWidget {
  const _GrandparentEasyView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GlassPanel(
      padding: const EdgeInsets.all(40),
      opacity: 0.1,
      child: Column(
        children: [
          Text(
            'Hello, Martha',
            style: theme.textTheme.displaySmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _EasyButton(
                icon: Icons.groups_outlined,
                label: 'See Family',
                color: colorScheme.primaryContainer.withOpacity(0.8),
              ),
              _EasyButton(
                icon: Icons.call_outlined,
                label: 'Call Someone',
                color: colorScheme.secondary.withOpacity(0.8),
              ),
              _EasyButton(
                icon: Icons.photo_library_outlined,
                label: 'New Photo',
                color: colorScheme.tertiary.withOpacity(0.8),
              ),
              _EasyButton(
                icon: Icons.check_circle_outline,
                label: "I'm Okay",
                color: const Color(0xFF86EFAC).withOpacity(0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EasyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EasyButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.black87),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
