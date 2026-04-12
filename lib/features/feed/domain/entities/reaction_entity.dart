import 'package:equatable/equatable.dart';

class ReactionEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String reactionType; // 'warm' | 'comforting' | 'i_see_you' | 'sending_strength'
  final DateTime createdAt;

  const ReactionEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.reactionType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, postId, userId, reactionType, createdAt];
}
