import 'package:equatable/equatable.dart';

class PrivateJokeEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String content; // text or image url
  final String? mediaUrl;
  final DateTime createdAt;

  const PrivateJokeEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, content, mediaUrl, createdAt];
}
