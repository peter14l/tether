import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String? receiverId; // Optional for 1:1 backward compatibility/convenience
  final String messageType; // 'text' | 'image' | 'video' | 'file'
  final String? encryptedText; // Decrypted content in memory for UI
  final String? r2ObjectKey;
  final String? mediaKey; // Hex or Base64 encoded key
  final bool isExpired;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    this.receiverId,
    required this.messageType,
    this.encryptedText,
    this.r2ObjectKey,
    this.mediaKey,
    this.isExpired = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        receiverId,
        messageType,
        encryptedText,
        r2ObjectKey,
        mediaKey,
        isExpired,
        createdAt,
      ];

  MessageEntity copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? receiverId,
    String? messageType,
    String? encryptedText,
    String? r2ObjectKey,
    String? mediaKey,
    bool? isExpired,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      messageType: messageType ?? this.messageType,
      encryptedText: encryptedText ?? this.encryptedText,
      r2ObjectKey: r2ObjectKey ?? this.r2ObjectKey,
      mediaKey: mediaKey ?? this.mediaKey,
      isExpired: isExpired ?? this.isExpired,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
