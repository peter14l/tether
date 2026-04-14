import '../../domain/entities/bedtime_story.dart';

class BedtimeStoryModel extends BedtimeStoryEntity {
  const BedtimeStoryModel({
    required super.id,
    required super.circleId,
    required super.recordedBy,
    super.title,
    required super.storagePath,
    required super.durationSecs,
    required super.createdAt,
  });

  factory BedtimeStoryModel.fromJson(Map<String, dynamic> json) {
    return BedtimeStoryModel(
      id: json['id'] as String? ?? '',
      circleId: json['circle_id'] as String? ?? '',
      recordedBy: json['recorded_by'] as String? ?? '',
      title: json['title'] as String?,
      storagePath: json['storage_path'] as String? ?? '',
      durationSecs: json['duration_secs'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'recorded_by': recordedBy,
      'title': title,
      'storage_path': storagePath,
      'duration_secs': durationSecs,
    };
  }
}
