import '../../domain/entities/future_letter.dart';

class FutureLetterModel extends FutureLetterEntity {
  const FutureLetterModel({
    required super.id,
    required super.circleId,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.deliverAt,
    super.delivered = false,
    required super.createdAt,
  });

  factory FutureLetterModel.fromJson(Map<String, dynamic> json) {
    return FutureLetterModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['encrypted_blob'] as String? ?? json['content'] as String,
      deliverAt: DateTime.parse(json['deliver_at'] as String),
      delivered: json['delivered'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson(String encryptedBlob) {
    return {
      'circle_id': circleId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'encrypted_blob': encryptedBlob,
      'deliver_at': deliverAt.toIso8601String(),
      'delivered': delivered,
    };
  }
}
