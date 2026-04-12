import 'package:equatable/equatable.dart';

class HeritageItemEntity extends Equatable {
  final String id;
  final String circleId;
  final String uploadedBy;
  final String mediaUrl;
  final String? caption;
  final String? eraLabel;
  final List<String> tags;
  final DateTime createdAt;

  const HeritageItemEntity({
    required this.id,
    required this.circleId,
    required this.uploadedBy,
    required this.mediaUrl,
    this.caption,
    this.eraLabel,
    this.tags = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, uploadedBy, mediaUrl, caption, eraLabel, tags, createdAt];
}
