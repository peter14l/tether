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
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/presentation/widgets/tether_walkthrough_overlay.dart';
import '../widgets/circle_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


import '../../../../core/widgets/onboarding_overlay.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final GlobalKey _circleListKey = GlobalKey();
  final GlobalKey _createButtonKey = GlobalKey();
  final GlobalKey _circleCardKey = GlobalKey();

  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_circles_onboarding_v2') ?? false;
    
    if (!hasSeen && mounted) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_circles_onboarding_v2', true);
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

    return BlocProvider(
      create: (context) => getIt<CircleCubit>()..loadCircles(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.01),
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ColorFilter.mode(colorScheme.surface.withOpacity(0.8), BlendMode.srcOver),
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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WhisperText('YOUR SANCTUARY'),
                  const SizedBox(height: 8),
                  Text(
                    'Your Circles',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
                      letterSpacing: -1,
                    ),
                  ),
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
                          key: _circleListKey,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.circles.length,
                          itemBuilder: (context, index) {
                            final circle = state.circles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CircleCard(
                                key: index == 0 ? _circleCardKey : null,
                                circle: circle,
                                onTap: () => context.push('/feed/${circle.id}'),
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Circle'),
                                      content: Text('Are you sure you want to permanently delete "${circle.name}"? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            context.read<CircleCubit>().deleteCircle(circle.id);
                                          },
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
            if (_showOverlay)
              FeatureOnboardingOverlay(
                steps: [
                  OnboardingStep(
                    targetKey: _circleListKey,
                    title: 'Your Circles',
                    body: "Each Circle is a private micro-network. What's shared inside one Circle never leaks to another. You architect your own social world.",
                  ),
                  OnboardingStep(
                    targetKey: _createButtonKey,
                    title: 'Start a New Circle',
                    body: "Create a Circle for any context in your life — a group trip, a support system, a creative project. Give it a name and invite exactly the right people.",
                  ),
                  OnboardingStep(
                    targetKey: _circleCardKey,
                    title: 'Circle at a Glance',
                    body: "See who's in each Circle and when they last shared. Tap to enter that Circle's dedicated feed.",
                  ),
                ],
                onComplete: _markOnboardingComplete,
                onSkip: _markOnboardingComplete,
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: TetherButton(
            key: _createButtonKey,
            onPressed: () => context.push('/circles/create'),
            isHighPriority: true,
            child: const Icon(FluentIcons.add_24_regular),
          ),
        ),
      ),
    );
  }
}
