import 'package:equatable/equatable.dart';

class CheckInEntity extends Equatable {
  final String id;
  final String userId;
  final String circleId;
  final DateTime checkedInAt;

  const CheckInEntity({
    required this.id,
    required this.userId,
    required this.circleId,
    required this.checkedInAt,
  });

  @override
  List<Object?> get props => [id, userId, circleId, checkedInAt];
}
