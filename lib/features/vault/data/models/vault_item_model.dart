import '../../domain/entities/vault_item.dart';

class VaultItemModel extends VaultItemEntity {
  const VaultItemModel({
    required super.id,
    required super.userId,
    required super.circleId,
    required super.type,
    required super.content,
    super.metadata,
    required super.createdAt,
  });

  factory VaultItemModel.fromJson(Map<String, dynamic> json, String decryptedContent) {
    return VaultItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      circleId: json['circle_id'] as String,
      type: json['type'] as String,
      content: decryptedContent,
      metadata: json['metadata'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson(String encryptedBlob) {
    return {
      'user_id': userId,
      'circle_id': circleId,
      'type': type,
      'encrypted_blob': encryptedBlob,
      'metadata': metadata,
    };
  }
}
