import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../bloc/messaging_thread_cubit.dart';
import '../bloc/messaging_thread_state.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = getIt<SupabaseClient>().auth.currentUser?.id;

    return BlocProvider(
      create: (context) => getIt<MessagingThreadCubit>()..loadThreads(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages', style: Theme.of(context).textTheme.headlineMedium),
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
                padding: const EdgeInsets.all(16),
                itemCount: state.threads.length,
                itemBuilder: (context, index) {
                  final thread = state.threads[index];
                  final otherUserId = thread.senderId == currentUserId ? thread.receiverId : thread.senderId;
                  
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        child: const Icon(Icons.person),
                      ),
                      title: Text(otherUserId, style: Theme.of(context).textTheme.titleLarge), // Simplified for now
                      subtitle: Text(
                        thread.contentText ?? 'Media message',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push('/messaging/chat/${thread.circleId ?? 'direct'}/$otherUserId'),
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
