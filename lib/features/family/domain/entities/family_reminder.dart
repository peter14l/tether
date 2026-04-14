import 'package:equatable/equatable.dart';

class FamilyReminderEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String? assignedTo;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;

  const FamilyReminderEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    this.assignedTo,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, assignedTo, title, description, isCompleted, completedAt, createdAt];
}
