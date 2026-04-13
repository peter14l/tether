import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String circleId;
  final String authorId;
  final String contentType; // 'text' | 'image' | 'voice' | 'letter' | 'one_way'
  final String? contentText;
  final String? mediaUrl;
  final String? authorName;
  final String? authorAvatarUrl;
  final bool isAnonymous;
  final DateTime? deliverAt;
  final Duration? expiresAfter;
  final bool isSoftDeleted;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.circleId,
    required this.authorId,
    required this.contentType,
    this.contentText,
    this.mediaUrl,
    this.authorName,
    this.authorAvatarUrl,
    required this.isAnonymous,
    this.deliverAt,
    this.expiresAfter,
    required this.isSoftDeleted,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        circleId,
        authorId,
        contentType,
        contentText,
        mediaUrl,
        authorName,
        authorAvatarUrl,
        isAnonymous,
        deliverAt,
        expiresAfter,
        isSoftDeleted,
        createdAt,
      ];
}
