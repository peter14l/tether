import 'package:equatable/equatable.dart';

class ChoreEntity extends Equatable {
  final String id;
  final String circleId;
  final String? assignedTo;
  final String title;
  final int seedsValue;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;

  const ChoreEntity({
    required this.id,
    required this.circleId,
    this.assignedTo,
    required this.title,
    this.seedsValue = 1,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, assignedTo, title, seedsValue, isCompleted, completedAt, createdAt];
}
