import 'package:equatable/equatable.dart';

class TemperatureCheckEntity extends Equatable {
  final String id;
  final String circleId;
  final DateTime date;
  final Map<String, String> responses; // userId: emojiKey

  const TemperatureCheckEntity({
    required this.id,
    required this.circleId,
    required this.date,
    required this.responses,
  });

  @override
  List<Object?> get props => [id, circleId, date, responses];
}
