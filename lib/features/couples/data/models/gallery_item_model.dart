import '../../domain/entities/gallery_item.dart';

class GalleryItemModel extends GalleryItemEntity {
  const GalleryItemModel({
    required super.id,
    required super.circleId,
    required super.uploadedBy,
    required super.storagePath,
    super.caption,
    required super.createdAt,
  });

  factory GalleryItemModel.fromJson(Map<String, dynamic> json) {
    return GalleryItemModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      uploadedBy: json['uploaded_by'] as String,
      storagePath: json['storage_path'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'uploaded_by': uploadedBy,
      'storage_path': storagePath,
      'caption': caption,
    };
  }
}
