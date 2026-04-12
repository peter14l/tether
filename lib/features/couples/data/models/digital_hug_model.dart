import '../../domain/entities/digital_hug.dart';

class DigitalHugModel extends DigitalHugEntity {
  const DigitalHugModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.circleId,
    required super.sentAt,
    super.returnedAt,
  });

  factory DigitalHugModel.fromJson(Map<String, dynamic> json) {
    return DigitalHugModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      circleId: json['circle_id'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      returnedAt: json['returned_at'] != null ? DateTime.parse(json['returned_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'circle_id': circleId,
      'sent_at': sentAt.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
    };
  }
}
