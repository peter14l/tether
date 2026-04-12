import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/bedtime_story.dart';
import '../../domain/repositories/bedtime_stories_repository.dart';
import 'bedtime_stories_state.dart';

@injectable
class BedtimeStoriesCubit extends Cubit<BedtimeStoriesState> {
  final IBedtimeStoriesRepository _storiesRepository;
  final SupabaseClient _supabaseClient;

  BedtimeStoriesCubit(this._storiesRepository, this._supabaseClient) : super(BedtimeStoriesInitial());

  Future<void> loadStories(String circleId) async {
    emit(BedtimeStoriesLoading());
    final result = await _storiesRepository.getBedtimeStories(circleId);
    result.fold(
      (failure) => emit(BedtimeStoriesError(failure.message)),
      (stories) => emit(BedtimeStoriesLoaded(stories)),
    );
  }

  Future<void> saveStory({
    required String circleId,
    required File file,
    String? title,
    required int durationSecs,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    emit(BedtimeStoriesLoading());
    final story = BedtimeStoryEntity(
      id: '',
      circleId: circleId,
      recordedBy: userId,
      title: title,
      storagePath: '', // Will be set by repo
      durationSecs: durationSecs,
      createdAt: DateTime.now(),
    );

    final result = await _storiesRepository.saveBedtimeStory(story, file);
    result.fold(
      (failure) => emit(BedtimeStoriesError(failure.message)),
      (_) {
        emit(BedtimeStorySaved());
        loadStories(circleId);
      },
    );
  }
}
