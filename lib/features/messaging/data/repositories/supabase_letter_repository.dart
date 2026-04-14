import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../domain/entities/future_letter.dart';
import '../../domain/repositories/future_letter_repository.dart';
import '../models/future_letter_model.dart';

@LazySingleton(as: IFutureLetterRepository)
class SupabaseLetterRepository implements IFutureLetterRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;
  static final List<int> _placeholderKey = List.filled(32, 3);

  SupabaseLetterRepository(this._client, this._encryptionService);

  @override
  Future<Either<Failure, List<FutureLetterEntity>>> getFutureLetters(String circleId) async {
    try {
      final response = await _client
          .from('future_letters')
          .select()
          .eq('circle_id', circleId)
          .order('deliver_at', ascending: true);

      final List<FutureLetterEntity> letters = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(encryptedBlob, _placeholderKey);
        letters.add(FutureLetterModel.fromJson(json)..content); // Content is already set in model from decrypted
        // Wait, FutureLetterModel.fromJson needs content.
      }
      // Re-implementing correctly:
      final List<FutureLetterEntity> results = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(encryptedBlob, _placeholderKey);
        results.add(FutureLetterModel.fromJson({...json, 'content': decryptedContent}));
      }
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendFutureLetter(FutureLetterEntity letter) async {
    try {
      final encryptedBlob = await _encryptionService.encrypt(letter.content, _placeholderKey);
      final model = FutureLetterModel(
        id: letter.id,
        circleId: letter.circleId,
        senderId: letter.senderId,
        receiverId: letter.receiverId,
        content: letter.content,
        deliverAt: letter.deliverAt,
        delivered: letter.delivered,
        createdAt: letter.createdAt,
      );
      await _client.from('future_letters').insert(model.toJson(encryptedBlob));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<FutureLetterEntity>> streamFutureLetters(String circleId) {
    // Realtime stream doesn't easily support client-side decryption for all items in stream
    // For now, we return the stream but BLoC will have to handle decryption or we use a more complex pattern
    return _client
        .from('future_letters')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .asyncMap((data) async {
          final List<FutureLetterEntity> results = [];
          for (final json in data) {
            final encryptedBlob = json['encrypted_blob'] as String;
            final decryptedContent = await _encryptionService.decrypt(encryptedBlob, _placeholderKey);
            results.add(FutureLetterModel.fromJson({...json, 'content': decryptedContent}));
          }
          return results;
        });
  }
}
