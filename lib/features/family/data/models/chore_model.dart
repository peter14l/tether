import '../../domain/entities/chore.dart';

class ChoreModel extends ChoreEntity {
  const ChoreModel({
    required super.id,
    required super.circleId,
    super.assignedTo,
    required super.title,
    super.seedsValue = 1,
    super.isCompleted = false,
    super.completedAt,
    required super.createdAt,
  });

  factory ChoreModel.fromJson(Map<String, dynamic> json) {
    return ChoreModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      assignedTo: json['assigned_to'] as String?,
      title: json['title'] as String,
      seedsValue: json['seeds_value'] as int? ?? 1,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'assigned_to': assignedTo,
      'title': title,
      'seeds_value': seedsValue,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
