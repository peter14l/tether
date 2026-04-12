import 'package:equatable/equatable.dart';

class SosAlertEntity extends Equatable {
  final String id;
  final String userId;
  final String circleId;
  final double? lat;
  final double? lng;
  final double? accuracy;
  final DateTime sentAt;
  final DateTime? resolvedAt;

  const SosAlertEntity({
    required this.id,
    required this.userId,
    required this.circleId,
    this.lat,
    this.lng,
    this.accuracy,
    required this.sentAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [id, userId, circleId, lat, lng, accuracy, sentAt, resolvedAt];
}
