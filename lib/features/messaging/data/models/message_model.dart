import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    super.receiverId,
    required super.messageType,
    super.encryptedText,
    super.r2ObjectKey,
    super.mediaKey,
    super.isExpired = false,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      roomId: json['room_id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? '',
      receiverId: json['receiver_id'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
      encryptedText: json['encrypted_text'] as String?,
      r2ObjectKey: json['r2_object_key'] as String?,
      mediaKey: json['media_key'] as String?,
      isExpired: json['is_expired'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_type': messageType,
      'encrypted_text': encryptedText,
      'r2_object_key': r2ObjectKey,
      'media_key': mediaKey,
      'is_expired': isExpired,
    };
  }
}
