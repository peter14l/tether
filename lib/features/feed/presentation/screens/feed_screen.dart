import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../bloc/feed_cubit.dart';
import '../bloc/feed_state.dart';
import '../widgets/post_card.dart';
import '../widgets/mood_room.dart';
import '../widgets/presence_circles.dart';
import '../widgets/temperature_check.dart';

class FeedScreen extends StatefulWidget {
  final String circleId;
  const FeedScreen({super.key, required this.circleId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<FeedCubit>()..loadFeed(widget.circleId),
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: colorScheme.surface.withOpacity(0.8),
              surfaceTintColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.8),
                ),
              ),
              title: Row(
                children: [
                  Icon(Icons.arrow_back, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Tether',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SquircleAvatar(
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDJ9rFr9LPlleeY2t7kg-bS3Fc6GVOsLt1yzhBvdMSgfmJyQ00we0ri8OGZg8o1uvM6lnSV8FsmvKV4CGEKXsqBaTOh_vT27mmfp3ihpNS0IlS0yTq_xlJw6iDk4ObtxfsUyiKJGywBq3r5qDTYmBQmwVYPbBBIZ8-f9YXFoUPazhKrPpuTWPv3R_XRkgpf2n747ITcTSVO3wDUUBYSn10raMF_VoFPlUHZYj9snOP5Pj4KBOmyPUxL13rwoIRDLZpjD7jWI4MoF4LC',
                    size: 40,
                    borderColor: colorScheme.primary.withOpacity(0.3),
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const MoodRoom(),
                    const SizedBox(height: 48),
                    const PresenceCircles(),
                    const SizedBox(height: 48),
                    const TemperatureCheck(),
                    const SizedBox(height: 48),
                    _GentleNudge(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FeedLoaded) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return PostCard(
                            post: post,
                            onReactionTap: (type) {
                              context.read<FeedCubit>().toggleReaction(widget.circleId, post.id, type);
                            },
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    ),
                  );
                } else if (state is FeedError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${state.message}')),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: const CircleBorder(),
          elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 32),
              const SizedBox(height: 4),
              Text(
                'CALM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GentleNudge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Gentle Nudge: Maya is feeling "Anxious"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            'SEND CARE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

