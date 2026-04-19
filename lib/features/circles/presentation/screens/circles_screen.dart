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
        body: SingleChildScrollView(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: TetherWalkthroughOverlay(
            showcaseKey: _fabKey,
            title: 'Your First Circle',
            description: 'Create a sanctuary for you and your inner circle here.',
            child: TetherButton(
              onPressed: () => context.push('/circles/create'),
              isHighPriority: true,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        ),
      ),
    );
  }
}
