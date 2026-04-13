import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.circleId,
    required super.authorId,
    required super.contentType,
    super.contentText,
    super.mediaUrl,
    super.authorName,
    super.authorAvatarUrl,
    required super.isAnonymous,
    super.deliverAt,
    super.expiresAfter,
    required super.isSoftDeleted,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      authorId: json['author_id'] as String,
      contentType: json['content_type'] as String,
      contentText: json['content_text'] as String?,
      mediaUrl: json['media_url'] as String?,
      authorName: json['author_name'] as String? ?? json['profiles']?['display_name'] as String?,
      authorAvatarUrl: json['author_avatar_url'] as String? ?? json['profiles']?['avatar_url'] as String?,
      isAnonymous: json['is_anonymous'] as bool,
      deliverAt: json['deliver_at'] != null ? DateTime.parse(json['deliver_at'] as String) : null,
      expiresAfter: json['expires_after'] != null ? _parseDuration(json['expires_after'] as String) : null,
      isSoftDeleted: json['is_soft_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'author_id': authorId,
      'content_type': contentType,
      'content_text': contentText,
      'media_url': mediaUrl,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'is_anonymous': isAnonymous,
      'deliver_at': deliverAt?.toIso8601String(),
      'expires_after': _formatDuration(expiresAfter),
      'is_soft_deleted': isSoftDeleted,
    };
  }

  static Duration? _parseDuration(String interval) {
    // Basic PG interval parser (e.g. "24:00:00")
    final parts = interval.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2].split('.')[0]),
      );
    }
    return null;
  }

  static String? _formatDuration(Duration? duration) {
    if (duration == null) return null;
    return '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';
  }
}
