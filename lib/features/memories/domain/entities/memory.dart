import 'package:equatable/equatable.dart';

class MemoryEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String? title;
  final String? description;
  final String? mediaUrl;
  final DateTime memoryDate;
  final DateTime createdAt;

  const MemoryEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    this.title,
    this.description,
    this.mediaUrl,
    required this.memoryDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, title, description, mediaUrl, memoryDate, createdAt];
}
