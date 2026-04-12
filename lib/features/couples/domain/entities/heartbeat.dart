import 'package:equatable/equatable.dart';

class HeartbeatEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final DateTime sentAt;

  const HeartbeatEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, sentAt];
}
