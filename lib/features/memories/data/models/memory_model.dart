import '../../domain/entities/memory.dart';

class MemoryModel extends MemoryEntity {
  const MemoryModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    super.title,
    super.description,
    super.mediaUrl,
    required super.memoryDate,
    required super.createdAt,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      mediaUrl: json['media_url'] as String?,
      memoryDate: DateTime.parse(json['memory_date'] as String? ?? json['created_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'media_url': mediaUrl,
      'memory_date': memoryDate.toIso8601String(),
    };
  }
}
