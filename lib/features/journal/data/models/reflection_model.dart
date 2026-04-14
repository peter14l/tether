import '../../domain/entities/reflection.dart';

class ReflectionModel extends ReflectionEntity {
  const ReflectionModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

  factory ReflectionModel.fromJson(Map<String, dynamic> json, String decryptedContent) {
    return ReflectionModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      content: decryptedContent,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson(String encryptedBlob) {
    return {
      'user_id': userId,
      'encrypted_blob': encryptedBlob,
    };
  }
}
