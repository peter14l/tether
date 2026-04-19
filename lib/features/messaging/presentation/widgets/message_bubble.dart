import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe 
              ? theme.colorScheme.primary 
              : theme.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.messageType == 'text' && message.encryptedText != null)
                Text(
                  message.encryptedText!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  ),
                ),
              if (message.messageType == 'voice' || message.messageType == 'audio')
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.play_24_regular, size: 24),
                    SizedBox(width: 8),
                    Text('Voice Note'),
                  ],
                ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.createdAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: (isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface).withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
