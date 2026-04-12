import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import 'feed_state.dart';

@injectable
class FeedCubit extends Cubit<FeedState> {
  final IFeedRepository _feedRepository;
  final SupabaseClient _supabaseClient;

  FeedCubit(this._feedRepository, this._supabaseClient) : super(FeedInitial());

  Future<void> loadFeed(String circleId) async {
    emit(FeedLoading());
    final result = await _feedRepository.getCircleFeed(circleId);
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (posts) => emit(FeedLoaded(posts)),
    );
  }

  Future<void> postText(String circleId, String content) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const FeedError('User not authenticated'));
      return;
    }

    final newPost = PostEntity(
      id: '',
      circleId: circleId,
      authorId: userId,
      contentType: 'text',
      contentText: content,
      isAnonymous: false,
      isSoftDeleted: false,
      createdAt: DateTime.now(),
    );

    final result = await _feedRepository.createPost(newPost);
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (post) {
        emit(PostCreated(post));
        loadFeed(circleId);
      },
    );
  }

  Future<void> toggleReaction(String circleId, String postId, String type) async {
    // Basic implementation: always add for now
    final result = await _feedRepository.addReaction(postId, type);
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (_) => loadFeed(circleId),
    );
  }
}
