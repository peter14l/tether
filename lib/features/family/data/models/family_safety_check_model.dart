import '../../domain/entities/family_safety_check.dart';

class FamilySafetyCheckModel extends FamilySafetyCheckEntity {
  const FamilySafetyCheckModel({
    required super.id,
    required super.circleId,
    required super.triggeredBy,
    super.respondedAt,
    required super.timeoutMinutes,
    required super.status,
    required super.createdAt,
  });

  factory FamilySafetyCheckModel.fromJson(Map<String, dynamic> json) {
    return FamilySafetyCheckModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      triggeredBy: json['triggered_by'] as String,
      respondedAt: json['responded_at'] != null ? DateTime.parse(json['responded_at'] as String) : null,
      timeoutMinutes: json['timeout_minutes'] as int? ?? 30,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'triggered_by': triggeredBy,
      'responded_at': respondedAt?.toIso8601String(),
      'timeout_minutes': timeoutMinutes,
      'status': status,
    };
  }
}
