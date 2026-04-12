import '../../domain/entities/heartbeat.dart';

class HeartbeatModel extends HeartbeatEntity {
  const HeartbeatModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.sentAt,
  });

  factory HeartbeatModel.fromJson(Map<String, dynamic> json) {
    return HeartbeatModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sent_at': sentAt.toIso8601String(),
    };
  }
}
