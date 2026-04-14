import '../../domain/entities/calendar_event.dart';

class CalendarEventModel extends CalendarEventEntity {
  const CalendarEventModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    required super.title,
    super.description,
    required super.eventDate,
    super.isRecurring = false,
    super.recurrenceRule,
    required super.createdAt,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventDate: DateTime.parse(json['event_date'] as String),
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurrenceRule: json['recurrence_rule'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'is_recurring': isRecurring,
      'recurrence_rule': recurrenceRule,
    };
  }
}
