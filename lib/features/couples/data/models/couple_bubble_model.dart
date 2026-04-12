import '../../domain/entities/couple_bubble.dart';

class CoupleBubbleModel extends CoupleBubbleEntity {
  const CoupleBubbleModel({
    required super.id,
    required super.circleId,
    super.ourSongUrl,
    super.ourSongTitle,
    super.anniversaryDate,
    super.promiseRingSetAt,
    super.promiseRingText,
    super.spaceToBreatheActive,
    super.spaceToBreatheUntil,
    super.spaceToBreatheBy,
    required super.createdAt,
  });

  factory CoupleBubbleModel.fromJson(Map<String, dynamic> json) {
    return CoupleBubbleModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      ourSongUrl: json['our_song_url'] as String?,
      ourSongTitle: json['our_song_title'] as String?,
      anniversaryDate: json['anniversary_date'] != null ? DateTime.parse(json['anniversary_date'] as String) : null,
      promiseRingSetAt: json['promise_ring_set_at'] != null ? DateTime.parse(json['promise_ring_set_at'] as String) : null,
      promiseRingText: json['promise_ring_text'] as String?,
      spaceToBreatheActive: json['space_to_breathe_active'] as bool? ?? false,
      spaceToBreatheUntil: json['space_to_breathe_until'] != null ? DateTime.parse(json['space_to_breathe_until'] as String) : null,
      spaceToBreatheBy: json['space_to_breathe_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'our_song_url': ourSongUrl,
      'our_song_title': ourSongTitle,
      'anniversary_date': anniversaryDate?.toIso8601String().split('T')[0],
      'promise_ring_set_at': promiseRingSetAt?.toIso8601String(),
      'promise_ring_text': promiseRingText,
      'space_to_breathe_active': spaceToBreatheActive,
      'space_to_breathe_until': spaceToBreatheUntil?.toIso8601String(),
      'space_to_breathe_by': spaceToBreatheBy,
    };
  }
}
