import 'package:equatable/equatable.dart';

class KindnessStreakEntity extends Equatable {
  final String id;
  final String userId;
  final String circleId;
  final String actionType;
  final DateTime loggedAt;

  const KindnessStreakEntity({
    required this.id,
    required this.userId,
    required this.circleId,
    required this.actionType,
    required this.loggedAt,
  });

  @override
  List<Object?> get props => [id, userId, circleId, actionType, loggedAt];
}
