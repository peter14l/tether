import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../../../core/utils/user_key_manager.dart';
import '../../domain/entities/future_letter.dart';
import '../../domain/repositories/future_letter_repository.dart';
import '../models/future_letter_model.dart';

@LazySingleton(as: IFutureLetterRepository)
class SupabaseLetterRepository implements IFutureLetterRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;
  final UserKeyManager _keyManager;

  SupabaseLetterRepository(
    this._client,
    this._encryptionService,
    this._keyManager,
  );

  @override
  Future<Either<Failure, List<FutureLetterEntity>>> getFutureLetters(
    String circleId,
  ) async {
    try {
      final response = await _client
          .from('future_letters')
          .select()
          .eq('circle_id', circleId)
          .order('deliver_at', ascending: true);

      final userKey = await _keyManager.getUserKey();
      final List<FutureLetterEntity> results = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(
          encryptedBlob,
          userKey,
        );
        results.add(
          FutureLetterModel.fromJson({...json, 'content': decryptedContent}),
        );
      }
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendFutureLetter(
    FutureLetterEntity letter,
  ) async {
    try {
      final userKey = await _keyManager.getUserKey();
      final encryptedBlob = await _encryptionService.encrypt(
        letter.content,
        userKey,
      );
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
    return _client
        .from('future_letters')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .asyncMap((data) async {
          final userKey = await _keyManager.getUserKey();
          final List<FutureLetterEntity> results = [];
          for (final json in data) {
            final encryptedBlob = json['encrypted_blob'] as String;
            final decryptedContent = await _encryptionService.decrypt(
              encryptedBlob,
              userKey,
            );
            results.add(
              FutureLetterModel.fromJson({
                ...json,
                'content': decryptedContent,
              }),
            );
          }
          return results;
        });
  }
}
