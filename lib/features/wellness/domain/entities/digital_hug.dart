import 'package:equatable/equatable.dart';

class DigitalHugEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String circleId;
  final DateTime sentAt;
  final DateTime? returnedAt;

  const DigitalHugEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.circleId,
    required this.sentAt,
    this.returnedAt,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, circleId, sentAt, returnedAt];
}
