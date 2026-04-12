import 'package:equatable/equatable.dart';

class JournalEntryEntity extends Equatable {
  final String id;
  final String userId;
  final String content;
  final DateTime date;
  final String? circleId;
  final DateTime createdAt;

  const JournalEntryEntity({
    required this.id,
    required this.userId,
    required this.content,
    required this.date,
    this.circleId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, content, date, circleId, createdAt];
}
