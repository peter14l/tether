import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String? circleId;
  final String contentType; // 'text' | 'image' | 'voice'
  final String? contentText;
  final String? mediaUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.circleId,
    required this.contentType,
    this.contentText,
    this.mediaUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        circleId,
        contentType,
        contentText,
        mediaUrl,
        isRead,
        readAt,
        createdAt,
      ];
}
