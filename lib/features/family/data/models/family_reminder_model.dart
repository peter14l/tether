import '../../domain/entities/family_reminder.dart';

class FamilyReminderModel extends FamilyReminderEntity {
  const FamilyReminderModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    super.assignedTo,
    required super.title,
    super.description,
    super.isCompleted = false,
    super.completedAt,
    required super.createdAt,
  });

  factory FamilyReminderModel.fromJson(Map<String, dynamic> json) {
    return FamilyReminderModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      assignedTo: json['assigned_to'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
