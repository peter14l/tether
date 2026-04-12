import 'package:equatable/equatable.dart';

class CoupleBubbleEntity extends Equatable {
  final String id;
  final String circleId;
  final String? ourSongUrl;
  final String? ourSongTitle;
  final DateTime? anniversaryDate;
  final DateTime? promiseRingSetAt;
  final String? promiseRingText;
  final bool spaceToBreatheActive;
  final DateTime? spaceToBreatheUntil;
  final String? spaceToBreatheBy;
  final DateTime createdAt;

  const CoupleBubbleEntity({
    required this.id,
    required this.circleId,
    this.ourSongUrl,
    this.ourSongTitle,
    this.anniversaryDate,
    this.promiseRingSetAt,
    this.promiseRingText,
    this.spaceToBreatheActive = false,
    this.spaceToBreatheUntil,
    this.spaceToBreatheBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        circleId,
        ourSongUrl,
        ourSongTitle,
        anniversaryDate,
        promiseRingSetAt,
        promiseRingText,
        spaceToBreatheActive,
        spaceToBreatheUntil,
        spaceToBreatheBy,
        createdAt,
      ];
}
