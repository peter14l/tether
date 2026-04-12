import 'package:equatable/equatable.dart';

enum MoodType {
  needQuiet,
  anxious,
  wantToChat,
  happy,
  tired,
  inMyHead,
  openDoor
}

class MoodStatusEntity extends Equatable {
  final String id;
  final String userId;
  final MoodType status;
  final String? label;
  final String? colorKey;
  final DateTime updatedAt;

  const MoodStatusEntity({
    required this.id,
    required this.userId,
    required this.status,
    this.label,
    this.colorKey,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, status, label, colorKey, updatedAt];
}
