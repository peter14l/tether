import 'package:equatable/equatable.dart';

class CircleMemberEntity extends Equatable {
  final String id;
  final String circleId;
  final String userId;
  final String role; // 'admin' | 'member'
  final DateTime joinedAt;

  const CircleMemberEntity({
    required this.id,
    required this.circleId,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [id, circleId, userId, role, joinedAt];
}
