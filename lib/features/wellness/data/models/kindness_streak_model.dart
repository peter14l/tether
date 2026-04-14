import '../../domain/entities/kindness_streak.dart';

class KindnessStreakModel extends KindnessStreakEntity {
  const KindnessStreakModel({
    required super.id,
    required super.userId,
    required super.circleId,
    required super.actionType,
    required super.loggedAt,
  });

  factory KindnessStreakModel.fromJson(Map<String, dynamic> json) {
    return KindnessStreakModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      circleId: json['circle_id'] as String,
      actionType: json['action_type'] as String,
      loggedAt: DateTime.parse(json['logged_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'circle_id': circleId,
      'action_type': actionType,
      'logged_at': loggedAt.toIso8601String(),
    };
  }
}
