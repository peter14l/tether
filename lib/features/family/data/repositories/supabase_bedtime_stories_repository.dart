import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/bedtime_story.dart';
import '../../domain/repositories/bedtime_stories_repository.dart';
import '../models/bedtime_story_model.dart';

@LazySingleton(as: IBedtimeStoriesRepository)
class SupabaseBedtimeStoriesRepository implements IBedtimeStoriesRepository {
  final SupabaseClient _client;

  SupabaseBedtimeStoriesRepository(this._client);

  @override
  Future<Either<Failure, List<BedtimeStoryEntity>>> getBedtimeStories(String circleId) async {
    try {
      final response = await _client
          .from('bedtime_stories')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final stories = (response as List).map((json) => BedtimeStoryModel.fromJson(json)).toList();
      return Right(stories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveBedtimeStory(BedtimeStoryEntity story, File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.m4a';
      final path = 'bedtime-stories/$fileName';
      await _client.storage.from('voice-notes').upload(path, file);

      final model = BedtimeStoryModel(
        id: story.id,
        circleId: story.circleId,
        recordedBy: story.recordedBy,
        title: story.title,
        storagePath: path,
        durationSecs: story.durationSecs,
        createdAt: story.createdAt,
      );

      await _client.from('bedtime_stories').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
