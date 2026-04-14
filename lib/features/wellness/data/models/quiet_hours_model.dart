import '../../domain/entities/quiet_hours.dart';

class QuietHoursModel extends QuietHoursEntity {
  const QuietHoursModel({
    required String id,
    required String userId,
    bool enabled = false,
    required String startTime,
    required String endTime,
    String? windDownStart,
    required List<String> daysActive,
  }) : super(
          id: id,
          userId: userId,
          enabled: enabled,
          startTime: startTime,
          endTime: endTime,
          windDownStart: windDownStart,
          daysActive: daysActive,
        );

  factory QuietHoursModel.fromJson(Map<String, dynamic> json) {
    return QuietHoursModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      enabled: json['enabled'] as bool? ?? false,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      windDownStart: json['wind_down_start'] as String?,
      daysActive: (json['days_active'] as List).cast<String>(),
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
