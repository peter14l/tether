import '../../domain/entities/circle_entity.dart';

class CircleModel extends CircleEntity {
  const CircleModel({
    required super.id,
    required super.name,
    required super.circleType,
    required super.createdBy,
    super.avatarUrl,
    super.description,
    required super.comfortRadius,
    required super.isEncrypted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      circleType: json['circle_type'] as String,
      createdBy: json['created_by'] as String,
      avatarUrl: json['avatar_url'] as String?,
      description: json['description'] as String?,
      comfortRadius: json['comfort_radius'] as String,
      isEncrypted: json['is_encrypted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'circle_type': circleType,
      'created_by': createdBy,
      'avatar_url': avatarUrl,
      'description': description,
      'comfort_radius': comfortRadius,
      'is_encrypted': isEncrypted,
    };
  }
}
