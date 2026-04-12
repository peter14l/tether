import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/feed_cubit.dart';
import '../bloc/feed_state.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  final String circleId;
  const FeedScreen({super.key, required this.circleId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeedCubit>()..loadFeed(widget.circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feed', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<FeedCubit, FeedState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_postController.text.isNotEmpty) {
                            context.read<FeedCubit>().postText(widget.circleId, _postController.text);
                            _postController.clear();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FeedCubit, FeedState>(
                builder: (context, state) {
                  if (state is FeedLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FeedLoaded) {
                    if (state.posts.isEmpty) {
                      return const Center(child: Text('No posts yet. Be the first!'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostCard(
                          post: post,
                          onReactionTap: (type) {
                            context.read<FeedCubit>().toggleReaction(widget.circleId, post.id, type);
                          },
                        );
                      },
                    );
                  } else if (state is FeedError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
