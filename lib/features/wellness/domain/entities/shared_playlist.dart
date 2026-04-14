import 'package:equatable/equatable.dart';

class SharedPlaylistEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String? title;
  final String? type; // 'ambient' | 'music' | 'lofi'
  final List<Map<String, dynamic>> tracks;

  const SharedPlaylistEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    this.title,
    this.type,
    required this.tracks,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, title, type, tracks];
}
