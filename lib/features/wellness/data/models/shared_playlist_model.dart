import '../../domain/entities/shared_playlist.dart';

class SharedPlaylistModel extends SharedPlaylistEntity {
  const SharedPlaylistModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    super.title,
    super.type,
    required super.tracks,
  });

  factory SharedPlaylistModel.fromJson(Map<String, dynamic> json) {
    return SharedPlaylistModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      title: json['title'] as String?,
      type: json['type'] as String?,
      tracks: (json['tracks'] as List).cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'title': title,
      'type': type,
      'tracks': tracks,
    };
  }
}
