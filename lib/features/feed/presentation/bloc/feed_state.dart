import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostEntity> posts;

  const FeedLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostCreated extends FeedState {
  final PostEntity post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}
