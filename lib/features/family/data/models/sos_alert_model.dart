import '../../domain/entities/sos_alert.dart';

class SosAlertModel extends SosAlertEntity {
  const SosAlertModel({
    required super.id,
    required super.userId,
    required super.circleId,
    super.lat,
    super.lng,
    super.accuracy,
    required super.sentAt,
    super.resolvedAt,
  });

  factory SosAlertModel.fromJson(Map<String, dynamic> json) {
    return SosAlertModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      circleId: json['circle_id'] as String? ?? '',
      lat: (json['location_lat'] as num?)?.toDouble(),
      lng: (json['location_lng'] as num?)?.toDouble(),
      accuracy: (json['location_accuracy'] as num?)?.toDouble(),
      sentAt: json['sent_at'] != null 
          ? DateTime.parse(json['sent_at'] as String) 
          : DateTime.now(),
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'circle_id': circleId,
      'location_lat': lat,
      'location_lng': lng,
      'location_accuracy': accuracy,
      'sent_at': sentAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }
}
