import 'package:flutter/material.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../domain/entities/post_entity.dart';
import 'reaction_bar.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final Function(String) onReactionTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      SquircleAvatar(
                        imageUrl: post.authorAvatarUrl ?? 'https://via.placeholder.com/150',
                        size: 48,
                        borderColor: colorScheme.primary,
                        borderWidth: 2,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colorScheme.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName ?? (post.isAnonymous ? 'Anonymous' : 'Someone Close'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      WhisperText(
                        _formatDate(post.createdAt),
                        fontSize: 11,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant.withOpacity(0.4)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                left: BorderSide(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.contentType == 'text' && post.contentText != null)
                  Text(
                    post.contentText!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                if (post.contentType == 'image' && post.mediaUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.mediaUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ReactionBar(
            postId: post.id,
            onReactionTap: onReactionTap,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inHours < 1) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${date.day}/${date.month}';
  }
}

