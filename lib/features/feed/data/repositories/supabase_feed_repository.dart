import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../models/post_model.dart';

@LazySingleton(as: IFeedRepository)
class SupabaseFeedRepository implements IFeedRepository {
  final SupabaseClient _client;

  SupabaseFeedRepository(this._client);

  @override
  Future<Either<Failure, List<PostEntity>>> getCircleFeed(String circleId) async {
    try {
      final response = await _client
          .from('posts')
          .select()
          .eq('circle_id', circleId)
          .eq('is_soft_deleted', false)
          .order('created_at', ascending: false);

      final posts = (response as List).map((json) => PostModel.fromJson(json)).toList();
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(PostEntity post) async {
    try {
      final model = PostModel(
        id: post.id,
        circleId: post.circleId,
        authorId: post.authorId,
        contentType: post.contentType,
        contentText: post.contentText,
        mediaUrl: post.mediaUrl,
        isAnonymous: post.isAnonymous,
        deliverAt: post.deliverAt,
        expiresAfter: post.expiresAfter,
        isSoftDeleted: post.isSoftDeleted,
        createdAt: post.createdAt,
      );

      final response = await _client
          .from('posts')
          .insert(model.toJson())
          .select()
          .single();

      return Right(PostModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReaction(String postId, String reactionType) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      await _client.from('reactions').upsert({
        'post_id': postId,
        'user_id': userId,
        'reaction_type': reactionType,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction(String postId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      await _client
          .from('reactions')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
