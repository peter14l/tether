import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/onboarding_overlay.dart';
import '../bloc/messaging_thread_cubit.dart';
import '../bloc/messaging_thread_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final GlobalKey _filterBarKey = GlobalKey();
  final GlobalKey _threadListKey = GlobalKey();
  final GlobalKey _newMessageKey = GlobalKey();

  bool _showOverlay = false;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_unified_messaging_onboarding') ?? false;
    if (!hasSeen && mounted) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_unified_messaging_onboarding', true);
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
    final currentUserId = getIt<SupabaseClient>().auth.currentUser?.id;

    return BlocProvider(
      create: (context) => getIt<MessagingThreadCubit>()..loadThreads(),
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

                // Unified Filter Bar
                SliverToBoxAdapter(
                  child: Container(
                    key: _filterBarKey,
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: ['All', 'Friends', 'Family', 'Partner'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: colorScheme.surfaceContainerLow,
                            selectedColor: colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                BlocBuilder<MessagingThreadCubit, MessagingThreadState>(
                  builder: (context, state) {
                    if (state is MessagingThreadLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is MessagingThreadLoaded) {
                      // Note: In a real implementation, you'd filter the threads 
                      // based on the circle they belong to. 
                      final filteredThreads = state.threads; // Simplified for prototype

                      if (filteredThreads.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: Text('No conversations here yet.')),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        sliver: SliverList(
                          key: _threadListKey,
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final thread = filteredThreads[index];
                              final otherUserId = thread.senderId == currentUserId
                                  ? thread.receiverId
                                  : thread.senderId;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () => context.pushNamed(
                                    'chat',
                                    pathParameters: {'roomId': thread.roomId},
                                    queryParameters: {'otherUserId': otherUserId ?? ''},
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  child: GlassPanel(
                                    padding: EdgeInsets.zero,
                                    opacity: 0.1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const SquircleAvatar(
                                            imageUrl: 'https://ui-avatars.com/api/?name=T&background=E8692A&color=fff',
                                            size: 56,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Someone Close',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                WhisperText(
                                                  thread.encryptedText ?? 'Media message',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: filteredThreads.length,
                          ),
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),
              ],
            ),

            if (_showOverlay)
              FeatureOnboardingOverlay(
                steps: [
                  OnboardingStep(
                    targetKey: _filterBarKey,
                    title: 'Filter by Circle',
                    body: "Tap a Circle to see only the conversations shared within that group. Your different worlds stay naturally separate.",
                  ),
                  OnboardingStep(
                    targetKey: _threadListKey,
                    title: 'Your Conversations',
                    body: "Private, end-to-end encrypted threads. Tether ensures your intimate talks stay just between you.",
                  ),
                  OnboardingStep(
                    targetKey: _newMessageKey,
                    title: 'Start a Chat',
                    body: "Tap here to find someone close and start a new sanctuary of conversation.",
                  ),
                ],
                onComplete: _markOnboardingComplete,
                onSkip: _markOnboardingComplete,
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          key: _newMessageKey,
          onPressed: () => context.pushNamed('new_message'),
          backgroundColor: colorScheme.primary,
          child: const Icon(FluentIcons.chat_24_regular, color: Colors.white),
        ),
      ),
    );
  }
}
