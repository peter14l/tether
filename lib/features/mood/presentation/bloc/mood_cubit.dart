import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/mood_status.dart';
import '../../domain/repositories/mood_repository.dart';
import 'mood_state.dart';

@injectable
class MoodCubit extends Cubit<MoodState> {
  final IMoodRepository _moodRepository;
  final SupabaseClient _supabaseClient;

  MoodCubit(this._moodRepository, this._supabaseClient) : super(MoodInitial());

  Future<void> loadMood() async {
    emit(MoodLoading());
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const MoodError('User not authenticated'));
      return;
    }

    final result = await _moodRepository.getMoodStatus(userId);
    result.fold(
      (failure) => emit(MoodError(failure.message)),
      (status) => emit(MoodLoaded(status)),
    );
  }

  Future<void> updateMood(MoodType type, {String? label}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final newStatus = MoodStatusEntity(
      id: '',
      userId: userId,
      status: type,
      label: label,
      updatedAt: DateTime.now(),
    );

    final result = await _moodRepository.setMoodStatus(newStatus);
    result.fold(
      (failure) => emit(MoodError(failure.message)),
      (_) => emit(MoodLoaded(newStatus)),
    );
  }
}
