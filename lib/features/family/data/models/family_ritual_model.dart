import '../../domain/entities/family_ritual.dart';

class FamilyRitualModel extends FamilyRitualEntity {
  const FamilyRitualModel({
    required super.id,
    required super.circleId,
    required super.title,
    required super.type,
    super.scheduledTime,
    required super.daysActive,
  });

  factory FamilyRitualModel.fromJson(Map<String, dynamic> json) {
    return FamilyRitualModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      scheduledTime: json['scheduled_time'] as String?,
      daysActive: (json['days_active'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'title': title,
      'type': type,
      'scheduled_time': scheduledTime,
      'days_active': daysActive,
    };
  }
}
