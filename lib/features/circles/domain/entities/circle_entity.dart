import 'package:equatable/equatable.dart';

class CircleEntity extends Equatable {
  final String id;
  final String name;
  final String circleType; // 'friends' | 'couple' | 'family' | 'inlaw'
  final String createdBy;
  final String? avatarUrl;
  final String? description;
  final String comfortRadius; // 'inner' | 'close' | 'all'
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CircleEntity({
    required this.id,
    required this.name,
    required this.circleType,
    required this.createdBy,
    this.avatarUrl,
    this.description,
    required this.comfortRadius,
    required this.isEncrypted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        circleType,
        createdBy,
        avatarUrl,
        description,
        comfortRadius,
        isEncrypted,
        createdAt,
        updatedAt,
      ];
}
