import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../bloc/messaging_thread_cubit.dart';
import '../bloc/messaging_thread_state.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = getIt<SupabaseClient>().auth.currentUser?.id;

    return BlocProvider(
      create: (context) => getIt<MessagingThreadCubit>()..loadThreads(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.01),
          elevation: 0,
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
            'Messages',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
        ),
        body: BlocBuilder<MessagingThreadCubit, MessagingThreadState>(
          builder: (context, state) {
            if (state is MessagingThreadLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MessagingThreadLoaded) {
              if (state.threads.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                itemCount: state.threads.length,
                itemBuilder: (context, index) {
                  final thread = state.threads[index];
                  final otherUserId = thread.senderId == currentUserId
                      ? thread.receiverId
                      : thread.senderId;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => context.push(
                        '/messaging/chat/${thread.circleId ?? 'direct'}/$otherUserId',
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
                                imageUrl:
                                    'https://ui-avatars.com/api/?name=Tether&background=6366f1&color=fff&size=150', // Placeholder
                                size: 56,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Someone Close', // Simplified name for now
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    WhisperText(
                                      thread.contentText ?? 'Media message',
                                    ),
                                  ],
                                ),
                              ),
                              if (true) // Simulation of unread
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is MessagingThreadError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
