import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/encryption_service.dart';
import '../../domain/entities/reflection.dart';
import '../../domain/repositories/reflection_repository.dart';
import '../models/reflection_model.dart';

@LazySingleton(as: IReflectionRepository)
class SupabaseReflectionRepository implements IReflectionRepository {
  final SupabaseClient _client;
  final EncryptionService _encryptionService;

  static final List<int> _placeholderKey = List.filled(32, 2); // Different key for wall

  SupabaseReflectionRepository(this._client, this._encryptionService);

  @override
  Future<Either<Failure, List<ReflectionEntity>>> getReflections() async {
    try {
      final response = await _client
          .from('reflection_wall')
          .select()
          .order('created_at', ascending: false);

      final List<ReflectionEntity> reflections = [];
      for (final json in (response as List)) {
        final encryptedBlob = json['encrypted_blob'] as String;
        final decryptedContent = await _encryptionService.decrypt(encryptedBlob, _placeholderKey);
        reflections.add(ReflectionModel.fromJson(json, decryptedContent));
      }
      
      return Right(reflections);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReflection(ReflectionEntity reflection) async {
    try {
      final encryptedBlob = await _encryptionService.encrypt(reflection.content, _placeholderKey);
      
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
