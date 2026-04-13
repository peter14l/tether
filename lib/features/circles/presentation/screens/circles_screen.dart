import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../bloc/circle_cubit.dart';
import '../bloc/circle_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/presentation/widgets/tether_walkthrough_overlay.dart';
import '../widgets/circle_card.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkShowcase());
  }

  Future<void> _checkShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_circles_guide') ?? false;
    
    if (!hasSeen && mounted) {
      ShowCaseWidget.of(context).startShowCase([_fabKey]);
      await prefs.setBool('has_seen_circles_guide', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<CircleCubit>()..loadCircles(),
      child: ShowCaseWidget(
        builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.8),
          elevation: 0,
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
                borderColor: colorScheme.primary.withOpacity(0.3),
                borderWidth: 2,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WhisperText('YOUR SANCTUARY', uppercase: true),
              const SizedBox(height: 4),
              Text('Your Circles', style: theme.textTheme.headlineLarge?.copyWith(fontSize: 32)),
              const SizedBox(height: 32),
              BlocBuilder<CircleCubit, CircleState>(
                builder: (context, state) {
                  if (state is CircleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CircleLoaded) {
                    if (state.circles.isEmpty) {
                      return const Center(child: Text('You are not in any circles yet.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.circles.length,
                      itemBuilder: (context, index) {
                        final circle = state.circles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CircleCard(
                            circle: circle,
                            onTap: () => context.push('/feed/${circle.id}'),
                          ),
                        );
                      },
                    );
                  } else if (state is CircleError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: TetherWalkthroughOverlay(
          showcaseKey: _fabKey,
          title: 'Your First Circle',
          description: 'Create a sanctuary for you and your inner circle here.',
          child: FloatingActionButton(
            onPressed: () => context.push('/circles/create'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add),
          ),
        ),
        ),
      ),
    );
  }
}
