import '../../domain/entities/private_joke.dart';

class PrivateJokeModel extends PrivateJokeEntity {
  const PrivateJokeModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    required super.content,
    super.mediaUrl,
    required super.createdAt,
  });

  factory PrivateJokeModel.fromJson(Map<String, dynamic> json) {
    return PrivateJokeModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      content: json['content'] as String,
      mediaUrl: json['media_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'content': content,
      'media_url': mediaUrl,
    };
  }
}
