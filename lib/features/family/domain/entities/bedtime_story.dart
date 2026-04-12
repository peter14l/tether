import 'package:equatable/equatable.dart';

class BedtimeStoryEntity extends Equatable {
  final String id;
  final String circleId;
  final String recordedBy;
  final String? title;
  final String storagePath;
  final int durationSecs;
  final DateTime createdAt;

  const BedtimeStoryEntity({
    required this.id,
    required this.circleId,
    required this.recordedBy,
    this.title,
    required this.storagePath,
    required this.durationSecs,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, recordedBy, title, storagePath, durationSecs, createdAt];
}
