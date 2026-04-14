import '../../domain/entities/mood_status.dart';

class MoodModel extends MoodStatusEntity {
  const MoodModel({
    required super.id,
    required super.userId,
    required super.status,
    super.label,
    super.colorKey,
    required super.updatedAt,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      status: _parseMoodType(json['status'] as String? ?? 'happy'),
      label: json['label'] as String?,
      colorKey: json['color_key'] as String?,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'status': status.name,
      'label': label,
      'color_key': colorKey,
    };
  }

  static MoodType _parseMoodType(String value) {
    return MoodType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MoodType.happy,
    );
  }
}
