import 'package:equatable/equatable.dart';

class FutureLetterEntity extends Equatable {
  final String id;
  final String circleId;
  final String senderId;
  final String receiverId;
  final String content; // stored encrypted
  final DateTime deliverAt;
  final bool delivered;
  final DateTime createdAt;

  const FutureLetterEntity({
    required this.id,
    required this.circleId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.deliverAt,
    this.delivered = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, senderId, receiverId, content, deliverAt, delivered, createdAt];
}
