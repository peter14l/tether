import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/memory.dart';
import '../../domain/repositories/memories_repository.dart';
import '../models/memory_model.dart';

@LazySingleton(as: IMemoriesRepository)
class SupabaseMemoriesRepository implements IMemoriesRepository {
  final SupabaseClient _client;

  SupabaseMemoriesRepository(this._client);

  @override
  Future<Either<Failure, List<MemoryEntity>>> getCircleMemories(String circleId) async {
    try {
      final response = await _client
          .from('posts') // Memories Lane pulls from posts table filtered by media or special tags
          .select()
          .eq('circle_id', circleId)
          .not('media_url', 'is', null)
          .order('created_at', ascending: false);
      
      final memories = (response as List).map((json) => MemoryModel.fromJson(json)).toList();
      return Right(memories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMemory(MemoryEntity memory) async {
    // In TETHER, memories are often created from posts or manual entries
    try {
      final model = MemoryModel(
        id: memory.id,
        circleId: memory.circleId,
        createdBy: memory.createdBy,
        title: memory.title,
        description: memory.description,
        mediaUrl: memory.mediaUrl,
        memoryDate: memory.memoryDate,
        createdAt: memory.createdAt,
      );
      // For now, insert into posts with content_type 'image' or 'text'
      await _client.from('posts').insert({
        'circle_id': model.circleId,
        'author_id': model.createdBy,
        'content_type': model.mediaUrl != null ? 'image' : 'text',
        'content_text': model.description ?? model.title,
        'media_url': model.mediaUrl,
        'created_at': model.memoryDate.toIso8601String(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<MemoryEntity>> streamCircleMemories(String circleId) {
    return _client
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data
            .where((json) => json['media_url'] != null)
            .map((json) => MemoryModel.fromJson(json))
            .toList());
  }
}
