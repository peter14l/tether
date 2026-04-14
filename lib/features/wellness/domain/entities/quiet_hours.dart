import 'package:equatable/equatable.dart';

class QuietHoursEntity extends Equatable {
  final String id;
  final String userId;
  final bool enabled;
  final String startTime; // "HH:mm"
  final String endTime;   // "HH:mm"
  final String? windDownStart; // "HH:mm"
  final List<String> daysActive;

  const QuietHoursEntity({
    required this.id,
    required this.userId,
    this.enabled = false,
    required this.startTime,
    required this.endTime,
    this.windDownStart,
    required this.daysActive,
  });

  @override
  List<Object?> get props => [id, userId, enabled, startTime, endTime, windDownStart, daysActive];
}
