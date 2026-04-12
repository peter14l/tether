import 'package:equatable/equatable.dart';

class FamilySafetyCheckEntity extends Equatable {
  final String id;
  final String circleId;
  final String triggeredBy;
  final DateTime? respondedAt;
  final int timeoutMinutes;
  final String status; // 'pending' | 'safe' | 'escalated'
  final DateTime createdAt;

  const FamilySafetyCheckEntity({
    required this.id,
    required this.circleId,
    required this.triggeredBy,
    this.respondedAt,
    this.timeoutMinutes = 30,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, triggeredBy, respondedAt, timeoutMinutes, status, createdAt];
}
