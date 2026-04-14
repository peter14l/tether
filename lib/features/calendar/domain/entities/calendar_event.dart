import 'package:equatable/equatable.dart';

class CalendarEventEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String title;
  final String? description;
  final DateTime eventDate;
  final bool isRecurring;
  final String? recurrenceRule;
  final DateTime createdAt;

  const CalendarEventEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    required this.title,
    this.description,
    required this.eventDate,
    this.isRecurring = false,
    this.recurrenceRule,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, title, description, eventDate, isRecurring, recurrenceRule, createdAt];
}
