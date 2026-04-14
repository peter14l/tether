import 'package:equatable/equatable.dart';

class FamilyRitualEntity extends Equatable {
  final String id;
  final String circleId;
  final String title;
  final String type; // 'call' | 'movie' | 'dinner'
  final String? scheduledTime; // "HH:mm"
  final List<String> daysActive;

  const FamilyRitualEntity({
    required this.id,
    required this.circleId,
    required this.title,
    required this.type,
    this.scheduledTime,
    required this.daysActive,
  });

  @override
  List<Object?> get props => [id, circleId, title, type, scheduledTime, daysActive];
}
