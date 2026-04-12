import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    super.circleId,
    required super.contentType,
    super.contentText,
    super.mediaUrl,
    required super.isRead,
    super.readAt,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      circleId: json['circle_id'] as String?,
      contentType: json['content_type'] as String,
      contentText: json['content_text'] as String?,
      mediaUrl: json['media_url'] as String?,
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'circle_id': circleId,
      'content_type': contentType,
      'content_text': contentText,
      'media_url': mediaUrl,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
    };
  }
}
