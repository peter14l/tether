import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  post.isAnonymous ? 'Anonymous' : 'Someone Close',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatDate(post.createdAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (post.contentType == 'text' && post.contentText != null)
              Text(post.contentText!, style: Theme.of(context).textTheme.bodyLarge),
            if (post.contentType == 'image' && post.mediaUrl != null)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Placeholder(fallbackHeight: 200), // Image placeholder for now
              ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ReactionBar(
              postId: post.id,
              onReactionTap: onReactionTap,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
