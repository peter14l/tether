import '../../domain/entities/quiet_hours.dart';

class QuietHoursModel extends QuietHoursEntity {
  const QuietHoursModel({
    required super.id,
    required super.userId,
    super.enabled = false,
    required super.startTime,
    required super.endTime,
    super.windDownStart,
    required super.days_active,
  }) : super(daysActive: days_active);

  factory QuietHoursModel.fromJson(Map<String, dynamic> json) {
    return QuietHoursModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      enabled: json['enabled'] as bool? ?? false,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      windDownStart: json['wind_down_start'] as String?,
      days_active: (json['days_active'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'enabled': enabled,
      'start_time': startTime,
      'end_time': endTime,
      'wind_down_start': windDownStart,
      'days_active': daysActive,
    };
  }
}
