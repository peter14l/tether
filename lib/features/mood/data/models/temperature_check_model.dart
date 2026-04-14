import '../../domain/entities/temperature_check.dart';

class TemperatureCheckModel extends TemperatureCheckEntity {
  const TemperatureCheckModel({
    required super.id,
    required super.circleId,
    required super.date,
    required super.responses,
  });

  factory TemperatureCheckModel.fromJson(Map<String, dynamic> json) {
    return TemperatureCheckModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      date: DateTime.parse(json['date'] as String),
      responses: Map<String, String>.from(json['responses'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'date': date.toIso8601String().split('T')[0], // only date part
      'responses': responses,
    };
  }
}
