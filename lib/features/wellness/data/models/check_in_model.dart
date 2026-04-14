import '../../domain/entities/check_in.dart';

class CheckInModel extends CheckInEntity {
  const CheckInModel({
    required super.id,
    required super.userId,
    required super.circleId,
    required super.checkedInAt,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      circleId: json['circle_id'] as String,
      checkedInAt: DateTime.parse(json['checked_in_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'circle_id': circleId,
      'checked_in_at': checkedInAt.toIso8601String(),
    };
  }
}
