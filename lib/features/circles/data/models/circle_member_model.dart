import '../../domain/entities/circle_member_entity.dart';

class CircleMemberModel extends CircleMemberEntity {
  const CircleMemberModel({
    required super.id,
    required super.circleId,
    required super.userId,
    required super.role,
    required super.joinedAt,
  });

  factory CircleMemberModel.fromJson(Map<String, dynamic> json) {
    return CircleMemberModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'user_id': userId,
      'role': role,
    };
  }
}
