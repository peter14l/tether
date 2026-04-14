import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../../../core/utils/user_key_manager.dart';
import '../../domain/entities/reflection.dart';
import '../../domain/repositories/reflection_repository.dart';
import '../models/reflection_model.dart';

@LazySingleton(as: IReflectionRepository)
class SupabaseReflectionRepository implements IReflectionRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;
  final UserKeyManager _keyManager;

  SupabaseReflectionRepository(
    this._client,
    this._encryptionService,
    this._keyManager,
  );

  @override
  Future<Either<Failure, List<ReflectionEntity>>> getReflections() async {
    try {
      final response = await _client
          .from('reflection_wall')
          .select()
          .order('created_at', ascending: false);

      final userKey = await _keyManager.getUserKey();
      final List<ReflectionEntity> reflections = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(
          encryptedBlob,
          userKey,
        );
        reflections.add(ReflectionModel.fromJson(json, decryptedContent));
      }

      return Right(reflections);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReflection(
    ReflectionEntity reflection,
  ) async {
    try {
      final userKey = await _keyManager.getUserKey();
      final encryptedBlob = await _encryptionService.encrypt(
        reflection.content,
        userKey,
      );

      final model = ReflectionModel(
        id: reflection.id,
        userId: reflection.userId,
        content: reflection.content,
        createdAt: reflection.createdAt,
      );

      await _client.from('reflection_wall').insert(model.toJson(encryptedBlob));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
