import '../../domain/entities/heritage_item.dart';

class HeritageItemModel extends HeritageItemEntity {
  const HeritageItemModel({
    required super.id,
    required super.circleId,
    required super.uploadedBy,
    required super.mediaUrl,
    super.caption,
    super.eraLabel,
    super.tags,
    required super.createdAt,
  });

  factory HeritageItemModel.fromJson(Map<String, dynamic> json) {
    return HeritageItemModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      uploadedBy: json['uploaded_by'] as String,
      mediaUrl: json['media_url'] as String,
      caption: json['caption'] as String?,
      eraLabel: json['era_label'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'uploaded_by': uploadedBy,
      'media_url': mediaUrl,
      'caption': caption,
      'era_label': eraLabel,
      'tags': tags,
    };
  }
}
