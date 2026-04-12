import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../models/journal_model.dart';

@LazySingleton(as: IJournalRepository)
class SupabaseJournalRepository implements IJournalRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;

  // Placeholder 32-byte key for demo purposes. 
  // In a real app, this would be retrieved from secure storage or escrow.
  static final List<int> _placeholderKey = List.filled(32, 1);

  SupabaseJournalRepository(this._client, this._encryptionService);

  @override
  Future<Either<Failure, List<JournalEntryEntity>>> getJournalEntries() async {
    try {
      final response = await _client
          .from('gratitude_journal')
          .select()
          .order('created_at', ascending: false);

      final List<JournalEntryEntity> entries = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(encryptedBlob, _placeholderKey);
        entries.add(JournalModel.fromJson(json, decryptedContent));
      }
      
      return Right(entries);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addJournalEntry(JournalEntryEntity entry) async {
    try {
      final encryptedBlob = await _encryptionService.encrypt(entry.content, _placeholderKey);
      
      final model = JournalModel(
        id: entry.id,
        userId: entry.userId,
        content: entry.content,
        date: entry.date,
        circleId: entry.circleId,
        createdAt: entry.createdAt,
      );

      await _client.from('gratitude_journal').insert(model.toJson(encryptedBlob));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
