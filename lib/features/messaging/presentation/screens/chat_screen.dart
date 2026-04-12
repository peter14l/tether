import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/theme/theme_tokens.dart';
import '../../../../core/theme/time_theme_cubit.dart';
import '../../../../core/theme/time_theme_state.dart';
import '../bloc/messaging_cubit.dart';
import '../bloc/messaging_state.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String circleId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.circleId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool _isSlowChat = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MessagingCubit>()..loadMessages(widget.otherUserId, circleId: widget.circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.otherUserId, style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('Online', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(_isSlowChat ? Icons.mic : Icons.message),
              onPressed: () => setState(() => _isSlowChat = !_isSlowChat),
              tooltip: 'Toggle Slow Chat',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagingCubit, MessagingState>(
                builder: (context, state) {
                  if (state is MessagingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessagingLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId != widget.otherUserId;
                        return MessageBubble(message: message, isMe: isMe);
                      },
                    );
                  } else if (state is MessagingError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    if (_isSlowChat) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Slow Chat Mode: Voice Only', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, size: 48, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text('Hold to Record', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Your message...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<MessagingCubit, MessagingState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    context.read<MessagingCubit>().sendMessage(
                      receiverId: widget.otherUserId,
                      circleId: widget.circleId,
                      contentType: 'text',
                      contentText: _messageController.text,
                    );
                    _messageController.clear();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
