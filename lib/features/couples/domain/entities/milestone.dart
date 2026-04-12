import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  final String id;
  final String circleId;
  final DateTime eventDate;
  final String title;
  final String? description;
  final String category; // 'auto' | 'manual'
  final DateTime createdAt;

  const MilestoneEntity({
    required this.id,
    required this.circleId,
    required this.eventDate,
    required this.title,
    this.description,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, eventDate, title, description, category, createdAt];
}
