import '../../domain/entities/reaction_entity.dart';

class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.reactionType,
    required super.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      reactionType: json['reaction_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'reaction_type': reactionType,
    };
  }
}
