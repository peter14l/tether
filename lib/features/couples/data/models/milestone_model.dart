import '../../domain/entities/milestone.dart';

class MilestoneModel extends MilestoneEntity {
  const MilestoneModel({
    required super.id,
    required super.circleId,
    required super.eventDate,
    required super.title,
    super.description,
    required super.category,
    required super.createdAt,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'title': title,
      'description': description,
      'category': category,
    };
  }
}
