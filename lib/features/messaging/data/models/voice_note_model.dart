import '../../domain/entities/voice_note_entity.dart';

class VoiceNoteModel extends VoiceNoteEntity {
  const VoiceNoteModel({
    required super.id,
    required super.circleId,
    required super.senderId,
    required super.storagePath,
    required super.durationSecs,
    required super.isSlowChat,
    required super.createdAt,
  });

  factory VoiceNoteModel.fromJson(Map<String, dynamic> json) {
    return VoiceNoteModel(
      id: json['id'] as String? ?? '',
      circleId: json['circle_id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? '',
      storagePath: json['storage_path'] as String? ?? '',
      durationSecs: json['duration_secs'] as int? ?? 0,
      isSlowChat: json['is_slow_chat'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'sender_id': senderId,
      'storage_path': storagePath,
      'duration_secs': durationSecs,
      'is_slow_chat': isSlowChat,
    };
  }
}
