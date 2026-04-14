import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../../../core/utils/user_key_manager.dart';
import '../../domain/entities/vault_item.dart';
import '../../domain/repositories/vault_repository.dart';
import '../models/vault_item_model.dart';

@LazySingleton(as: IVaultRepository)
class SupabaseVaultRepository implements IVaultRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;
  final UserKeyManager _keyManager;

  SupabaseVaultRepository(
    this._client,
    this._encryptionService,
    this._keyManager,
  );

  @override
  Future<Either<Failure, List<VaultItemEntity>>> getVaultItems(
    String circleId,
  ) async {
    try {
      final response = await _client
          .from('reflection_wall')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final userKey = await _keyManager.getUserKey();
      final List<VaultItemEntity> results = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(
          encryptedBlob,
          userKey,
        );
        results.add(VaultItemModel.fromJson(json, decryptedContent));
      }
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addVaultItem(VaultItemEntity item) async {
    try {
      final userKey = await _keyManager.getUserKey();
      final encryptedBlob = await _encryptionService.encrypt(
        item.content,
        userKey,
      );
      final model = VaultItemModel(
        id: item.id,
        userId: item.userId,
        circleId: item.circleId,
        type: item.type,
        content: item.content,
        metadata: item.metadata,
        createdAt: item.createdAt,
      );
      await _client.from('reflection_wall').insert(model.toJson(encryptedBlob));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVaultItem(String itemId) async {
    try {
      await _client.from('reflection_wall').delete().eq('id', itemId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<VaultItemEntity>> streamVaultItems(String circleId) {
    return _client
        .from('reflection_wall')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .asyncMap((data) async {
          final userKey = await _keyManager.getUserKey();
          final List<VaultItemEntity> results = [];
          for (final json in data) {
            final encryptedBlob = json['encrypted_blob'] as String;
            final decryptedContent = await _encryptionService.decrypt(
              encryptedBlob,
              userKey,
            );
            results.add(VaultItemModel.fromJson(json, decryptedContent));
          }
          return results;
        });
  }
}
