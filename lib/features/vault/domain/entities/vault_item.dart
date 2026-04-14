import 'package:equatable/equatable.dart';

class VaultItemEntity extends Equatable {
  final String id;
  final String userId;
  final String circleId;
  final String type; // 'text' | 'image' | 'file'
  final String content; // encrypted
  final String? metadata;
  final DateTime createdAt;

  const VaultItemEntity({
    required this.id,
    required this.userId,
    required this.circleId,
    required this.type,
    required this.content,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, circleId, type, content, metadata, createdAt];
}
