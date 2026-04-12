import 'package:equatable/equatable.dart';

class VoiceNoteEntity extends Equatable {
  final String id;
  final String circleId;
  final String senderId;
  final String storagePath;
  final int durationSecs;
  final bool isSlowChat;
  final DateTime createdAt;

  const VoiceNoteEntity({
    required this.id,
    required this.circleId,
    required this.senderId,
    required this.storagePath,
    required this.durationSecs,
    required this.isSlowChat,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, senderId, storagePath, durationSecs, isSlowChat, createdAt];
}
