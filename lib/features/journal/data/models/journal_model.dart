import '../../domain/entities/journal_entry.dart';

class JournalModel extends JournalEntryEntity {
  const JournalModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.date,
    super.circleId,
    required super.createdAt,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json, String decryptedContent) {
    return JournalModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: decryptedContent,
      date: DateTime.parse(json['date'] as String),
      circleId: json['shared_with_circle_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson(String encryptedBlob) {
    return {
      'user_id': userId,
      'encrypted_blob': encryptedBlob,
      'shared_with_circle_id': circleId,
      'date': date.toIso8601String().split('T')[0],
    };
  }
}
