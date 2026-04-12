import 'package:equatable/equatable.dart';

class GalleryItemEntity extends Equatable {
  final String id;
  final String circleId;
  final String uploadedBy;
  final String storagePath;
  final String? caption;
  final DateTime createdAt;

  const GalleryItemEntity({
    required this.id,
    required this.circleId,
    required this.uploadedBy,
    required this.storagePath,
    this.caption,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, uploadedBy, storagePath, caption, createdAt];
}
