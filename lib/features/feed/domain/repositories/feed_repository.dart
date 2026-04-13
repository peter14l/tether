import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class IFeedRepository {
  Future<Either<Failure, List<PostEntity>>> getCircleFeed(String circleId);
  Stream<List<PostEntity>> watchCircleFeed(String circleId);
  Future<Either<Failure, PostEntity>> createPost(PostEntity post);
  Future<Either<Failure, void>> addReaction(String postId, String reactionType);
  Future<Either<Failure, void>> removeReaction(String postId);
}
